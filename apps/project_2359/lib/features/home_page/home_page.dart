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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _selectedFolderIds = {};
  final Set<String> _selectedMaterialIds = {};

  bool get _isSelecting =>
      _selectedFolderIds.isNotEmpty || _selectedMaterialIds.isNotEmpty;

  void _toggleFolderSelection(String id) {
    setState(() {
      if (_selectedFolderIds.contains(id)) {
        _selectedFolderIds.remove(id);
      } else {
        _selectedFolderIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedFolderIds.clear();
      _selectedMaterialIds.clear();
    });
  }

  Future<void> _handlePinSelected() async {
    final service = context.read<StudyMaterialService>();
    for (final id in _selectedFolderIds) {
      // We need to know current state or just toggle? Usually Pin action means "Pin them all".
      // For simplicity, let's assume it Pins them.
      await service.toggleFolderPin(id, true);
    }
    // TODO: handle materials too if present
    _clearSelection();
  }

  Future<void> _handleDeleteSelected() async {
    final service = context.read<StudyMaterialService>();
    for (final id in _selectedFolderIds) {
      await service.deleteFolder(id);
    }
    _clearSelection();
  }

  late Stream<List<StudyFolderItem>> _foldersStream;
  late Stream<List<StudyFolderItem>> _pinnedFoldersStream;

  @override
  void initState() {
    super.initState();
    final service = context.read<StudyMaterialService>();
    _foldersStream = service.watchAllFolders();
    _pinnedFoldersStream = service.watchPinnedFolders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ExpandableFab(
        collapsedBuilder: (context, isOpen, expand, close) {
          if (_isSelecting) {
            return _SelectionActionBar(
              selectedCount:
                  _selectedFolderIds.length + _selectedMaterialIds.length,
              onClose: _clearSelection,
              onPin: _handlePinSelected,
              onDelete: _handleDeleteSelected,
            );
          }
          return InkWell(
            onTap: expand,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.plus, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "New",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        expandedBuilder: (context, isOpen, expand, close) {
          return const _NewButtonExpandedContent();
        },
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
                      _PinnedFoldersSection(
                        stream: _pinnedFoldersStream,
                        selectedIds: _selectedFolderIds,
                        onToggleSelection: _toggleFolderSelection,
                        isSelecting: _isSelecting,
                      ),

                      const SizedBox(height: 24),

                      // ALL COLLECTIONS SECTION
                      const _SectionHeader(title: "Today"),
                      const SizedBox(height: 8),
                      _FolderList(
                        stream: _foldersStream,
                        backgroundColor: theme.colorScheme.surfaceContainer,
                        selectedIds: _selectedFolderIds,
                        onToggleSelection: _toggleFolderSelection,
                        isSelecting: _isSelecting,
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
  final Stream<List<StudyFolderItem>> stream;
  final Color? backgroundColor;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _FolderList({
    required this.stream,
    this.backgroundColor,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<StudyFolderItem>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
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
            for (final folder in folders)
              ProjectListTile.simple(
                label: folder.name,
                date: folder.updatedAt.substring(11, 16), // Simple HH:mm
                sources: const [], // TODO: Get sources for folder
                targetPage: FolderPage(
                  folderId: folder.id,
                  initialFolderName: folder.name,
                ),
                transitionType: ProjectTransitionType.slideLeft,
                showChevron: !isSelecting,
                isSelected: selectedIds.contains(folder.id),
                isSelecting: isSelecting,
                onTap: isSelecting ? () => onToggleSelection(folder.id) : null,
                onLongPress: () => onToggleSelection(folder.id),
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
  bool _isSuccess = false;
  String _addedName = "";

  @override
  void initState() {
    super.initState();
    _folderNameController.addListener(() {
      setState(() {}); // Trigger rebuild to show/hide the button
    });
  }

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

      if (mounted) {
        setState(() {
          _isSuccess = true;
          _isCreatingFolder = false;
          _addedName = name;
        });

        // Feedback: Turn FAB green
        ExpandableFab.of(context).setOverrideColor(
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1B5E20) // Deep green
              : const Color(0xFF4CAF50), // Standard green
        );

        // Wait then close
        await Future.delayed(const Duration(milliseconds: 1200));

        if (mounted) {
          _folderNameController.clear();
          ExpandableFab.of(context).close();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreatingFolder = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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

    if (_isSuccess) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.checkCircle,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              "Added '$_addedName'",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // NEW COLLECTION CREATION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEW COLLECTION",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _folderNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name...",
                          hintStyle: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.3),
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: FaIcon(
                              FontAwesomeIcons.folderPlus,
                              size: 16,
                              color: cs.primary.withValues(alpha: 0.6),
                            ),
                          ),
                          filled: true,
                          fillColor: cs.onSurface.withValues(alpha: 0.04),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: cs.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _createFolder(),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: _folderNameController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: _isCreatingFolder
                                    ? null
                                    : _createFolder,
                                icon: _isCreatingFolder
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                style: IconButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  fixedSize: const Size(54, 54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SEPARATOR
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  color: cs.onSurface.withValues(alpha: 0.08),
                  indent: 32,
                  endIndent: 32,
                ),
                Container(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.98,
                  ), // Match FAB bg
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST TILES FOR MORE OPTIONS
          ProjectListGroup(
            backgroundColor:
                Colors.transparent, // Let FAB background show through
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
                label: "Upload Media",
                icon: FontAwesomeIcons.photoFilm,
                showDivider: false,
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

class _SelectionActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const _SelectionActionBar({
    required this.selectedCount,
    required this.onClose,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onClose,
            icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Text(
            "$selectedCount Selected",
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          _BarAction(
            icon: FontAwesomeIcons.thumbtack,
            label: "Pin",
            onTap: onPin,
          ),
          const SizedBox(width: 8),
          _BarAction(
            icon: FontAwesomeIcons.trashCan,
            label: "Delete",
            onTap: onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _BarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _BarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinnedFoldersSection extends StatelessWidget {
  final Stream<List<StudyFolderItem>> stream;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _PinnedFoldersSection({
    required this.stream,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<StudyFolderItem>>(
      stream: stream,
      builder: (context, snapshot) {
        final pinned = snapshot.data ?? [];
        if (pinned.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: "Pinned"),
            const SizedBox(height: 8),
            ProjectListGroup(
              backgroundColor: theme.colorScheme.surfaceContainer,
              children: [
                for (final folder in pinned)
                  ProjectListTile.simple(
                    label: folder.name,
                    date: folder.updatedAt.substring(11, 16),
                    sources: const [], // TODO
                    targetPage: FolderPage(
                      folderId: folder.id,
                      initialFolderName: folder.name,
                    ),
                    transitionType: ProjectTransitionType.slideLeft,
                    showChevron: !isSelecting,
                    isSelected: selectedIds.contains(folder.id),
                    isSelecting: isSelecting,
                    onTap: isSelecting
                        ? () => onToggleSelection(folder.id)
                        : null,
                    onLongPress: () => onToggleSelection(folder.id),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
