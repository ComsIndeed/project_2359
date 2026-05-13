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
      // 1. Fetch current card and its deck/config
      final card = await (_db.select(_db.cardItems)
            ..where((t) => t.id.equals(cardId)))
          .getSingle();

      final deck = await (_db.select(_db.deckItems)
            ..where((t) => t.id.equals(card.deckId ?? '')))
          .getSingleOrNull();

      DeckConfigItem? config;
      if (deck?.configId != null) {
        config = await (_db.select(_db.deckConfigItems)
              ..where((t) => t.id.equals(deck!.configId!)))
            .getSingleOrNull();
      }

      // 2. Map row data to FSRS Card object
      final fsrsCard = _toFsrsCard(card, mode);

      // 3. Compute next state (Custom Checkpoint Logic for New/Learning cards)
      DateTime nextDue;
      fsrs.Card nextFsrsCard;
      int nextStep = card.spacedStep ?? 0;
      int nextState = card.spacedState ?? 0;

      final learningSteps = (config?.learningSteps ?? '1,10')
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 1)
          .toList();

      if (mode == StudySessionMode.spaced &&
          (card.spacedState == 0 ||
              fsrsCard.state == fsrs.State.learning)) {
        // --- Anki-style Checkpoint Logic ---
        if (rating == fsrs.Rating.again) {
          nextStep = 0;
          nextDue = now.add(Duration(minutes: learningSteps[0]));
          nextState = fsrs.State.learning.index;
          nextFsrsCard = fsrsCard.copyWith(
            due: nextDue,
            state: fsrs.State.learning,
            step: nextStep,
          );
        } else if (rating == fsrs.Rating.easy) {
          // Immediate graduation
          final result = _scheduler.reviewCard(fsrsCard, rating);
          nextFsrsCard = result.card;
          nextDue = nextFsrsCard.due;
          nextState = nextFsrsCard.state.index;
          nextStep = 0;
        } else {
          // Good or Hard
          nextStep++;
          if (nextStep >= learningSteps.length) {
            // Graduate!
            final result = _scheduler.reviewCard(fsrsCard, rating);
            nextFsrsCard = result.card;
            nextDue = nextFsrsCard.due;
            nextState = nextFsrsCard.state.index;
            nextStep = 0;
          } else {
            // Stay in learning steps
            nextDue = now.add(Duration(minutes: learningSteps[nextStep]));
            nextState = fsrs.State.learning.index;
            nextFsrsCard = fsrsCard.copyWith(
              due: nextDue,
              state: fsrs.State.learning,
              step: nextStep,
            );
          }
        }
      } else {
        // --- Standard FSRS for Review/Relearning ---
        final result = _scheduler.reviewCard(fsrsCard, rating);
        nextFsrsCard = result.card;
        nextDue = nextFsrsCard.due;
        nextState = nextFsrsCard.state.index;
        nextStep = nextFsrsCard.step ?? 0;
      }

      // 4. Update the card record
      final companion = _toCompanion(nextFsrsCard, mode).copyWith(
        spacedStep: Value(nextStep),
        spacedState: Value(nextState),
      );
      
      await (_db.update(_db.cardItems)..where((t) => t.id.equals(cardId)))
          .write(companion);

      // 5. Automatic Sibling Burying
      if (config?.burySiblings ?? true) {
        if (card.noteId != null) {
          final tomorrow = DateTime(now.year, now.month, now.day + 1);
          await (_db.update(_db.cardItems)
                ..where((t) => t.noteId.equals(card.noteId!))
                ..where((t) => t.id.equals(cardId).not()))
              .write(CardItemsCompanion(
            isBuried: const Value(true),
            buriedUntil: Value(tomorrow),
          ));
        }
      }

      // 6. Log the session event
      final scheduledDays = nextDue.difference(now).inDays;

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
    final now = DateTime.now();

    if (mode == StudySessionMode.spaced) {
      return fsrs.Card(
        cardId: fCardId,
        due: card.spacedDue ?? now,
        stability: card.spacedStability ?? 0.0,
        difficulty: card.spacedDifficulty ?? 0.0,
        state: fsrs.State.values[card.spacedState ?? 0],
        step: card.spacedStep ?? 0,
        lastReview: card.spacedLastReview,
      );
    } else {
      // Load from continuous columns
      return fsrs.Card(
        cardId: fCardId,
        due: card.continuousDue ?? now,
        stability: card.continuousStability ?? 0.0,
        difficulty: card.continuousDifficulty ?? 0.0,
        state: fsrs.State.values[card.continuousState ?? 0],
        step: card.continuousStep ?? 0,
        lastReview: card.continuousLastReview,
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
        spacedStep: Value(card.step ?? 0),
        spacedLastReview: Value(card.lastReview),
      );
    } else {
      return CardItemsCompanion(
        continuousDue: Value(card.due),
        continuousStability: Value(card.stability),
        continuousDifficulty: Value(card.difficulty),
        continuousState: Value(card.state.index),
        continuousStep: Value(card.step ?? 0),
        continuousLastReview: Value(card.lastReview),
      );
    }
  }

  // --- Query Support ---

  Stream<List<CardItem>> watchDueCards({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug('Watching due cards for deck $deckId (recursive)', tag: _tag);
    
    return Stream.fromFuture(_getTransitiveDeckIds(deckId)).asyncExpand((allDeckIds) {
      final now = DateTime.now();
      final query = _db.select(_db.cardItems)
        ..where((t) => t.deckId.isIn(allDeckIds));

      if (mode == StudySessionMode.spaced) {
        query.where((t) => t.spacedDue.isSmallerOrEqualValue(now));
      } else {
        query.where((t) => t.continuousDue.isSmallerOrEqualValue(now));
      }

      // Order by due date early in SQL
      if (mode == StudySessionMode.spaced) {
        query.orderBy([(t) => OrderingTerm.asc(t.spacedDue)]);
      }

      return query.watch().asyncMap((deckCards) async {
        return await _applyLimitsAndFilters(deckId, deckCards, mode);
      });
    });
  }

  final Map<String, List<String>> _transitiveDeckIdsCache = {};
  DateTime? _lastDeckCacheUpdate;

  Future<List<String>> _getTransitiveDeckIds(String rootId) async {
    final now = DateTime.now();
    // Cache for 5 seconds to avoid storming during batch updates
    if (_lastDeckCacheUpdate != null && 
        now.difference(_lastDeckCacheUpdate!).inSeconds < 5 &&
        _transitiveDeckIdsCache.containsKey(rootId)) {
      return _transitiveDeckIdsCache[rootId]!;
    }

    // 1. Fetch all decks once
    final allDecks = await _db.select(_db.deckItems).get();
    
    // 2. Build map of parent -> children
    final childrenMap = <String, List<String>>{};
    for (final deck in allDecks) {
      if (deck.parentId != null) {
        childrenMap.putIfAbsent(deck.parentId!, () => []).add(deck.id);
      }
    }
    
    // 3. Helper to build transitive list for a specific ID
    List<String> buildList(String id) {
      final list = [id];
      final children = childrenMap[id];
      if (children != null) {
        for (final childId in children) {
          list.addAll(buildList(childId));
        }
      }
      return list;
    }

    // 4. Update cache for ALL decks while we're at it
    _transitiveDeckIdsCache.clear();
    for (final deck in allDecks) {
      _transitiveDeckIdsCache[deck.id] = buildList(deck.id);
    }
    
    _lastDeckCacheUpdate = now;
    return _transitiveDeckIdsCache[rootId] ?? [rootId];
  }

  Future<List<CardItem>> _applyLimitsAndFilters(String deckId, List<CardItem> cards, StudySessionMode mode) async {
    final now = DateTime.now();
    
    // 1. Fetch deck and config
    final deck = await (_db.select(_db.deckItems)..where((t) => t.id.equals(deckId))).getSingleOrNull();
    DeckConfigItem? config;
    if (deck?.configId != null) {
      config = await (_db.select(_db.deckConfigItems)..where((t) => t.id.equals(deck!.configId!))).getSingleOrNull();
    }
    
    final newLimit = config?.newCardsPerDay ?? 20;
    final reviewLimit = config?.reviewsPerDay ?? 200;

    // 2. Count today's stats
    final stats = await getTodayStats(deckId);
    final remainingNew = (newLimit - stats.newCards).clamp(0, newLimit);
    final remainingReviews = (reviewLimit - stats.reviews).clamp(0, reviewLimit);

    // 3. Filter cards
    final filtered = cards.where((t) {
      if (t.isSuspended) return false;
      if (t.isBuried && t.buriedUntil != null && t.buriedUntil!.isAfter(now)) return false;
      
      if (mode == StudySessionMode.spaced) {
        return (t.spacedDue ?? now).isBefore(now) || (t.spacedDue ?? now).isAtSameMomentAs(now);
      } else {
        return (t.continuousDue ?? now).isBefore(now) || (t.continuousDue ?? now).isAtSameMomentAs(now);
      }
    }).toList();

    if (mode == StudySessionMode.spaced) {
      // Separate new from reviews
      // A card is 'new' if it has never been reviewed in spaced mode
      final newCards = filtered.where((c) => c.spacedLastReview == null).toList();
      final reviewCards = filtered.where((c) => c.spacedLastReview != null).toList();

      // Apply limits
      final limitedNew = newCards.take(remainingNew).toList();
      final limitedReviews = reviewCards.take(remainingReviews).toList();

      final result = [...limitedReviews, ...limitedNew];
      
      // Order
      if (config?.reviewOrder == 1) { // Random
        result.shuffle();
      } else {
        result.sort((a, b) => (a.spacedDue ?? now).compareTo(b.spacedDue ?? now));
      }
      
      return result;
    } else {
      return filtered;
    }
  }

  Future<({int newCards, int reviews})> getTodayStats(String deckId) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();
    
    final query = _db.select(_db.studySessionEvents)
      ..where((t) => t.deckId.equals(deckId))
      ..where((t) => t.reviewedAt.isBiggerOrEqualValue(todayStart));
    
    final events = await query.get();
    if (events.isEmpty) return (newCards: 0, reviews: 0);

    final cardIds = events.map((e) => e.cardId).toSet().toList();
    
    // Find which of these cards were reviewed BEFORE today
    final previouslyReviewed = await (_db.selectOnly(_db.studySessionEvents)
          ..addColumns([_db.studySessionEvents.cardId])
          ..where(_db.studySessionEvents.cardId.isIn(cardIds))
          ..where(_db.studySessionEvents.reviewedAt.isSmallerThanValue(todayStart)))
        .map((row) => row.read(_db.studySessionEvents.cardId))
        .get();
    
    final previouslyReviewedSet = previouslyReviewed.toSet();
    
    int newCount = 0;
    int reviewCount = 0;
    
    final countedAsNew = <String>{};
    for (final event in events) {
      if (previouslyReviewedSet.contains(event.cardId)) {
        reviewCount++;
      } else {
        // If it's the first time we see this card today AND it was never reviewed before today
        if (!countedAsNew.contains(event.cardId)) {
          newCount++;
          countedAsNew.add(event.cardId);
        } else {
          // It was a new card intro today, but this is a subsequent review of the same card today
          reviewCount++;
        }
      }
    }
    
    return (newCards: newCount, reviews: reviewCount);
  }

  /// Watch just the due count for a specific deck (recursive)
  Stream<int> watchDueCount({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    // Avoid watchDueCards (which pulls all cards) for simple badges.
    // We still watch the table but do a lightweight count query.
    return Stream.fromFuture(_getTransitiveDeckIds(deckId)).asyncExpand((allDeckIds) {
      final now = DateTime.now();
      final query = _db.selectOnly(_db.cardItems)
        ..addColumns([_db.cardItems.id.count()])
        ..where(_db.cardItems.deckId.isIn(allDeckIds));

      if (mode == StudySessionMode.spaced) {
        query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
      } else {
        query.where(_db.cardItems.continuousDue.isSmallerOrEqualValue(now));
      }

      return query.map((row) => row.read<int>(_db.cardItems.id.count()) ?? 0).watchSingle();
    });
  }

  /// Direct fetch for the due count (recursive)
  Future<int> getDueCount({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) async {
    final now = DateTime.now();
    final allDeckIds = await _getTransitiveDeckIds(deckId);
    
    final query = _db.selectOnly(_db.cardItems)
      ..addColumns([_db.cardItems.id.count()])
      ..where(_db.cardItems.deckId.isIn(allDeckIds));

    if (mode == StudySessionMode.spaced) {
      query.where(_db.cardItems.spacedDue.isSmallerOrEqualValue(now));
    } else {
      query.where(_db.cardItems.continuousDue.isSmallerOrEqualValue(now));
    }

    final row = await query.getSingle();
    return row.read<int>(_db.cardItems.id.count()) ?? 0;
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
      query.where(_db.cardItems.continuousDue.isSmallerOrEqualValue(now));
    }

    return query
        .map((row) => row.read<int>(_db.cardItems.id.count()) ?? 0)
        .watchSingle();
  }

  // --- Query Support (Lists of Task/Card IDs for flexibility) ---

  /// Watch due card items for a specific deck (recursive)
  Stream<List<CardItem>> watchDueCardItems({
    required String deckId,
    StudySessionMode mode = StudySessionMode.spaced,
  }) {
    AppLogger.debug('Watching due card items for deck $deckId ($mode)', tag: _tag);
    final now = DateTime.now();

    return watchDueCards(deckId: deckId, mode: mode);
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
      query.where((t) => t.continuousDue.isSmallerOrEqualValue(now));
      query.orderBy([(t) => OrderingTerm.asc(t.continuousDue)]);
    }

    return query.watch();
  }

  /// Fetches all cards for a specific deck.
  Future<List<CardItem>> getAllCardsForDeck(String deckId) async {
    return await (_db.select(_db.cardItems)..where((t) => t.deckId.equals(deckId))).get();
  }

  Future<void> suspendCard(String cardId, bool suspend) async {
    await (_db.update(_db.cardItems)..where((t) => t.id.equals(cardId)))
        .write(CardItemsCompanion(isSuspended: Value(suspend)));
  }

  Future<void> buryCard(String cardId) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    await (_db.update(_db.cardItems)..where((t) => t.id.equals(cardId)))
        .write(CardItemsCompanion(
      isBuried: const Value(true),
      buriedUntil: Value(tomorrow),
    ));
  }
}
