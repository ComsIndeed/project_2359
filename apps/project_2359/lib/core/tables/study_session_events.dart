import 'package:drift/drift.dart';

class StudySessionEvents extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get deckId => text()();
  IntColumn get rating => integer()(); // fsrs Rating enum index
  TextColumn get reviewedAt => text()(); // ISO8601 UTC
  IntColumn get scheduledDays => integer()(); // how many days until next review

  @override
  Set<Column> get primaryKey => {id};
}
