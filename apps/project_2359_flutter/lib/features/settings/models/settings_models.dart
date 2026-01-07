import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String subtitle;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
  });
}

enum SettingItemType { toggle, navigation }

class SettingItem {
  final String id;
  final String title;
  final String? value;
  final IconData icon;
  final Color iconBackgroundColor;
  final SettingItemType type;
  final bool toggleValue;
  final String? badge;

  const SettingItem({
    required this.id,
    required this.title,
    this.value,
    required this.icon,
    required this.iconBackgroundColor,
    this.type = SettingItemType.navigation,
    this.toggleValue = false,
    this.badge,
  });
}

class SettingSection {
  final String title;
  final List<SettingItem> items;

  const SettingSection({required this.title, required this.items});
}
