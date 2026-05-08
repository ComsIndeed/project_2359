import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/deck_items.dart';
import 'package:project_2359/core/tables/card_creation_draft_items.dart';
import 'package:project_2359/core/tables/citation_items.dart';
import 'package:project_2359/core/models/note_type.dart';

class NoteItems extends Table {
  TextColumn get id => text()();

  IntColumn get noteType => intEnum<NoteType>()();

  TextColumn get deckId => text().nullable().references(DeckItems, #id)();

  TextColumn get front => text().nullable()();
  TextColumn get back => text().nullable()();
  TextColumn get content => text().nullable()();

  TextColumn get citationId =>
      text().nullable().references(CitationItems, #id)();
  TextColumn get draftId =>
      text().nullable().references(CardCreationDraftItems, #id)();

  DateTimeColumn get createdAt =>
      dateTime().nullable().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().nullable().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
