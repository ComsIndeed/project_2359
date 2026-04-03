import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';

class DeckItems extends Table {
  TextColumn get id => text()();
  TextColumn get folderId => text().references(StudyFolderItems, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
