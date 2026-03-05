import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:project_2359/core/widgets/page_aware_scroll_view.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/tap_to_slide.dart';
import 'package:project_2359/features/auth/auth_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';

class HomePageContent extends StatefulWidget {
  final PageController pageController;

  const HomePageContent({super.key, required this.pageController});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final topBgHeight = screenHeight * 0.10; // Doubled from 0.05

        return Stack(
          children: [
            // BRIGHTER CONTAINER BACKGROUND (From Page 2, extended up)
            Positioned.fill(
              top: topBgHeight * 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -10),
                      ),
                  ],
                ),
              ),
            ),

            // TOP GENERATED BACKGROUND (Expanded and softer fade)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.35, // Large area for a very long fade
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.transparent],
                    stops: [0.28, 1.0], // Solid for ~10% then long fade
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SpecialBackgroundGenerator(
                  seed: GenerationSeed.fromString("home_v2"),
                  label: "Project 2359",
                  icon: FontAwesomeIcons.bolt,
                  type: SpecialBackgroundType.vibrantGradients,
                  showBorder: false,
                  borderRadius: 0,
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // MAIN CONTENT
            PageAwareScrollView(
              pageController: widget.pageController,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const ClampingScrollPhysics(),
                children: [
                  SizedBox(height: topBgHeight * 0.7),
                  const _HomeHeader(),
                  const SizedBox(height: 24),
                  const _StatusPill(),
                  const SizedBox(height: 16),
                  const _RecentActivitySection(),
                  const SizedBox(height: 24),
                  const _QuickActionsSection(),
                  const SizedBox(height: 48),
                  const _ScrollIndicator(),
                  const SizedBox(height: 100), // Bottom padding for Nav
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App icon collection for "more alive" look
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            Hero(
              tag: 'app_icon',
              child: Image.asset(
                isDark
                    ? 'assets/images/app_icon_light_nobg.png'
                    : 'assets/images/app_icon_nobg.png',
                height: 36,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project 2359",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: theme.colorScheme.onSurface,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              Text(
                "Your second brain",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 0.5),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Credits and Settings
        const _HeaderActions(),
      ],
    );
  }
}

class _ScrollIndicator extends StatelessWidget {
  const _ScrollIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text(
            "SCROLL TO STUDY",
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            final session = snapshot.data?.session;
            if (session == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TapToSlide(
                page: const SettingsPage(),
                direction: SlideDirection.up,
                builder: (pushPage) => InkWell(
                  onTap: pushPage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          size: 10,
                          color: Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "800",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(
                              0xFFFFD700,
                            ).withValues(alpha: 0.9),
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
        TapToSlide(
          page: const SettingsPage(),
          direction: SlideDirection.up,
          builder: (pushPage) => IconButton.outlined(
            onPressed: pushPage,
            icon: const FaIcon(FontAwesomeIcons.gear, size: 16),
            style: IconButton.styleFrom(
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Quick Actions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: FontAwesomeIcons.wandSparkles,
                label: "Generate",
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: FontAwesomeIcons.layerGroup,
                label: "Sources",
                color: Colors.orange,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: FontAwesomeIcons.bolt,
                label: "Quick Quiz",
                color: Colors.purple,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              FaIcon(icon, size: 20, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
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

            if (isOffline) {
              return _buildPill(
                context,
                onTap: () {},
                icon: FontAwesomeIcons.wifi,
                text: "Offline — your content is still available",
              );
            }

            if (!isLoggedIn) {
              return TapToSlide(
                page: const AuthPage(initialIsLogin: false),
                direction: SlideDirection.up,
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
    bool showChevron = false,
  }) {
    final theme = Theme.of(context);
    final color =
        iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
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
              if (showChevron)
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
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
        SectionHeader(title: "Recent Activity", onViewAllTap: () {}),
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
