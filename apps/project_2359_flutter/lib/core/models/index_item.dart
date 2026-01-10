/// Index item model for Project 2359
///
/// Represents an indexed content segment extracted from a source.
/// Each IndexItem captures extractable content with location metadata,
/// enabling selective queries (e.g., LLMs only need text + ID).
library;

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
/// - For LLM contexts: use [id], [sourceId], and [content]
/// - For source navigation: use location fields
class IndexItem {
  /// Unique identifier for this index item
  final String id;

  /// The source this item was extracted from
  final String sourceId;

  /// Type of extracted content
  final IndexItemType type;

  /// The actual extracted text content
  final String content;

  /// Optional summary/preview of the content (first N chars)
  final String? preview;

  // --- Location metadata (varies by source type) ---

  /// For PDF/documents: page number (1-indexed)
  final int? pageNumber;

  /// For text: starting character offset
  final int? startOffset;

  /// For text: ending character offset
  final int? endOffset;

  /// For audio/video: start timestamp in seconds
  final double? startTimestamp;

  /// For audio/video: end timestamp in seconds
  final double? endTimestamp;

  /// For images: region X coordinate (0-1 percentage)
  final double? regionX;

  /// For images: region Y coordinate (0-1 percentage)
  final double? regionY;

  /// For images: region width (0-1 percentage)
  final double? regionWidth;

  /// For images: region height (0-1 percentage)
  final double? regionHeight;

  /// Optional path to extracted image (for PDF images, screenshots, etc.)
  final String? extractedImagePath;

  /// Creation timestamp
  final DateTime createdAt;

  const IndexItem({
    required this.id,
    required this.sourceId,
    required this.type,
    required this.content,
    this.preview,
    this.pageNumber,
    this.startOffset,
    this.endOffset,
    this.startTimestamp,
    this.endTimestamp,
    this.regionX,
    this.regionY,
    this.regionWidth,
    this.regionHeight,
    this.extractedImagePath,
    required this.createdAt,
  });

  /// Creates a text index item (for documents)
  factory IndexItem.text({
    required String id,
    required String sourceId,
    required String content,
    required int pageNumber,
    int? startOffset,
    int? endOffset,
  }) {
    return IndexItem(
      id: id,
      sourceId: sourceId,
      type: IndexItemType.text,
      content: content,
      preview: content.length > 100 ? '${content.substring(0, 100)}...' : null,
      pageNumber: pageNumber,
      startOffset: startOffset,
      endOffset: endOffset,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a transcription index item (for audio/video)
  factory IndexItem.transcription({
    required String id,
    required String sourceId,
    required String content,
    required double startTimestamp,
    double? endTimestamp,
  }) {
    return IndexItem(
      id: id,
      sourceId: sourceId,
      type: IndexItemType.transcription,
      content: content,
      preview: content.length > 100 ? '${content.substring(0, 100)}...' : null,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      createdAt: DateTime.now(),
    );
  }

  /// Creates an image description index item
  factory IndexItem.imageDescription({
    required String id,
    required String sourceId,
    required String content,
    String? extractedImagePath,
    int? pageNumber,
    double? regionX,
    double? regionY,
    double? regionWidth,
    double? regionHeight,
  }) {
    return IndexItem(
      id: id,
      sourceId: sourceId,
      type: IndexItemType.imageDescription,
      content: content,
      extractedImagePath: extractedImagePath,
      pageNumber: pageNumber,
      regionX: regionX,
      regionY: regionY,
      regionWidth: regionWidth,
      regionHeight: regionHeight,
      createdAt: DateTime.now(),
    );
  }

  /// Human-readable location string
  String get displayLocation {
    if (pageNumber != null) {
      return 'Page $pageNumber';
    }
    if (startTimestamp != null) {
      final minutes = startTimestamp!.floor() ~/ 60;
      final seconds = (startTimestamp! % 60).floor();
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    if (regionX != null) {
      return 'Image region';
    }
    return '';
  }

  IndexItem copyWith({
    String? id,
    String? sourceId,
    IndexItemType? type,
    String? content,
    String? preview,
    int? pageNumber,
    int? startOffset,
    int? endOffset,
    double? startTimestamp,
    double? endTimestamp,
    double? regionX,
    double? regionY,
    double? regionWidth,
    double? regionHeight,
    String? extractedImagePath,
    DateTime? createdAt,
  }) {
    return IndexItem(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      content: content ?? this.content,
      preview: preview ?? this.preview,
      pageNumber: pageNumber ?? this.pageNumber,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      regionX: regionX ?? this.regionX,
      regionY: regionY ?? this.regionY,
      regionWidth: regionWidth ?? this.regionWidth,
      regionHeight: regionHeight ?? this.regionHeight,
      extractedImagePath: extractedImagePath ?? this.extractedImagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
