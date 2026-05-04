import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/tables/study_session_events.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

class SchedulingService {
  final AppDatabase _db;
  final fsrs.Scheduler _scheduler = fsrs.Scheduler();
  static const String _tag = 'SchedulingService';

  SchedulingService(this._db);

  /// The main entry point for reviewing a card.
  /// It loads the current schedule, computes the next one via FSRS,
  /// saves it back to the card, and logs the event.
  Future<void> reviewCard({
    required String cardId,
    required fsrs.Rating rating,
    StudySessionMode mode = StudySessionMode.spaced,
  }) async {
    final now = DateTime.now();
    AppLogger.info(
      'Reviewing card $cardId with rating $rating in $mode mode',
      tag: _tag,
    );

    await _db.transaction(() async {
      // 1. Fetch current card
      final card = await (_db.select(
        _db.cardItems,
      )..where((t) => t.id.equals(cardId))).getSingle();

      // 2. Map row data to FSRS Card object based on mode
      // NOTE: For Continuous mode, we don't actually call this from SchedulingService 
      // if we follow the in-memory only rule. But we keep it for backward compatibility 
      // with existing DB columns if needed.
      final fsrsCard = _toFsrsCard(card, mode);

      // 3. Compute next state
      final result = _scheduler.reviewCard(fsrsCard, rating);
      final nextFsrsCard = result.card;

      // 4. Update the card record
      if (mode == StudySessionMode.spaced) {
        final companion = _toCompanion(nextFsrsCard, mode);
        await (_db.update(
          _db.cardItems,
        )..where((t) => t.id.equals(cardId))).write(companion);
      } else {
        // Continuous mode currently does NOT write back to the DB to keep 
        // the main FSRS schedule pure.
        AppLogger.debug('Continuous mode: skipping DB write for card $cardId', tag: _tag);
      }

      // 5. Log the session event
      final scheduledDays = nextFsrsCard.due.difference(now).inDays;

      await _db
          .into(_db.studySessionEvents)
          .insert(
            StudySessionEventsCompanion.insert(
              id: const Uuid().v4(),
              cardId: cardId,
              deckId: card.deckId ?? '',
              rating: rating.index,
              reviewedAt: now.toIso8601String(),
              scheduledDays: scheduledDays,
              mode: mode,
            ),
          );

      AppLogger.debug(
        'Card $cardId updated. Next due: ${nextFsrsCard.due}',
        tag: _tag,
      );
    });
  }

  /// Gives a hypothetical rating to a card and returns the resulting due date.
  /// Useful for displaying "1d", "4d", etc. on review buttons.
  Future<DateTime> getPreviewNextDue({
    required String cardId,
    required fsrs.Rating rating,
    StudySessionMode mode = StudySessionMode.spaced,
  }) async {
    final card = await (_db.select(
      _db.cardItems,
    )..where((t) => t.id.equals(cardId))).getSingle();

    final fsrsCard = _toFsrsCard(card, mode);
    final result = _scheduler.reviewCard(fsrsCard, rating);

    return result.card.due;
  }

  /// Maps a CardItem row to an fsrs.Card
  fsrs.Card _toFsrsCard(CardItem card, StudySessionMode mode) {
    final fCardId = card.id.hashCode;
    
    if (mode == StudySessionMode.spaced) {
      return fsrs.Card(
        cardId: fCardId,
        due: card.spacedDue,
        stability: card.spacedStability,
        difficulty: card.spacedDifficulty,
        state: fsrs.State.values[card.spacedState],
        step: card.spacedStep,
        lastReview: card.spacedLastReview,
      );
    } else {
      // Even in continuous mode, we load from the drill columns if they exist
      return fsrs.Card(
        cardId: fCardId,
        due: card.drillDue,
        stability: card.drillStability,
        difficulty: card.drillDifficulty,
        state: fsrs.State.values[card.drillState],
        step: card.drillStep,
        lastReview: card.drillLastReview,
      );
    }
  }

  /// Converts FSRS Card object back to a Drift companion
  CardItemsCompanion _toCompanion(fsrs.Card card, StudySessionMode mode) {
    if (mode == StudySessionMode.spaced) {
      return CardItemsCompanion(
        spacedDue: Value(card.due),
        spacedStability: Value(card.stability),
        spacedDifficulty: Value(card.difficulty),
        spacedState: Value(card.state.index),
        spacedStep: Value(card.step!),
        spacedLastReview: Value(card.lastReview),
      );
    } else {
      return CardItemsCompanion(
        drillDue: Value(card.due),
        drillStability: Value(card.stability),
        drillDifficulty: Value(card.difficulty),
        drillState: Value(card.state.index),
        drillStep: Value(card.step!),
        drillLastReview: Value(card.lastReview),
      );
    }
  }

