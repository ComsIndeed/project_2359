import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/features/folder_page/folder_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:provider/provider.dart';

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
                  bottom: false,
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
  final Stream<List<(StudyFolderItem, int)>> stream;
  final String searchQuery;
  final Color? backgroundColor;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _FolderList({
    required this.stream,
    required this.searchQuery,
    this.backgroundColor,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
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
                  isSelected: selectedIds.contains(pair.$1.id),
                  onTap: isSelecting
                      ? () => onToggleSelection(pair.$1.id)
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FolderPage(
                              folderId: pair.$1.id,
                              initialFolderName: pair.$1.name,
                            ),
                          ),
                        ),
                  onLongTap: () => onToggleSelection(pair.$1.id),
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
  const _NewButtonExpandedContent();

  @override
  State<_NewButtonExpandedContent> createState() =>
      _NewButtonExpandedContentState();
}

class _NewButtonExpandedContentState extends State<_NewButtonExpandedContent> {
  final TextEditingController _folderNameController = TextEditingController();
  bool _isCreatingFolder = false;

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
        _folderNameController.clear();
        ExpandableFab.of(context).close();
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

class _PinnedFoldersSection extends StatelessWidget {
  final Stream<List<(StudyFolderItem, int)>> stream;
  final String searchQuery;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _PinnedFoldersSection({
    required this.stream,
    required this.searchQuery,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<(StudyFolderItem, int)>>(
      stream: stream,
      builder: (context, snapshot) {
        final pinned = (snapshot.data ?? []).where((p) {
          if (searchQuery.isEmpty) return true;
          return p.$1.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (pinned.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: "Pinned"),
            const SizedBox(height: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final pair in pinned)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
                      isSelected: selectedIds.contains(pair.$1.id),
                      onTap: isSelecting
                          ? () => onToggleSelection(pair.$1.id)
                          : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FolderPage(
                                  folderId: pair.$1.id,
                                  initialFolderName: pair.$1.name,
                                ),
                              ),
                            ),
                      onLongTap: () => onToggleSelection(pair.$1.id),
                    ),
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
