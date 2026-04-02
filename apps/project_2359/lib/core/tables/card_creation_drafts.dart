import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';
import 'package:project_2359/core/tables/source_items.dart';

class CardCreationDrafts extends Table {
  TextColumn get folderId => text().references(StudyFolderItems, #id)();
  TextColumn get lastSourceId =>
      text().nullable().references(SourceItems, #id)();

  // PDF state
  RealColumn get scrollX => real().nullable()();
  RealColumn get scrollY => real().nullable()();
  RealColumn get zoom => real().nullable()();

  // Card state
  TextColumn get frontText => text().nullable()();
  TextColumn get backText => text().nullable()();
  TextColumn get toolbarMode =>
      text().nullable()(); // CardCreationToolbarMode.name

  // Selected text/image context
  TextColumn get selectedText => text().nullable()();
  TextColumn get capturedImageBlobId =>
      text().nullable()(); // If we have a blob

  @override
  Set<Column> get primaryKey => {folderId};
}
