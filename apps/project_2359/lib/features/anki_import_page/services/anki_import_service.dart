import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/models/note_type.dart';
import 'package:project_2359/core/enums/media_type.dart';

// ---------------------------------------------------------------------------
// Exceptions
// ---------------------------------------------------------------------------

class AnkiImportError implements Exception {
  final String message;
  const AnkiImportError(this.message);
  @override
  String toString() => 'AnkiImportError: $message';
}

// ---------------------------------------------------------------------------
// Format detection
// ---------------------------------------------------------------------------

enum AnkiFormat { anki21, anki2, anki21b, unknown }

// ---------------------------------------------------------------------------
// Parsed model classes (all plain Dart — safe to pass across isolates)
// ---------------------------------------------------------------------------

class AnkiParsedDeck {
  final String ankiId;
  final String name;
  const AnkiParsedDeck({required this.ankiId, required this.name});
}

class _AnkiParsedModel {
  final String id;
  final String name;
  final int type; // 0 = standard, 1 = cloze
  final List<String> fieldNames;
  final int templateCount;
  final String? css;
  const _AnkiParsedModel({
    required this.id,
    required this.name,
    required this.type,
    required this.fieldNames,
    required this.templateCount,
    this.css,
  });
}

class AnkiParsedNote {
  final String ankiId;
  final NoteType noteType;
  final String? front;
  final String? back;
  final String? content;
  final String modelName;
  final List<String> tags;
  final String? css;
  const AnkiParsedNote({
    required this.ankiId,
    required this.noteType,
    this.front,
    this.back,
    this.content,
    required this.modelName,
    required this.tags,
    this.css,
  });
}

class AnkiParsedCard {
  final String ankiId;
  final String noteAnkiId;
  final String deckAnkiId;
  final int ord;
  final int queue; // -1=suspended, 0=new, 1=learning, 2=review, 3=relearning
  final int due;
  final double? fsrsStability;
  final double? fsrsDifficulty;
  const AnkiParsedCard({
    required this.ankiId,
    required this.noteAnkiId,
    required this.deckAnkiId,
    required this.ord,
    required this.queue,
    required this.due,
    this.fsrsStability,
    this.fsrsDifficulty,
  });
}

class AnkiParsedMedia {
  final String key;
  final String originalName;
  final String tempFilePath;
  const AnkiParsedMedia({
    required this.key,
    required this.originalName,
    required this.tempFilePath,
  });
}

/// The full in-memory representation after parsing an .apkg. Held in state
/// while the user previews, then passed to [AnkiImportService.commitImport].
class AnkiImportData {
  final String filename;
  final AnkiFormat format;
  final int collectionCreationTimestamp;
  final List<AnkiParsedDeck> decks;
  final List<AnkiParsedNote> notes;
  final List<AnkiParsedCard> cards;
  final List<AnkiParsedMedia> media;

  /// Temp directory created during extraction. Caller is responsible for
  /// cleanup via [AnkiImportService.cleanupTempDir] after committing.
  final String tempDir;

  const AnkiImportData({
    required this.filename,
    required this.format,
    required this.collectionCreationTimestamp,
    required this.decks,
    required this.notes,
    required this.cards,
    required this.media,
    required this.tempDir,
  });

  int get deckCount => decks.length;
  int get noteCount => notes.length;
  int get cardCount => cards.length;
  int get mediaCount => media.length;
}

class AnkiImportResult {
  final int deckCount;
  final int noteCount;
  final int cardCount;
  final int mediaCount;
  final List<String> warnings;
  final String collectionId;
  final String collectionName;
  const AnkiImportResult({
    required this.deckCount,
    required this.noteCount,
    required this.cardCount,
    required this.mediaCount,
    required this.warnings,
    required this.collectionId,
    required this.collectionName,
  });
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

class AnkiImportService {
  static const _fieldSeparator = '\x1f'; // ASCII 31

  // ── Parse ────────────────────────────────────────────────────────────────

  /// Parses an .apkg file and returns staged [AnkiImportData] for preview.
  /// Runs all heavy work in a background isolate.
  static Future<AnkiImportData> parseApkg(
    String filePath,
    String filename,
  ) async {
    // Run all archive + SQLite work in a background isolate.
    return Isolate.run(() => _parseApkgIsolate([filePath, filename]));
  }

