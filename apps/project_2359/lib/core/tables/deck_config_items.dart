import 'package:drift/drift.dart';

class DeckConfigItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant('Default Config'))();

  // New Cards
  IntColumn get newCardsPerDay => integer().withDefault(const Constant(20))();
  IntColumn get newCardOrder => integer().withDefault(const Constant(0))(); // 0: Added, 1: Random

  // Reviews
  IntColumn get reviewsPerDay => integer().withDefault(const Constant(200))();
  IntColumn get reviewOrder => integer().withDefault(const Constant(0))(); // 0: Due, 1: Random, 2: Deck

  // Learning Steps (minutes) - stored as comma-separated string for simplicity in Drift
  // e.g., "1,10"
  TextColumn get learningSteps => text().withDefault(const Constant('1,10'))();
  TextColumn get relearningSteps => text().withDefault(const Constant('10'))();

  // Intervals (days)
  IntColumn get graduatingInterval => integer().withDefault(const Constant(1))();
  IntColumn get easyInterval => integer().withDefault(const Constant(4))();
  IntColumn get maxInterval => integer().withDefault(const Constant(36500))();

  // FSRS specific
  RealColumn get desiredRetention => real().withDefault(const Constant(0.9))();

  // Burying
  BoolColumn get burySiblings => boolean().withDefault(const Constant(true))();

  // Leech
  IntColumn get leechThreshold => integer().withDefault(const Constant(8))();

  @override
  Set<Column> get primaryKey => {id};
}
