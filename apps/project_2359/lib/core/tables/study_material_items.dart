import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';

class StudyMaterialItems extends Table {
  TextColumn get id => text()();
  TextColumn get folderId => text().references(StudyFolderItems, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
