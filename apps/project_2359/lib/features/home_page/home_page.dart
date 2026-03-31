import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/folder_page/folder_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:project_2359/features/study/study_page.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:project_2359/layouts/landscape/home_page_landscape_layout.dart';
import 'package:project_2359/features/card_creation_page/card_creation_page.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';

enum MainContentType { empty, study, sourceDetail, settings }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _selectedFolderIds = {};
  final Set<String> _selectedMaterialIds = {};
  List<StudyFolderItem> _allFolders = [];
  List<StudyMaterialItem> _allMaterials = [];
  StreamSubscription? _folderSub;
  StreamSubscription? _materialSub;

  // New state for responsive desktop layout
  String? _selectedFolderId;
  String? _selectedMaterialId;
  String? _selectedMaterialName;
  String? _selectedSourceId;
  Uint8List? _selectedSourceBlob;
  MainContentType _mainContentType = MainContentType.empty;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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

  void _navigateToMain(
    MainContentType type, {
    String? materialId,
    String? materialName,
    String? sourceId,
    Uint8List? sourceBlob,
  }) {
    setState(() {
      _mainContentType = type;
      _selectedMaterialId = materialId;
      _selectedMaterialName = materialName;
      _selectedSourceId = sourceId;
      _selectedSourceBlob = sourceBlob;
    });
  }

  Future<void> _loadSourceAndNavigate(SourceItem source) async {
    final service = context.read<SourceService>();
    final blob = await service.getSourceBlobBySourceId(source.id);
    if (blob != null) {
      _navigateToMain(
        MainContentType.sourceDetail,
        sourceId: source.id,
        sourceBlob: blob.bytes,
      );
    } else {
      // Fallback if no blob: if it's a text source, maybe we can use extractedContent?
      // For now, let's just use empty bytes or notify
      AppLogger.warning(
        'No blob found for source: ${source.id}',
        tag: 'HomePage',
      );
      // If it's a text source, we might want to wrap it in a PDF or show a text viewer
      // But SourcePage expects PDF bytes.
    }
  }

  Future<void> _handlePinSelected({required bool pin}) async {
    final service = context.read<StudyMaterialService>();
    for (final id in _selectedFolderIds) {
      await service.toggleFolderPin(id, pin);
    }
    for (final id in _selectedMaterialIds) {
      await service.toggleMaterialPin(id, pin);
    }
    _clearSelection();
  }

  Future<void> _handleDeleteSelected() async {
    final count = _selectedFolderIds.length + _selectedMaterialIds.length;
    if (count == 0) return;

    final confirmed = await _showDeleteConfirmation(context, count: count);
    if (!confirmed || !mounted) return;

    final service = context.read<StudyMaterialService>();
    for (final id in _selectedFolderIds) {
      await service.deleteFolder(id);
    }
    // TODO: handle materials if we ever allow multiselecting them on home
    for (final id in _selectedMaterialIds) {
      await service.deleteMaterial(id);
    }
    _clearSelection();
  }

  Future<bool> _showDeleteConfirmation(
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

  late Stream<List<(StudyFolderItem, int)>> _foldersStream;
  late Stream<List<(StudyFolderItem, int)>> _pinnedFoldersStream;

  @override
  void initState() {
    super.initState();
    AppLogger.info('Initializing HomePage...', tag: 'HomePage');
    final service = context.read<StudyMaterialService>();
    _foldersStream = service.watchUnpinnedFoldersWithStats();
    _pinnedFoldersStream = service.watchPinnedFoldersWithStats();

    _folderSub = service.watchAllFolders().listen((folders) {
      if (mounted) setState(() => _allFolders = folders);
    });
    _materialSub = service.watchAllMaterials().listen((materials) {
      if (mounted) setState(() => _allMaterials = materials);
    });
  }

  @override
  void dispose() {
    _folderSub?.cancel();
    _materialSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      return _buildLandscapeLayout();
    }
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ExpandableFab(
        collapsedBuilder: (context, isOpen, expand, close) {
          if (_isSelecting) {
            final selectedFolders = _allFolders
                .where((f) => _selectedFolderIds.contains(f.id))
                .toList();
            final selectedMaterials = _allMaterials
                .where((m) => _selectedMaterialIds.contains(m.id))
                .toList();

            final allSelected = [...selectedFolders, ...selectedMaterials];
            final allPinned =
                allSelected.isNotEmpty &&
                allSelected.every((i) {
                  if (i is StudyFolderItem) return i.isPinned;
                  if (i is StudyMaterialItem) return i.isPinned;
                  return false;
                });
            final allUnpinned =
                allSelected.isNotEmpty &&
                allSelected.every((i) {
                  if (i is StudyFolderItem) return !i.isPinned;
                  if (i is StudyMaterialItem) return !i.isPinned;
                  return false;
                });
            final isMixed = !allPinned && !allUnpinned;

            return _SelectionActionBar(
              selectedCount:
                  _selectedFolderIds.length + _selectedMaterialIds.length,
              onClose: _clearSelection,
              onPin: () => _handlePinSelected(pin: true),
              onUnpin: () => _handlePinSelected(pin: false),
              isUnpin: allPinned,
              isPinDisabled: isMixed,
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
                // MAIN CONTENT
                SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      SizedBox(height: topBgHeight * 0.3),
                      const _HomeHeader(),
                      const SizedBox(height: 24),
                      // REFINED SEARCH BAR
                      SpecialSearchBar(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 48),

                      // PINNED SECTION
                      _PinnedFoldersSection(
                        stream: _pinnedFoldersStream,
                        searchQuery: _searchQuery,
                        selectedIds: _selectedFolderIds,
                        onToggleSelection: _toggleFolderSelection,
                        onSelect:
                            (id) {}, // Not used on mobile due to internal check
                        isSelecting: _isSelecting,
                      ),

                      const SizedBox(height: 24),

                      // ALL COLLECTIONS SECTION
                      const _SectionHeader(title: "Today"),
                      const SizedBox(height: 8),
                      _FolderList(
                        stream: _foldersStream,
                        searchQuery: _searchQuery,
                        backgroundColor: theme.colorScheme.surfaceContainer,
                        selectedIds: _selectedFolderIds,
                        onToggleSelection: _toggleFolderSelection,
                        onSelect:
                            (id) {}, // Not used on mobile due to internal check
                        isSelecting: _isSelecting,
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: StreamBuilder<List<(StudyFolderItem, int)>>(
                          stream: _foldersStream,
                          builder: (context, snapshot) {
                            final count = (snapshot.data?.length ?? 0);
                            return Text(
                              "$count Collection${count == 1 ? '' : 's'}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                                letterSpacing: 0.2,
                              ),
                            );
                          },
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

  /// TODO: Refactor the UI into layouts and contents.
  /// That way, only the layout changes, the contents aren't repeated.
  Widget _buildLandscapeLayout() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: HomePageLandscapeLayout(
        header: _HomeHeader(
          isLandscape: true,
          onPlusTap: () => _showNewMenu(context),
        ),
        sidebarA: _buildSidebarA(),
        sidebarB: _selectedFolderId != null ? _buildSidebarB() : null,
        mainContent: _buildMainContent(),
        onSettingsTap: () => _navigateToMain(MainContentType.settings),
        onProfileTap: () {
          // TODO: Profile implementation
        },
      ),
    );
  }

  Widget _buildSidebarA() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _PinnedFoldersSection(
          stream: _pinnedFoldersStream,
          searchQuery: _searchQuery,
          selectedIds: _selectedFolderIds,
          activeFolderId: _selectedFolderId,
          onToggleSelection: _toggleFolderSelection,
          onSelect: (id) => setState(() {
            _selectedFolderId = id;
            _mainContentType = MainContentType.empty;
            _selectedMaterialId = null;
          }),
          isSelecting: _isSelecting,
          isLandscape: true,
        ),
        const SizedBox(height: 24),
        const _SectionHeader(title: "Collections"),
        _FolderList(
          stream: _foldersStream,
          searchQuery: _searchQuery,
          selectedIds: _selectedFolderIds,
          activeFolderId: _selectedFolderId,
          onToggleSelection: _toggleFolderSelection,
          onSelect: (id) => setState(() {
            _selectedFolderId = id;
            _mainContentType = MainContentType.empty;
            _selectedMaterialId = null;
          }),
          isSelecting: _isSelecting,
          isLandscape: true,
        ),
      ],
    );
  }

  Widget _buildSidebarB() {
    final theme = Theme.of(context);
    if (_selectedFolderId == null) return const SizedBox.shrink();

    final service = context.read<StudyMaterialService>();
    final materialsStream = service.watchMaterialsByFolderId(
      _selectedFolderId!,
    );

    final folderName = _allFolders.any((f) => f.id == _selectedFolderId)
        ? _allFolders.firstWhere((f) => f.id == _selectedFolderId).name
        : "Folder Contents";

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    folderName,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CardCreationPage(folderId: _selectedFolderId!),
                      ),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                StreamBuilder<List<StudyMaterialItem>>(
                  stream: materialsStream,
                  builder: (context, snapshot) {
                    final materials = snapshot.data ?? [];
                    if (materials.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionHeader(title: "Materials"),
                        for (var m in materials)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child:
                                GestureDetector(
                                      onSecondaryTapDown: (details) =>
                                          _showCoolContextMenu(
                                            context,
                                            details.globalPosition,
                                            m.id,
                                          ),
                                      child: ProjectCardTile(
                                        backgroundColor: theme
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.5),
                                        title: Text(m.name),
                                        subtitle: Text(
                                          m.description ?? "Card Pack",
                                        ),
                                        isSelected: _selectedMaterialId == m.id,
                                        isCompact: true,
                                        leading: const WizardFlashcardPreview(),
                                        onTap: () {
                                          _navigateToMain(
                                            MainContentType.study,
                                            materialId: m.id,
                                            materialName: m.name,
                                          );
                                        },
                                      ),
                                    )
                                    .animate(
                                      key: ValueKey(
                                        "ani_mat_${_selectedFolderId!}_${m.id}",
                                      ),
                                    )
                                    .fadeIn(duration: 250.ms)
                                    .slideX(
                                      begin: 0.1,
                                      end: 0,
                                      curve: Curves.easeOutCubic,
                                    ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<SourceItem>>(
                  stream: context.read<SourceService>().watchSourcesByFolderId(
                    _selectedFolderId!,
                  ),
                  builder: (context, snapshot) {
                    final sources = snapshot.data ?? [];
                    if (sources.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionHeader(title: "Sources"),
                        for (var s in sources)
                          Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onSecondaryTapDown: (details) =>
                                      _showCoolContextMenu(
                                        context,
                                        details.globalPosition,
                                        s.id,
                                      ),
                                  child: ProjectCardTile(
                                    backgroundColor: theme
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                                    title: Text(s.label),
                                    subtitle: Text(
                                      "${s.type.toUpperCase()} | ${s.extractedContent?.length ?? 0} chars",
                                    ),
                                    isSelected: false,
                                    isCompact: true,
                                    leading: const WizardSourcePagePreview(),
                                    onTap: () {
                                      _loadSourceAndNavigate(s);
                                    },
                                  ),
                                ),
                              )
                              .animate(
                                key: ValueKey(
                                  "ani_src_${_selectedFolderId!}_${s.id}",
                                ),
                              )
                              .fadeIn(duration: 250.ms)
                              .slideX(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final isLandscape = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    switch (_mainContentType) {
      case MainContentType.study:
        if (_selectedMaterialId != null) {
          return StudyPage(
            key: ValueKey('study_$_selectedMaterialId'),
            materialId: _selectedMaterialId!,
            materialName: _selectedMaterialName ?? "Material",
            showBackButton: !isLandscape,
          );
        }
        break;
      case MainContentType.sourceDetail:
        if (_selectedSourceBlob != null) {
          return SourcePage(
            fileBytes: _selectedSourceBlob!,
            title: _selectedSourceId,
            showBackButton: !isLandscape,
          );
        }
        break;
      case MainContentType.settings:
        return const SettingsPage();
      case MainContentType.empty:
        break;
    }

    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.ghost,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            const SizedBox(height: 24),
            Text(
              "Select something to view.",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "idk what else to tell you yet...",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCoolContextMenu(
    BuildContext context,
    Offset position,
    String id, {
    bool isFolder = false,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = Curves.easeOutBack.transform(anim1.value);
        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Transform.scale(
                scale: curve,
                alignment: Alignment.topLeft,
                child: FadeTransition(
                  opacity: anim1,
                  child: Material(
                    elevation: 12,
                    clipBehavior: Clip.antiAlias,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuItem(
                            context,
                            icon: FontAwesomeIcons.checkDouble,
                            label: "Multi-select",
                            onTap: () {
                              Navigator.pop(context);
                              if (isFolder) {
                                _toggleFolderSelection(id);
                              } else {
                                setState(() {
                                  if (_selectedMaterialIds.contains(id)) {
                                    _selectedMaterialIds.remove(id);
                                  } else {
                                    _selectedMaterialIds.add(id);
                                  }
                                });
                              }
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: FontAwesomeIcons.thumbtack,
                            label: "Pin",
                            onTap: () {
                              Navigator.pop(context);
                              _handlePinSelected(pin: true);
                            },
                          ),
                          Divider(
                            height: 1,
                            color: cs.onSurface.withValues(alpha: 0.05),
                          ),
                          _buildMenuItem(
                            context,
                            icon: FontAwesomeIcons.trashCan,
                            label: "Delete",
                            isDestructive: true,
                            onTap: () {
                              Navigator.pop(context);
                              _handleDeleteSelected();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    final color = isDestructive ? cs.error : cs.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            FaIcon(icon, size: 14, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewMenu(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = Curves.easeInOutCubicEmphasized.transform(anim1.value);
        return Stack(
          children: [
            Center(
              child: Opacity(
                opacity: anim1.value,
                child: Transform.scale(
                  scale: 0.8 + (0.2 * curve),
                  child: Container(
                    width: 400,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.98),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.4 : 0.12,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                          spreadRadius: -2,
                        ),
                      ],
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.2,
                          ),
                          width: 1.0,
                        ),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: _NewButtonExpandedContent(
                        onActionCompleted: () => Navigator.pop(context),
                        activeFolderId: _selectedFolderId,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

class _PinnedFoldersSection extends StatelessWidget {
  final Stream<List<(StudyFolderItem, int)>> stream;
  final String searchQuery;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onSelect;
  final bool isSelecting;
  final bool isLandscape;
  final String? activeFolderId;

  const _PinnedFoldersSection({
    required this.stream,
    required this.searchQuery,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onSelect,
    required this.isSelecting,
    this.isLandscape = false,
    this.activeFolderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<(StudyFolderItem, int)>>(
      stream: stream,
      builder: (context, snapshot) {
        final folderPairs = (snapshot.data ?? []).where((p) {
          if (searchQuery.isEmpty) return true;
          return p.$1.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (folderPairs.isEmpty) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: "Pinned"),
            for (final pair in folderPairs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onSecondaryTapDown: (details) =>
                      (context.findAncestorStateOfType<_HomePageState>())
                          ?._showCoolContextMenu(
                            context,
                            details.globalPosition,
                            pair.$1.id,
                            isFolder: true,
                          ),
                  child: ProjectCardTile(
                    title: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.thumbtack,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pair.$1.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 10,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("${pair.$2} Card${pair.$2 == 1 ? '' : 's'}"),
                      ],
                    ),
                    isSelected:
                        selectedIds.contains(pair.$1.id) ||
                        (isLandscape && activeFolderId == pair.$1.id),
                    isCompact: isLandscape,
                    onTap: isSelecting
                        ? () => onToggleSelection(pair.$1.id)
                        : () {
                            if (ResponsiveBreakpoints.of(
                              context,
                            ).largerThan(MOBILE)) {
                              onSelect(pair.$1.id);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FolderPage(
                                    folderId: pair.$1.id,
                                    initialFolderName: pair.$1.name,
                                  ),
                                ),
                              );
                            }
                          },
                    onLongTap: () => onToggleSelection(pair.$1.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FolderList extends StatelessWidget {
  final Stream<List<(StudyFolderItem, int)>> stream;
  final String searchQuery;
  final Color? backgroundColor;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onSelect;
  final bool isSelecting;
  final bool isLandscape;
  final String? activeFolderId;

  const _FolderList({
    required this.stream,
    required this.searchQuery,
    this.backgroundColor,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onSelect,
    required this.isSelecting,
    this.isLandscape = false,
    this.activeFolderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<(StudyFolderItem, int)>>(
      stream: stream,
      builder: (context, snapshot) {
        final folderPairs = (snapshot.data ?? []).where((p) {
          if (searchQuery.isEmpty) return true;
          return p.$1.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (folderPairs.isEmpty) {
          final isSearching = searchQuery.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                isSearching
                    ? "No matching collections found."
                    : "No collections yet. Create one below!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final pair in folderPairs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onSecondaryTapDown: (details) =>
                      (context.findAncestorStateOfType<_HomePageState>())
                          ?._showCoolContextMenu(
                            context,
                            details.globalPosition,
                            pair.$1.id,
                            isFolder: true,
                          ),
                  child: ProjectCardTile(
                    title: Row(
                      children: [
                        if (pair.$1.isPinned) ...[
                          FaIcon(
                            FontAwesomeIcons.thumbtack,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            pair.$1.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 10,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("${pair.$2} Card${pair.$2 == 1 ? '' : 's'}"),
                      ],
                    ),
                    isSelected:
                        selectedIds.contains(pair.$1.id) ||
                        (isLandscape && activeFolderId == pair.$1.id),
                    isCompact: isLandscape,
                    onTap: isSelecting
                        ? () => onToggleSelection(pair.$1.id)
                        : () {
                            if (ResponsiveBreakpoints.of(
                              context,
                            ).largerThan(MOBILE)) {
                              onSelect(pair.$1.id);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FolderPage(
                                    folderId: pair.$1.id,
                                    initialFolderName: pair.$1.name,
                                  ),
                                ),
                              );
                            }
                          },
                    onLongTap: () => onToggleSelection(pair.$1.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final bool isLandscape;
  final VoidCallback? onPlusTap;
  const _HomeHeader({this.isLandscape = false, this.onPlusTap});

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
        if (!isLandscape) const _HeaderActions(),
        if (isLandscape)
          IconButton(
            onPressed: onPlusTap,
            icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.05,
              ),
            ),
          ),
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
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
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
      ],
    );
  }
}

class _NewButtonExpandedContent extends StatefulWidget {
  final VoidCallback? onActionCompleted;
  final String? activeFolderId;

  const _NewButtonExpandedContent({
    this.onActionCompleted,
    this.activeFolderId,
  });

  @override
  State<_NewButtonExpandedContent> createState() =>
      _NewButtonExpandedContentState();
}

class _NewButtonExpandedContentState extends State<_NewButtonExpandedContent> {
  final TextEditingController folderNameController = TextEditingController();
  bool isCreatingFolder = false;

  @override
  void initState() {
    super.initState();
    folderNameController.addListener(() {
      setState(() {}); // Trigger rebuild to show/hide the button
    });
  }

  Future<void> createFolder() async {
    final name = folderNameController.text.trim();
    if (name.isEmpty) return;

    setState(() => isCreatingFolder = true);
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
        folderNameController.clear();
        if (widget.onActionCompleted != null) {
          widget.onActionCompleted!();
        } else {
          try {
            ExpandableFab.of(context).close();
          } catch (_) {
            // Fallback for when not used inside ExpandableFab but callback is missing
            Navigator.maybePop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isCreatingFolder = false);
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
    folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                        controller: folderNameController,
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
                        onSubmitted: (_) => createFolder(),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: folderNameController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: isCreatingFolder
                                    ? null
                                    : createFolder,
                                icon: isCreatingFolder
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
                label: "New Card Pack",
                icon: FontAwesomeIcons.layerGroup,
                showDivider: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardCreationPage(
                        folderId: widget.activeFolderId ?? "default",
                      ),
                    ),
                  );
                  if (widget.onActionCompleted != null) {
                    widget.onActionCompleted!();
                  } else {
                    try {
                      ExpandableFab.of(context).close();
                    } catch (_) {}
                  }
                },
                showChevron: false,
              ),
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
