import 'package:flutter/material.dart';

enum SourceType { pdf, link, note }

class SourceMaterial {
  final String id;
  final String title;
  final SourceType type;
  final String metadata;
  final String? imageUrl;
  final DateTime lastAccessed;
  final String? size;
  final String? url;

  const SourceMaterial({
    required this.id,
    required this.title,
    required this.type,
    required this.metadata,
    this.imageUrl,
    required this.lastAccessed,
    this.size,
    this.url,
  });
}

class SourceCategory {
  final String title;
  final IconData icon;
  final SourceType? type;

  const SourceCategory({required this.title, required this.icon, this.type});
}
