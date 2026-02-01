import 'package:drift/drift.dart';

/// User: Partly worried that I may be forgetting some properties here.
///       Maybe something like the IDs for the sources or the indexing?
///       Still dont really know how to handle those yet

class StudyMaterialItems extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text()();
  TextColumn get materialType => text()(); // e.g. MCQ, TrueFalse, etc
  TextColumn get question => text()();
  TextColumn get optionsListJson => text()(); // Thisll be a list
  TextColumn get answer => text()();

  @override
  Set<Column> get primaryKey => {id};
}
