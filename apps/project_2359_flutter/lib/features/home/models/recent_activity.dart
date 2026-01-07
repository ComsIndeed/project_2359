import 'package:flutter/material.dart';

class RecentActivity {
  final String title;
  final String score;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const RecentActivity({
    required this.title,
    required this.score,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}
