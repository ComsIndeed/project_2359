import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

/// Service for CRUD operations on study folders, materials (packs), and cards.
class StudyDatabaseService {
  final AppDatabase _db;
  static const String _tag = 'StudyDatabaseService';

  StudyDatabaseService(this._db);

  // --- Folders ---

  Future<List<StudyFolderItem>> getAllFolders() async {
    AppLogger.debug('Fetching all folders', tag: _tag);
    return await _db.select(_db.studyFolderItems).get();
  }

  Stream<List<StudyFolderItem>> watchAllFolders() {
    AppLogger.debug('Watching all folders', tag: _tag);
    return (_db.select(
      _db.studyFolderItems,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  }

  Stream<List<(StudyFolderItem, int)>> watchPinnedFoldersWithStats() {
    final cardsCount = CustomExpression<int>(
      '(SELECT COUNT(*) FROM card_items c JOIN deck_items d ON c.deck_id = d.id WHERE d.folder_id = study_folder_items.id)',
    );

    final query = _db.select(_db.studyFolderItems).addColumns([cardsCount])
      ..where(_db.studyFolderItems.isPinned.equals(true))
      ..orderBy([OrderingTerm.desc(_db.studyFolderItems.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final folder = row.readTable(_db.studyFolderItems);
        final count = row.read(cardsCount) ?? 0;
        return (folder, count);
      }).toList();
    });
  }

  Stream<List<(StudyFolderItem, int)>> watchUnpinnedFoldersWithStats() {
    final cardsCount = CustomExpression<int>(
      '(SELECT COUNT(*) FROM card_items c JOIN deck_items d ON c.deck_id = d.id WHERE d.folder_id = study_folder_items.id)',
    );

    final query = _db.select(_db.studyFolderItems).addColumns([cardsCount])
      ..where(_db.studyFolderItems.isPinned.equals(false))
      ..orderBy([OrderingTerm.desc(_db.studyFolderItems.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final folder = row.readTable(_db.studyFolderItems);
        final count = row.read(cardsCount) ?? 0;
        return (folder, count);
      }).toList();
    });
  }