  // Split out so tests can call it directly without isolates.
  static AnkiImportData _parseApkgIsolate(List<String> args) {
    final filePath = args[0];
    final filename = args[1];

    final tempDir = _extractApkg(filePath);

    final format = _detectFormat(tempDir);
    if (format == AnkiFormat.anki21b) {
      cleanupTempDir(tempDir);
      throw const AnkiImportError(
        'This deck uses the anki21b format (very new Anki version).\n'
        'Please re-export from Anki with "Legacy format" enabled.',
      );
    }
    if (format == AnkiFormat.unknown) {
      cleanupTempDir(tempDir);
      throw const AnkiImportError(
        'Could not find a valid Anki database inside this file.',
      );
    }

    final dbPath = _getDbPath(tempDir, format);
    final db = sqlite3.open(dbPath, mode: OpenMode.readOnly);
    try {
      final colRows = db.select('SELECT crt, models, decks FROM col LIMIT 1');
      if (colRows.isEmpty) {
        throw const AnkiImportError('Collection database is empty.');
      }
      final colRow = colRows.first;
      final crt = (colRow['crt'] as int?) ?? 0;

      final models = _parseModels(db, colRow['models'] as String?);
      final decks = _parseDecks(db, colRow['decks'] as String?);
      final notes = _parseNotes(db, models);
      final cards = _parseCards(db, crt);
      final media = _parseMedia(tempDir);

      return AnkiImportData(
        filename: filename,
        format: format,
        collectionCreationTimestamp: crt,
        decks: decks,
        notes: notes,
        cards: cards,
        media: media,
        tempDir: tempDir,
      );
    } finally {
      db.dispose();
    }
  }

  // ── Archive extraction ───────────────────────────────────────────────────

  static String _extractApkg(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tempDir = Directory.systemTemp.createTempSync('anki_import_').path;
    
    for (final file in archive) {
      if (file.isFile) {
        final outPath = p.join(tempDir, file.name);
        final f = File(outPath);
        f.parent.createSync(recursive: true);
        f.writeAsBytesSync(file.content as List<int>);
      }
    }
    return tempDir;
  }

  // ── Format detection ─────────────────────────────────────────────────────

  static AnkiFormat _detectFormat(String tempDir) {
    final files = Directory(tempDir).listSync().map((f) => p.basename(f.path).toLowerCase()).toSet();
    
    // Prioritize Raw SQLite
    if (files.contains('collection.anki21')) {
      return AnkiFormat.anki21;
    }
    if (files.contains('collection.anki2')) {
      return AnkiFormat.anki2;
    }
    // Then Compressed
    if (files.contains('collection.anki21b')) {
      return AnkiFormat.anki21b;
    }
    
    return AnkiFormat.unknown;
  }

  static String _getDbPath(String tempDir, AnkiFormat format) => p.join(
    tempDir,
    format == AnkiFormat.anki21 ? 'collection.anki21' : 'collection.anki2',
  );

  // ── Models ───────────────────────────────────────────────────────────────

  static List<_AnkiParsedModel> _parseModels(Database db, String? jsonBlob) {
    final hasNotetypesTable = db
        .select(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='notetypes'",
        )
        .isNotEmpty;
    if (hasNotetypesTable) return _parseModelsFromTable(db);
    if (jsonBlob != null && jsonBlob.isNotEmpty) {
      return _parseModelsFromJson(jsonBlob);
    }
    return [];
  }

  static List<_AnkiParsedModel> _parseModelsFromTable(Database db) {
    final rows = db.select('SELECT id, name FROM notetypes');
    return rows.map((row) {
      final id = row['id'].toString();
      final name = row['name'] as String;
      final fields = db.select(
        'SELECT name FROM fields WHERE ntid = ? ORDER BY ord',
        [row['id']],
      );
      final fieldNames = fields.map((f) => f['name'] as String).toList();
      final templates = db.select(
        'SELECT qfmt FROM templates WHERE ntid = ?',
        [row['id']],
      );
      final css = row['css'] as String?;
      final isCloze = templates.any(
        (t) => (t['qfmt'] as String).contains('{{cloze:'),
      );
      return _AnkiParsedModel(
        id: id,
        name: name,
        type: isCloze ? 1 : 0,
        fieldNames: fieldNames,
        templateCount: templates.length,
        css: css,
      );
    }).toList();
  }

