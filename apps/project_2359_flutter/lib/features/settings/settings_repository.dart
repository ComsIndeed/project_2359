import 'package:flutter/material.dart';
import 'models/settings_models.dart';

class SettingsRepository {
  UserProfile getUserProfile() {
    return const UserProfile(
      name: 'Jane Doe',
      subtitle: 'Sophomore • Computer Science',
      avatarUrl: 'https://i.pravatar.cc/150?u=jane_doe',
    );
  }

  List<SettingSection> getSettingsSections() {
    return [
      const SettingSection(
        title: 'GENERAL',
        items: [
          SettingItem(
            title: 'Notifications',
            icon: Icons.notifications,
            iconBackgroundColor: Color(0xFF2E7DFF),
            type: SettingItemType.toggle,
            toggleValue: true,
          ),
          SettingItem(
            title: 'Study Timer Default',
            value: '25 min',
            icon: Icons.timer,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            title: 'Appearance',
            value: 'Dark',
            icon: Icons.dark_mode,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
        ],
      ),
      const SettingSection(
        title: 'ACCOUNT',
        items: [
          SettingItem(
            title: 'Membership',
            badge: 'PRO',
            icon: Icons.credit_card,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            title: 'Personal Details',
            icon: Icons.person,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            title: 'Synced Devices',
            value: '2',
            icon: Icons.devices,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
        ],
      ),
      const SettingSection(
        title: 'DATA & STORAGE',
        items: [
          SettingItem(
            title: 'Manage Sources',
            icon: Icons.folder,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            title: 'Clear Cache',
            icon: Icons.delete,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
        ],
      ),
      const SettingSection(
        title: 'SUPPORT',
        items: [
          SettingItem(
            title: 'Help Center',
            icon: Icons.help,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            title: 'Privacy Policy',
            icon: Icons.security,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
        ],
      ),
    ];
  }
}