  Future<StudyFolderItem?> getFolderById(String id) async {
    AppLogger.debug('Fetching folder by ID: $id', tag: _tag);
    return await (_db.select(
      _db.studyFolderItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertFolder(StudyFolderItemsCompanion folder) async {
    AppLogger.info('Inserting new folder: ${folder.name.value}', tag: _tag);
    await _db.into(_db.studyFolderItems).insert(folder);
  }

  Future<void> updateFolder(StudyFolderItemsCompanion folder) async {
    AppLogger.info('Updating folder: ${folder.id.value}', tag: _tag);
    await (_db.update(
      _db.studyFolderItems,
    )..where((t) => t.id.equals(folder.id.value))).write(folder);
  }

  Future<void> toggleFolderPin(String id, bool isPinned) async {
    AppLogger.info(
      '${isPinned ? 'Pinning' : 'Unpinning'} folder: $id',
      tag: _tag,
    );
    await (_db.update(_db.studyFolderItems)..where((t) => t.id.equals(id)))
        .write(StudyFolderItemsCompanion(isPinned: Value(isPinned)));
  }

  Future<void> deleteFolder(String id) async {
    AppLogger.warning('Deleting folder and all its contents: $id', tag: _tag);
    await _db.transaction(() async {
      // 1. Get all decks in this folder
      final materials = await (_db.select(
        _db.deckItems,
      )..where((t) => t.folderId.equals(id))).get();

      // 2. For each deck, delete its cards
      for (final material in materials) {
        await (_db.delete(
          _db.cardItems,
        )..where((t) => t.deckId.equals(material.id))).go();
      }

      // 3. Delete decks
      await (_db.delete(
        _db.deckItems,
      )..where((t) => t.folderId.equals(id))).go();

      // 4. Delete sources (if they also belong to folders)
      await (_db.delete(
        _db.sourceItems,
      )..where((t) => t.folderId.equals(id))).go();

      // 5. Finally, delete the folder
      await (_db.delete(
        _db.studyFolderItems,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  /// Fetches all folders and joins them with their associated sources.
  Future<List<(StudyFolderItem, List<SourceItem>)>>
  getFoldersWithSources() async {
    AppLogger.debug('Fetching folders with sources', tag: _tag);
    final folders = await getAllFolders();
    final result = <(StudyFolderItem, List<SourceItem>)>[];

    for (final folder in folders) {
      final sources = await (_db.select(
        _db.sourceItems,
      )..where((t) => t.folderId.equals(folder.id))).get();
      result.add((folder, sources));
    }
    return result;
  }

  // --- Decks ---

  Future<DeckItem?> getDeckById(String id) async {
    AppLogger.debug('Fetching deck by ID: $id', tag: _tag);
    return await (_db.select(
      _db.deckItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DeckItem>> getDecksByFolderId(String folderId) async {
    AppLogger.debug('Fetching decks for folder: $folderId', tag: _tag);
    return await (_db.select(
      _db.deckItems,
    )..where((t) => t.folderId.equals(folderId))).get();
  }

  Stream<List<DeckItem>> watchDecksByFolderId(String folderId) {
    AppLogger.debug('Watching decks for folder: $folderId', tag: _tag);
    return (_db.select(
      _db.deckItems,
    )..where((t) => t.folderId.equals(folderId))).watch();
  }

  Stream<List<DeckItem>> watchPinnedDecks() {
    AppLogger.debug('Watching pinned decks', tag: _tag);
    return (_db.select(
      _db.deckItems,
    )..where((t) => t.isPinned.equals(true))).watch();
  }

  Stream<List<DeckItem>> watchAllDecks() {
    AppLogger.debug('Watching all decks', tag: _tag);
    return _db.select(_db.deckItems).watch();
  }

  Future<void> toggleDeckPin(String id, bool isPinned) async {
    AppLogger.info(
      '${isPinned ? 'Pinning' : 'Unpinning'} deck: $id',
      tag: _tag,
    );
    await (_db.update(_db.deckItems)..where((t) => t.id.equals(id))).write(
      DeckItemsCompanion(isPinned: Value(isPinned)),
    );
  }

  Future<void> insertDeck(DeckItemsCompanion deck) async {
    AppLogger.info('Inserting deck: ${deck.name.value}', tag: _tag);
    await _db.into(_db.deckItems).insert(deck);
  }

  Future<void> deleteDeck(String id) async {
    AppLogger.warning('Deleting deck and its cards: $id', tag: _tag);
    await _db.transaction(() async {
      // Delete cards first
      await (_db.delete(_db.cardItems)..where((t) => t.deckId.equals(id))).go();
      // Then delete deck
      await (_db.delete(_db.deckItems)..where((t) => t.id.equals(id))).go();
    });
  }

  // --- Cards ---

  Future<List<CardItem>> getCardsByDeckId(String deckId) async {
    AppLogger.debug('Fetching cards for deck: $deckId', tag: _tag);
    return await (_db.select(
      _db.cardItems,
    )..where((t) => t.deckId.equals(deckId))).get();
  }

  Stream<List<CardItem>> watchCardsByDeckId(String deckId) {
    AppLogger.debug('Watching cards for deck: $deckId', tag: _tag);
    return (_db.select(
      _db.cardItems,
    )..where((t) => t.deckId.equals(deckId))).watch();
  }

  Future<void> insertCard(CardItemsCompanion card) async {
    AppLogger.info('Inserting new card', tag: _tag);
    await _db.into(_db.cardItems).insert(card);
  }

  Future<void> insertCards(List<CardItemsCompanion> cards) async {
    AppLogger.info('Inserting batch of ${cards.length} cards', tag: _tag);
    await _db.batch((batch) {
      batch.insertAll(_db.cardItems, cards);
    });
  }

  Future<void> reviewCard(String id, int rating) async {
    AppLogger.info('Reviewing card $id with rating $rating', tag: _tag);
    // TODO: Implement FSRS scheduling logic here
    // This will update the 'due' and 'fsrsCardJson' fields in card_items
  }

  Future<void> deleteCard(String id) async {
    AppLogger.warning('Deleting card: $id', tag: _tag);
    await (_db.delete(_db.cardItems)..where((t) => t.id.equals(id))).go();
  }

  // --- Combined Operations ---

  /// Creates a deck and all its cards in a single transaction.
  Future<void> createDeckWithCards({
    required DeckItemsCompanion deck,
    required List<CardItemsCompanion> cards,
  }) async {
    AppLogger.info(
      'Creating deck "${deck.name.value}" with ${cards.length} cards',
      tag: _tag,
    );
    await _db.transaction(() async {
      await _db.into(_db.deckItems).insert(deck);
      await _db.batch((batch) {
        batch.insertAll(_db.cardItems, cards);
      });
    });
  }

  // --- Citations ---

  Future<CitationItem?> getCitationById(String id) async {
    return await (_db.select(_db.citationItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Checks if mock data has already been injected by looking for the Demo folder.
  Stream<bool> watchHasMockData() {
    return _db.select(_db.studyFolderItems).watch().map(
      (folders) => folders.any((f) => f.name == 'Biology & Medicine (DEMO)'),
    );
  }
}