  static List<_AnkiParsedModel> _parseModelsFromJson(String jsonBlob) {
    final modelsJson = jsonDecode(jsonBlob) as Map<String, dynamic>;
    return modelsJson.entries.map((entry) {
      final model = entry.value as Map<String, dynamic>;
      final flds = (model['flds'] as List).cast<Map<String, dynamic>>();
      final tmpls =
          (model['tmpls'] as List? ?? []).cast<Map<String, dynamic>>();
      return _AnkiParsedModel(
        id: entry.key,
        name: model['name'] as String,
        type: (model['type'] as int?) ?? 0,
        fieldNames: flds.map((f) => f['name'] as String).toList(),
        templateCount: tmpls.length,
        css: model['css'] as String?,
      );
    }).toList();
  }

  // ── Decks ────────────────────────────────────────────────────────────────

  static List<AnkiParsedDeck> _parseDecks(Database db, String? jsonBlob) {
    final hasDecksTable = db
        .select(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='decks'",
        )
        .isNotEmpty;
    List<AnkiParsedDeck> result;
    if (hasDecksTable) {
      result = _parseDecksFromTable(db);
    } else if (jsonBlob != null && jsonBlob.isNotEmpty) {
      result = _parseDecksFromJson(jsonBlob);
    } else {
      result = [];
    }
    
    // Alphabetize decks
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return result;
  }

  static List<AnkiParsedDeck> _parseDecksFromTable(Database db) {
    return db
        .select('SELECT id, name FROM decks')
        .where((r) => r['id'].toString() != '1')
        .map(
          (r) => AnkiParsedDeck(
            ankiId: r['id'].toString(),
            name: r['name'] as String,
          ),
        )
        .toList();
  }

  static List<AnkiParsedDeck> _parseDecksFromJson(String jsonBlob) {
    final decksJson = jsonDecode(jsonBlob) as Map<String, dynamic>;
    return decksJson.entries
        .where((e) => e.key != '1')
        .map((e) {
          final deck = e.value as Map<String, dynamic>;
          return AnkiParsedDeck(
            ankiId: e.key,
            name: deck['name'] as String,
          );
        })
        .toList();
  }

  // ── Notes ────────────────────────────────────────────────────────────────

  static List<AnkiParsedNote> _parseNotes(
    Database db,
    List<_AnkiParsedModel> models,
  ) {
    final modelMap = {for (final m in models) m.id: m};
    final rows = db.select('SELECT id, mid, flds, tags FROM notes');
    final notes = <AnkiParsedNote>[];
    for (final row in rows) {
      final modelId = row['mid'].toString();
      final model = modelMap[modelId];
      if (model == null) continue;

      final fields = (row['flds'] as String).split(_fieldSeparator);
      final tagsRaw = (row['tags'] as String?) ?? '';
      final tags =
          tagsRaw.trim().isEmpty
              ? <String>[]
              : tagsRaw
                  .trim()
                  .split(' ')
                  .where((t) => t.isNotEmpty)
                  .toList();

      notes.add(_mapNote(row['id'].toString(), model, fields, tags));
    }
    return notes;
  }

