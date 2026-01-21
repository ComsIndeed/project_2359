/// Source reference model for Project 2359
///
/// Tracks the exact location within a source where content originated,
/// enabling "view source" functionality for generated study materials.
library;

/// Type of reference location within a source
enum ReferenceType {
  /// Text position (page, paragraph, character offset)
  text,

  /// Timestamp in audio/video
  timestamp,

  /// Region in an image
  imageRegion,

  /// URL with optional anchor
  webLink,
}

/// A reference to a specific location within a source material.
///
/// This enables the app to show users exactly where generated content
/// (flashcards, quiz questions, etc.) originated from in the source material.
class SourceReference {
  final String id;
  final String sourceId;
  final ReferenceType type;

  /// For text: page number (1-indexed)
  final int? pageNumber;

  /// For text: starting character offset
  final int? startOffset;

  /// For text: ending character offset
  final int? endOffset;

  /// For text: the exact matched text
  final String? matchedText;

  /// For audio/video: start timestamp in seconds
  final double? startTimestamp;

  /// For audio/video: end timestamp in seconds
  final double? endTimestamp;

  /// For images: region bounds (x, y, width, height as percentages 0-1)
  final double? regionX;
  final double? regionY;
  final double? regionWidth;
  final double? regionHeight;

  /// For web links: the anchor/fragment
  final String? anchor;

  const SourceReference({
    required this.id,
    required this.sourceId,
    required this.type,
    this.pageNumber,
    this.startOffset,
    this.endOffset,
    this.matchedText,
    this.startTimestamp,
    this.endTimestamp,
    this.regionX,
    this.regionY,
    this.regionWidth,
    this.regionHeight,
    this.anchor,
  });

  /// Creates a text reference
  factory SourceReference.text({
    required String id,
    required String sourceId,
    required int pageNumber,
    required int startOffset,
    required int endOffset,
    String? matchedText,
  }) {
    return SourceReference(
      id: id,
      sourceId: sourceId,
      type: ReferenceType.text,
      pageNumber: pageNumber,
      startOffset: startOffset,
      endOffset: endOffset,
      matchedText: matchedText,
    );
  }

  /// Creates a timestamp reference for audio/video
  factory SourceReference.timestamp({
    required String id,
    required String sourceId,
    required double startTimestamp,
    double? endTimestamp,
  }) {
    return SourceReference(
      id: id,
      sourceId: sourceId,
      type: ReferenceType.timestamp,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
    );
  }

  /// Creates an image region reference
  factory SourceReference.imageRegion({
    required String id,
    required String sourceId,
    required double x,
    required double y,
    required double width,
    required double height,
  }) {
    return SourceReference(
      id: id,
      sourceId: sourceId,
      type: ReferenceType.imageRegion,
      regionX: x,
      regionY: y,
      regionWidth: width,
      regionHeight: height,
    );
  }

  /// Human-readable location string
  String get displayLocation {
    switch (type) {
      case ReferenceType.text:
        return 'Page $pageNumber';
      case ReferenceType.timestamp:
        final minutes = (startTimestamp ?? 0) ~/ 60;
        final seconds = ((startTimestamp ?? 0) % 60).toInt();
        return '$minutes:${seconds.toString().padLeft(2, '0')}';
      case ReferenceType.imageRegion:
        return 'Image region';
      case ReferenceType.webLink:
        return anchor ?? 'Web link';
    }
  }
}
