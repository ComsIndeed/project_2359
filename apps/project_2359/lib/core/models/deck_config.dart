import 'dart:convert';
import 'package:drift/drift.dart';

/// Defines the order in which new cards are gathered from the deck.
enum NewCardGatherOrder {
  /// Gather cards in the order they were added to the deck (oldest first).
  oldestFirst,

  /// Gather cards in random order.
  random,
}

/// Defines how new cards are interleaved with review cards during a session.
enum NewReviewMixOrder {
  /// Show all new cards before starting reviews.
  newBeforeReviews,

  /// Show all reviews before starting new cards.
  reviewsBeforeNew,

  /// Mix new cards and reviews together.
  interleaved,
}

/// Defines the sort priority for the review queue.
enum ReviewSortOrder {
  /// Sort by due date (standard).
  dueOrder,

  /// Randomize the review order.
  random,

  /// Prioritize cards that the user is most likely to forget.
  ascendingRetrievability,

  /// Prioritize the hardest cards.
  ascendingDifficulty,
}

/// Defines the automatic action taken when a card becomes a leech.
enum LeechAction {
  /// Remove the card from all study queues until manually addressed.
  suspend,

  /// Only tag the card as a leech without removing it from queues.
  tagOnly,
}

/// Configuration policy for a deck, controlling workload, scheduling, and queue behavior.
class DeckConfig {
  // --- 1. Workload Control ---

  /// The maximum number of new cards to introduce per day.
  /// This acts as a throttle for future workload.
  final int newCardsPerDay;

  /// The maximum number of reviews to perform per day.
  /// If the number of due cards exceeds this, the remaining are deferred.
  final int maxReviewsPerDay;

  // --- 2. Learning and Relearning Steps ---

  /// The sequence of intervals (in minutes) for new cards in the learning state.
  /// Example: [1, 10] means a card is shown after 1m and then 10m before graduating.
  final List<int> learningSteps;

  /// The sequence of intervals (in minutes) for cards that have been lapsed (failed).
  final List<int> relearningSteps;

  /// The initial interval (in days) applied when a card graduates from the learning phase.
  final int graduatingInterval;

  /// The interval (in days) applied if a card is rated 'Easy' during the learning phase.
  final int easyInterval;

  // --- 3. Queue Orchestration ---

  /// The strategy used to pick which new cards to show first.
  final NewCardGatherOrder newCardGatherOrder;

  /// How new cards and reviews are mixed during the study session.
  final NewReviewMixOrder newReviewMixOrder;

  /// The priority order for cards in the review queue.
  final ReviewSortOrder reviewSortOrder;

  // --- 4. Sibling Burying ---

  /// If true, other new cards from the same note will be hidden until the next day
  /// when one card from that note is studied.
  final bool buryNewSiblings;

  /// If true, other review cards from the same note will be hidden until the next day
  /// when one card from that note is studied.
  final bool buryReviewSiblings;

  // --- 5. Constraints and FSRS Parameters ---

  /// The target probability of successful recall (0.7 to 0.97).
  /// Higher values increase the frequency of reviews.
  final double desiredRetention;

  /// The absolute maximum interval (in days) any card can reach.
  final int maximumInterval;

  /// The minimum interval (in days) applied to a card after a lapse.
  final int minimumLapseInterval;

  /// The optimized weights for the FSRS model.
  final List<double> fsrsWeights;

  // --- 6. Leech Handling ---

  /// The number of times a card must lapse (fail) before it is marked as a leech.
  final int leechThreshold;

  /// The action to perform automatically when a card reaches the leech threshold.
  final LeechAction leechAction;

  const DeckConfig({
    this.newCardsPerDay = 20,
    this.maxReviewsPerDay = 200,
    this.learningSteps = const [1, 10],
    this.relearningSteps = const [10],
    this.graduatingInterval = 1,
    this.easyInterval = 4,
    this.newCardGatherOrder = NewCardGatherOrder.oldestFirst,
    this.newReviewMixOrder = NewReviewMixOrder.newBeforeReviews,
    this.reviewSortOrder = ReviewSortOrder.dueOrder,
    this.buryNewSiblings = true,
    this.buryReviewSiblings = true,
    this.desiredRetention = 0.9,
    this.maximumInterval = 36500,
    this.minimumLapseInterval = 1,
    this.fsrsWeights = const [
      0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01, 1.49,
      0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61,
    ],
    this.leechThreshold = 8,
    this.leechAction = LeechAction.suspend,
  });

  factory DeckConfig.fromJson(Map<String, dynamic> json) {
    return DeckConfig(
      newCardsPerDay: json['newCardsPerDay'] as int? ?? 20,
      maxReviewsPerDay: json['maxReviewsPerDay'] as int? ?? 200,
      learningSteps: (json['learningSteps'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [1, 10],
      relearningSteps: (json['relearningSteps'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [10],
      graduatingInterval: json['graduatingInterval'] as int? ?? 1,
      easyInterval: json['easyInterval'] as int? ?? 4,
      newCardGatherOrder: NewCardGatherOrder.values.firstWhere(
        (e) => e.name == json['newCardGatherOrder'],
        orElse: () => NewCardGatherOrder.oldestFirst,
      ),
      newReviewMixOrder: NewReviewMixOrder.values.firstWhere(
        (e) => e.name == json['newReviewMixOrder'],
        orElse: () => NewReviewMixOrder.newBeforeReviews,
      ),
      reviewSortOrder: ReviewSortOrder.values.firstWhere(
        (e) => e.name == json['reviewSortOrder'],
        orElse: () => ReviewSortOrder.dueOrder,
      ),
      buryNewSiblings: json['buryNewSiblings'] as bool? ?? true,
      buryReviewSiblings: json['buryReviewSiblings'] as bool? ?? true,
      desiredRetention: (json['desiredRetention'] as num? ?? 0.9).toDouble(),
      maximumInterval: json['maximumInterval'] as int? ?? 36500,
      minimumLapseInterval: json['minimumLapseInterval'] as int? ?? 1,
      fsrsWeights: (json['fsrsWeights'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [
            0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01, 1.49,
            0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61,
          ],
      leechThreshold: json['leechThreshold'] as int? ?? 8,
      leechAction: LeechAction.values.firstWhere(
        (e) => e.name == json['leechAction'],
        orElse: () => LeechAction.suspend,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newCardsPerDay': newCardsPerDay,
      'maxReviewsPerDay': maxReviewsPerDay,
      'learningSteps': learningSteps,
      'relearningSteps': relearningSteps,
      'graduatingInterval': graduatingInterval,
      'easyInterval': easyInterval,
      'newCardGatherOrder': newCardGatherOrder.name,
      'newReviewMixOrder': newReviewMixOrder.name,
      'reviewSortOrder': reviewSortOrder.name,
      'buryNewSiblings': buryNewSiblings,
      'buryReviewSiblings': buryReviewSiblings,
      'desiredRetention': desiredRetention,
      'maximumInterval': maximumInterval,
      'minimumLapseInterval': minimumLapseInterval,
      'fsrsWeights': fsrsWeights,
      'leechThreshold': leechThreshold,
      'leechAction': leechAction.name,
    };
  }
}

class DeckConfigConverter extends TypeConverter<DeckConfig, String> {
  const DeckConfigConverter();

  @override
  DeckConfig fromSql(String fromDb) {
    return DeckConfig.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(DeckConfig value) {
    return json.encode(value.toJson());
  }
}