  static AnkiParsedNote _mapNote(
    String noteId,
    _AnkiParsedModel model,
    List<String> fields,
    List<String> tags,
  ) {
    if (model.type == 1) {
      return AnkiParsedNote(
        ankiId: noteId,
        noteType: NoteType.cloze,
        content: jsonEncode({
          'text': fields.isNotEmpty ? fields[0] : '',
          'css': model.css,
        }),
        modelName: model.name,
        tags: tags,
        css: model.css,
      );
    }

    final front = fields.isNotEmpty ? fields[0] : null;
    final back = fields.length > 1 ? fields[1] : null;

    // Custom: more than 2 fields
    if (model.fieldNames.length > 2) {
      final fieldMap = <String, String>{};
      for (int i = 0; i < model.fieldNames.length && i < fields.length; i++) {
        fieldMap[model.fieldNames[i]] = fields[i];
      }
      return AnkiParsedNote(
        ankiId: noteId,
        noteType: NoteType.custom,
        front: front,
        back: back,
        content: jsonEncode({
          'fields': fieldMap,
          'modelName': model.name,
          'tags': tags,
          'css': model.css,
        }),
        modelName: model.name,
        tags: tags,
        css: model.css,
      );
    }

    // Extra fields beyond 2 stored in content JSON
    final extras = <String, String>{};
    if (fields.length > 2 && model.fieldNames.length >= fields.length) {
      for (int i = 2; i < fields.length; i++) {
        extras[model.fieldNames[i]] = fields[i];
      }
    }
    
    final content = jsonEncode({
      if (extras.isNotEmpty) 'extras': extras,
      if (model.css != null) 'css': model.css,
    });

    final noteType =
        model.templateCount >= 2 ? NoteType.basicAndReversed : NoteType.basic;

    return AnkiParsedNote(
      ankiId: noteId,
      noteType: noteType,
      front: front,
      back: back,
      content: content,
      modelName: model.name,
      tags: tags,
      css: model.css,
    );
  }

  // ── Cards ────────────────────────────────────────────────────────────────

  static List<AnkiParsedCard> _parseCards(Database db, int crt) {
    return db.select('SELECT id, nid, did, ord, queue, due, data FROM cards').map((row) {
      final queue = (row['queue'] as int?) ?? 0;
      final dataStr = (row['data'] as String?) ?? '';
      double? stability;
      double? difficulty;
      if (dataStr.isNotEmpty) {
        try {
          final d = jsonDecode(dataStr) as Map<String, dynamic>;
          final s = d['s'];
          final dv = d['d'];
          if (s != null) stability = (s as num).toDouble();
          if (dv != null) difficulty = (dv as num).toDouble();
        } catch (_) {}
      }
      return AnkiParsedCard(
        ankiId: row['id'].toString(),
        noteAnkiId: row['nid'].toString(),
        deckAnkiId: row['did'].toString(),
        ord: (row['ord'] as int?) ?? 0,
        queue: queue,
        due: (row['due'] as int?) ?? 0,
        fsrsStability: stability,
        fsrsDifficulty: difficulty,
      );
    }).toList();
  }

  // ── Media ────────────────────────────────────────────────────────────────

