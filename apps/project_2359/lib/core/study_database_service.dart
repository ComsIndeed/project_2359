import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

/// Service for CRUD operations on study collections, materials (packs), and cards.
class StudyDatabaseService {
  final AppDatabase _db;
  static const String _tag = 'StudyDatabaseService';

  StudyDatabaseService(this._db);

  // --- Collections ---

  Future<List<StudyCollectionItem>> getAllCollections() async {
    AppLogger.debug('Fetching all collections', tag: _tag);
    return await _db.select(_db.studyCollectionItems).get();
  }

  Stream<List<StudyCollectionItem>> watchAllCollections() {
    AppLogger.debug('Watching all collections', tag: _tag);
    return (_db.select(
      _db.studyCollectionItems,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  }

  Stream<List<(StudyCollectionItem, int)>> watchPinnedCollectionsWithStats() {
    final cardsCount = CustomExpression<int>(
      '(SELECT COUNT(*) FROM card_items c JOIN deck_items d ON c.deck_id = d.id WHERE d.collection_id = study_collection_items.id)',
    );

    final query = _db.select(_db.studyCollectionItems).addColumns([cardsCount])
      ..where(_db.studyCollectionItems.isPinned.equals(true))
      ..orderBy([OrderingTerm.desc(_db.studyCollectionItems.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final collection = row.readTable(_db.studyCollectionItems);
        final count = row.read(cardsCount) ?? 0;
        return (collection, count);
      }).toList();
    });
  }

  Stream<List<(StudyCollectionItem, int)>> watchUnpinnedCollectionsWithStats() {
    final cardsCount = CustomExpression<int>(
      '(SELECT COUNT(*) FROM card_items c JOIN deck_items d ON c.deck_id = d.id WHERE d.collection_id = study_collection_items.id)',
    );

    final query = _db.select(_db.studyCollectionItems).addColumns([cardsCount])
      ..where(_db.studyCollectionItems.isPinned.equals(false))
      ..orderBy([OrderingTerm.desc(_db.studyCollectionItems.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final collection = row.readTable(_db.studyCollectionItems);
        final count = row.read(cardsCount) ?? 0;
        return (collection, count);
      }).toList();
    });
  }

  Future<StudyCollectionItem?> getCollectionById(String id) async {
    AppLogger.debug('Fetching collection by ID: $id', tag: _tag);
    return await (_db.select(
      _db.studyCollectionItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertCollection(StudyCollectionItemsCompanion collection) async {
    AppLogger.info('Inserting new collection: ${collection.name.value}', tag: _tag);
    await _db.into(_db.studyCollectionItems).insert(collection);
  }

  Future<void> updateCollection(StudyCollectionItemsCompanion collection) async {
    AppLogger.info('Updating collection: ${collection.id.value}', tag: _tag);
    await (_db.update(
      _db.studyCollectionItems,
    )..where((t) => t.id.equals(collection.id.value))).write(collection);
  }

  Future<void> toggleCollectionPin(String id, bool isPinned) async {
    AppLogger.info(
      '${isPinned ? 'Pinning' : 'Unpinning'} collection: $id',
      tag: _tag,
    );
    await (_db.update(_db.studyCollectionItems)..where((t) => t.id.equals(id)))
        .write(StudyCollectionItemsCompanion(isPinned: Value(isPinned)));
  }

  Future<void> deleteCollection(String id) async {
    AppLogger.warning('Deleting collection and all its contents: $id', tag: _tag);
    await _db.transaction(() async {
      // 1. Get all decks in this collection
      final materials = await (_db.select(
        _db.deckItems,
      )..where((t) => t.collectionId.equals(id))).get();

      // 2. For each deck, delete its cards
      for (final material in materials) {
        await (_db.delete(
          _db.cardItems,
        )..where((t) => t.deckId.equals(material.id))).go();
      }

      // 3. Delete decks
      await (_db.delete(
        _db.deckItems,
      )..where((t) => t.collectionId.equals(id))).go();

      // 4. Delete sources (if they also belong to collections)
      await (_db.delete(
        _db.sourceItems,
      )..where((t) => t.collectionId.equals(id))).go();

      // 5. Finally, delete the collection
      await (_db.delete(
        _db.studyCollectionItems,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  /// Fetches all collections and joins them with their associated sources.
  Future<List<(StudyCollectionItem, List<SourceItem>)>>
  getCollectionsWithSources() async {
    AppLogger.debug('Fetching collections with sources', tag: _tag);
    final collections = await getAllCollections();
    final result = <(StudyCollectionItem, List<SourceItem>)>[];

    for (final collection in collections) {
      final sources = await (_db.select(
        _db.sourceItems,
      )..where((t) => t.collectionId.equals(collection.id))).get();
      result.add((collection, sources));
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

  Future<List<DeckItem>> getDecksByCollectionId(String collectionId) async {
    AppLogger.debug('Fetching decks for collection: $collectionId', tag: _tag);
    return await (_db.select(
      _db.deckItems,
    )..where((t) => t.collectionId.equals(collectionId))).get();
  }

  Stream<List<DeckItem>> watchDecksByCollectionId(String collectionId) {
    AppLogger.debug('Watching decks for collection: $collectionId', tag: _tag);
    return (_db.select(
      _db.deckItems,
    )..where((t) => t.collectionId.equals(collectionId))).watch();
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

  /// Checks if mock data has already been injected by looking for the Demo collection.
  Stream<bool> watchHasMockData() {
    return _db.select(_db.studyCollectionItems).watch().map(
      (collections) => collections.any((f) => f.name == 'Biology & Medicine (DEMO)'),
    );
  }
}
