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
                    const SizedBox(height: 24),
                    // REFINED SEARCH BAR
                    const _HomeSearchBar(),
                    const SizedBox(height: 48),

                    // PINNED SECTION
                    const _SectionHeader(title: "Pinned"),
                    const SizedBox(height: 8),
                    ProjectListTile.simple(
                      label: "University Physics",
                      emoji: "⚛️",
                      date: "2:40 PM",
                      sources: [
                        (
                          label: "Mechanics.pdf",
                          icon: FontAwesomeIcons.filePdf,
                        ),
                        (label: "Waves.doc", icon: FontAwesomeIcons.fileWord),
                        (label: "Notes", icon: FontAwesomeIcons.fileLines),
                      ],
                      onTap: () {
                        debugPrint("Pinned item tapped");
                      },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer.withValues(
          alpha: 0.8,
        ),
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
        label: const Text(
          "New",
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
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
      height: 42,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                Text(
                  "Search",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    letterSpacing: 0.1,
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
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 0.5,
          fontSize: 12,
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
        date: "2:40 PM",
        sources: [
          (label: "ML_Foundations.pdf", icon: FontAwesomeIcons.filePdf),
          (label: "Dataset_v2.csv", icon: FontAwesomeIcons.fileCsv),
          (label: "Summary", icon: FontAwesomeIcons.fileLines),
        ],
        dueCount: 12,
      ),
      (
        label: "Japanese N1 Grammar",
        date: "Yesterday",
        sources: [
          (label: "Particles.doc", icon: FontAwesomeIcons.fileWord),
          (label: "Kanji_List", icon: FontAwesomeIcons.fileLines),
        ],
        dueCount: 45,
      ),
      (
        label: "Organic Chemistry",
        date: "Monday",
        sources: [
          (label: "Reactions.pdf", icon: FontAwesomeIcons.filePdf),
          (label: "LabNotes.txt", icon: FontAwesomeIcons.fileCode),
          (label: "Diagrams", icon: FontAwesomeIcons.fileImage),
        ],
        dueCount: 0,
      ),
      (
        label: "World History v2",
        date: "Oct 12",
        sources: [
          (label: "Timeline", icon: FontAwesomeIcons.fileLines),
          (label: "Map_Data", icon: FontAwesomeIcons.map),
        ],
        dueCount: 0,
      ),
      (
        label: "Cooking Secrets",
        date: "Sept 30",
        sources: [
          (label: "French_Base", icon: FontAwesomeIcons.fileLines),
          (label: "Spices_Table", icon: FontAwesomeIcons.fileCsv),
        ],
        dueCount: 8,
      ),
      (
        label: "Guitar Theory",
        date: "Aug 15",
        sources: [
          (label: "Scales.pdf", icon: FontAwesomeIcons.filePdf),
          (label: "Modes_Guide", icon: FontAwesomeIcons.fileLines),
        ],
        dueCount: 0,
      ),
    ];

    final theme = Theme.of(context);

    return ProjectListGroup(
      backgroundColor: backgroundColor,
      children: [
        for (int i = 0; i < folders.length; i++) ...[
          ProjectListTile.simple(
            label: folders[i].label,
            date: folders[i].date,
            sources: folders[i].sources,
            dueCount: folders[i].dueCount,
            onTap: () {
              debugPrint("Folder tapped: ${folders[i].label}");
            },
            showDivider: i < folders.length - 1,
            showChevron: false,
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
        // Compact App Icon
        Hero(
          tag: 'app_icon',
          child: Image.asset(
            isDark
                ? 'assets/images/app_icon_light_nobg.png'
                : 'assets/images/app_icon_nobg.png',
            height: 28, // More compact icon
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Project 2359",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.95),
            ),
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
          builder: (pushPage) => Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: pushPage,
              icon: FaIcon(
                FontAwesomeIcons.gear,
                size: 15,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ],
    );
  }
}