  static List<AnkiParsedMedia> _parseMedia(String tempDir) {
    final mediaFilePath = p.join(tempDir, 'media');
    if (!File(mediaFilePath).existsSync()) return [];
    
    // Some Anki media files might have encoding issues or non-standard characters
    final bytes = File(mediaFilePath).readAsBytesSync();
    final mediaStr = utf8.decode(bytes, allowMalformed: true);
    
    if (mediaStr.isEmpty) return [];
    try {
      final mediaJson = jsonDecode(mediaStr) as Map<String, dynamic>;
      final result = <AnkiParsedMedia>[];
      for (final entry in mediaJson.entries) {
        final tempFilePath = p.join(tempDir, entry.key);
        if (File(tempFilePath).existsSync()) {
          result.add(AnkiParsedMedia(
            key: entry.key,
            originalName: entry.value as String,
            tempFilePath: tempFilePath,
          ));
        }
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  // ── Commit ───────────────────────────────────────────────────────────────

  /// Writes the parsed [data] into the app's Drift [db] under [collectionId].
  static Future<AnkiImportResult> commitImport({
    required AnkiImportData data,
    required String collectionId,
    required String collectionName,
    required AppDatabase db,
    bool preserveFsrsState = true,
    void Function(String phase, double progress)? onProgress,
  }) async {
    const uuid = Uuid();
    final warnings = <String>[];

    onProgress?.call('Creating decks…', 0.1);

    // Anki deck id → app deck id
    final deckIdMap = <String, String>{};
    // Anki note id → app note id
    final noteIdMap = <String, String>{};
    // Anki note id → Anki deck id (primary deck from first card)
    final noteToDeckAnkiId = <String, String>{};
    for (final card in data.cards) {
      noteToDeckAnkiId.putIfAbsent(card.noteAnkiId, () => card.deckAnkiId);
    }

    await db.transaction(() async {
      // 1. Decks
      for (final ankiDeck in data.decks) {
        final appDeckId = uuid.v4();
        deckIdMap[ankiDeck.ankiId] = appDeckId;
        await db.into(db.deckItems).insert(
          DeckItemsCompanion.insert(
            id: appDeckId,
            collectionId: collectionId,
            name: ankiDeck.name,
          ),
        );
      }

      onProgress?.call('Importing notes…', 0.3);

      // 2. Notes
      final noteCompanions = <NoteItemsCompanion>[];
      final noteAnkiIdToNote = {for (final n in data.notes) n.ankiId: n};
      for (final note in data.notes) {
        final appNoteId = uuid.v4();
        noteIdMap[note.ankiId] = appNoteId;
        final deckAnkiId = noteToDeckAnkiId[note.ankiId];
        final appDeckId = deckAnkiId != null ? deckIdMap[deckAnkiId] : null;
        noteCompanions.add(
          NoteItemsCompanion.insert(
            id: appNoteId,
            noteType: note.noteType,
            deckId: Value(appDeckId),
            front: Value(note.front),
            back: Value(note.back),
            content: Value(note.content),
          ),
        );
      }
      await db.batch((b) => b.insertAll(db.noteItems, noteCompanions));

      onProgress?.call('Importing cards…', 0.5);

      // 3. Cards
      final crt = data.collectionCreationTimestamp;
      final cardCompanions = <CardItemsCompanion>[];
      for (final card in data.cards) {
        final appNoteId = noteIdMap[card.noteAnkiId];
        final appDeckId = deckIdMap[card.deckAnkiId];
        if (appNoteId == null || appDeckId == null) continue;

        final dueDate =
            (card.queue == 2 && card.due > 0)
                ? DateTime.fromMillisecondsSinceEpoch(crt * 1000).add(
                  Duration(days: card.due),
                )
                : DateTime.now();

        final stability =
            preserveFsrsState ? card.fsrsStability : null;
        final difficulty =
            preserveFsrsState ? card.fsrsDifficulty : null;
        // Suspended cards → treat as new
        final state =
            card.queue == -1 ? 0 : (preserveFsrsState ? card.queue : 0);

        final note = noteAnkiIdToNote[card.noteAnkiId];
        if (note == null) continue;

        final cssTag = note.css != null ? '<style>${note.css}</style>' : '';
        final frontText = cssTag + _renderCardText(note, card.ord, 'front');
        final backText = cssTag + _renderCardText(note, card.ord, 'back');

        cardCompanions.add(
          CardItemsCompanion.insert(
            id: uuid.v4(),
            noteId: Value(appNoteId),
            deckId: Value(appDeckId),
            templateOrdinal: Value(card.ord),
            frontText: Value(frontText),
            backText: Value(backText),
            spacedDue: Value(dueDate),
            spacedStability: Value(stability),
            spacedDifficulty: Value(difficulty),
            spacedState: Value(state),
          ),
        );
      }
      await db.batch((b) => b.insertAll(db.cardItems, cardCompanions));

      onProgress?.call('Importing media…', 0.75);

      // 4. Media
      for (final m in data.media) {
        final bytes = File(m.tempFilePath).readAsBytesSync();
        final ext = p.extension(m.originalName).toLowerCase();
        final mediaType = _resolveMediaType(ext);
        if (mediaType == null) {
          warnings.add('Skipped unsupported media: ${m.originalName}');
          continue;
        }
        await db.into(db.assetItems).insert(
          AssetItemsCompanion.insert(
            id: uuid.v4(),
            data: bytes,
            name: Value(m.originalName),
            type: mediaType,
          ),
        );
      }
    });

    onProgress?.call('Done!', 1.0);
    cleanupTempDir(data.tempDir);

    return AnkiImportResult(
      deckCount: data.deckCount,
      noteCount: data.noteCount,
      cardCount: data.cardCount,
      mediaCount: data.media
          .where(
            (m) =>
                _resolveMediaType(p.extension(m.originalName).toLowerCase()) !=
                null,
          )
          .length,
      warnings: warnings,
      collectionId: collectionId,
      collectionName: collectionName,
    );
  }

  // ── Rendering Helpers ───────────────────────────────────────────────────

  static String _renderCardText(AnkiParsedNote note, int ordinal, String side) {
    String? content = note.content;
    
    if (content != null && content.trim().startsWith('{')) {
      try {
        final data = jsonDecode(content) as Map<String, dynamic>;
        if (note.noteType == NoteType.cloze) {
          content = data['text'] as String?;
        } else if (note.noteType == NoteType.custom) {
          // Fallback to fields[0]/[1] if available in the map
          final fields = data['fields'] as Map<String, dynamic>?;
          if (fields != null && fields.isNotEmpty) {
             final values = fields.values.toList();
             return side == 'front' ? values[0].toString() : (values.length > 1 ? values[1].toString() : '');
          }
        }
      } catch (_) {}
    }

    if (note.noteType == NoteType.cloze) {
      return _renderClozeText(content ?? '', ordinal, side);
    }

    // TODO: Support image occlusion for Anki imports.
    if (note.noteType == NoteType.imageOcclusion) {
      return side == 'front' ? 'Image Occlusion Card' : 'Revealed Image';
    }

    // For Basic and Basic+Reversed, we can use front/back fields
    if (note.noteType == NoteType.basic ||
        note.noteType == NoteType.basicAndReversed) {
      String text = '';
      if (note.noteType == NoteType.basicAndReversed && ordinal == 1) {
        text = side == 'front' ? (note.back ?? '') : (note.front ?? '');
      } else {
        text = side == 'front' ? (note.front ?? '') : (note.back ?? '');
      }
      return text;
    }

    // For Custom fallback
    if (note.noteType == NoteType.custom) {
      return side == 'front' ? (note.front ?? '') : (note.back ?? '');
    }

    return '';
  }

  static String _renderClozeText(String content, int ordinal, String side) {
    final clozePattern = RegExp(r'\{\{c(\d+)::(.*?)\}\}');

    return content.replaceAllMapped(clozePattern, (match) {
      final matchOrdinal = int.tryParse(match.group(1) ?? '0') ?? 1;
      final inner = match.group(2) ?? '';
      
      // Anki clozes can be {{c1::answer::hint}}
      final parts = inner.split('::');
      final answer = parts[0];
      final hint = parts.length > 1 ? parts[1] : null;

      // Ordinals in {{cN::...}} are 1-indexed.
      if (matchOrdinal == (ordinal + 1)) {
        if (side == 'front') {
          return hint != null ? '<span class="cloze-hint">[$hint]</span>' : '<span class="cloze-placeholder">[...]</span>';
        } else {
          return '<span class="cloze-answer">$answer</span>';
        }
      }
      return answer;
    });
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static MediaType? _resolveMediaType(String ext) => switch (ext) {
    '.png' || '.jpg' || '.jpeg' || '.gif' || '.webp' || '.svg' => MediaType.image,
    '.mp3' || '.ogg' || '.wav' || '.m4a' => MediaType.audio,
    '.mp4' || '.webm' => MediaType.video,
    _ => null,
  };

  static void cleanupTempDir(String tempDir) {
    try {
      Directory(tempDir).deleteSync(recursive: true);
    } catch (_) {}
  }

  // ── Test-accessible parse helpers (no isolate overhead) ──────────────────

  /// Exposed for unit tests only.
  static List<String> splitFields(String flds) =>
      flds.split(_fieldSeparator);

  /// Exposed for unit tests only.
  static DateTime decodeDueDate(int crt, int due) =>
      DateTime.fromMillisecondsSinceEpoch(crt * 1000).add(Duration(days: due));

  /// Exposed for unit tests only.
  static ({double? stability, double? difficulty}) parseFsrsData(
    String dataStr,
  ) {
    if (dataStr.isEmpty) return (stability: null, difficulty: null);
    try {
      final d = jsonDecode(dataStr) as Map<String, dynamic>;
      final s = d['s'];
      final dv = d['d'];
      return (
        stability: s != null ? (s as num).toDouble() : null,
        difficulty: dv != null ? (dv as num).toDouble() : null,
      );
    } catch (_) {
      return (stability: null, difficulty: null);
    }
  }
}
