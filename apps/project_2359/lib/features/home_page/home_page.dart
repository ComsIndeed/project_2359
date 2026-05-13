import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/services/debug_seeder.dart';
import 'package:project_2359/features/study_page/study_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/features/home_page/widgets/collection_list_view.dart';
import 'package:project_2359/core/widgets/selection_action_bar.dart';
import 'package:project_2359/features/home_page/widgets/home_header.dart';
import 'package:project_2359/features/home_page/widgets/new_item_menu.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/features/collection_page/collection_page.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/core/widgets/due_cards_tiles.dart';

enum MainContentType { empty, study, sourceDetail, settings }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> _selectedDeckIds = {};
  List<DeckItem> _allDecks = [];
  StreamSubscription? _deckSub;

  String? _selectedDeckId;
  String? _selectedDeckName;
  MainContentType _mainContentType = MainContentType.empty;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool get _isSelecting => _selectedDeckIds.isNotEmpty;

  void _toggleDeckSelection(String id) {
    setState(() {
      if (_selectedDeckIds.contains(id)) {
        _selectedDeckIds.remove(id);
      } else {
        _selectedDeckIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedDeckIds.clear();
    });
  }

  Future<void> _handlePinSelected({required bool pin}) async {
    final service = context.read<StudyDatabaseService>();
    for (final id in _selectedDeckIds) {
      await service.toggleDeckPin(id, pin);
    }
    _clearSelection();
  }

  Future<void> _handleDeleteSelected() async {
    final count = _selectedDeckIds.length;
    if (count == 0) return;

    final confirmed = await _showDeleteConfirmation(context, count: count);
    if (!confirmed || !mounted) return;

    final service = context.read<StudyDatabaseService>();
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

  late Stream<List<DeckItem>> _rootDecksStream;

  @override
  void initState() {
    super.initState();
    AppLogger.info('Initializing HomePage...', tag: 'HomePage');
    final service = context.read<StudyDatabaseService>();
    _rootDecksStream = service.watchRootDecks();

    _deckSub = _rootDecksStream.listen((decks) {
      if (mounted) setState(() => _allDecks = decks);
    });
  }

  @override
  void dispose() {
    _deckSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptivePaneLayout(
        key: const ValueKey('home_pane_layout'),
        masterWidth: 350,
        master: (context, controller) => _buildMasterView(controller, false),
        masterCollapsed: (context, controller) => _buildMasterView(controller, true),
        detail: (context, controller) => _buildDetailView(),
        wrapDetail: _selectedDeckId == null,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildMasterView(AdaptivePaneController controller, bool isCollapsed) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            if (!isCollapsed)
              ExpandableFab(
                collapsedBuilder: (context, isOpen, expand, close) {
                  if (_isSelecting) {
                    return SelectionActionBar(
                      selectedCount: _selectedDeckIds.length,
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
                          const SizedBox(height: 32),
                          DeckSection(
                            stream: _rootDecksStream.map((list) => list.where((d) => d.isPinned).toList()),
                            title: "Pinned",
                            searchQuery: _searchQuery,
                            selectedIds: _selectedDeckIds,
                            onToggleSelection: _toggleDeckSelection,
                            onSelect: _handleDeckSelect,
                            activeDeckId: _selectedDeckId,
                            isCollapsed: isCollapsed,
                            isDesktop: ResponsiveBreakpoints.of(context).largerThan(MOBILE),
                            isSelecting: _isSelecting,
                            onContextMenu: (pos, id) => _showCoolContextMenu(context, pos, id),
                          ),
                          const SizedBox(height: 24),
                          DeckSection(
                            stream: _rootDecksStream.map((list) => list.where((d) => !d.isPinned).toList()),
                            title: "Decks",
                            searchQuery: _searchQuery,
                            selectedIds: _selectedDeckIds,
                            onToggleSelection: _toggleDeckSelection,
                            onSelect: _handleDeckSelect,
                            activeDeckId: _selectedDeckId,
                            isCollapsed: isCollapsed,
                            isDesktop: ResponsiveBreakpoints.of(context).largerThan(MOBILE),
                            isSelecting: _isSelecting,
                            onContextMenu: (pos, id) => _showCoolContextMenu(context, pos, id),
                          ),
                          const SizedBox(height: 48),
                          const _DevInjectionTile(),
                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            if (isCollapsed)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              DeckSection(
                                stream: _rootDecksStream.map((list) => list.where((d) => d.isPinned).toList()),
                                title: "Pinned",
                                searchQuery: _searchQuery,
                                selectedIds: _selectedDeckIds,
                                onToggleSelection: _toggleDeckSelection,
                                onSelect: _handleDeckSelect,
                                activeDeckId: _selectedDeckId,
                                isCollapsed: isCollapsed,
                                isDesktop: ResponsiveBreakpoints.of(context).largerThan(MOBILE),
                                isSelecting: _isSelecting,
                                onContextMenu: (pos, id) => _showCoolContextMenu(context, pos, id),
                              ),
                              const SizedBox(height: 12),
                              DeckSection(
                                stream: _rootDecksStream.map((list) => list.where((d) => !d.isPinned).toList()),
                                title: "Decks",
                                searchQuery: _searchQuery,
                                selectedIds: _selectedDeckIds,
                                onToggleSelection: _toggleDeckSelection,
                                onSelect: _handleDeckSelect,
                                activeDeckId: _selectedDeckId,
                                isCollapsed: isCollapsed,
                                isDesktop: ResponsiveBreakpoints.of(context).largerThan(MOBILE),
                                isSelecting: _isSelecting,
                                onContextMenu: (pos, id) => _showCoolContextMenu(context, pos, id),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      onPressed: controller.toggleCollapsed,
                      icon: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainer,
                      ),
                    ),
                  ),
                ],
              ),
            if (ResponsiveBreakpoints.of(context).largerThan(MOBILE) && !isCollapsed)
              Positioned(
                bottom: 16,
                right: 16,
                child: IconButton(
                  onPressed: controller.toggleCollapsed,
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    if (_mainContentType == MainContentType.study) {
      return StudyPage(
        key: ValueKey(_selectedDeckId ?? 'global_study'),
        deckId: _selectedDeckId,
        title: _selectedDeckName ?? "Global Review",
        isNested: true,
        onBack: () {
          setState(() {
            _mainContentType = MainContentType.empty;
            _selectedDeckId = null;
          });
        },
      );
    }

    if (_selectedDeckId != null) {
      final deck = _allDecks.any((d) => d.id == _selectedDeckId)
          ? _allDecks.firstWhere((d) => d.id == _selectedDeckId)
          : null;

      if (deck != null) {
        return DeckPage(
          key: ValueKey(_selectedDeckId),
          deckId: _selectedDeckId!,
          initialDeckName: deck.name,
          isNested: true,
        );
      }
    }

    if (_mainContentType == MainContentType.settings) {
      return const SettingsPage();
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
            FontAwesomeIcons.layerGroup,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 24),
          Text(
            "Select a Deck to View Contents",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStudyGlobal() {
    if (!ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StudyPage(title: "Global Review"),
        ),
      );
    } else {
      setState(() {
        _selectedDeckId = null;
        _mainContentType = MainContentType.study;
      });
    }
  }

  void _handleDeckSelect(String id) {
    if (!ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      final deck = _allDecks.firstWhere((d) => d.id == id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeckPage(
            deckId: id,
            initialDeckName: deck.name,
          ),
        ),
      );
    } else {
      setState(() {
        _selectedDeckId = id;
        _mainContentType = MainContentType.empty;
      });
    }
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
      decoration: InputDecoration(
        hintText: "Search decks...",
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  void _showCoolContextMenu(BuildContext context, Offset position, String id) {
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
                              _toggleDeckSelection(id);
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
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
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevInjectionTile extends StatefulWidget {
  const _DevInjectionTile();

  @override
  State<_DevInjectionTile> createState() => _DevInjectionTileState();
}

class _DevInjectionTileState extends State<_DevInjectionTile> {
  bool _isSeeding = false;

  Future<void> _handleSeed() async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: AppTheme.cardShape,
        title: Row(
          children: [
            Icon(FontAwesomeIcons.terminal, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 12),
            Text(
              'DEVELOPER_INJECTION',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
        content: Text(
          'INJECTION_REQUESTED: This will download ~16MB of study materials from GitHub.\n\nPROCEED?',
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'Courier',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'CANCEL',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontFamily: 'Courier',
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'EXECUTE',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('INJECTION_SUCCESSFUL')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('INJECTION_FAILED: $e')));
        }
      } finally {
        if (mounted) setState(() => _isSeeding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return StreamBuilder<bool>(
      stream: context.read<StudyDatabaseService>().watchHasMockData(),
      builder: (context, snapshot) {
        final hasData = snapshot.data ?? false;
        if (hasData) return const SizedBox.shrink();

        final theme = Theme.of(context);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _isSeeding ? null : _handleSeed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isSeeding ? FontAwesomeIcons.gear : FontAwesomeIcons.bug,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ).animate(onPlay: (c) => _isSeeding ? c.repeat() : null).rotate(duration: 2.seconds),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isSeeding ? 'INJECTING_PAYLOAD...' : 'INJECT_MOCK_DATA',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              fontFamily: 'Courier',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Internal tool: Seed ~16MB of cards',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isSeeding)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                        ),
                      )
                    else
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        size: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.1),
        );
      },
    );
  }
}
