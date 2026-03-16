import 'package:drift/drift.dart';

class StudyFolderItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
