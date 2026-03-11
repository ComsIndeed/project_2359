import 'package:drift/drift.dart';

// TODO: Run the Drift compiler thingy here

class StudyFolderItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
