import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/core/widgets/tap_to_slide.dart';
import 'package:project_2359/features/folder_page/folder_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ExpandableFab(
        collapsed: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.plus, size: 14),
            SizedBox(width: 8),
            Text(
              "New",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        expanded: const _NewButtonExpandedContent(),
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
                      const SpecialSearchBar(),
                      const SizedBox(height: 48),

                      // PINNED SECTION
                      const _SectionHeader(title: "Pinned"),
                      const SizedBox(height: 8),
                      ProjectListGroup(
                        backgroundColor: theme.colorScheme.surfaceContainer,
                        children: [
                          ProjectListTile.simple(
                            label: "University Physics",
                            date: "2:40 PM",
                            sources: [
                              (
                                label: "Mechanics.pdf",
                                icon: FontAwesomeIcons.filePdf,
                              ),
                              (
                                label: "Waves.doc",
                                icon: FontAwesomeIcons.fileWord,
                              ),
                              (
                                label: "Notes",
                                icon: FontAwesomeIcons.fileLines,
                              ),
                            ],
                            targetPage: FolderPage(
                              folderId: 'physics_dummy',
                              initialFolderName: "University Physics",
                            ),
                            transitionType: ProjectTransitionType.slideLeft,
                            showChevron: false,
                          ),
                        ],
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
    final theme = Theme.of(context);
    final service = context.read<StudyMaterialService>();

    return StreamBuilder<List<StudyFolderItem>>(
      stream: service.watchAllFolders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final folders = snapshot.data ?? [];

        if (folders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No collections yet. Create one below!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }

        return ProjectListGroup(
          backgroundColor: backgroundColor,
          children: [
            for (int i = 0; i < folders.length; i++) ...[
              ProjectListTile.simple(
                label: folders[i].name,
                date:
                    "Recent", // In a real app, you'd format folders[i].updatedAt
                sources:
                    const [], // TODO: Link sources to folders and display here
                targetPage: FolderPage(
                  folderId: folders[i].id,
                  initialFolderName: folders[i].name,
                ),
                transitionType: ProjectTransitionType.slideLeft,
                showDivider: i < folders.length - 1,
                showChevron: false,
              ),
            ],
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

class _NewButtonExpandedContent extends StatefulWidget {
  const _NewButtonExpandedContent();

  @override
  State<_NewButtonExpandedContent> createState() =>
      _NewButtonExpandedContentState();
}

class _NewButtonExpandedContentState extends State<_NewButtonExpandedContent> {
  final TextEditingController _folderNameController = TextEditingController();
  bool _isCreatingFolder = false;

  Future<void> _createFolder() async {
    final name = _folderNameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreatingFolder = true);
    try {
      final service = context.read<StudyMaterialService>();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await service.insertFolder(
        StudyFolderItemsCompanion.insert(
          id: id,
          name: name,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );
      _folderNameController.clear();
      if (mounted) {
        // Close FAB (assuming it's controlled via a scaffold or state)
        // For now, just show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Collection '$name' created!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreatingFolder = false);
    }
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Quick Access",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // PREMIUM FOLDER CREATION BOX
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.folderPlus,
                      size: 14,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "NEW COLLECTION",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _folderNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Name...",
                    hintStyle: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.2),
                    ),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: cs.primary, width: 1.5),
                    ),
                  ),
                  onSubmitted: (_) => _createFolder(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCreatingFolder ? null : _createFolder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isCreatingFolder
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            "Create Collection",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "More Options",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ProjectListGroup(
            backgroundColor: theme.colorScheme.surfaceContainer,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ProjectListTile.simple(
                label: "Scan Documents",
                icon: FontAwesomeIcons.camera,
                showDivider: true,
                onTap: () {},
                showChevron: false,
              ),
              ProjectListTile.simple(
                label: "Upload File",
                icon: FontAwesomeIcons.fileArrowUp,
                showDivider: false,
                onTap: () {},
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // A suggested action area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recent Suggestions",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ProjectListGroup(
            backgroundColor: theme.colorScheme.surfaceContainer.withValues(
              alpha: 0.5,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ProjectListTile.simple(
                label: "Summarize Physics Notes",
                icon: FontAwesomeIcons.wandMagicSparkles,
                onTap: () {},
                showChevron: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
