import 'package:drift/drift.dart';

class DeckItems extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable().references(DeckItems, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
