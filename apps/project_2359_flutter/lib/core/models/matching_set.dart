/// Matching item domain model for Project 2359
///
/// Represents matching exercises where items from two columns are paired.
library;

import 'source_reference.dart';

/// A single matching pair.
class MatchingPair {
  final String id;
  final String left;
  final String right;

  const MatchingPair({
    required this.id,
    required this.left,
    required this.right,
  });
}

/// A set of matching pairs for study.
class MatchingSet {
  final String id;
  final String sourceId;
  final String title;

  /// The pairs to match
  final List<MatchingPair> pairs;

  /// Instructions for the matching exercise
  final String? instructions;

  /// Reference to the source location
  final SourceReference? sourceReference;

  /// Tags for organization
  final List<String> tags;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MatchingSet({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.pairs,
    this.instructions,
    this.sourceReference,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  MatchingSet copyWith({
    String? id,
    String? sourceId,
    String? title,
    List<MatchingPair>? pairs,
    String? instructions,
    SourceReference? sourceReference,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MatchingSet(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      pairs: pairs ?? this.pairs,
      instructions: instructions ?? this.instructions,
      sourceReference: sourceReference ?? this.sourceReference,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
