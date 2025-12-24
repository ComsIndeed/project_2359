import 'package:isar/isar.dart';

@collection
class DeckEntity {
  Id id = Isar.autoIncrement; // Local ID for fast queries

  @Index(unique: true, replace: true)
  String uuid; // Critical for syncing (GUID)

  String name;
  String? description;

  /// Parent Deck UUID for nesting decks (e.g., "Medicine" -> "Cardiology")
  String? parentId;

  // --- FSRS Configuration ---
  /// Stores custom FSRS weights/parameters for this specific deck.
  /// If null, use global defaults. This allows you to tune the algorithm
  /// differently for "Pharmacology" (rote) vs "Physiology" (conceptual).
  List<double>? fsrsWeights;

  /// Desired retention rate (e.g., 0.90 for high stakes, 0.85 for casual)
  double desiredRetention;

  // --- Daily Limits ---
  int newCardsLimit;
  int reviewLimit;

  // --- Metadata ---
  DateTime createdAt;
  DateTime updatedAt;
  bool isArchived;

  DeckEntity({
    required this.uuid,
    required this.name,
    required this.desiredRetention,
    required this.newCardsLimit,
    required this.reviewLimit,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
}
