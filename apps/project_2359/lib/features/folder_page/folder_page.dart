import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/study/study_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';

import 'package:project_2359/features/folder_page/widgets/fab_generation_view.dart';
import 'package:project_2359/features/folder_page/widgets/fab_sources_view.dart';
import 'package:project_2359/features/folder_page/widgets/fab_settings_view.dart';
import 'package:project_2359/features/folder_page/widgets/fab_study_options_view.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';

enum FabMode { generation, sources, settings, study }

class FolderPage extends StatefulWidget {
  final String folderId;
  final String initialFolderName;

  const FolderPage({
    super.key,
    required this.folderId,
    required this.initialFolderName,
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late String folderName;
  final Set<String> _selectedMaterialIds = {};
  List<StudyMaterialItem> _allMaterials = [];
  StreamSubscription? _materialSub;
  List<SourceItem>? _currentSources;
  StreamSubscription? _sourcesSub;
  FabMode _fabMode = FabMode.generation;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  void _requestPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
    );
  }

  bool get _isSelecting => _selectedMaterialIds.isNotEmpty;

  void _toggleMaterialSelection(String id) {
    setState(() {
      if (_selectedMaterialIds.contains(id)) {
        _selectedMaterialIds.remove(id);
      } else {
        _selectedMaterialIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedMaterialIds.clear();
    });
  }

  Future<void> _handlePinSelected({required bool pin}) async {
    final service = context.read<StudyMaterialService>();
    for (final id in _selectedMaterialIds) {
      await service.toggleMaterialPin(id, pin);
    }
    _clearSelection();
  }

  Future<void> _handleDeleteSelected() async {
    final count = _selectedMaterialIds.length;
    if (count == 0) return;

    final confirmed = await _showMultiDeleteConfirmation(context, count: count);
    if (!confirmed || !mounted) return;

    final service = context.read<StudyMaterialService>();
    for (final id in _selectedMaterialIds) {
      await service.deleteMaterial(id);
    }
    _clearSelection();
  }

  Future<bool> _showMultiDeleteConfirmation(
    BuildContext context, {
    required int count,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete $count Item${count > 1 ? 's' : ''}?"),
            content: Text(
              "Are you sure you want to delete the selected ${count > 1 ? 'items' : 'item'}? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }

  late Stream<List<StudyMaterialItem>> _materialsStream;

  @override
  void initState() {
    super.initState();
    folderName = widget.initialFolderName;
    final service = context.read<StudyMaterialService>();
    _materialsStream = service.watchMaterialsByFolderId(widget.folderId);
    _materialSub = _materialsStream.listen((materials) {
      if (mounted) setState(() => _allMaterials = materials);
    });

    // Also watch sources to provide initialData to FAB for smooth animation
    final sourceService = context.read<SourceService>();
    _sourcesSub = sourceService.watchSourcesByFolderId(widget.folderId).listen((
      sources,
    ) {
      if (mounted) setState(() => _currentSources = sources);
    });
  }

  @override
  void didUpdateWidget(FolderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderId != widget.folderId) {
      _materialSub?.cancel();
      _sourcesSub?.cancel();

      final service = context.read<StudyMaterialService>();
      _materialsStream = service.watchMaterialsByFolderId(widget.folderId);
      _materialSub = _materialsStream.listen((materials) {
        if (mounted) setState(() => _allMaterials = materials);
      });

      final sourceService = context.read<SourceService>();
      _sourcesSub = sourceService
          .watchSourcesByFolderId(widget.folderId)
          .listen((sources) {
            if (mounted) setState(() => _currentSources = sources);
          });
    }
  }

  @override
  void dispose() {
    _materialSub?.cancel();
    _sourcesSub?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Removed _showFolderSettings

  // Removed _showDeleteConfirmation

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: ExpandableFab(
        collapsedBuilder: (context, isOpen, expand, close) {
          if (_isSelecting) {
            final selectedMaterials = _allMaterials
                .where((m) => _selectedMaterialIds.contains(m.id))
                .toList();

            final allPinned =
                selectedMaterials.isNotEmpty &&
                selectedMaterials.every((m) => m.isPinned);
            final allUnpinned =
                selectedMaterials.isNotEmpty &&
                selectedMaterials.every((m) => !m.isPinned);
            final isMixed = !allPinned && !allUnpinned;

            return _SelectionActionBar(
              selectedCount: _selectedMaterialIds.length,
              onClose: _clearSelection,
              onPin: () => _handlePinSelected(pin: true),
              onUnpin: () => _handlePinSelected(pin: false),
              isUnpin: allPinned,
              isPinDisabled: isMixed,
              onDelete: _handleDeleteSelected,
            );
          }
          return InkWell(
            onTap: () {
              setState(() => _fabMode = FabMode.generation);
              expand();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.plus, size: 14),
                  const SizedBox(width: 10),
                  Text(
                    'Create',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        expandedBuilder: (context, isOpen, expand, close) {
          return _FolderFabContent(
            folderId: widget.folderId,
            folderName: folderName,
            mode: _fabMode,
            initialSources: _currentSources,
          );
        },
        body: Stack(
          children: [
            // Full-screen animated background
            Positioned.fill(
              child: SpecialBackgroundGenerator(
                type: SpecialBackgroundType.geometricSquares,
                seed: GenerationSeed.fromString(folderName),
                label: folderName,
                icon: FontAwesomeIcons.folder,
                showBorder: false,
                showShadow: false,
                backgroundColor: null,
                borderRadius: 0,
                child: const SizedBox.expand(),
              ),
            ),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CollapsingHeaderDelegate(
                      folderName: folderName,
                      topPadding: MediaQuery.of(context).padding.top,
                      onBack: () => Navigator.pop(context),
                      currentIndex: _currentPageIndex,
                      onPageRequested: _requestPage,
                    ),
                  ),
                ];
              },
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // PAGE 0: CARDS
                  _CardsPage(
                    materials: _allMaterials,
                    folderId: widget.folderId,
                    selectedIds: _selectedMaterialIds,
                    onToggleSelection: _toggleMaterialSelection,
                    isSelecting: _isSelecting,
                  ),
                  // PAGE 1: SOURCES
                  _SourcesPage(
                    folderId: widget.folderId,
                    sources: _currentSources ?? [],
                  ),
                  // PAGE 2: SETTINGS
                  _SettingsPage(
                    folderId: widget.folderId,
                    folderName: folderName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// COLLAPSING HEADER DELEGATE
// ---------------------------------------------------------------------------

class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String folderName;
  final double topPadding;
  final VoidCallback onBack;
  final int currentIndex;
  final ValueChanged<int> onPageRequested;

  _CollapsingHeaderDelegate({
    required this.folderName,
    required this.topPadding,
    required this.onBack,
    required this.currentIndex,
    required this.onPageRequested,
  });

  static const double _collapsedBarHeight = 64.0;

  @override
  double get maxExtent => 280 + topPadding; // Increased to avoid overflow

  @override
  double get minExtent => _collapsedBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);

    // 0.0 = fully expanded, 1.0 = fully collapsed
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Appbar background — solid black but with a subtle border when collapsed
    final bgColor = Color.lerp(
      Colors.black.withValues(alpha: 0.0),
      Colors.black,
      (t * 1.5).clamp(0.0, 1.0),
    )!;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── EXPANDED CONTENT ──
          Positioned(
            left: 20,
            right: 20,
            top: topPadding + _collapsedBarHeight,
            child: Opacity(
              opacity: (1.0 - t * 2.5).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: t > 0.4,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline
                      Text(
                        "FOLDER",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title with Accent Bar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 32,
                            margin: const EdgeInsets.only(top: 4, right: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              folderName,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.8,
                                fontSize: 28,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Header Actions
                      Row(
                        children: [
                          _HeaderCircleAction(
                            icon: FontAwesomeIcons.solidClone,
                            onTap: () => onPageRequested(0),
                            label: "Decks",
                            isActive: currentIndex == 0,
                          ),
                          const SizedBox(width: 16),
                          _HeaderCircleAction(
                            icon: FontAwesomeIcons.layerGroup,
                            onTap: () => onPageRequested(1),
                            label: "Sources",
                            isActive: currentIndex == 1,
                          ),
                          const SizedBox(width: 16),
                          _HeaderCircleAction(
                            icon: FontAwesomeIcons.gear,
                            onTap: () => onPageRequested(2),
                            label: "Settings",
                            isActive: currentIndex == 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── COLLAPSED BAR ──
          Positioned(
            left: 0,
            right: 0,
            top: topPadding,
            height: _collapsedBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 20),
                    onPressed: onBack,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Opacity(
                      opacity: (t * 2.0 - 0.6).clamp(0.0, 1.0),
                      child: Text(
                        folderName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Collapsed Actions
                  Opacity(
                    opacity: (t * 2.0 - 0.6).clamp(0.0, 1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CompactIconButton(
                          icon: FontAwesomeIcons.solidClone,
                          onTap: () => onPageRequested(0),
                          isActive: currentIndex == 0,
                        ),
                        _CompactIconButton(
                          icon: FontAwesomeIcons.layerGroup,
                          onTap: () => onPageRequested(1),
                          isActive: currentIndex == 1,
                        ),
                        _CompactIconButton(
                          icon: FontAwesomeIcons.gear,
                          onTap: () => onPageRequested(2),
                          isActive: currentIndex == 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircleAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderCircleAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary
                  : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 16,
                color: isActive ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _CompactIconButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: onTap,
      icon: FaIcon(
        icon,
        size: 16,
        color: isActive
            ? theme.colorScheme.primary
            : Colors.white.withValues(alpha: 0.6),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PAGE CONTENT WIDGETS
// ---------------------------------------------------------------------------

class _CardsPage extends StatelessWidget {
  final List<StudyMaterialItem> materials;
  final String folderId;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _CardsPage({
    required this.materials,
    required this.folderId,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(title: "Card Packs"),
          const SizedBox(height: 12),
          _StudyMaterialsList(
            materials: materials,
            folderId: folderId,
            selectedIds: selectedIds,
            onToggleSelection: onToggleSelection,
            isSelecting: isSelecting,
          ),
          const SizedBox(height: 100), // FAB spacing
        ],
      ),
    );
  }
}

class _SourcesPage extends StatelessWidget {
  final String folderId;
  final List<SourceItem> sources;

  const _SourcesPage({required this.folderId, required this.sources});

  IconData _getSourceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return FontAwesomeIcons.filePdf;
      case 'text':
        return FontAwesomeIcons.fileLines;
      default:
        return FontAwesomeIcons.fileLines;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(title: "Folder Sources"),
          const SizedBox(height: 12),
          if (sources.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 32,
                      color: cs.onSurface.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No sources yet",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < sources.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child:
                        ProjectCardTile(
                              backgroundColor: theme
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              minHeight: 100,
                              title: Text(sources[i].label),
                              subtitle: Row(
                                children: [
                                  FaIcon(
                                    _getSourceIcon(sources[i].type),
                                    size: 10,
                                    color: cs.onSurface.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${sources[i].type.toUpperCase()} | ${sources[i].extractedContent?.length ?? 0} chars",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              leading: const WizardSourcePagePreview(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SourcePageLoader(
                                      sourceId: sources[i].id,
                                      sourceLabel: sources[i].label,
                                    ),
                                  ),
                                );
                              },
                            )
                            .animate()
                            .fadeIn(delay: (i * 50).ms)
                            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
                  ),
              ],
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  final String folderId;
  final String folderName;

  const _SettingsPage({required this.folderId, required this.folderName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(title: "General"),
          const SizedBox(height: 12),
          ProjectListGroup(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            children: [
              ProjectListTile.simple(
                label: "Rename Folder",
                icon: FontAwesomeIcons.pen,
                showDivider: true,
                onTap: () {},
              ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.1),
              ProjectListTile.simple(
                label: "Folder Icon & Color",
                icon: FontAwesomeIcons.palette,
                showDivider: true,
                onTap: () {},
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
              ProjectListTile.simple(
                label: "Collaboration & Sharing",
                icon: FontAwesomeIcons.userGroup,
                onTap: () {},
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: "Content & Data"),
          const SizedBox(height: 12),
          ProjectListGroup(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            children: [
              ProjectListTile.simple(
                label: "Archive Folder",
                icon: FontAwesomeIcons.boxArchive,
                showDivider: true,
                onTap: () {},
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              ProjectListTile.simple(
                label: "Download All Sources",
                icon: FontAwesomeIcons.cloudArrowDown,
                onTap: () {},
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: "Danger Zone"),
          const SizedBox(height: 12),
          ProjectListGroup(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            children: [
              ProjectListTile.simple(
                label: "Delete Folder",
                icon: FontAwesomeIcons.trashCan,
                isAlert: true,
                onTap: () async {
                  final service = context.read<StudyMaterialService>();
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Folder?"),
                          content: const Text(
                            "Are you sure you want to delete this folder? This action cannot be undone.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: cs.error,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmed) {
                    await service.deleteFolder(folderId);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EXISTING WIDGETS (preserved from original)
// ---------------------------------------------------------------------------

// DELETED _ActionButtonChip

class _StudyMaterialsList extends StatelessWidget {
  final List<StudyMaterialItem> materials;
  final String folderId;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _StudyMaterialsList({
    required this.materials,
    required this.folderId,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (materials.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.inbox,
                  size: 32,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Empty Collection",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create your first study material\nto get started with this project.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < materials.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                ProjectCardTile(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      leading: const WizardFlashcardPreview(),
                      title: Text(materials[i].name),
                      subtitle: Text(materials[i].description ?? "Card Pack"),
                      isSelected: selectedIds.contains(materials[i].id),
                      onTap: isSelecting
                          ? () => onToggleSelection(materials[i].id)
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudyPage(
                                    materialId: materials[i].id,
                                    materialName: materials[i].name,
                                  ),
                                ),
                              );
                            },
                      onLongTap: () => onToggleSelection(materials[i].id),
                    )
                    .animate()
                    .fadeIn(delay: (i * 50).ms)
                    .slideY(begin: 0.1, curve: Curves.easeOutQuad),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

// DELETED _SourcesBottomSheet

// ---------------------------------------------------------------------------
// COMPACT GENERATION WIZARD CONTENT
// ---------------------------------------------------------------------------

class _FolderFabContent extends StatefulWidget {
  final String folderId;
  final String folderName;
  final FabMode mode;
  final List<SourceItem>? initialSources;

  const _FolderFabContent({
    required this.folderId,
    required this.folderName,
    required this.mode,
    this.initialSources,
  });

  @override
  State<_FolderFabContent> createState() => _FolderFabContentState();
}

class _FolderFabContentState extends State<_FolderFabContent> {
  late FabMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
  }

  @override
  void didUpdateWidget(_FolderFabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      setState(() {
        _currentMode = widget.mode;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentMode) {
      case FabMode.generation:
        return FabGenerationView(
          folderId: widget.folderId,
          initialSources: widget.initialSources,
        );
      case FabMode.sources:
        return FabSourcesView(
          folderId: widget.folderId,
          initialSources: widget.initialSources,
        );
      case FabMode.settings:
        return FabSettingsView(
          folderId: widget.folderId,
          folderName: widget.folderName,
        );
      case FabMode.study:
        return FabStudyOptionsView(folderId: widget.folderId);
    }
  }
}

class _SelectionActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onPin;
  final VoidCallback onUnpin;
  final VoidCallback onDelete;
  final bool isUnpin;
  final bool isPinDisabled;

  const _SelectionActionBar({
    required this.selectedCount,
    required this.onClose,
    required this.onPin,
    required this.onUnpin,
    required this.onDelete,
    this.isUnpin = false,
    this.isPinDisabled = false,
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
            icon: isUnpin
                ? FontAwesomeIcons.thumbtack
                : FontAwesomeIcons.thumbtack,
            label: isUnpin ? "Unpin" : "Pin",
            onTap: isUnpin ? onUnpin : onPin,
            isDisabled: isPinDisabled,
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
  final bool isDisabled;

  const _BarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
        : isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: isDisabled ? null : onTap,
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
