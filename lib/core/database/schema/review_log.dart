import 'package:isar/isar.dart';

enum Rating {
  again, // 1: Forgot
  hard, // 2: Remembered with difficulty
  good, // 3: Remembered perfectly
  easy, // 4: Remembered with no effort
}

@collection
class ReviewLog {
  Id id = Isar.autoIncrement;

  @Index()
  String cardId; // Links to CardEntity.uuid

  // --- Review Outcome ---
  @Enumerated(EnumType.ordinal)
  Rating rating; // The button the user pressed

  /// The state of the card *before* this review (New, Learning, Review).
  /// Essential for distinguishing "learning" logs from "review" logs.
  int state;

  // --- Timing Data ---
  /// When the review actually happened.
  DateTime reviewedAt;

  /// When the card was *supposed* to be reviewed (Due Date).
  /// FSRS uses the difference between this and reviewedAt to calculate "Retrievability".
  DateTime due;

  /// How long the user stared at the card (in milliseconds).
  /// Useful for analytics: "Hard cards take me 15s avg".
  int durationMillis;

  // --- FSRS Snapshots ---
  /// Stability of the card *after* this review.
  double stability;

  /// Difficulty of the card *after* this review.
  double difficulty;

  /// The actual days passed since the previous review.
  double elapsedDays;

  /// The interval that was scheduled for this review.
  double scheduledDays;

  ReviewLog({
    required this.cardId,
    required this.rating,
    required this.reviewedAt,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.due,
    required this.state,
    required this.durationMillis,
    required this.stability,
    required this.difficulty,
  });
}
