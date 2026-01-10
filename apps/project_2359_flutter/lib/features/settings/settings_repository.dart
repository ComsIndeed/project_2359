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
            id: 'notifications',
            title: 'Notifications',
            icon: Icons.notifications,
            iconBackgroundColor: Color(0xFF2E7DFF),
            type: SettingItemType.toggle,
            toggleValue: true,
          ),
          SettingItem(
            id: 'study_timer',
            title: 'Study Timer Default',
            value: '25 min',
            icon: Icons.timer,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'appearance',
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
            id: 'credits',
            title: 'Credit System',
            value: '1,250',
            icon: Icons.account_balance_wallet,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'personal_details',
            title: 'Personal Details',
            icon: Icons.person,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'synced_devices',
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
            id: 'storage',
            title: 'Storage',
            icon: Icons.storage,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'manage_sources',
            title: 'Manage Sources',
            icon: Icons.folder,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'clear_cache',
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
            id: 'help_center',
            title: 'Help Center',
            icon: Icons.help,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
          SettingItem(
            id: 'privacy_policy',
            title: 'Privacy Policy',
            icon: Icons.security,
            iconBackgroundColor: Color(0xFF2E7DFF),
          ),
        ],
      ),
    ];
  }
}
