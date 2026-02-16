import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/tap_to_slide_up.dart';
import 'package:project_2359/features/auth/auth_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/theme_notifier.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const _HomeHeader(),
        const SizedBox(height: 24),
        const _StatusPill(),
        const SizedBox(height: 16),
        const _RecentActivitySection(),
        const SizedBox(height: 100), // Bottom padding for FAB/Nav
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListenableBuilder(
          listenable: themeNotifier,
          builder: (context, _) => Hero(
            tag: 'app_icon',
            child: AnimatedSwitcher(
              duration: Durations.short4,
              child: themeNotifier.themeMode == ThemeMode.dark
                  ? Image.asset(
                      'assets/images/app_icon_light_nobg.png',
                      height: 32,
                    )
                  : Image.asset('assets/images/app_icon_nobg.png', height: 32),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "Project 2359",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Credits Chip (Logged-in only)
        StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            final session = snapshot.data?.session;
            if (session == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () {
                    // Navigate to credits purchase page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: const Color(
                        0xFFFFD700,
                      ).withValues(alpha: 0.15), // Gold tint
                      // border: Border.all(
                      //   color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                      // ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          size: 12,
                          color: Color(0xFFFFD700), // Gold
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "800",
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: const Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        TapToSlideUp(
          page: const SettingsPage(),
          builder: (pushPage) {
            return IconButton(
              onPressed: pushPage,
              icon: const FaIcon(FontAwesomeIcons.gear, size: 20),
            );
          },
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, connectivitySnapshot) {
        final isOffline =
            connectivitySnapshot.hasData &&
            connectivitySnapshot.data!.contains(ConnectivityResult.none);

        return StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, authSnapshot) {
            final isLoggedIn = authSnapshot.data?.session != null;

            // Case 1: Offline
            if (isOffline) {
              return _buildPill(
                context,
                onTap: () {},
                icon: FontAwesomeIcons.wifi,
                text: "Offline — your content is still available",
                isError: false,
              );
            }

            // Case 2: Online but Logged Out
            if (!isLoggedIn) {
              return TapToSlideUp(
                page: const AuthPage(initialIsLogin: false),
                builder: (pushPage) => _buildPill(
                  onTap: pushPage,
                  context,
                  icon: FontAwesomeIcons.circleExclamation,
                  text: "Sign up to generate study materials",
                  iconColor: AppTheme.warning,
                  showChevron: true,
                ),
              );
            }

            // Case 3: Online & Logged In -> Hidden
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildPill(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Function() onTap,
    Color? iconColor,
    bool isError = false,
    bool showChevron = false,
  }) {
    final theme = Theme.of(context);
    final color =
        iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 14, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: 8),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Where you left off",
          onViewAllTap: () {
            // TODO: Navigate to full history
          },
        ),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.filePdf),
          title: const Text("Introduction to Psychology"),
          subtitle: const Text("PDF • Last opened 2h ago"),
          onTap: () {},
        ),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.layerGroup),
          title: const Text("Calculus Quiz Pack"),
          subtitle: const Text("Flashcards • 24 cards due"),
          onTap: () {},
          accentColor: Colors.orange,
        ),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.image),
          title: const Text("Biology Notes_Final"),
          subtitle: const Text("Image • Imported yesterday"),
          onTap: () {},
          accentColor: Colors.purpleAccent,
        ),
      ],
    );
  }
}
