import 'package:flutter/material.dart';

class SourceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? backgroundImage;

  const SourceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.backgroundImage,
  });
}

class OutputFormat {
  final String title;
  final IconData icon;
  final Color color;

  const OutputFormat({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class RecentGeneration {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const RecentGeneration({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}
