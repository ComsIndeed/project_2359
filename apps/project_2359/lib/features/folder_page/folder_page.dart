import 'package:flutter/material.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:project_2359/core/enums/media_type.dart'; // For MediaType
import 'package:project_2359/core/tables/source_item_blobs.dart'; // For SourceFileType
import 'package:project_2359/features/card_creation_page/card_creation_page.dart';
import 'package:project_2359/features/study_page/study_page.dart';

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
  final Set<String> _selectedDeckIds = {};
  List<DeckItem> _allDecks = [];
  List<CardCreationDraftItem> _allDrafts = [];
  StreamSubscription? _deckSub;
  StreamSubscription? _draftSub;
  List<SourceItem>? _currentSources;
  StreamSubscription? _sourcesSub;
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

    final confirmed = await _showMultiDeleteConfirmation(context, count: count);
    if (!confirmed || !mounted) return;

    final service = context.read<StudyDatabaseService>();
    for (final id in _selectedDeckIds) {
      await service.deleteDeck(id);
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

  late Stream<List<DeckItem>> _decksStream;

  Future<void> _importSources() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final sourceService = SourceService(context.read<AppDatabase>());
      final uuid = const Uuid();

      for (final file in result.files) {
        if (file.bytes == null) continue;

        final sourceId = uuid.v4();
        final blobId = uuid.v4();

        await sourceService.insertSource(
          SourceItemsCompanion(
            id: drift.Value(sourceId),
            folderId: drift.Value(widget.folderId),
            label: drift.Value(file.name),
            type: const drift.Value(MediaType.document),
            isPinned: const drift.Value(false),
          ),
        );

        await sourceService.insertSourceBlob(
          SourceItemBlobsCompanion(
            id: drift.Value(blobId),
            sourceItemId: drift.Value(sourceId),
            sourceItemName: drift.Value(file.name),
            type: const drift.Value(SourceFileType.pdf),
            bytes: drift.Value(file.bytes!),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully imported ${result.files.length} sources',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error importing sources: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    folderName = widget.initialFolderName;
    final service = context.read<StudyDatabaseService>();
    _decksStream = service.watchDecksByFolderId(widget.folderId);
    _deckSub = _decksStream.listen((decks) {
      if (mounted) setState(() => _allDecks = decks);
    });

    // Watch drafts for this folder
    final draftService = context.read<AppController>().draftService;
    _draftSub = draftService.watchDraftsByFolderId(widget.folderId).listen((
      drafts,
    ) {
      if (mounted) setState(() => _allDrafts = drafts);
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
      _deckSub?.cancel();
      _sourcesSub?.cancel();

      final service = context.read<StudyDatabaseService>();
      _decksStream = service.watchDecksByFolderId(widget.folderId);
      _deckSub = _decksStream.listen((decks) {
        if (mounted) setState(() => _allDecks = decks);
      });

      _draftSub?.cancel();
      final draftService = context.read<AppController>().draftService;
      _draftSub = draftService.watchDraftsByFolderId(widget.folderId).listen((
        drafts,
      ) {
        if (mounted) setState(() => _allDrafts = drafts);
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
    _deckSub?.cancel();
    _draftSub?.cancel();
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
        isVisible: _currentPageIndex != 2,
        collapsedBuilder: (context, isOpen, expand, close) {
          if (_isSelecting) {
            final selectedDecks = _allDecks
                .where((m) => _selectedDeckIds.contains(m.id))
                .toList();

            final allPinned =
                selectedDecks.isNotEmpty &&
                selectedDecks.every((m) => m.isPinned);
            final allUnpinned =
                selectedDecks.isNotEmpty &&
                selectedDecks.every((m) => !m.isPinned);
            final isMixed = !allPinned && !allUnpinned;

            return SelectionActionBar(
              selectedCount: _selectedDeckIds.length,
              onClose: _clearSelection,
              onPin: () => _handlePinSelected(pin: true),
              onUnpin: () => _handlePinSelected(pin: false),
              isUnpin: allPinned,
              isPinDisabled: isMixed,
              onDelete: _handleDeleteSelected,
            );
          }

          final isSources = _currentPageIndex == 1;
          final String title = isSources ? "Import Sources" : "Create Cards";
          final IconData mainIcon = isSources
              ? FontAwesomeIcons.layerGroup
              : FontAwesomeIcons.plus;

          return IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (isSources) {
                        _importSources();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CardCreationPage(folderId: widget.folderId),
                          ),
                        );
                      }
                    },
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
                      child: Row(
                        children: [
                          FaIcon(mainIcon, size: 14),
                          const SizedBox(width: 12),
                          Text(
                            title,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                // Expand Trigger
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: expand,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chevronUp,
                        size: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        expandedBuilder: (context, isOpen, expand, close) {
          final isSources = _currentPageIndex == 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Row(
                    children: [
                      Text(
                        isSources ? "IMPORT OPTIONS" : "CREATION TOOLS",
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                        onPressed: close,
                        color: Colors.white24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (isSources) ...[
                  _FabMenuItem(
                    label: "Import from Text",
                    icon: FontAwesomeIcons.fileLines,
                    onTap: () {
                      close();
                      // Logic for text import
                    },
                  ),
                  _FabMenuItem(
                    label: "Import from YouTube",
                    icon: FontAwesomeIcons.youtube,
                    onTap: () {
                      close();
                      // Logic for youtube import
                    },
                  ),
                ] else ...[
                  _FabMenuItem(
                    label: "Quick AI Card Gen",
                    icon: FontAwesomeIcons.wandMagicSparkles,
                    onTap: () {
                      close();
                      // Logic for AI Generation
                    },
                  ),
                ],
                const SizedBox(height: 6),
              ],
            ),
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
                  // PAGE 0: DECKS
                  _CardsPage(
                    decks: _allDecks,
                    drafts: _allDrafts,
                    folderId: widget.folderId,
                    selectedIds: _selectedDeckIds,
                    onToggleSelection: _toggleDeckSelection,
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
                  ProjectBackButton(onPressed: onBack),
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
  final List<DeckItem> decks;
  final List<CardCreationDraftItem> drafts;
  final String folderId;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _CardsPage({
    required this.decks,
    required this.drafts,
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
          if (drafts.isNotEmpty) ...[
            const _SectionLabel(title: "Resume Projects"),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: drafts.length,
                itemBuilder: (context, index) {
                  final draft = drafts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 240,
                      child: ProjectCardTile(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        title: Text(
                          "New Draft ${draft.createdAt.split('T')[0]}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Last updated ${draft.updatedAt.split('T')[0]}",
                          style: const TextStyle(fontSize: 11),
                        ),
                        leading: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                          size: 16,
                          color: Colors.white38,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardCreationPage(
                                folderId: folderId,
                                deckId: draft.deckId,
                                draftId: draft.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          const _SectionLabel(title: "Study Decks"),
          const SizedBox(height: 12),
          _DecksList(
            decks: decks,
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

  IconData _getSourceIcon(MediaType type) {
    switch (type) {
      case MediaType.document:
        return FontAwesomeIcons.filePdf;
      case MediaType.text:
        return FontAwesomeIcons.fileLines;
      case MediaType.video:
        return FontAwesomeIcons.youtube;
      case MediaType.audio:
        return FontAwesomeIcons.fileAudio;
      case MediaType.image:
        return FontAwesomeIcons.fileImage;
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
                                    "${sources[i].type.name.toUpperCase()} | ${sources[i].extractedContent?.length ?? 0} chars",
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
                  final service = context.read<StudyDatabaseService>();
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

class _DecksList extends StatelessWidget {
  final List<DeckItem> decks;
  final String folderId;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelection;
  final bool isSelecting;

  const _DecksList({
    required this.decks,
    required this.folderId,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.isSelecting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (decks.isEmpty) {
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
                "Create your first study deck\nto get started with this project.",
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
        for (var i = 0; i < decks.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                ProjectCardTile(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      leading: const WizardFlashcardPreview(),
                      title: Text(decks[i].name),
                      subtitle: Text(decks[i].description ?? "Card Pack"),
                      isSelected: selectedIds.contains(decks[i].id),
                      onTap: isSelecting
                          ? () => onToggleSelection(decks[i].id)
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudyPage(
                                    deckId: decks[i].id,
                                    deckName: decks[i].name,
                                  ),
                                ),
                              );
                            },
                      onLongTap: () => onToggleSelection(decks[i].id),
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
// HELPER COMPONENTS
// ---------------------------------------------------------------------------

class _FabMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                FaIcon(icon, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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

// ---------------------------------------------------------------------------
// SELECTION ACTION BAR
