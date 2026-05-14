import 'package:drift/drift.dart';
import 'package:project_2359/core/models/deck_config.dart';

class DeckItems extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable().references(DeckItems, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  TextColumn get config =>
      text().map(const DeckConfigConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
