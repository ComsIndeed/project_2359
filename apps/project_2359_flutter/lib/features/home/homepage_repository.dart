import 'package:flutter/material.dart';
import 'models/home_models.dart';

class HomepageRepository {
  List<QuickAction> getQuickActions() {
    return [
      const QuickAction(
        title: 'New Material',
        icon: Icons.add,
        color: Color(0xFF2E7DFF),
      ),
      const QuickAction(
        title: 'Start Quiz',
        icon: Icons.quiz,
        color: Color(0xFFEC4899),
      ),
      const QuickAction(
        title: 'Sources',
        icon: Icons.folder,
        color: Color(0xFF06B6D4),
      ),
      const QuickAction(
        title: 'History',
        icon: Icons.history,
        color: Color(0xFFEAB308),
      ),
    ];
  }

  List<StudyStat> getStudyStats() {
    return [
      const StudyStat(
        title: 'Generated',
        value: '12 Sets',
        icon: Icons.check_circle,
        color: Color(0xFF4ADE80),
      ),
      const StudyStat(
        title: 'Avg. Score',
        value: '88%',
        icon: Icons.trending_up,
        color: Color(0xFFFB923C),
      ),
      const StudyStat(
        title: 'Study Time',
        value: '4h 20m',
        icon: Icons.access_time,
        color: Color(0xFFA855F7),
      ),
    ];
  }

  List<RecentActivity> getRecentActivities() {
    return [
      const RecentActivity(
        title: 'European History: The Cold War',
        type: 'Quiz',
        info: 'Score: 92%',
        timeAgo: '2h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=2066&auto=format&fit=crop',
      ),
      const RecentActivity(
        title: 'Calculus II: Integrals',
        type: 'Flashcards',
        info: '24 Cards',
        timeAgo: '5h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=2070&auto=format&fit=crop',
      ),
      const RecentActivity(
        title: 'CS 101: Python Basics',
        type: 'Notes',
        info: 'Viewed',
        timeAgo: '1d ago',
        imageUrl:
            'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?q=80&w=2069&auto=format&fit=crop',
      ),
    ];
  }
}
