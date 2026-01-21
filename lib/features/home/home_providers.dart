/// Homepage Riverpod providers for Project 2359
///
/// Provides data to the Homepage UI using the core datasources.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';

// ==================== UI Models (kept for visual elements) ====================

/// Quick action button for the homepage grid
class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final String? route;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    this.route,
  });
}

/// Study stat display item
class StudyStatUI {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StudyStatUI({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

/// Recent activity display item
class RecentActivityUI {
  final String title;
  final String type;
  final String info;
  final String timeAgo;
  final String imageUrl;

  const RecentActivityUI({
    required this.title,
    required this.type,
    required this.info,
    required this.timeAgo,
    required this.imageUrl,
  });
}

// ==================== Static UI Data ====================

/// Quick actions grid items
const quickActions = <QuickAction>[
  QuickAction(title: 'New Material', icon: Icons.add, color: Color(0xFF2E7DFF)),
  QuickAction(title: 'Start Quiz', icon: Icons.quiz, color: Color(0xFFEC4899)),
  QuickAction(title: 'Sources', icon: Icons.folder, color: Color(0xFF06B6D4)),
  QuickAction(title: 'History', icon: Icons.history, color: Color(0xFFEAB308)),
];

// ==================== Providers ====================

/// Current user profile provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  final datasource = ref.watch(userDatasourceProvider);
  return datasource.getCurrentUser();
});

/// Study stats provider (converts User to UI display models)
final studyStatsProvider = FutureProvider<List<StudyStatUI>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return [];
  }

  return [
    StudyStatUI(
      title: 'Generated',
      value: '${user.totalQuizzesTaken} Sets',
      icon: Icons.check_circle,
      color: const Color(0xFF4ADE80),
    ),
    StudyStatUI(
      title: 'Avg. Score',
      value: '${(user.averageScore * 100).toInt()}%',
      icon: Icons.trending_up,
      color: const Color(0xFFFB923C),
    ),
    StudyStatUI(
      title: 'Study Time',
      value: user.formattedStudyTime,
      icon: Icons.access_time,
      color: const Color(0xFFA855F7),
    ),
  ];
});

/// Recent sources for activity display
final recentActivityProvider = FutureProvider<List<RecentActivityUI>>((
  ref,
) async {
  final sourcesDatasource = ref.watch(sourcesDatasourceProvider);
  final studyDatasource = ref.watch(studyDatasourceProvider);

  // Get recent sources
  final recentSources = await sourcesDatasource.getRecentSources(limit: 3);

  // Get some flashcards for activity info
  final flashcards = await studyDatasource.getFlashcards();
  final quizzes = await studyDatasource.getQuizQuestions();

  // Build activity items from study content
  final activities = <RecentActivityUI>[];

  for (final source in recentSources) {
    // Count flashcards for this source
    final sourceFlashcards = flashcards
        .where((f) => f.sourceId == source.id)
        .length;
    final sourceQuizzes = quizzes.where((q) => q.sourceId == source.id).length;

    String type = 'Source';
    String info = '';

    if (sourceQuizzes > 0) {
      type = 'Quiz';
      info = '$sourceQuizzes Qs';
    } else if (sourceFlashcards > 0) {
      type = 'Flashcards';
      info = '$sourceFlashcards Cards';
    } else {
      info = source.formattedSize.isNotEmpty ? source.formattedSize : 'Viewed';
    }

    activities.add(
      RecentActivityUI(
        title: source.title,
        type: type,
        info: info,
        timeAgo: source.lastAccessedFormatted,
        imageUrl: source.thumbnailPath ?? 'assets/images/hero_biology.png',
      ),
    );
  }

  return activities;
});

/// Extension to get formatted last accessed time
extension _SourceTimeExt on Source {
  String get lastAccessedFormatted {
    final diff = DateTime.now().difference(lastAccessedAt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
