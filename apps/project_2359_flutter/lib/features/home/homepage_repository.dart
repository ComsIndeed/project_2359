import 'package:flutter/material.dart';
import 'models/home_models.dart';

class HomepageRepository {
  List<QuickAction> getQuickActions() {
    return [
      const QuickAction(
        title: 'Materials\nStudio',
        subtitle: 'Generate Notes',
        icon: Icons.auto_awesome,
        backgroundColor: Color(0xFF1E2843),
        iconColor: Color(0xFF2E7DFF),
      ),
      const QuickAction(
        title: 'Study Session',
        subtitle: 'Focus Mode',
        icon: Icons.timer_outlined,
        backgroundColor: Color(0xFF2A211D),
        iconColor: Color(0xFFFF7D33),
      ),
      const QuickAction(
        title: 'Scores',
        subtitle: 'Analytics',
        icon: Icons.bar_chart_rounded,
        backgroundColor: Color(0xFF1B2A23),
        iconColor: Color(0xFF4ADE80),
      ),
      const QuickAction(
        title: 'Sources',
        subtitle: 'File Manager',
        icon: Icons.folder_open_rounded,
        backgroundColor: Color(0xFF231B32),
        iconColor: Color(0xFFA855F7),
      ),
    ];
  }

  List<UpNextTask> getUpNextTasks() {
    return [
      const UpNextTask(
        title: 'Calculus III Final',
        dueText: 'Due Tomorrow, 11:59 PM',
        tag: 'URGENT',
        tagColor: Colors.redAccent,
      ),
      const UpNextTask(
        title: 'Modern History',
        dueText: 'Draft Due in 2 Days',
        tag: 'DRAFT',
        tagColor: Colors.orangeAccent,
      ),
    ];
  }

  List<RecentActivity> getRecentActivities() {
    return [
      const RecentActivity(
        title: 'Biology Chapter 4',
        score: '85%',
        timeAgo: '2h ago',
        icon: Icons.help_outline,
        iconColor: Colors.blueAccent,
        backgroundColor: Color(0xFF1E2843),
      ),
    ];
  }
}
