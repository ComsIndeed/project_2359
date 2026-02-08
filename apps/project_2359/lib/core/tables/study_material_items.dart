import 'package:drift/drift.dart';

/// The type of study material.
enum StudyMaterialType {
  multipleChoiceQuestion,
  freeTextQuestion,
  imageOcclusion,
}

/// Study material items table.
/// Use [StudyMaterialType.name] to store type as string.
class StudyMaterialItems extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text()();
  TextColumn get materialType => text()(); // Store as StudyMaterialType.name
  TextColumn get citationJson => text().nullable()();

  /// Fields are nullable because not all types use the same properties.
  /// - MCQ: question, optionsListJson, answer
  /// - Free-Text: question, answer
  /// - Image Occlusion: (not yet implemented)
  TextColumn get question => text().nullable()();
  TextColumn get optionsListJson => text().nullable()(); // List<String>
  TextColumn get answer => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
