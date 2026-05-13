import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

/// Service for managing card creation drafts.
///
/// This service allows syncing temporary sessions (drafts) for note creation,
/// and later committing these notes to a real deck or discarding them.
class DraftService {
  final AppDatabase _db;
  static const String _tag = 'DraftService';

  DraftService(this._db);

  // --- Main Action ---

  /// Synchronizes a draft session.
  ///
  /// This is the primary method for "autosaving" card creation progress.
  /// It upserts the draft session metadata and then REPLACES all temporary notes
  /// for that [draftId] with the provided [notes] list.
  ///
  /// The [draftId] and [targetDeckId] should be generated and managed by the UI.
  Future<void> syncDraft({
    required String draftId,
    required String targetDeckId,
    required List<NoteItemsCompanion> notes,
  }) async {
    final now = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      // 1. Fetch metadata to preserve 'createdAt' if it already exists
      final existing = await getDraftById(draftId);
      final createdAt = existing?.createdAt ?? now;

      // 2. Upsert the draft session record
      await _db
          .into(_db.cardCreationDraftItems)
          .insertOnConflictUpdate(
            CardCreationDraftItemsCompanion.insert(
              id: draftId,
              deckId: targetDeckId,
              createdAt: createdAt,
              updatedAt: now,
            ),
          );

      // 3. WIPE all currently buffered notes for this session
      await (_db.delete(
        _db.noteItems,
      )..where((t) => t.draftId.equals(draftId))).go();

      // 4. INSERT the updated list of notes
      await _db.batch((batch) {
        batch.insertAll(
          _db.noteItems,
          notes
              .map(
                (n) => n.copyWith(
                  draftId: Value(draftId),
                  deckId: Value(targetDeckId),
                ),
              )
              .toList(),
        );
      });
    });

    AppLogger.debug(
      'Synced draft $draftId with ${notes.length} notes',
      tag: _tag,
    );
  }

  /// Commits a draft to a real deck.
  ///
  /// The notes are moved to the provided [deckId]. If the deck does not exist,
  /// it is created with the [deckName] and [collectionId] Fallbacks to draft values.
  Future<void> saveDraft({
    required String draftId,
    required String deckId,
    String? deckName,
  }) async {
    AppLogger.info('Promoting draft $draftId to deck $deckId', tag: _tag);

    final draft = await getDraftById(draftId);
    if (draft == null) {
      AppLogger.error('Draft $draftId not found', tag: _tag);
      return;
    }

    await _db.transaction(() async {
      // 1. Move all notes associated with this draft to the target deckId
      // and clear the draft association.
      await (_db.update(
        _db.noteItems,
      )..where((t) => t.draftId.equals(draftId))).write(
        NoteItemsCompanion(deckId: Value(deckId), draftId: const Value(null)),
      );

      // 2. Fetch existing deck to see if we need to create it
      final existingDeck = await (_db.select(
        _db.deckItems,
      )..where((t) => t.id.equals(deckId))).getSingleOrNull();

      // 3. Create deck if absent, otherwise update metadata if explicitly provided
      if (existingDeck == null) {
        await _db
            .into(_db.deckItems)
            .insert(
              DeckItemsCompanion.insert(
                id: deckId,
                name:
                    deckName ??
                    'New Deck ${DateTime.now().toIso8601String().substring(0, 10)}',
              ),
            );
      } else if (deckName != null) {
        await (_db.update(
          _db.deckItems,
        )..where((t) => t.id.equals(deckId))).write(
          DeckItemsCompanion(
            name: deckName != null ? Value(deckName) : const Value.absent(),
          ),
        );
      }

      // 4. Remove the draft session record
      await (_db.delete(
        _db.cardCreationDraftItems,
      )..where((t) => t.id.equals(draftId))).go();
    });
  }

  /// Updates properties for a specified draft ID.
  ///
  /// Used for autosaving non-card metadata (e.g. current PDF page or source).
  Future<void> updateDraftProperties(
    String id, {
    String? lastOpenedSourceId,
    String? lastOpenedPage,
  }) async {
    AppLogger.debug('Updating draft properties for $id', tag: _tag);
    final now = DateTime.now().toIso8601String();

    await (_db.update(
      _db.cardCreationDraftItems,
    )..where((t) => t.id.equals(id))).write(
      CardCreationDraftItemsCompanion(
        updatedAt: Value(now),
        lastOpenedSourceId: lastOpenedSourceId != null
            ? Value(lastOpenedSourceId)
            : const Value.absent(),
        lastOpenedPage: lastOpenedPage != null
            ? Value(lastOpenedPage)
            : const Value.absent(),
      ),
    );
  }

  /// Deletes a draft and all its associated notes.
  ///
  /// Use this to discard a card creation session without saving anything.
  Future<void> deleteDraft(String draftId) async {
    AppLogger.warning(
      'Discarding draft $draftId and associated notes',
      tag: _tag,
    );
    await _db.transaction(() async {
      // 1. Delete associated notes
      await (_db.delete(
        _db.noteItems,
      )..where((t) => t.draftId.equals(draftId))).go();
      // 2. Delete draft session record
      await (_db.delete(
        _db.cardCreationDraftItems,
      )..where((t) => t.id.equals(draftId))).go();
    });
  }

  /// Retrieves all notes currently associated with a draft session. Returns empty list if draft not found.
  Future<List<NoteItem>> getNotesByDraftId(String? draftId) async {
    if (draftId == null) {
      return [];
    }
    return await (_db.select(
      _db.noteItems,
    )..where((t) => t.draftId.equals(draftId))).get();
  }

  /// Retrieves a specific draft session.
  Future<CardCreationDraftItem?> getDraftById(String id) async {
    return await (_db.select(
      _db.cardCreationDraftItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Watches all active draft sessions.
  Stream<List<CardCreationDraftItem>> watchAllDrafts() {
    return (_db.select(
      _db.cardCreationDraftItems,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  }

  /// Watches all active draft sessions for a specific deck.
  Stream<List<CardCreationDraftItem>> watchDraftsByDeckId(String deckId) {
    return (_db.select(_db.cardCreationDraftItems)
          ..where((t) => t.deckId.equals(deckId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<void> insertCitation(CitationItemsCompanion citation) async {
    await _db.into(_db.citationItems).insert(citation);
  }
}
