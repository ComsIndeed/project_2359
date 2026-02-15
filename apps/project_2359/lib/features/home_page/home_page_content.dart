import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/tap_to_slide_up.dart';
import 'package:project_2359/features/settings_page/auth_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/theme_notifier.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  /// Global notifier for the carousel visibility, allowing Settings to toggle it.
  static final ValueNotifier<bool> showCarouselNotifier = ValueNotifier(true);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  void initState() {
    super.initState();
    _loadCarouselPreference();
  }

  Future<void> _loadCarouselPreference() async {
    final prefs = await SharedPreferences.getInstance();
    HomePageContent.showCarouselNotifier.value =
        prefs.getBool('show_home_carousel') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const _HomeHeader(),
        const SizedBox(height: 24),
        const _StatusPill(),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: HomePageContent.showCarouselNotifier,
          builder: (context, show, child) {
            if (!show) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: _FeatureCarousel(),
            );
          },
        ),
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
          builder: (context, _) => AnimatedSwitcher(
            duration: Durations.short4,
            child: themeNotifier.themeMode == ThemeMode.dark
                ? Image.asset(
                    'assets/images/app_icon_light_nobg.png',
                    height: 32,
                  )
                : Image.asset('assets/images/app_icon_nobg.png', height: 32),
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
                page: const AuthPage(),
                builder: (pushPage) => _buildPill(
                  onTap: pushPage,
                  context,
                  icon: FontAwesomeIcons.circleExclamation,
                  text: "Sign in to generate study materials",
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

class _FeatureCarousel extends StatefulWidget {
  const _FeatureCarousel();

  @override
  State<_FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<_FeatureCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    HomePageContent.showCarouselNotifier.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_home_carousel', false);
  }

  @override
  Widget build(BuildContext context) {
    const double height = 180;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            padEnds:
                false, // Align to start so first card is flush if desired, or center. standard is center.
            // Let's keep padEnds true (default) for centering 0.92 width cards
            children: [
              _buildCard(
                seed: GenerationSeed.fromString('pdf_feature'),
                icon: FontAwesomeIcons.filePdf,
                title: "Turn PDFs into Flashcards",
                subtitle:
                    "Import your course materials and let AI generate study decks.",
              ),
              _buildCard(
                seed: GenerationSeed.fromString('quiz_feature'),
                icon: FontAwesomeIcons.clipboardQuestion,
                title: "Generate Quizzes",
                subtitle:
                    "Test your knowledge with auto-generated quizzes from your notes.",
              ),
              _buildCard(
                seed: GenerationSeed.fromString('offline_feature'),
                icon: FontAwesomeIcons.wifi,
                title: "Study Anywhere",
                subtitle:
                    "Your library works completely offline. No internet? No problem.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(3, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ],
              ),
              Positioned(
                right: 0,
                child: TextButton(
                  onPressed: _dismiss,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    "Hide",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required GenerationSeed seed,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SpecialBackgroundGenerator(
              seed: seed,
              label: title,
              icon: icon,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: FaIcon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
