/// Source domain model for Project 2359
///
/// Represents a learning source material that can be:
/// - PDF documents
/// - Web links/URLs
/// - Notes (text-based)
/// - Audio files
/// - Video files
/// - Images
library;

/// Types of source materials supported by the app
enum SourceType { pdf, link, note, audio, video, image }

/// A source material that can be ingested for study content generation.
///
/// Sources are the raw materials from which flashcards, quizzes, and other
/// study materials are generated. Each source tracks its origin and provides
/// reference capabilities back to specific locations within it.
class Source {
  final String id;
  final String title;
  final SourceType type;
  final DateTime createdAt;
  final DateTime lastAccessedAt;

  /// File path for local files (PDF, audio, video, image)
  final String? filePath;

  /// URL for web links
  final String? url;

  /// Raw text content for notes
  final String? content;

  /// File size in bytes (for files)
  final int? sizeBytes;

  /// Duration in seconds (for audio/video)
  final int? durationSeconds;

  /// Thumbnail or preview image path
  final String? thumbnailPath;

  /// Tags for organization
  final List<String> tags;

  /// Whether this source has been fully indexed/processed
  final bool isIndexed;

  const Source({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.lastAccessedAt,
    this.filePath,
    this.url,
    this.content,
    this.sizeBytes,
    this.durationSeconds,
    this.thumbnailPath,
    this.tags = const [],
    this.isIndexed = false,
  });

  Source copyWith({
    String? id,
    String? title,
    SourceType? type,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    String? filePath,
    String? url,
    String? content,
    int? sizeBytes,
    int? durationSeconds,
    String? thumbnailPath,
    List<String>? tags,
    bool? isIndexed,
  }) {
    return Source(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      filePath: filePath ?? this.filePath,
      url: url ?? this.url,
      content: content ?? this.content,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      tags: tags ?? this.tags,
      isIndexed: isIndexed ?? this.isIndexed,
    );
  }

  /// Human-readable size string
  String get formattedSize {
    if (sizeBytes == null) return '';
    if (sizeBytes! < 1024) return '$sizeBytes B';
    if (sizeBytes! < 1024 * 1024) {
      return '${(sizeBytes! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Human-readable duration string
  String get formattedDuration {
    if (durationSeconds == null) return '';
    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;
    return '${minutes}m ${seconds}s';
  }
}