  // --- Query Support ---

  /// Returns cards that are due right now for a specific deck and mode.
  Stream<List<CardItem>> watchDueCards({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug('Watching due cards for deck $deckId', tag: _tag);
    final now = DateTime.now();
    final query = _db.select(_db.cardItems)
      ..where((t) => t.deckId.equals(deckId));

    if (mode == StudySessionMode.spaced) {
      query.where((t) => t.spacedDue.isSmallerOrEqualValue(now));
      query.orderBy([(t) => OrderingTerm.asc(t.spacedDue)]);
    } else {
      query.where((t) => t.drillDue.isSmallerOrEqualValue(now));
      query.orderBy([(t) => OrderingTerm.asc(t.drillDue)]);
    }

    return query.watch();
  }

  /// Watch just the due count for a specific deck
  Stream<int> watchDueCount({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    final now = DateTime.now();
    final query = _db.selectOnly(_db.cardItems)
      ..addColumns([_db.cardItems.id.count()])
      ..where(_db.cardItems.deckId.equals(deckId));

    if (mode == StudySessionMode.spaced) {
      query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
    } else {
      query.where(_db.cardItems.drillDue.isSmallerOrEqualValue(now));
    }

    return query
        .map((row) => row.read<int>(_db.cardItems.id.count()) ?? 0)
        .watchSingle();
  }

  /// Watch due count for an entire folder (joins decks and cards)
  Stream<int> watchDueCountForFolder({
    required String folderId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug('Watching due count for folder $folderId', tag: _tag);
    final now = DateTime.now();
    final count = _db.cardItems.id.count();

    final query =
        _db.selectOnly(_db.cardItems).join([
            innerJoin(
              _db.deckItems,
              _db.deckItems.id.equalsExp(_db.cardItems.deckId),
            ),
          ])
          ..addColumns([count])
          ..where(_db.deckItems.folderId.equals(folderId));

    if (mode == StudySessionMode.spaced) {
      query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
    } else {
      query.where(_db.cardItems.drillDue.isSmallerOrEqualValue(now));
    }

    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  /// Watch total due count across the entire app
  Stream<int> watchTotalDueCount({
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug('Watching total app-wide due count', tag: _tag);
    final now = DateTime.now();
    final query = _db.selectOnly(_db.cardItems)
      ..addColumns([_db.cardItems.id.count()]);

    if (mode == StudySessionMode.spaced) {
      query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
    } else {
      query.where(_db.cardItems.drillDue.isSmallerOrEqualValue(now));
    }

    return query
        .map((row) => row.read<int>(_db.cardItems.id.count()) ?? 0)
        .watchSingle();
  }

  // --- Query Support (Lists of Task/Card IDs for flexibility) ---

  /// Watch due card items for an entire folder
  Stream<List<CardItem>> watchDueCardItemsForFolder({
    required String folderId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug(
      'Watching due card items for folder $folderId ($mode)',
      tag: _tag,
    );
    final now = DateTime.now();

    final query = _db.select(_db.cardItems).join([
      innerJoin(
        _db.deckItems,
        _db.deckItems.id.equalsExp(_db.cardItems.deckId),
      ),
    ])..where(_db.deckItems.folderId.equals(folderId));

    if (mode == StudySessionMode.spaced) {
      query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
      query.orderBy([OrderingTerm.asc(_db.cardItems.spacedDue)]);
    } else {
      query.where(_db.cardItems.drillDue.isSmallerOrEqualValue(now));
      query.orderBy([OrderingTerm.asc(_db.cardItems.drillDue)]);
    }

    return query.watch().map(
      (rows) => rows.map((r) => r.readTable(_db.cardItems)).toList(),
    );
  }

  /// Watch total due card items across the entire app
  Stream<List<CardItem>> watchTotalDueCardItems({
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug(
      'Watching total app-wide due card items ($mode)',
      tag: _tag,
    );
    final now = DateTime.now();
    final query = _db.select(_db.cardItems);

    if (mode == StudySessionMode.spaced) {
      query.where((t) => t.spacedDue.isSmallerOrEqualValue(now));
      query.orderBy([(t) => OrderingTerm.asc(t.spacedDue)]);
    } else {
      query.where((t) => t.drillDue.isSmallerOrEqualValue(now));
      query.orderBy([(t) => OrderingTerm.asc(t.drillDue)]);
    }

    return query.watch();
  }

  /// Fetches all cards for a specific deck.
  Future<List<CardItem>> getAllCardsForDeck(String deckId) async {
    return await (_db.select(_db.cardItems)..where((t) => t.deckId.equals(deckId))).get();
  }

}
