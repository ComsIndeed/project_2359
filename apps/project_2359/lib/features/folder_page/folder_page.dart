import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show compute;
import 'package:llm_json_stream/llm_json_stream.dart';
import 'package:project_2359/app_database.dart';

import 'package:project_2359/core/ai_helpers.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:provider/provider.dart';
// removed FolderSourcesPage import as it is now integrated
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:project_2359/features/sources_page/source_list_item.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';

enum FabMode { generation, sources, settings }

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
            mode: _fabMode,
            initialSources: _currentSources,
          );
        },
        body: StreamBuilder<List<StudyMaterialItem>>(
          stream: _materialsStream,
          builder: (context, snapshot) {
            final materials = snapshot.data ?? [];

            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                // COLLAPSING HEADER → APPBAR
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CollapsingHeaderDelegate(
                    folderName: folderName,
                    topPadding: MediaQuery.of(context).padding.top,
                    onBack: () => Navigator.pop(context),
                    onSourcesTap: () {
                      setState(() => _fabMode = FabMode.sources);
                      ExpandableFab.of(context).expand();
                    },
                    onSettingsTap: () {
                      setState(() => _fabMode = FabMode.settings);
                      ExpandableFab.of(context).expand();
                    },
                  ),
                ),

                // SECTION LABEL
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12, // Increased spacing
                  ),
                  sliver: SliverToBoxAdapter(
                    child: const _SectionLabel(title: "Card Packs"),
                  ),
                ),

                // MATERIALS LIST
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  sliver: SliverToBoxAdapter(
                    child: _StudyMaterialsList(
                      materials: materials,
                      folderId: widget.folderId,
                      selectedIds: _selectedMaterialIds,
                      onToggleSelection: _toggleMaterialSelection,
                      isSelecting: _isSelecting,
                    ),
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

// ---------------------------------------------------------------------------
// COLLAPSING HEADER DELEGATE
// ---------------------------------------------------------------------------

class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String folderName;
  final double topPadding;
  final VoidCallback onBack;
  final VoidCallback onSourcesTap;
  final VoidCallback onSettingsTap;

  _CollapsingHeaderDelegate({
    required this.folderName,
    required this.topPadding,
    required this.onBack,
    required this.onSourcesTap,
    required this.onSettingsTap,
  });

  static const double _collapsedBarHeight = 64.0;

  @override
  double get maxExtent => 240 + topPadding; // Increased to avoid overflow

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
          // ── BACKGROUND DECORATION (SQUARES PATTERN) ──
          Positioned(
            right: -20,
            top: -20,
            bottom: -20,
            width: 300,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: SpecialBackgroundGenerator(
                type: SpecialBackgroundType.geometricSquares,
                seed: GenerationSeed.fromString(folderName),
                label: folderName,
                icon: FontAwesomeIcons.folder,
                showBorder: false,
                borderRadius: 0,
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // ── EXPANDED CONTENT ──
          Positioned(
            left: 20,
            right: 20,
            top: topPadding + _collapsedBarHeight,
            bottom: 0,
            child: Opacity(
              opacity: (1.0 - t * 2.5).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: t > 0.4,
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
                          icon: FontAwesomeIcons.layerGroup,
                          onTap: onSourcesTap,
                          label: "Sources",
                        ),
                        const SizedBox(width: 16),
                        _HeaderCircleAction(
                          icon: FontAwesomeIcons.gear,
                          onTap: onSettingsTap,
                          label: "Settings",
                        ),
                      ],
                    ),
                  ],
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
                          icon: FontAwesomeIcons.layerGroup,
                          onTap: onSourcesTap,
                        ),
                        _CompactIconButton(
                          icon: FontAwesomeIcons.gear,
                          onTap: onSettingsTap,
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

  const _HeaderCircleAction({
    required this.icon,
    required this.label,
    required this.onTap,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Center(child: FaIcon(icon, size: 16, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.4),
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

  const _CompactIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: FaIcon(icon, size: 16),
      color: Colors.white.withValues(alpha: 0.6),
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
        for (final material in materials)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProjectCardTile(
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.clone,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              title: Text(material.name),
              subtitle: Text(material.description ?? "Card Pack"),
              isSelected: selectedIds.contains(material.id),
              onTap: isSelecting
                  ? () => onToggleSelection(material.id)
                  : () {
                      // TODO: Navigate to study / view Card Pack
                    },
              onLongTap: () => onToggleSelection(material.id),
            ),
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
  final FabMode mode;
  final List<SourceItem>? initialSources;

  const _FolderFabContent({
    required this.folderId,
    required this.mode,
    this.initialSources,
  });

  @override
  State<_FolderFabContent> createState() => _FolderFabContentState();
}

class _FolderFabContentState extends State<_FolderFabContent> {
  int _currentStep = 1; // 1: Source, 2: Config, 3: Generation
  bool _showManualBranch = false;

  // Generation State
  bool _isExtracting = false;
  bool _isGenerating = false;
  final List<StreamedStudyCard> _streamedCards = [];
  String? _generationError;
  GenerateMaterialMetadata? _metadata;

  StreamSubscription? _generationSub;
  JsonStreamParser? _parser;
  StreamController<String>? _llmStreamController;

  // Tracking for animation direction
  int _prevStep = 1;
  bool _prevManual = false;
  late FabMode _currentMode;
  FabMode? _prevMode;

  late Stream<List<SourceItem>> _sourcesStream;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _sourcesStream = context.read<SourceService>().watchSourcesByFolderId(
      widget.folderId,
    );
  }

  @override
  void didUpdateWidget(_FolderFabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderId != widget.folderId) {
      _sourcesStream = context.read<SourceService>().watchSourcesByFolderId(
        widget.folderId,
      );
    }
    if (oldWidget.mode != widget.mode) {
      setState(() {
        _prevMode = _currentMode;
        _currentMode = widget.mode;
        // If switching TO generation, reset steps
        if (_currentMode == FabMode.generation) {
          _currentStep = 1;
          _showManualBranch = false;
        }
      });
    }
  }

  void _updateStep(int nextStep, {bool? manual}) {
    setState(() {
      _prevStep = _currentStep;
      _prevManual = _showManualBranch;
      _currentStep = nextStep;
      if (manual != null) _showManualBranch = manual;
    });
  }

  final Set<String> _selectedTypes = {'flashcards'};
  final Set<String> _selectedSources = {}; // Use IDs
  String _strategy = 'Spaced'; // 'Spaced' or 'Cram'

  final List<({String id, String label, IconData icon, Color color})> _types = [
    (
      id: 'flashcards',
      label: 'Flashcards',
      icon: FontAwesomeIcons.layerGroup,
      color: const Color(0xFF4ECDC4),
    ),
    (
      id: 'quizzes',
      label: 'Practice Quiz',
      icon: FontAwesomeIcons.listCheck,
      color: const Color(0xFFFF6B6B),
    ),
    (
      id: 'assessment',
      label: 'Assessment',
      icon: FontAwesomeIcons.fileCircleExclamation,
      color: const Color(0xFFF1C40F),
    ),
  ];

  Future<void> _startGeneration() async {
    final sourceService = context.read<SourceService>();

    // Clean up previous run
    _generationSub?.cancel();
    _parser?.dispose();
    _llmStreamController?.close();

    setState(() {
      _isExtracting = true;
      _isGenerating = true;
      _streamedCards.clear();
      _generationError = null;
      _metadata = null;
      _currentStep = 3; // Move to generation step
    });

    try {
      // 1. Extract text
      final extractedTexts = <Map<String, String>>[];
      for (final sourceId in _selectedSources) {
        final blob = await sourceService.getSourceBlobBySourceId(sourceId);
        final source = await sourceService.getSourceById(sourceId);
        if (blob == null || source == null) continue;

        final pages = await compute(
          _extractPdfTextInIsolate,
          Uint8List.fromList(blob.bytes),
        );
        final fullText = pages.join('\n');
        if (fullText.trim().isNotEmpty) {
          extractedTexts.add({'sourceName': source.label, 'content': fullText});
        }
      }

      if (extractedTexts.isEmpty) {
        setState(() {
          _isExtracting = false;
          _isGenerating = false;
          _generationError =
              'No text could be extracted from selected sources.';
        });
        return;
      }

      setState(() => _isExtracting = false);

      // 2. Preferences
      final preferences = {
        'generationTypes': _selectedTypes.join(','),
        'learningMode': _strategy,
      };

      // 3. Parser
      _llmStreamController = StreamController<String>();
      _parser = JsonStreamParser(
        _llmStreamController!.stream,
        closeOnRootComplete: true,
      );

      _parser!.getListProperty('studyMaterials').onElement((element, index) {
        if (!mounted) return;
        final card = StreamedStudyCard();
        setState(() => _streamedCards.add(card));

        final map = element.asMap;
        map
            .getStringProperty('type')
            .stream
            .listen(
              (chunk) => setState(() => card.type = (card.type ?? '') + chunk),
            );
        map
            .getStringProperty('frontContent')
            .stream
            .listen((chunk) => setState(() => card.frontContent += chunk));
        map
            .getStringProperty('backContent')
            .stream
            .listen((chunk) => setState(() => card.backContent += chunk));
        map
            .getStringProperty('question')
            .stream
            .listen((chunk) => setState(() => card.question += chunk));
        map
            .getStringProperty('criteria')
            .stream
            .listen((chunk) => setState(() => card.criteria += chunk));
        map.getListProperty('choices').onElement((choiceElement, choiceIndex) {
          setState(() {
            while (card.choices.length <= choiceIndex) {
              card.choices.add('');
            }
          });
          choiceElement.asStr.stream.listen(
            (chunk) => setState(() => card.choices[choiceIndex] += chunk),
          );
        });
        map
            .getNumberProperty('correctAnswerIndex')
            .future
            .then(
              (val) => setState(() => card.correctAnswerIndex = val.toInt()),
            );
      });

      // 4. Stream from AI
      final stream = AiHelpers.generateMaterial(
        extractedTexts: extractedTexts,
        preferences: preferences,
      );

      _generationSub = stream.listen(
        (event) {
          if (!mounted) return;
          switch (event) {
            case GenerateMaterialChunk(:final text):
              _llmStreamController?.add(text);
            case GenerateMaterialMeta(:final metadata):
              setState(() => _metadata = metadata);
          }
        },
        onError: (e) {
          _llmStreamController?.close();
          setState(() {
            _isGenerating = false;
            _generationError = e.toString();
          });
        },
        onDone: () {
          _llmStreamController?.close();
          setState(() => _isGenerating = false);
        },
      );
    } catch (e) {
      _llmStreamController?.close();
      setState(() {
        _isExtracting = false;
        _isGenerating = false;
        _generationError = e.toString();
      });
    }
  }

  Future<void> _saveMaterial() async {
    print(_streamedCards);
    if (_streamedCards.isEmpty) return;

    final materialService = context.read<StudyMaterialService>();
    final materialId = const Uuid().v4();

    // Create material entry
    final material = StudyMaterialItemsCompanion.insert(
      id: materialId,
      folderId: widget.folderId,
      name: "Generated Pack - ${DateTime.now().toString().substring(5, 16)}",
      description: const Value("AI Generated materials"),
    );

    // Create cards entries
    final cards = _streamedCards
        .map(
          (c) => StudyCardItemsCompanion.insert(
            id: const Uuid().v4(),
            materialId: materialId,
            type: c.type ?? 'flashcard',
            question: Value(
              c.frontContent.isNotEmpty ? c.frontContent : c.question,
            ),
            answer: Value(
              c.backContent.isNotEmpty
                  ? c.backContent
                  : (c.choices.isNotEmpty
                        ? c.choices[c.correctAnswerIndex ?? 0]
                        : c.criteria),
            ),
            optionsListJson: Value(
              c.choices.isNotEmpty ? jsonEncode(c.choices) : null,
            ),
          ),
        )
        .toList();

    await materialService.createMaterialWithCards(
      material: material,
      cards: cards,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Materials saved to folder!')),
      );
      // We can either close or go back to start
      ExpandableFab.of(context).close();
    }
  }

  @override
  void dispose() {
    _generationSub?.cancel();
    _parser?.dispose();
    _llmStreamController?.close();
    super.dispose();
  }

  void _importDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      withData: true,
      allowedExtensions: ["pdf", "docx", "pptx"],
    );

    if (result == null) return;

    if (context.mounted) {
      context.read<SourcesPageBloc>().add(
        ImportDocumentsEvent(result.files, folderId: widget.folderId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the active widget and its key for AnimatedSwitcher
    final Widget currentWidget;
    final ValueKey key;

    // Use mode-based switching first, then step-based within generation
    switch (_currentMode) {
      case FabMode.generation:
        if (_showManualBranch) {
          currentWidget = _buildManualBranch(context);
          key = const ValueKey('manual');
        } else {
          key = ValueKey(_currentStep);
          switch (_currentStep) {
            case 1:
              currentWidget = _buildStep1(context);
              break;
            case 2:
              currentWidget = _buildStep2(context);
              break;
            case 3:
              currentWidget = _buildStep3(context);
              break;
            default:
              currentWidget = _buildStep1(context);
          }
        }
        break;
      case FabMode.sources:
        currentWidget = _buildSourcesView(context);
        key = const ValueKey('sources');
        break;
      case FabMode.settings:
        currentWidget = _buildSettingsView(context);
        key = const ValueKey('settings');
        break;
    }

    // Progression logic
    final bool isForward;
    if (_prevMode != null && _prevMode != _currentMode) {
      final modeOrder = {
        FabMode.generation: 0,
        FabMode.sources: 1,
        FabMode.settings: 2,
      };
      isForward = modeOrder[_currentMode]! > modeOrder[_prevMode]!;
    } else {
      isForward =
          (_showManualBranch && !_prevManual) ||
          (!_showManualBranch && !_prevManual && _currentStep > _prevStep);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool isEntering = child.key == key;
        var beginOffset = isForward
            ? const Offset(0.0, 1.0)
            : const Offset(0.0, -1.0);
        if (!isEntering) {
          beginOffset = isForward
              ? const Offset(0.0, -1.0)
              : const Offset(0.0, 1.0);
        }

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [...previousChildren, ?currentChild],
        );
      },
      child: KeyedSubtree(key: key, child: currentWidget),
    );
  }

  Widget _buildStep1(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return StreamBuilder<List<SourceItem>>(
      stream: _sourcesStream,
      initialData: widget.initialSources,
      builder: (context, snapshot) {
        final sources = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _updateStep(_currentStep, manual: true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.lightbulb,
                        size: 14,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can manually create your own materials too',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 10,
                        color: cs.primary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _SectionLabel(title: "Select Sources"),
              const SizedBox(height: 8),

              if (sources.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "No sources in this folder yet.\nImport some below!",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              else
                ProjectListGroup(
                  backgroundColor: cs.onSurface.withValues(alpha: 0.04),
                  children: [
                    for (var i = 0; i < sources.length; i++)
                      ProjectListTile(
                        title: Text(
                          sources[i].label,
                          style: TextStyle(
                            color: _selectedSources.contains(sources[i].id)
                                ? cs.onSurface
                                : cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        leading: FaIcon(
                          FontAwesomeIcons.filePdf,
                          size: 18,
                          color: _selectedSources.contains(sources[i].id)
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.25),
                        ),
                        showDivider: i < sources.length - 1,
                        backgroundColor:
                            _selectedSources.contains(sources[i].id)
                            ? cs.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        onTap: () {
                          setState(() {
                            if (_selectedSources.contains(sources[i].id)) {
                              _selectedSources.remove(sources[i].id);
                            } else {
                              _selectedSources.add(sources[i].id);
                            }
                          });
                        },
                        trailing: FaIcon(
                          _selectedSources.contains(sources[i].id)
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.circle,
                          size: 16,
                          color: _selectedSources.contains(sources[i].id)
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                  ],
                ),

              const SizedBox(height: 24),
              _buildImportGrid(context),

              const SizedBox(height: 16),
              _WizardButton(
                label: "Continue to Configuration",
                onPressed: _selectedSources.isEmpty
                    ? null
                    : () => _updateStep(2),
                icon: FontAwesomeIcons.chevronDown,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep2(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _updateStep(1),
                icon: FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 16,
                  color: cs.secondary,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const _SectionLabel(title: "Configure Materials"),
            ],
          ),
          const SizedBox(height: 8),

          Column(
            children: [
              for (var type in _types) ...[
                _ConfigurableTypeTile(
                  type: type,
                  isSelected: _selectedTypes.contains(type.id),
                  onToggle: () {
                    setState(() {
                      if (_selectedTypes.contains(type.id)) {
                        _selectedTypes.remove(type.id);
                      } else {
                        _selectedTypes.add(type.id);
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),

          const SizedBox(height: 12),
          const _SectionLabel(title: "Studying Strategy"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                _StrategyButton(
                  label: "Spaced",
                  isSelected: _strategy == 'Spaced',
                  onTap: () => setState(() => _strategy = 'Spaced'),
                ),
                _StrategyButton(
                  label: "Cram",
                  isSelected: _strategy == 'Cram',
                  onTap: () => setState(() => _strategy = 'Cram'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _WizardButton(
            label: "Begin Generation",
            onPressed: _selectedTypes.isEmpty ? null : _startGeneration,
            icon: FontAwesomeIcons.chevronDown,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (_generationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.circleExclamation,
                color: cs.error,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text("Generation Failed", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                _generationError!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              _WizardButton(
                label: "Try Again",
                onPressed: () => _updateStep(2),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (_isGenerating || _isExtracting)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const FaIcon(
                  FontAwesomeIcons.circleCheck,
                  color: Colors.green,
                  size: 20,
                ),
              const SizedBox(width: 12),
              Text(
                _isGenerating ? "AI is generating..." : "Generation Complete",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ProjectListGroup(
            backgroundColor: cs.onSurface.withValues(alpha: 0.02),
            children: [
              _GenerationProgressTile(
                label: "Parsing PDF Content",
                status: _isExtracting ? "In Progress" : "Complete",
                progress: _isExtracting ? 0.5 : 1.0,
                isDone: !_isExtracting,
              ),
              _GenerationProgressTile(
                label: "Material Generation",
                status: _isGenerating ? "Synthesizing" : "Complete",
                progress: _isGenerating ? 0.8 : 1.0,
                isDone: !_isGenerating,
              ),
            ],
          ),

          if (_streamedCards.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              "Preview (${_streamedCards.length} items)",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _streamedCards.length,
                itemBuilder: (context, index) {
                  final card = _streamedCards[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      card.frontContent.isNotEmpty
                          ? card.frontContent
                          : (card.question.isNotEmpty
                                ? card.question
                                : "Generating..."),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ],

          if (!_isGenerating && _metadata != null) ...[
            const SizedBox(height: 16),
            Text(
              "Generation completed with ${_metadata?.totalTokens ?? 0} tokens",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 32),
          if (!_isGenerating && !_isExtracting && _streamedCards.isNotEmpty)
            _WizardButton(
              label: "Save to Folder",
              onPressed: _saveMaterial,
              icon: FontAwesomeIcons.floppyDisk,
            )
          else
            _WizardButton(
              label: "Cancel",
              onPressed: () {
                _generationSub?.cancel();
                _updateStep(2);
              },
              isSecondary: true,
            ),
        ],
      ),
    );
  }

  Widget _buildManualBranch(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _updateStep(_currentStep, manual: false),
                icon: const FaIcon(
                  FontAwesomeIcons.chevronUp,
                  size: 16,
                  color: Colors.grey,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const _SectionLabel(title: "Manual Creation"),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "Enter material title...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: cs.onSurface.withValues(alpha: 0.04),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Type",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: cs.onSurface.withValues(alpha: 0.04),
            ),
            items: const [
              DropdownMenuItem(value: "flash", child: Text("Flashcards")),
              DropdownMenuItem(value: "quiz", child: Text("Quiz")),
            ],
            onChanged: (v) {},
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Content",
              hintText: "Paste or type your content here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: cs.onSurface.withValues(alpha: 0.04),
            ),
          ),
          const SizedBox(height: 20),
          _WizardButton(
            label: "Create Material",
            onPressed: () {},
            icon: FontAwesomeIcons.plus,
          ),
        ],
      ),
    );
  }

  Widget _buildImportGrid(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(title: "Import New Sources"),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.3,
          children: [
            CardButton(
              icon: FontAwesomeIcons.fileLines,
              label: "Documents",
              subLabel: "PDF only for now",
              layoutDirection: CardLayoutDirection.horizontal,
              isCompact: true,
              accentColor: cs.primary,
              onTap: () => _importDocument(context),
            ),
            CardButton(
              icon: FontAwesomeIcons.image,
              label: "Images",
              subLabel: "TODO: Support",
              layoutDirection: CardLayoutDirection.horizontal,
              isCompact: true,
              accentColor: const Color(0xFF00D2D3),
              onTap: null,
            ),
            CardButton(
              icon: FontAwesomeIcons.video,
              label: "Videos",
              subLabel: "TODO: Support",
              layoutDirection: CardLayoutDirection.horizontal,
              isCompact: true,
              accentColor: const Color(0xFFFF9F43),
              onTap: null,
            ),
            CardButton(
              icon: FontAwesomeIcons.music,
              label: "Audios",
              subLabel: "TODO: Support",
              layoutDirection: CardLayoutDirection.horizontal,
              isCompact: true,
              accentColor: const Color(0xFF54A0FF),
              onTap: null,
            ),
            CardButton(
              icon: FontAwesomeIcons.paragraph,
              label: "Text",
              subLabel: "TODO: Support",
              layoutDirection: CardLayoutDirection.horizontal,
              isCompact: true,
              accentColor: const Color(0xFF5F27CD),
              onTap: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSourcesView(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return StreamBuilder<List<SourceItem>>(
      stream: _sourcesStream,
      initialData: widget.initialSources,
      builder: (context, snapshot) {
        final sources = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.layerGroup, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    "Folder Sources",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sources.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      "No sources in this folder yet.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              else
                ProjectListGroup(
                  backgroundColor: cs.onSurface.withValues(alpha: 0.04),
                  children: [
                    for (var source in sources)
                      SourceListItem(
                        title: source.label,
                        subtitle: source.path ?? "Source Document",
                        icon: FontAwesomeIcons.fileLines,
                        initialStatus: SourceIndexingStatus.indexed,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _SourcePageLoader(
                                sourceId: source.id,
                                sourceLabel: source.label,
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<SourcesPageBloc>().add(
                            DeleteSourceEvent(source.id),
                          );
                        },
                      ),
                  ],
                ),
              const SizedBox(height: 24),
              _buildImportGrid(context),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsView(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.gear, size: 18),
              const SizedBox(width: 12),
              Text(
                "Folder Settings",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProjectListGroup(
            backgroundColor: cs.onSurface.withValues(alpha: 0.04),
            children: [
              ProjectListTile.simple(
                label: "Rename Folder",
                icon: FontAwesomeIcons.pen,
                showDivider: true,
                onTap: () {
                  // TODO: Implement rename
                },
              ),
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
                                foregroundColor: theme.colorScheme.error,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirmed) {
                    await service.deleteFolder(widget.folderId);
                    if (context.mounted) {
                      Navigator.pop(context); // Close FolderPage
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _WizardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;

  const _WizardButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isSecondary
        ? cs.onSurface.withValues(alpha: 0.05)
        : (isDark
              ? Color.lerp(cs.primary, Colors.black, 0.4)!
              : Color.lerp(cs.primary, Colors.white, 0.15)!);

    return Container(
      decoration: BoxDecoration(
        color: isSecondary ? baseColor : null,
        gradient: isSecondary
            ? null
            : LinearGradient(
                colors: [baseColor, baseColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: !isSecondary && onPressed != null
            ? [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: isSecondary ? cs.onSurface : cs.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSecondary ? cs.onSurface : cs.onPrimary,
                letterSpacing: 0.5,
                fontSize: 15,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              FaIcon(
                icon,
                size: 14,
                color: (isSecondary ? cs.onSurface : cs.onPrimary).withValues(
                  alpha: 0.7,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConfigurableTypeTile extends StatefulWidget {
  final ({String id, String label, IconData icon, Color color}) type;
  final bool isSelected;
  final VoidCallback onToggle;

  const _ConfigurableTypeTile({
    required this.type,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<_ConfigurableTypeTile> createState() => _ConfigurableTypeTileState();
}

class _ConfigurableTypeTileState extends State<_ConfigurableTypeTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Material(
          color: widget.isSelected
              ? Colors.green.withValues(alpha: 0.08)
              : cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.type.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: FaIcon(
                        widget.type.icon,
                        size: 18,
                        color: widget.type.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.type.label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.isSelected
                                ? cs.onSurface
                                : cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        if (widget.isSelected)
                          Text(
                            "Configure options below",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: widget.isSelected
              ? Container(
                  margin: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.02),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConfigItem(context, "Difficulty", "Medium"),
                      const SizedBox(height: 12),
                      _buildConfigItem(context, "Item Count", "20 Items"),
                      const SizedBox(height: 12),
                      _buildConfigItem(context, "Focus Area", "Summarization"),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildConfigItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        Row(
          children: [
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 10,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenerationProgressTile extends StatelessWidget {
  final String label;
  final String status;
  final double progress;
  final bool isDone;

  const _GenerationProgressTile({
    required this.label,
    required this.status,
    required this.progress,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDone
                      ? cs.onSurface
                      : cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                status,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDone ? Colors.green : cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: cs.onSurface.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? Colors.green : cs.primary,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StrategyButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.scaffoldBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? cs.onSurface
                    : cs.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<String>> _extractPdfTextInIsolate(Uint8List bytes) async {
  final document = PdfDocument(inputBytes: bytes);
  final List<String> pages = [];
  final PdfTextExtractor extractor = PdfTextExtractor(document);
  for (int i = 0; i < document.pages.count; i++) {
    pages.add(extractor.extractText(startPageIndex: i, endPageIndex: i));
  }
  document.dispose();
  return pages;
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

// ---------------------------------------------------------------------------
// SOURCE PAGE LOADER
// ---------------------------------------------------------------------------

class _SourcePageLoader extends StatefulWidget {
  final String sourceId;
  final String sourceLabel;

  const _SourcePageLoader({required this.sourceId, required this.sourceLabel});

  @override
  State<_SourcePageLoader> createState() => _SourcePageLoaderState();
}

class _SourcePageLoaderState extends State<_SourcePageLoader> {
  SourceItemBlob? _blob;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBlob();
  }

  Future<void> _loadBlob() async {
    final sourceService = SourceService(context.read<AppDatabase>());
    final blob = await sourceService.getSourceBlobBySourceId(widget.sourceId);
    if (mounted) {
      setState(() {
        _blob = blob;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_blob == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("File data not found")),
      );
    }

    return SourcePage(fileBytes: _blob!.bytes, title: widget.sourceLabel);
  }
}
