import 'package:isar/isar.dart';

enum CardType {
  flashcard, // Standard Front/Back
  mcq, // Multiple Choice
  freeText, // Type in the answer
  imageOcclusion, // Future support
}

enum CardState {
  newCard, // 0: Never studied
  learning, // 1: In short-term learning steps
  review, // 2: Graduated, tracking via FSRS
  relearning, // 3: Lapsed (forgotten), back in learning steps
}

@collection
class CardEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String uuid;

  @Index()
  String deckId; // Links to DeckEntity.uuid

  // --- Content Payload ---
  @Enumerated(EnumType.ordinal)
  CardType cardType;

  /// Flexible JSON storage for content.
  /// Example MCQ: { "question": "...", "options": ["A", "B"], "correctIndex": 1 }
  /// Example Flashcard: { "front": "...", "back": "...", "images": [...] }
  String jsonContent;

  // --- Source Linking (File Indexer) ---
  /// UUID of the original file (e.g., the PDF this card came from)
  String? sourceFileId;

  /// Character index start/end in the source file.
  /// Allows the app to "Open source context" when reviewing.
  int? sourceStartIndex;
  int? sourceEndIndex;

  // --- FSRS Memory State (CRITICAL) ---
  @Enumerated(EnumType.ordinal)
  CardState state;

  /// The date this card is next due to be shown.
  @Index()
  DateTime due;

  /// Stability (S): Interval where retention drops to 90%.
  double stability;

  /// Difficulty (D): 1-10 scale of complexity.
  double difficulty;

  /// Days since the card was last reviewed.
  double elapsedDays;

  /// The interval the card was *scheduled* for (used for optimization).
  double scheduledDays;

  /// Total repetition count.
  int reps;

  /// Total number of times the user forgot this card.
  int lapses;

  /// Timestamp of the last review.
  DateTime lastReview;

  // --- Metadata ---
  bool isSuspended; // User manually paused this card
  DateTime createdAt;
  DateTime updatedAt;

  CardEntity({
    required this.uuid,
    required this.deckId,
    required this.cardType,
    required this.jsonContent,
    required this.state,
    required this.due,
    required this.stability,
    required this.difficulty,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
    required this.lapses,
    required this.lastReview,
    this.sourceFileId,
    this.sourceStartIndex,
    this.sourceEndIndex,
    required this.isSuspended,
    required this.createdAt,
    required this.updatedAt,
  });
}
