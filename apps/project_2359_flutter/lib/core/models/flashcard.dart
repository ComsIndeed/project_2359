/// Flashcard domain model for Project 2359
///
/// Represents a two-sided flashcard with front/back content,
/// supporting spaced repetition learning.
library;

import 'source_reference.dart';

/// A flashcard for memorization and spaced repetition.
class Flashcard {
  final String id;
  final String sourceId;
  final String front;
  final String back;

  /// Optional image on the front
  final String? frontImagePath;

  /// Optional image on the back
  final String? backImagePath;

  /// Reference to the exact location in the source
  final SourceReference? sourceReference;

  /// Tags for organization
  final List<String> tags;

  /// Difficulty rating (1-5, used for spaced repetition)
  final int difficulty;

  /// Number of times reviewed
  final int reviewCount;

  /// Last review date
  final DateTime? lastReviewedAt;

  /// Next scheduled review date (for spaced repetition)
  final DateTime? nextReviewAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  const Flashcard({
    required this.id,
    required this.sourceId,
    required this.front,
    required this.back,
    this.frontImagePath,
    this.backImagePath,
    this.sourceReference,
    this.tags = const [],
    this.difficulty = 3,
    this.reviewCount = 0,
    this.lastReviewedAt,
    this.nextReviewAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Flashcard copyWith({
    String? id,
    String? sourceId,
    String? front,
    String? back,
    String? frontImagePath,
    String? backImagePath,
    SourceReference? sourceReference,
    List<String>? tags,
    int? difficulty,
    int? reviewCount,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      front: front ?? this.front,
      back: back ?? this.back,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      sourceReference: sourceReference ?? this.sourceReference,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      reviewCount: reviewCount ?? this.reviewCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
