/// Index item model for Project 2359
///
/// Represents an indexed content segment extracted from a source.
/// Simplified structure with unique short IDs and type-specific properties.
library;

import 'dart:math';

/// Type of indexed content
enum IndexItemType {
  /// Direct text extraction from document
  text,

  /// Description of an image (from LLM analysis)
  imageDescription,

  /// Transcription from audio/video
  transcription,
}

/// A single indexed content segment from a source.
///
/// Designed for selective column extraction:
/// - For LLM contexts: use [id] and [content]
/// - For source navigation: use type-specific location fields
class IndexItem {
  /// Unique short identifier for this index item (e.g., 'idx_a1b2c3d4')
  final String id;

  /// The source this item was extracted from
  final String sourceId;

  /// Type of extracted content
  final IndexItemType type;

  /// The actual extracted text content
  final String content;

  /// Creation timestamp
  final DateTime createdAt;

  // --- Type-specific location metadata ---

  /// For text/notes: paragraph number (1-indexed)
  final int? paragraphNumber;

  /// For audio/video: start timestamp in seconds
  final double? startTimestamp;

  /// For audio/video: end timestamp in seconds
  final double? endTimestamp;

  /// For PDF/documents: page number (1-indexed)
  final int? pageNumber;

  /// For images: path to the source image
  final String? imagePath;

  const IndexItem({
    required this.id,
    required this.sourceId,
    required this.type,
    required this.content,
    required this.createdAt,
    this.paragraphNumber,
    this.startTimestamp,
    this.endTimestamp,
    this.pageNumber,
    this.imagePath,
  });

  /// Generate a unique short ID with prefix
  static String generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final suffix = List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return 'idx_$suffix';
  }

  /// Creates a text index item (for documents/notes)
  factory IndexItem.text({
    String? id,
    required String sourceId,
    required String content,
    int? paragraphNumber,
    int? pageNumber,
  }) {
    return IndexItem(
      id: id ?? generateId(),
      sourceId: sourceId,
      type: IndexItemType.text,
      content: content,
      paragraphNumber: paragraphNumber,
      pageNumber: pageNumber,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a transcription index item (for audio/video)
  factory IndexItem.transcription({
    String? id,
    required String sourceId,
    required String content,
    required double startTimestamp,
    double? endTimestamp,
  }) {
    return IndexItem(
      id: id ?? generateId(),
      sourceId: sourceId,
      type: IndexItemType.transcription,
      content: content,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      createdAt: DateTime.now(),
    );
  }

  /// Creates an image description index item
  factory IndexItem.imageDescription({
    String? id,
    required String sourceId,
    required String content,
    String? imagePath,
    int? pageNumber,
  }) {
    return IndexItem(
      id: id ?? generateId(),
      sourceId: sourceId,
      type: IndexItemType.imageDescription,
      content: content,
      imagePath: imagePath,
      pageNumber: pageNumber,
      createdAt: DateTime.now(),
    );
  }

  /// Human-readable location string
  String get displayLocation {
    if (pageNumber != null) {
      return 'Page $pageNumber';
    }
    if (paragraphNumber != null) {
      return 'Paragraph $paragraphNumber';
    }
    if (startTimestamp != null) {
      final minutes = startTimestamp!.floor() ~/ 60;
      final seconds = (startTimestamp! % 60).floor();
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    if (imagePath != null) {
      return 'Image';
    }
    return '';
  }

  IndexItem copyWith({
    String? id,
    String? sourceId,
    IndexItemType? type,
    String? content,
    DateTime? createdAt,
    int? paragraphNumber,
    double? startTimestamp,
    double? endTimestamp,
    int? pageNumber,
    String? imagePath,
  }) {
    return IndexItem(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      paragraphNumber: paragraphNumber ?? this.paragraphNumber,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      pageNumber: pageNumber ?? this.pageNumber,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
