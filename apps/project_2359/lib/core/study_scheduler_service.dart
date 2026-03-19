import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';
import 'package:uuid/uuid.dart';

import 'package:project_2359/app_database.dart';

class StudySchedulerService {
  final AppDatabase _db;
  // Scheduler uses all defaults — 0.9 retention, standard learning steps.
  // You can expose this as a user setting later.
  final Scheduler _scheduler = Scheduler();

  StudySchedulerService(this._db);

  /// Cards are due if `due` is null (never reviewed) or <= now.
  Future<List<StudyCardItem>> getCardsDue(String materialId) async {
    final now = DateTime.now().toUtc().toIso8601String();
    return await (_db.select(_db.studyCardItems)..where(
          (t) =>
              t.materialId.equals(materialId) &
              (t.due.isNull() | t.due.isSmallerOrEqualValue(now)),
        ))
        .get();
  }

  Future<int> getDueCount(String materialId) async {
    final cards = await getCardsDue(materialId);
    return cards.length;
  }

  Stream<int> watchDueCount(String materialId) {
    final now = DateTime.now().toUtc().toIso8601String();
    return (_db.select(_db.studyCardItems)..where(
          (t) =>
              t.materialId.equals(materialId) &
              (t.due.isNull() | t.due.isSmallerOrEqualValue(now)),
        ))
        .watch()
        .map((cards) => cards.length);
  }

  Future<void> recordReview(String cardId, Rating rating) async {
    // 1. Fetch the row
    final row = await (_db.select(
      _db.studyCardItems,
    )..where((t) => t.id.equals(cardId))).getSingle();

    // 2. Reconstruct the fsrs Card from stored JSON, or create a fresh one
    final Card fsrsCard;
    if (row.fsrsCardJson != null) {
      fsrsCard = Card.fromMap(
        Map<String, dynamic>.from(jsonDecode(row.fsrsCardJson!)),
      );
    } else {
      // First review — create a new card. cardId here is just an int identifier
      // for the fsrs package; we use 0 since we track identity via our own UUID.
      fsrsCard = Card(cardId: 0);
    }

    // 3. Review — no datetime argument in v2, it uses DateTime.now().toUtc() internally
    final (:card, :reviewLog) = _scheduler.reviewCard(fsrsCard, rating);

    // 4. Serialize and write back
    await (_db.update(
      _db.studyCardItems,
    )..where((t) => t.id.equals(cardId))).write(
      StudyCardItemsCompanion(
        due: Value(card.due.toUtc().toIso8601String()),
        fsrsCardJson: Value(jsonEncode(card.toMap())),
      ),
    );

    final scheduledDays = card.due
        .toUtc()
        .difference(DateTime.now().toUtc())
        .inDays
        .clamp(0, 999999);

    // TODO: IMPLEMENT LAST REVIEW BS

    // final elapsedDays = row.lastReview != null
    //     ? DateTime.now()
    //           .toUtc()
    //           .difference(DateTime.parse(row.lastReview!))
    //           .inDays
    //           .clamp(0, 999999)
    //     : 0;

    // 5. Log the session event
    await _db
        .into(_db.studySessionEvents)
        .insert(
          StudySessionEventsCompanion.insert(
            id: const Uuid().v4(),
            cardId: cardId,
            materialId: row.materialId,
            rating: rating.index,
            reviewedAt: reviewLog.reviewDateTime.toUtc().toIso8601String(),
            scheduledDays: scheduledDays,
            // elapsedDays: card.elapsedDays,
          ),
        );
  }

  /// Retrievability: probability (0–1) the user still remembers this card right now.
  /// Useful for a "health" indicator on the material detail page later.
  double? getRetrievability(StudyCardItem row) {
    if (row.fsrsCardJson == null) return null;
    final fsrsCard = Card.fromMap(
      Map<String, dynamic>.from(jsonDecode(row.fsrsCardJson!)),
    );
    return _scheduler.getCardRetrievability(fsrsCard);
  }

  Future<int> getReviewedTodayCount() async {
    final startOfDay = DateTime.now().toUtc().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final events =
        await (_db.select(_db.studySessionEvents)..where(
              (t) => t.reviewedAt.isBiggerOrEqualValue(
                startOfDay.toIso8601String(),
              ),
            ))
            .get();
    return events.length;
  }
}
