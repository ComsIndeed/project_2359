import 'package:drift/drift.dart';

/// Will contain a list of decks and some metadata on the card creation session
///
/// For mvp, we just save the currently autosaved cards for draft, and last opened source + the page, thats it for now
///

class CardCreationDraftItems extends Table {
  TextColumn get id => text()();
  TextColumn get collectionId => text()();
  TextColumn get deckId => text()(); // Stable ID, even for new decks
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  // For mvp, we just save the currently autosaved cards for draft, and last opened source + the page, thats it for now
  TextColumn get lastOpenedSourceId => text().nullable()();
  TextColumn get lastOpenedPage =>
      text().nullable()(); // For mvp, only documents for now

  @override
  Set<Column> get primaryKey => {id};
}
