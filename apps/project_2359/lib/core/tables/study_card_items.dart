import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/study_folder_items.dart';
import 'package:project_2359/core/tables/study_material_items.dart';
import 'package:project_2359/core/models/citation.dart';

/// The type of study material.
enum StudyCardType {
  flashcard,
  multipleChoiceQuestion,
  freeTextQuestion,
  imageOcclusion,
  image,
}

class StudyCardItems extends Table {
  TextColumn get id => text()();
  TextColumn get folderId => text().references(StudyFolderItems, #id)();
  TextColumn get materialId =>
      text().nullable().references(StudyMaterialItems, #id)();
  TextColumn get type => text()(); // Store as StudyCardType.name
  TextColumn get citationIds => text()
      .map(const StringListConverter())
      .nullable()(); // JSON list of citation IDs

  /// Fields are nullable because not all types use the same properties.
  /// - Flashcard: question (front), answer (back)
  /// - MCQ: question, optionsListJson, answer
  /// - Free-Text: question, answer
  /// - Image Occlusion: (not yet implemented)
  TextColumn get question => text().nullable()();
  TextColumn get optionsListJson => text().nullable()(); // List<String>
  TextColumn get answer => text().nullable()();

  // FSRS fields
  TextColumn get due => text()
      .nullable()(); // ISO8601 UTC, null = never reviewed (due immediately)
  TextColumn get fsrsCardJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
