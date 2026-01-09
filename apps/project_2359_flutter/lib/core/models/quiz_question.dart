/// Quiz question domain model for Project 2359
///
/// Represents multiple choice questions with options and correct answer tracking.
library;

import 'source_reference.dart';

/// A multiple choice quiz question.
class QuizQuestion {
  final String id;
  final String sourceId;
  final String question;
  final List<String> options;

  /// Index of the correct option (0-indexed)
  final int correctOptionIndex;

  /// Explanation shown after answering
  final String? explanation;

  /// Optional image for the question
  final String? imagePath;

  /// Reference to the source location
  final SourceReference? sourceReference;

  /// Tags for organization
  final List<String> tags;

  /// Difficulty level (1-5)
  final int difficulty;

  final DateTime createdAt;
  final DateTime updatedAt;

  const QuizQuestion({
    required this.id,
    required this.sourceId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
    this.imagePath,
    this.sourceReference,
    this.tags = const [],
    this.difficulty = 3,
    required this.createdAt,
    required this.updatedAt,
  });

  String get correctAnswer => options[correctOptionIndex];

  QuizQuestion copyWith({
    String? id,
    String? sourceId,
    String? question,
    List<String>? options,
    int? correctOptionIndex,
    String? explanation,
    String? imagePath,
    SourceReference? sourceReference,
    List<String>? tags,
    int? difficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
      imagePath: imagePath ?? this.imagePath,
      sourceReference: sourceReference ?? this.sourceReference,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
