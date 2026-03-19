import 'package:drift/drift.dart';

class StudySessionEvents extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get materialId => text()();
  IntColumn get rating => integer()(); // fsrs Rating enum index
  TextColumn get reviewedAt => text()(); // ISO8601 UTC
  IntColumn get scheduledDays => integer()(); // how many days until next review
  // IntColumn get elapsedDays => integer()(); // days since last review

  @override
  Set<Column> get primaryKey => {id};
}
