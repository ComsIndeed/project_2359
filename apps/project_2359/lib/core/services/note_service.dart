import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/models/note_type.dart';
import 'package:project_2359/core/services/note_template_renderer.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

class NoteService {
  final AppDatabase _db;
  static const String _tag = 'NoteService';

  NoteService(this._db);

  /// Creates a note and its associated cards.
  Future<void> createNote(NoteItemsCompanion note) async {
    final noteId = note.id.value;
    AppLogger.info('Creating note $noteId', tag: _tag);
    await _db.into(_db.noteItems).insert(note);
    await syncCards(noteId);
  }

  /// Updates a note and synchronizes its cards.
  Future<void> updateNote(NoteItemsCompanion note) async {
    final noteId = note.id.value;
    AppLogger.info('Updating note $noteId', tag: _tag);
    await (_db.update(_db.noteItems)..where((t) => t.id.equals(noteId)))
        .write(note);
    await syncCards(noteId);
  }

  /// Deletes a note and all its associated cards.
  Future<void> deleteNote(String noteId) async {
    AppLogger.warning('Deleting note $noteId and its cards', tag: _tag);
    await _db.transaction(() async {
      await (_db.delete(_db.cardItems)..where((t) => t.noteId.equals(noteId))).go();
      await (_db.delete(_db.noteItems)..where((t) => t.id.equals(noteId))).go();
    });
  }

  /// Synchronizes cards for a given note.
  /// 
  /// This implements the Ordinal Sync logic: when updating a note, match existing cards 
  /// by their ordinal to preserve FSRS data (stability, difficulty, etc).
  Future<void> syncCards(String noteId) async {
    final note = await (_db.select(_db.noteItems)
          ..where((t) => t.id.equals(noteId)))
        .getSingle();

    final existingCards = await (_db.select(_db.cardItems)
          ..where((t) => t.noteId.equals(noteId)))
        .get();

    final int targetCardCount = _calculateTargetCardCount(note);
    
    await _db.transaction(() async {
      for (int i = 0; i < targetCardCount; i++) {
        final existingCard = existingCards.where((c) => c.templateOrdinal == i).firstOrNull;

        final front = NoteTemplateRenderer.render(note, ordinal: i, side: 'front');
        final back = NoteTemplateRenderer.render(note, ordinal: i, side: 'back');

        if (existingCard != null) {
          // Update existing card text but keep FSRS data
          await (_db.update(_db.cardItems)..where((t) => t.id.equals(existingCard.id)))
              .write(CardItemsCompanion(
            frontText: Value(front),
            backText: Value(back),
            updatedAt: Value(DateTime.now()),
            deckId: Value(note.deckId), // Ensure it stays in sync with note's deck
          ));
        } else {
          // Create new card
          await _db.into(_db.cardItems).insert(CardItemsCompanion.insert(
                id: const Uuid().v4(),
                noteId: Value(noteId),
                deckId: Value(note.deckId),
                templateOrdinal: Value(i),
                frontText: Value(front),
                backText: Value(back),
              ));
        }
      }

      // Delete redundant cards (if the number of deletions in a cloze note decreased)
      final redundantCards = existingCards.where((c) => (c.templateOrdinal ?? 0) >= targetCardCount);
      for (final card in redundantCards) {
        await (_db.delete(_db.cardItems)..where((t) => t.id.equals(card.id))).go();
      }
    });
  }

  int _calculateTargetCardCount(NoteItem note) {
    if (note.noteType == NoteType.cloze) {
      final content = note.content ?? '';
      final clozePattern = RegExp(r'\{\{c(\d+)::.*?\}\}');
      final matches = clozePattern.allMatches(content);
      if (matches.isEmpty) return 0; // Or 1? Usually 1 if we want at least one card, but 0 if no deletions.
      
      int maxN = 0;
      for (final m in matches) {
        final n = int.tryParse(m.group(1) ?? '0') ?? 1;
        if (n > maxN) maxN = n;
      }
      return maxN;
    }
    return note.noteType.templateCount;
  }
}
