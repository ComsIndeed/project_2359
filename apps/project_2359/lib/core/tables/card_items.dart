import 'package:drift/drift.dart';
import 'package:project_2359/core/tables/deck_items.dart';
import 'package:project_2359/core/tables/card_creation_draft_items.dart';
import 'package:project_2359/core/models/card_occlusion.dart';

class CardItems extends Table {
  TextColumn get id => text()();

  TextColumn get frontText => text().nullable()();
  TextColumn get backText => text().nullable()();

  TextColumn get frontImageId => text().nullable()();
  TextColumn get backImageId => text().nullable()();

  TextColumn get occlusionData =>
      text().map(const CardOcclusionConverter()).nullable()();

  // --- Spaced Repetition (Standard) ---
  DateTimeColumn get spacedDue =>
      dateTime().nullable().withDefault(currentDateAndTime)();
  RealColumn get spacedStability => real().nullable()();
  RealColumn get spacedDifficulty => real().nullable()();
  IntColumn get spacedState =>
      integer().nullable().withDefault(const Constant(0))();
  IntColumn get spacedStep =>
      integer().nullable().withDefault(const Constant(0))();
  DateTimeColumn get spacedLastReview => dateTime().nullable()();

  // --- Continuous Mode (Standby) ---
  DateTimeColumn get continuousDue =>
      dateTime().nullable().withDefault(currentDateAndTime)();
  RealColumn get continuousStability => real().nullable()();
  RealColumn get continuousDifficulty => real().nullable()();
  IntColumn get continuousState =>
      integer().nullable().withDefault(const Constant(0))();
  IntColumn get continuousStep =>
      integer().nullable().withDefault(const Constant(0))();
  DateTimeColumn get continuousLastReview => dateTime().nullable()();

  TextColumn get deckId => text().nullable().references(DeckItems, #id)();
  TextColumn get draftId =>
      text().nullable().references(CardCreationDraftItems, #id)();

  DateTimeColumn get createdAt =>
      dateTime().nullable().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().nullable().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
