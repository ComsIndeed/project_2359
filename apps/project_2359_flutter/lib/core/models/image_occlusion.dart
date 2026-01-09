/// Image occlusion domain model for Project 2359
///
/// Represents an image with hidden regions that students must identify.
library;

import 'source_reference.dart';

/// A region on an image that is occluded (hidden) for testing.
class OcclusionRegion {
  final String id;

  /// Position as percentage of image dimensions (0-1)
  final double x;
  final double y;
  final double width;
  final double height;

  /// The answer/label for this region
  final String label;

  /// Optional hint
  final String? hint;

  const OcclusionRegion({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
    this.hint,
  });
}

/// An image occlusion study item.
class ImageOcclusion {
  final String id;
  final String sourceId;
  final String title;

  /// Path to the base image
  final String imagePath;

  /// Regions that are occluded
  final List<OcclusionRegion> regions;

  /// Reference to the source location
  final SourceReference? sourceReference;

  /// Tags for organization
  final List<String> tags;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ImageOcclusion({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.imagePath,
    required this.regions,
    this.sourceReference,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  ImageOcclusion copyWith({
    String? id,
    String? sourceId,
    String? title,
    String? imagePath,
    List<OcclusionRegion>? regions,
    SourceReference? sourceReference,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ImageOcclusion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      regions: regions ?? this.regions,
      sourceReference: sourceReference ?? this.sourceReference,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
