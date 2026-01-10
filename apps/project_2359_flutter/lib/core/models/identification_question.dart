/// Identification question domain model for Project 2359
///
/// Represents identification-style questions where users identify
/// a term or concept from its definition/description.
library;

import 'source_reference.dart';

/// An identification question for term/concept recognition.
class IdentificationQuestion {
  final String id;
  final String sourceId;
  final String question;

  /// Model answer or key points expected
  final String modelAnswer;

  /// Hints to guide the student
  final List<String> hints;

  /// Keywords that should appear in a good answer
  final List<String> keywords;

  /// Reference to the source location
  final SourceReference? sourceReference;

  /// Tags for organization
  final List<String> tags;

  /// Difficulty level (1-5)
  final int difficulty;

  final DateTime createdAt;
  final DateTime updatedAt;

  const IdentificationQuestion({
    required this.id,
    required this.sourceId,
    required this.question,
    required this.modelAnswer,
    this.hints = const [],
    this.keywords = const [],
    this.sourceReference,
    this.tags = const [],
    this.difficulty = 3,
    required this.createdAt,
    required this.updatedAt,
  });

  IdentificationQuestion copyWith({
    String? id,
    String? sourceId,
    String? question,
    String? modelAnswer,
    List<String>? hints,
    List<String>? keywords,
    SourceReference? sourceReference,
    List<String>? tags,
    int? difficulty,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IdentificationQuestion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      question: question ?? this.question,
      modelAnswer: modelAnswer ?? this.modelAnswer,
      hints: hints ?? this.hints,
      keywords: keywords ?? this.keywords,
      sourceReference: sourceReference ?? this.sourceReference,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
