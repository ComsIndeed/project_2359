/// Sources feature Riverpod providers
///
/// Provides data to the Sources UI using the core datasources.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moment_dart/moment_dart.dart';

import '../../core/core.dart';

// ==================== UI Models ====================

/// Source category for filtering in the UI
class SourceCategory {
  final String title;
  final IconData icon;
  final SourceType? type;

  const SourceCategory({required this.title, required this.icon, this.type});
}

/// Static list of categories for the filter chips
const sourceCategories = <SourceCategory>[
  SourceCategory(title: 'All', icon: Icons.check),
  SourceCategory(
    title: 'PDFs',
    icon: Icons.picture_as_pdf,
    type: SourceType.pdf,
  ),
  SourceCategory(title: 'Links', icon: Icons.link, type: SourceType.link),
  SourceCategory(
    title: 'Notes',
    icon: Icons.description,
    type: SourceType.note,
  ),
  SourceCategory(
    title: 'Audio',
    icon: Icons.headphones,
    type: SourceType.audio,
  ),
  SourceCategory(
    title: 'Video',
    icon: Icons.video_library,
    type: SourceType.video,
  ),
  SourceCategory(title: 'Images', icon: Icons.image, type: SourceType.image),
];

// ==================== Providers ====================

/// Notifier for selected category filter
class SelectedCategoryNotifier extends Notifier<SourceType?> {
  @override
  SourceType? build() => null;

  void select(SourceType? type) => state = type;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, SourceType?>(
      SelectedCategoryNotifier.new,
    );

/// All sources from the datasource
final allSourcesProvider = FutureProvider<List<Source>>((ref) async {
  final datasource = ref.watch(sourcesDatasourceProvider);
  return datasource.getSources();
});

/// Filtered sources based on selected category
final filteredSourcesProvider = FutureProvider<List<Source>>((ref) async {
  final datasource = ref.watch(sourcesDatasourceProvider);
  final category = ref.watch(selectedCategoryProvider);
  return datasource.getSources(type: category);
});

/// Recent sources (top 5)
final recentSourcesProvider = FutureProvider<List<Source>>((ref) async {
  final datasource = ref.watch(sourcesDatasourceProvider);
  return datasource.getRecentSources(limit: 5);
});

/// Notifier for search query
class SourceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final sourceSearchQueryProvider =
    NotifierProvider<SourceSearchQueryNotifier, String>(
      SourceSearchQueryNotifier.new,
    );

/// Search results
final searchSourcesProvider = FutureProvider<List<Source>>((ref) async {
  final datasource = ref.watch(sourcesDatasourceProvider);
  final query = ref.watch(sourceSearchQueryProvider);
  if (query.isEmpty) {
    return datasource.getSources();
  }
  return datasource.searchSources(query);
});

// ==================== Extensions ====================

/// Extension on Source to provide UI-friendly properties
extension SourceUIExtension on Source {
  /// Icon for this source type
  IconData get icon {
    switch (type) {
      case SourceType.pdf:
        return Icons.picture_as_pdf;
      case SourceType.link:
        return Icons.link;
      case SourceType.note:
        return Icons.description;
      case SourceType.audio:
        return Icons.headphones;
      case SourceType.video:
        return Icons.video_library;
      case SourceType.image:
        return Icons.image;
    }
  }

  /// Color for this source type
  Color get typeColor {
    switch (type) {
      case SourceType.pdf:
        return const Color(0xFFE53935);
      case SourceType.link:
        return const Color(0xFF2196F3);
      case SourceType.note:
        return const Color(0xFF4CAF50);
      case SourceType.audio:
        return const Color(0xFFFF9800);
      case SourceType.video:
        return const Color(0xFF9C27B0);
      case SourceType.image:
        return const Color(0xFF00BCD4);
    }
  }

  /// Formatted last accessed time (e.g., "2h ago")
  String get lastAccessedFormatted {
    return lastAccessedAt.toMoment().fromNow();
  }

  /// Metadata string for display
  String get metadata {
    final parts = <String>[];

    // Add time ago
    parts.add('Accessed $lastAccessedFormatted');

    // Add size if available
    if (formattedSize.isNotEmpty) {
      parts.add(formattedSize);
    }

    // Add duration if available
    if (formattedDuration.isNotEmpty) {
      parts.add(formattedDuration);
    }

    return parts.join(' • ');
  }
}
