import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';

/// The type of source content.
enum SourceType { document, video, audio, image, text }

class SourceItems extends Table {
  TextColumn get id => text()();
  TextColumn get folderId =>
      text().nullable().references(StudyFolderItems, #id)();
  TextColumn get label => text()();
  TextColumn get path => text().nullable()();
  TextColumn get type => text()(); // Use SourceType.name to store as string
  TextColumn get extractedContent => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
