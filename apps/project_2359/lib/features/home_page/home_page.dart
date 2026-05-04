import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/services/debug_seeder.dart';
import 'package:project_2359/features/study_page/study_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/features/home_page/widgets/folder_list_view.dart';
import 'package:project_2359/core/widgets/selection_action_bar.dart';
import 'package:project_2359/features/home_page/widgets/home_header.dart';
import 'package:project_2359/features/home_page/widgets/new_item_menu.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/features/folder_page/folder_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/core/widgets/due_cards_tiles.dart';

enum MainContentType { empty, study, sourceDetail, settings }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _selectedFolderIds = {};
  final Set<String> _selectedDeckIds = {};
  List<StudyFolderItem> _allFolders = [];
  StreamSubscription? _folderSub;
  StreamSubscription? _deckSub;

  // New state for responsive desktop layout
  String? _selectedFolderId;
  String? _selectedDeckId;
  String? _selectedDeckName;
  MainContentType _mainContentType = MainContentType.empty;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool get _isSelecting =>
      _selectedFolderIds.isNotEmpty || _selectedDeckIds.isNotEmpty;

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
      _selectedDeckIds.clear();
    });
  }

  Future<void> _handlePinSelected({required bool pin}) async {
    final service = context.read<StudyDatabaseService>();
    for (final id in _selectedFolderIds) {
      await service.toggleFolderPin(id, pin);
    }
    for (final id in _selectedDeckIds) {
      await service.toggleDeckPin(id, pin);
    }
    _clearSelection();
  }

  Future<void> _handleDeleteSelected() async {
    final count = _selectedFolderIds.length + _selectedDeckIds.length;
    if (count == 0) return;

    final confirmed = await _showDeleteConfirmation(context, count: count);
    if (!confirmed || !mounted) return;

    final service = context.read<StudyDatabaseService>();
    for (final id in _selectedFolderIds) {
      await service.deleteFolder(id);
    }
    // TODO: handle decks if we ever allow multiselecting them on home
    for (final id in _selectedDeckIds) {
      await service.deleteDeck(id);
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
    final service = context.read<StudyDatabaseService>();
    _foldersStream = service.watchUnpinnedFoldersWithStats();
    _pinnedFoldersStream = service.watchPinnedFoldersWithStats();

    _folderSub = service.watchAllFolders().listen((folders) {
      if (mounted) setState(() => _allFolders = folders);
    });
  }

  @override
  void dispose() {
    _folderSub?.cancel();
    _deckSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AdaptivePaneLayout(
        masterWidth: 350,
        master: _buildMasterView(),
        detail: _buildDetailView(),
      ),
    );
  }

  Widget _buildMasterView() {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ExpandableFab(
          collapsedBuilder: (context, isOpen, expand, close) {
            if (_isSelecting) {
              final selectedCount =
                  _selectedFolderIds.length + _selectedDeckIds.length;
              return SelectionActionBar(
                selectedCount: selectedCount,
                onClose: _clearSelection,
                onPin: () => _handlePinSelected(pin: true),
                onUnpin: () => _handlePinSelected(pin: false),
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
            return const NewItemMenu();
          },
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HomeHeader(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    const HomeDueCardsTile(),
                    const SizedBox(height: 32),
                    PinnedFoldersSection(
                      stream: _pinnedFoldersStream,
                      searchQuery: _searchQuery,
                      selectedIds: _selectedFolderIds,
                      onToggleSelection: _toggleFolderSelection,
                      onSelect: _handleFolderSelect,
                      activeFolderId: _selectedFolderId,
                      isSelecting: _isSelecting,
                      onContextMenu: (pos, id, isF) =>
                          _showCoolContextMenu(context, pos, id, isFolder: isF),
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(title: "Collections"),
                    const SizedBox(height: 8),
                    FolderList(
                      stream: _foldersStream,
                      searchQuery: _searchQuery,
                      selectedIds: _selectedFolderIds,
                      onToggleSelection: _toggleFolderSelection,
                      onSelect: _handleFolderSelect,
                      activeFolderId: _selectedFolderId,
                      isSelecting: _isSelecting,
                      onContextMenu: (pos, id, isF) =>
                          _showCoolContextMenu(context, pos, id, isFolder: isF),
                    ),
                    const SizedBox(height: 48),
                    const _GlitchyDebugTile(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    if (_selectedFolderId != null) {
      final folder = _allFolders.any((f) => f.id == _selectedFolderId)
          ? _allFolders.firstWhere((f) => f.id == _selectedFolderId)
          : null;

      if (folder != null) {
        return FolderPage(
          key: ValueKey(_selectedFolderId),
          folderId: _selectedFolderId!,
          initialFolderName: folder.name,
          isNested: true,
        );
      }
    }

    if (_mainContentType == MainContentType.settings) {
      return const SettingsPage();
    }

    // New case: Global study if needed
    if (_mainContentType == MainContentType.study && _selectedDeckId != null) {
      return StudyPage(
        key: ValueKey(_selectedDeckId),
        deckId: _selectedDeckId!,
        deckName: _selectedDeckName ?? "Study",
        isNested: true,
      );
    }

    return _buildEmptyDetail();
  }

  Widget _buildEmptyDetail() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.folderOpen,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 24),
          Text(
            "Select a Collection to View Contents",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFolderSelect(String id) {
    if (!ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      final folder = _allFolders.firstWhere((f) => f.id == id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FolderPage(folderId: id, initialFolderName: folder.name),
        ),
      );
    } else {
      setState(() {
        _selectedFolderId = id;
        _mainContentType = MainContentType.empty;
      });
    }
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        decoration: InputDecoration(
          hintText: "Search collections...",
          border: InputBorder.none,
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
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
                                  if (_selectedDeckIds.contains(id)) {
                                    _selectedDeckIds.remove(id);
                                  } else {
                                    _selectedDeckIds.add(id);
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
}

class _GlitchyDebugTile extends StatefulWidget {
  const _GlitchyDebugTile();

  @override
  State<_GlitchyDebugTile> createState() => _GlitchyDebugTileState();
}

class _GlitchyDebugTileState extends State<_GlitchyDebugTile> {
  bool _isSeeding = false;

  Future<void> _handleSeed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          '[SYSTEM_WARNING]: DATA_INJECTION',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
        content: const Text(
          'INJECTION REQUIRES ~15MB NETWORK RETRIEVAL FROM GITHUB_RAW.\n\nPROCEED WITH MOCK_DATA_OVERRIDE?',
          style: TextStyle(color: Colors.white70, fontFamily: 'Courier'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ABORT', style: TextStyle(color: Colors.white24)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'PROCEED',
              style: TextStyle(color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isSeeding = true);
      try {
        await DebugSeeder.seed(context.read<AppDatabase>());
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('INJECTION_SUCCESSFUL')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('INJECTION_FAILED: $e')));
        }
      } finally {
        if (mounted) setState(() => _isSeeding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isSeeding ? null : _handleSeed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent.withValues(alpha: 0.05),
                Colors.cyanAccent.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    const Icon(
                          FontAwesomeIcons.bug,
                          color: Colors.pinkAccent,
                          size: 20,
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shake(hz: 4, curve: Curves.easeInOut),
                    Positioned(
                      left: 2,
                      top: 2,
                      child:
                          const Icon(
                                FontAwesomeIcons.bug,
                                color: Colors.cyanAccent,
                                size: 20,
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .shake(hz: 3, curve: Curves.easeInOut),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSeeding
                            ? 'INJECTING...'
                            : '[SYSTEM_DEBUG]: INJECT_MOCK_DATA',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pulls biology seeds from GitHub Main.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSeeding)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),
                    ),
                  ),
              ],
            ),
          ),
        ).animate().fadeIn().slideY(begin: 0.1),
      ),
    );
  }
}
