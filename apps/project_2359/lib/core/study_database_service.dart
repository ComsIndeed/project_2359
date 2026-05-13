import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

/// Service for CRUD operations on decks and cards.
/// Replaces the old Collection-based model with a hierarchical Deck model.
class StudyDatabaseService {
  final AppDatabase _db;
  static const String _tag = 'StudyDatabaseService';

  StudyDatabaseService(this._db);

  // --- Decks ---

  Future<DeckItem?> getDeckById(String id) async {
    AppLogger.debug('Fetching deck by ID: $id', tag: _tag);
    return await (_db.select(_db.deckItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DeckItem>> getRootDecks() async {
    AppLogger.debug('Fetching root decks', tag: _tag);
    return await (_db.select(_db.deckItems)..where((t) => t.parentId.isNull())).get();
  }

  Stream<List<DeckItem>> watchRootDecks() {
    AppLogger.debug('Watching root decks', tag: _tag);
    return (_db.select(_db.deckItems)
          ..where((t) => t.parentId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.isPinned), (t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<DeckItem>> watchSubDecks(String parentId) {
    AppLogger.debug('Watching sub-decks for parent: $parentId', tag: _tag);
    return (_db.select(_db.deckItems)
          ..where((t) => t.parentId.equals(parentId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<DeckItem>> watchPinnedDecks() {
    AppLogger.debug('Watching pinned decks', tag: _tag);
    return (_db.select(_db.deckItems)..where((t) => t.isPinned.equals(true))).watch();
  }

  Stream<List<DeckItem>> watchAllDecks() {
    AppLogger.debug('Watching all decks', tag: _tag);
    return _db.select(_db.deckItems).watch();
  }

  Future<List<DeckItem>> getAllDecks() async {
    AppLogger.debug('Fetching all decks', tag: _tag);
    return await _db.select(_db.deckItems).get();
  }

  Future<void> toggleDeckPin(String id, bool isPinned) async {
    AppLogger.info('${isPinned ? 'Pinning' : 'Unpinning'} deck: $id', tag: _tag);
    await (_db.update(_db.deckItems)..where((t) => t.id.equals(id))).write(
      DeckItemsCompanion(isPinned: Value(isPinned)),
    );
  }

  Future<void> insertDeck(DeckItemsCompanion deck) async {
    AppLogger.info('Inserting deck: ${deck.name.value}', tag: _tag);
    await _db.into(_db.deckItems).insert(deck);
  }

  Future<void> updateDeck(DeckItemsCompanion deck) async {
    AppLogger.info('Updating deck: ${deck.id.value}', tag: _tag);
    await (_db.update(_db.deckItems)..where((t) => t.id.equals(deck.id.value))).write(deck);
  }

  Future<void> deleteDeck(String id) async {
    AppLogger.warning('Deleting deck and all sub-contents: $id', tag: _tag);
    await _db.transaction(() async {
      // Recursive delete logic
      final subDecks = await (_db.select(_db.deckItems)..where((t) => t.parentId.equals(id))).get();
      for (final sub in subDecks) {
        await deleteDeck(sub.id);
      }

      // Delete cards in this deck
      await (_db.delete(_db.cardItems)..where((t) => t.deckId.equals(id))).go();
      
      // Delete sources in this deck
      await (_db.delete(_db.sourceItems)..where((t) => t.deckId.equals(id))).go();

      // Finally delete the deck itself
      await (_db.delete(_db.deckItems)..where((t) => t.id.equals(id))).go();
    });
  }

  // --- Deck Configs ---

  Future<DeckConfigItem?> getDeckConfigById(String id) async {
    return await (_db.select(_db.deckConfigItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DeckConfigItem>> getAllDeckConfigs() async {
    return await _db.select(_db.deckConfigItems).get();
  }

  Future<void> insertDeckConfig(DeckConfigItemsCompanion config) async {
    await _db.into(_db.deckConfigItems).insert(config);
  }

  Future<void> updateDeckConfig(DeckConfigItemsCompanion config) async {
    await (_db.update(_db.deckConfigItems)..where((t) => t.id.equals(config.id.value))).write(config);
  }

  // --- Cards ---

  Future<List<CardItem>> getCardsByDeckId(String deckId) async {
    AppLogger.debug('Fetching cards for deck: $deckId', tag: _tag);
    return await (_db.select(_db.cardItems)..where((t) => t.deckId.equals(deckId))).get();
  }

  Stream<List<CardItem>> watchCardsByDeckId(String deckId) {
    AppLogger.debug('Watching cards for deck: $deckId', tag: _tag);
    return (_db.select(_db.cardItems)..where((t) => t.deckId.equals(deckId))).watch();
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

  Future<void> deleteCard(String id) async {
    AppLogger.warning('Deleting card: $id', tag: _tag);
    await (_db.delete(_db.cardItems)..where((t) => t.id.equals(id))).go();
  }

  // --- Combined Operations ---

  Future<void> createDeckWithCards({
    required DeckItemsCompanion deck,
    required List<CardItemsCompanion> cards,
  }) async {
    AppLogger.info('Creating deck "${deck.name.value}" with ${cards.length} cards', tag: _tag);
    await _db.transaction(() async {
      await _db.into(_db.deckItems).insert(deck);
      await _db.batch((batch) {
        batch.insertAll(_db.cardItems, cards);
      });
    });
  }

  // --- Citations ---

  Future<CitationItem?> getCitationById(String id) async {
    return await (_db.select(_db.citationItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // --- Sources ---

  Future<List<SourceItem>> getSourcesByDeckId(String deckId) async {
    return await (_db.select(_db.sourceItems)..where((t) => t.deckId.equals(deckId))).get();
  }

  Stream<List<SourceItem>> watchSourcesByDeckId(String deckId) {
    return (_db.select(_db.sourceItems)..where((t) => t.deckId.equals(deckId))).watch();
  }

  Stream<bool> watchHasMockData() {
    return _db.select(_db.deckItems).watch().map(
      (decks) => decks.any((f) => f.name.contains('(DEMO)')),
    );
  }
}
