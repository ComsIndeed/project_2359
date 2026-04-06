import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';
import 'package:project_2359/core/enums/media_type.dart';

class SourceItems extends Table {
  TextColumn get id => text()();
  TextColumn get folderId =>
      text().nullable().references(StudyFolderItems, #id)();
  TextColumn get label => text()();
  TextColumn get path => text().nullable()();
  TextColumn get type => textEnum<MediaType>()();
  TextColumn get extractedContent => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
