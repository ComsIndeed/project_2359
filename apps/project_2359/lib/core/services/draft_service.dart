import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

/// Service for managing card creation drafts.
///
/// This service allows syncing temporary sessions (drafts) for card creation,
/// and later committing these cards to a real deck or discarding them.
class DraftService {
  final AppDatabase _db;
  static const String _tag = 'DraftService';

  DraftService(this._db);

  // --- Main Action ---

  /// Synchronizes a draft session.
  ///
  /// This is the primary method for "autosaving" card creation progress.
  /// It upserts the draft session metadata and then REPLACES all temporary cards
  /// for that [draftId] with the provided [cards] list.
  ///
  /// The [draftId] and [targetDeckId] should be generated and managed by the UI.
  Future<void> syncDraft({
    required String draftId,
    required String folderId,
    required String targetDeckId,
    required List<CardItemsCompanion> cards,
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
              folderId: folderId,
              deckId: targetDeckId,
              createdAt: createdAt,
              updatedAt: now,
            ),
          );

      // 3. WIPE all currently buffered cards for this session
      await (_db.delete(
        _db.cardItems,
      )..where((t) => t.draftId.equals(draftId))).go();

      // 4. INSERT the updated list of cards
      await _db.batch((batch) {
        batch.insertAll(
          _db.cardItems,
          cards
              .map(
                (c) => c.copyWith(
                  draftId: Value(draftId),
                  deckId: Value(targetDeckId),
                ),
              )
              .toList(),
        );
      });
    });

    AppLogger.debug(
      'Synced draft $draftId with ${cards.length} cards',
      tag: _tag,
    );
  }

  /// Commits a draft to a real deck.
  ///
  /// The cards are moved to the provided [deckId]. If the deck does not exist,
  /// it is created with the [deckName] and [folderId] Fallbacks to draft values.
  Future<void> saveDraft({
    required String draftId,
    required String deckId,
    String? deckName,
    String? folderId,
  }) async {
    AppLogger.info('Promoting draft $draftId to deck $deckId', tag: _tag);

    final draft = await getDraftById(draftId);
    if (draft == null) {
      AppLogger.error('Draft $draftId not found', tag: _tag);
      return;
    }

    await _db.transaction(() async {
      // 1. Move all cards associated with this draft to the target deckId
      // and clear the draft association.
      await (_db.update(
        _db.cardItems,
      )..where((t) => t.draftId.equals(draftId))).write(
        CardItemsCompanion(deckId: Value(deckId), draftId: const Value(null)),
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
                folderId: folderId ?? draft.folderId,
                name:
                    deckName ??
                    'New Deck ${DateTime.now().toIso8601String().substring(0, 10)}',
              ),
            );
      } else if (deckName != null || folderId != null) {
        await (_db.update(
          _db.deckItems,
        )..where((t) => t.id.equals(deckId))).write(
          DeckItemsCompanion(
            name: deckName != null ? Value(deckName) : const Value.absent(),
            folderId: folderId != null ? Value(folderId) : const Value.absent(),
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

  /// Deletes a draft and all its associated cards.
  ///
  /// Use this to discard a card creation session without saving anything.
  Future<void> deleteDraft(String draftId) async {
    AppLogger.warning(
      'Discarding draft $draftId and associated cards',
      tag: _tag,
    );
    await _db.transaction(() async {
      // 1. Delete associated cards
      await (_db.delete(
        _db.cardItems,
      )..where((t) => t.draftId.equals(draftId))).go();
      // 2. Delete draft session record
      await (_db.delete(
        _db.cardCreationDraftItems,
      )..where((t) => t.id.equals(draftId))).go();
    });
  }

  /// Retrieves all cards currently associated with a draft session. Returns empty list if draft not found.
  Future<List<CardItem>> getCardsByDraftId(String? draftId) async {
    if (draftId == null) {
      return [];
    }
    return await (_db.select(
      _db.cardItems,
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

  /// Watches all active draft sessions for a specific folder.
  Stream<List<CardCreationDraftItem>> watchDraftsByFolderId(String folderId) {
    return (_db.select(_db.cardCreationDraftItems)
          ..where((t) => t.folderId.equals(folderId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }
}
