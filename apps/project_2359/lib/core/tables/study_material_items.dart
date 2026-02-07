import 'package:drift/drift.dart';

/// User: Partly worried that I may be forgetting some properties here.
///       Maybe something like the IDs for the sources or the indexing?
///       Still dont really know how to handle those yet

class StudyMaterialItems extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text()();
  TextColumn get materialType => text()(); // e.g. MCQ, TrueFalse, etc
  TextColumn get citationJson => text().nullable()();

  /// Everything else is nullable because not all types will have the same props.
  /// MCQ: Question, choices, answer
  /// Free-Text: Question, answer
  /// Image Occlusion (not yet implemented; under drafting): List of {question -> answer, and their coordinates and masking values}
  TextColumn get question => text().nullable()();
  TextColumn get optionsListJson => text().nullable()(); // Thisll be a list
  TextColumn get answer => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
