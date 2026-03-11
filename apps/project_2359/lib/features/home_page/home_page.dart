import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/tap_to_slide.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topBgHeight = constraints.maxHeight * 0.10;

          return Stack(
            children: [
              // TOP GENERATED BACKGROUND (FULL SCREEN)
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                      stops: const [0.0, 0.3, 1.0],
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
              SafeArea(
                bottom: false,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    SizedBox(height: topBgHeight * 0.3),
                    const _HomeHeader(),
                    const SizedBox(height: 20),
                    // REFINED SEARCH BAR
                    const _HomeSearchBar(),
                    const SizedBox(height: 28),

                    // PINNED SECTION
                    const _SectionHeader(title: "Pinned"),
                    const SizedBox(height: 8),
                    ProjectListTile.simple(
                      label: "University Physics",
                      subLabel: "2:40 PM • 12 sources",
                      icon: FontAwesomeIcons.folderOpen,
                      onTap: () {},
                      isSingle: true,
                      showChevron: false,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                    ),

                    const SizedBox(height: 24),

                    // ALL COLLECTIONS SECTION
                    const _SectionHeader(title: "Today"),
                    const SizedBox(height: 8),
                    _FolderList(
                      backgroundColor: theme.colorScheme.surfaceContainer,
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: Text(
                        "4 Collections",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.primary,
        child: const FaIcon(FontAwesomeIcons.penToSquare),
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  "Search",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _FolderList extends StatelessWidget {
  final Color? backgroundColor;
  const _FolderList({this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final folders = [
      (
        label: "Machine Learning",
        subLabel: "Yesterday • 8 sources",
        icon: FontAwesomeIcons.brain,
      ),
      (
        label: "Japanese N1",
        subLabel: "Tuesday • 5 sources",
        icon: FontAwesomeIcons.language,
      ),
      (
        label: "Cooking Recipes",
        subLabel: "Oct 12 • 3 sources",
        icon: FontAwesomeIcons.utensils,
      ),
    ];

    return ProjectListGroup(
      backgroundColor: backgroundColor,
      children: [
        for (int i = 0; i < folders.length; i++) ...[
          ProjectListTile.simple(
            label: folders[i].label,
            subLabel: folders[i].subLabel,
            icon: folders[i].icon,
            onTap: () {},
            showDivider: i < folders.length - 1,
          ),
        ],
      ],
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
        // Settings Action
        const _HeaderActions(),
      ],
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
