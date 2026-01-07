import 'package:flutter/material.dart';

class UpNextTask {
  final String title;
  final String dueText;
  final String tag;
  final Color tagColor;

  const UpNextTask({
    required this.title,
    required this.dueText,
    required this.tag,
    required this.tagColor,
  });
}
