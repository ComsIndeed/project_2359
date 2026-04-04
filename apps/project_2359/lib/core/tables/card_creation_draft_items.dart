import 'package:drift/drift.dart';

/// Will contain a list of decks and some metadata on the card creation session

class CardCreationDraftItems extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
