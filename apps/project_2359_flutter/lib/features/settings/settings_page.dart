import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../common/project_image.dart';
import '../common/app_list_tile.dart';
import '../common/app_header.dart';
import 'models/settings_models.dart';
import 'settings_repository.dart';
import 'pages/appearance_page.dart';
import 'pages/credit_system_page.dart';
import 'pages/personal_details_page.dart';
import 'pages/synced_devices_page.dart';
import 'pages/manage_sources_page.dart';
import 'pages/help_center_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/settings_boilerplate_page.dart';
import 'pages/storage_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _navigateTo(BuildContext context, String id, String title) {
    Widget page;
    switch (id) {
      case 'appearance':
        page = const AppearancePage();
        break;
      case 'credits':
        page = const CreditSystemPage();
        break;
      case 'personal_details':
        page = const PersonalDetailsPage();
        break;
      case 'synced_devices':
        page = const SyncedDevicesPage();
        break;
      case 'manage_sources':
        page = const ManageSourcesPage();
        break;
      case 'storage':
        page = const StoragePage();
        break;
      case 'help_center':
        page = const HelpCenterPage();
        break;
      case 'privacy_policy':
        page = const PrivacyPolicyPage();
        break;
      default:
        page = SettingsBoilerplatePage(title: title);
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final repository = SettingsRepository();
    final profile = repository.getUserProfile();
    final sections = repository.getSettingsSections();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTopHeader(context),
              const SizedBox(height: 32),
              Center(child: _buildProfileHeader(context, profile)),
              const SizedBox(height: 32),
              ...sections.map((section) => _buildSection(context, section)),
              const SizedBox(height: 24),
              _buildLogOutButton(context),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Project 2359 v1.2.4',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: AppPageHeader(
        title: 'Profile',
        subtitle: 'PROJECT 2359',
        icon: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 24),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 4),
                ),
                child: ClipOval(
                  child: ProjectImage(
                    imageUrl: profile.avatarUrl,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(profile.name, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 6),
        Text(
          profile.subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () =>
                _navigateTo(context, 'edit_profile', 'Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              elevation: 0,
            ),
            child: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, SettingSection section) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: section.title),
          const SizedBox(height: 12),
          ...section.items.map((item) => _buildSettingItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, SettingItem item) {
    return AppListTile(
      title: item.title,
      subtitle: item.value,
      icon: item.icon,
      iconColor: item.iconBackgroundColor,
      onTap: item.type == SettingItemType.navigation
          ? () => _navigateTo(context, item.id, item.title)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.badge != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (item.type == SettingItemType.toggle)
            Switch(
              value: item.toggleValue,
              onChanged: (value) {},
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.primary,
            )
          else
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Log Out',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
