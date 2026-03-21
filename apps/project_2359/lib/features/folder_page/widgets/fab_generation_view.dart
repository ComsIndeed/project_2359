import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:llm_json_stream/llm_json_stream.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/ai_helpers.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;
import 'package:provider/provider.dart';

class FabGenerationView extends StatefulWidget {
  final String folderId;
  final List<SourceItem>? initialSources;

  const FabGenerationView({
    super.key,
    required this.folderId,
    this.initialSources,
  });

  @override
  State<FabGenerationView> createState() => _FabGenerationViewState();
}

class _FabGenerationViewState extends State<FabGenerationView> {
  int _currentStep = 1; // 1: Source, 2: Config, 3: Generation
  bool _showManualBranch = false;
  bool _showImportGrid = false;

  // Generation State
  bool _isExtracting = false;
  bool _isGenerating = false;
  final List<StreamedStudyCard> _streamedCards = [];
  String? _generationError;

  StreamSubscription? _generationSub;
  JsonStreamParser? _parser;
  StreamController<String>? _llmStreamController;
  int _presentingIndex = 0;
  bool _isFinishingCard = false;

  // Tracking for animation direction
  int _prevStep = 1;
  bool _prevManual = false;

  late Stream<List<SourceItem>> _sourcesStream;

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

  @override
  void initState() {
    super.initState();
    _sourcesStream = context.read<SourceService>().watchSourcesByFolderId(
      widget.folderId,
    );
  }

  @override
  void dispose() {
    _generationSub?.cancel();
    _parser?.dispose();
    _llmStreamController?.close();
    super.dispose();
  }

  void _updateStep(int nextStep, {bool? manual}) {
    setState(() {
      _prevStep = _currentStep;
      _prevManual = _showManualBranch;
      _currentStep = nextStep;
      if (manual != null) _showManualBranch = manual;
    });
  }

  Future<void> _startGeneration() async {
    final sourceService = context.read<SourceService>();

    _generationSub?.cancel();
    _parser?.dispose();
    _llmStreamController?.close();

    setState(() {
      _isExtracting = true;
      _isGenerating = true;
      _streamedCards.clear();
      _presentingIndex = 0;
      _isFinishingCard = false;
      _generationError = null;
      _currentStep = 3;
    });

    try {
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

      final preferences = {
        'generationTypes': _selectedTypes.join(','),
        'learningMode': _strategy,
      };

      _llmStreamController = StreamController<String>();
      _parser = JsonStreamParser(
        _llmStreamController!.stream,
        closeOnRootComplete: true,
      );

      _parser!.getListProperty('studyMaterials').onElement((element, index) {
        if (!mounted) return;
        final card = StreamedStudyCard()..startTime = DateTime.now();
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

        map.future.then((_) async {
          card.endTime = DateTime.now();
          if (!mounted) return;
          final durationMs = card.endTime!
              .difference(card.startTime!)
              .inMilliseconds;
          final totalChars = card.totalCharacters;
          final cps = durationMs > 0 ? (totalChars / (durationMs / 1000)) : 0;
          final int adjustedDelay = (1500 - (cps * 15))
              .clamp(400, 1500)
              .toInt();

          await Future.delayed(Duration(milliseconds: adjustedDelay));
          if (!mounted) return;
          setState(() => _isFinishingCard = true);
          await Future.delayed(const Duration(milliseconds: 600));
          if (!mounted) return;
          setState(() {
            _isFinishingCard = false;
            _presentingIndex++;
          });
        });
      });

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
            case GenerateMaterialMeta():
              break;
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
    if (_streamedCards.isEmpty) return;
    final materialService = context.read<StudyMaterialService>();
    final materialId = const Uuid().v4();

    final material = StudyMaterialItemsCompanion.insert(
      id: materialId,
      folderId: widget.folderId,
      name: "Generated Pack - ${DateTime.now().toString().substring(5, 16)}",
      description: const Value("AI Generated materials"),
    );

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
      ExpandableFab.of(context).close();
    }
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
    final Widget currentWidget;
    final ValueKey key;

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

    final bool isForward =
        (_showManualBranch && !_prevManual) ||
        (!_showManualBranch && !_prevManual && _currentStep > _prevStep);

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sources.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      "No sources folder yet.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (var source in sources)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProjectCardTile(
                          minHeight: 100,
                          title: Text(source.label),
                          subtitle: Row(
                            children: [
                              FaIcon(
                                _getSourceIcon(source.type),
                                size: 10,
                                color: cs.onSurface.withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${source.type.toUpperCase()} | ${source.extractedContent?.length ?? 0} chars",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                          leading: const WizardSourcePagePreview(),
                          isSelected: _selectedSources.contains(source.id),
                          onTap: () => setState(
                            () => _selectedSources.contains(source.id)
                                ? _selectedSources.remove(source.id)
                                : _selectedSources.add(source.id),
                          ),
                          trailing: _selectedSources.contains(source.id)
                              ? const FaIcon(
                                  FontAwesomeIcons.circleCheck,
                                  size: 20,
                                  color: Colors.blue,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 8),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: _showImportGrid
                    ? Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildImportGrid(context),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: WizardButton(
                      label: "Continue",
                      onPressed: _selectedSources.isEmpty
                          ? null
                          : () => _updateStep(2),
                      icon: FontAwesomeIcons.chevronDown,
                    ),
                  ),
                  const SizedBox(width: 8),
                  WizardSquareButton(
                    icon: FontAwesomeIcons.penToSquare,
                    onPressed: () => _updateStep(_currentStep, manual: true),
                  ),
                  const SizedBox(width: 8),
                  ImportToggleButton(
                    isActive: _showImportGrid,
                    onTap: () =>
                        setState(() => _showImportGrid = !_showImportGrid),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep2(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
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
              const SectionLabel(title: "Configure Materials"),
            ],
          ),
          const SizedBox(height: 8),
          for (var type in _types) ...[
            ConfigurableTypeTile(
              type: type,
              isSelected: _selectedTypes.contains(type.id),
              onToggle: () => setState(
                () => _selectedTypes.contains(type.id)
                    ? _selectedTypes.remove(type.id)
                    : _selectedTypes.add(type.id),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          const SectionLabel(title: "Studying Strategy"),
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
                StrategyButton(
                  label: "Spaced",
                  isSelected: _strategy == 'Spaced',
                  onTap: () => setState(() => _strategy = 'Spaced'),
                ),
                StrategyButton(
                  label: "Cram",
                  isSelected: _strategy == 'Cram',
                  onTap: () => setState(() => _strategy = 'Cram'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          WizardButton(
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
          padding: const EdgeInsets.all(24),
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
              WizardButton(label: "Try Again", onPressed: () => _updateStep(2)),
            ],
          ),
        ),
      );
    }
    final currentCard = _presentingIndex < _streamedCards.length
        ? _streamedCards[_presentingIndex]
        : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GenerationPackOverview(
            selectedTypes: _selectedTypes.toList(),
            streamedCards: _streamedCards,
            isGenerating: _isGenerating,
            isExtracting: _isExtracting,
            isPresenting: _presentingIndex < _streamedCards.length,
            selectedSources: _selectedSources.toList(),
          ),
        ),
        const SizedBox(height: 24),
        if (_presentingIndex < _streamedCards.length)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 450),
              child: Center(
                child: SizedBox(
                  width: 340,
                  child: GenerationMockupCard(
                    key: ValueKey('mockup_$_presentingIndex'),
                    card: currentCard,
                    isFinishing: _isFinishingCard,
                    index: _presentingIndex,
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: WizardButton(
                  label: "Save Pack",
                  onPressed:
                      (_isGenerating ||
                          _isExtracting ||
                          _isFinishingCard ||
                          _presentingIndex < _streamedCards.length)
                      ? null
                      : _saveMaterial,
                  icon: FontAwesomeIcons.floppyDisk,
                ),
              ),
              if (_presentingIndex >= _streamedCards.length &&
                  !_isGenerating) ...[
                const SizedBox(width: 8),
                WizardSquareButton(
                  icon: FontAwesomeIcons.rotateRight,
                  onPressed: _startGeneration,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportGrid(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        CardButton(
          icon: FontAwesomeIcons.fileLines,
          label: "Files",
          subLabel: "PDF, DOCX, PPTX",
          layoutDirection: CardLayoutDirection.horizontal,
          isCompact: true,
          accentColor: cs.primary,
          onTap: () => _importDocument(context),
        ),
        CardButton(
          icon: FontAwesomeIcons.paragraph,
          label: "Text",
          subLabel: "Paste content",
          layoutDirection: CardLayoutDirection.horizontal,
          isCompact: true,
          accentColor: const Color(0xFF5F27CD),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildManualBranch(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
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
              const SectionLabel(title: "Manual Creation"),
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
          const SizedBox(height: 16),
          WizardButton(
            label: "Create (TODO)",
            onPressed: () {},
            icon: FontAwesomeIcons.plus,
          ),
        ],
      ),
    );
  }
}

class ConfigurableTypeTile extends StatelessWidget {
  final ({String id, String label, IconData icon, Color color}) type;
  final bool isSelected;
  final VoidCallback onToggle;
  const ConfigurableTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withValues(alpha: 0.1)
              : cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? type.color.withValues(alpha: 0.3)
                : cs.onSurface.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              type.icon,
              color: isSelected
                  ? type.color
                  : cs.onSurface.withValues(alpha: 0.2),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                type.label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? type.color : cs.onSurface,
                ),
              ),
            ),
            if (isSelected)
              FaIcon(FontAwesomeIcons.circleCheck, color: type.color, size: 16),
          ],
        ),
      ),
    );
  }
}

class StrategyButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const StrategyButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenerationPackOverview extends StatelessWidget {
  final List<String> selectedTypes;
  final List<StreamedStudyCard> streamedCards;
  final bool isGenerating;
  final bool isExtracting;
  final bool isPresenting;
  final List<String> selectedSources;

  const GenerationPackOverview({
    super.key,
    required this.selectedTypes,
    required this.streamedCards,
    required this.isGenerating,
    required this.isExtracting,
    required this.isPresenting,
    required this.selectedSources,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDone = !isGenerating && !isExtracting && !isPresenting;
    return ProjectListTile(
      title: Text(
        selectedTypes.length > 1
            ? "${selectedTypes.length} Types"
            : selectedTypes.first.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        isDone ? "Generated ${streamedCards.length} items" : "Generating...",
        style: TextStyle(
          color: isDone ? Colors.green : cs.onSurface.withValues(alpha: 0.5),
        ),
      ),
      leading: FaIcon(FontAwesomeIcons.layerGroup, size: 18, color: cs.primary),
      backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      isSingle: true,
      trailing: isDone
          ? const FaIcon(
              FontAwesomeIcons.circleCheck,
              color: Colors.green,
              size: 16,
            )
          : null,
    );
  }
}

class GenerationMockupCard extends StatefulWidget {
  final StreamedStudyCard? card;
  final bool isFinishing;
  final int index;
  const GenerationMockupCard({
    super.key,
    required this.card,
    required this.isFinishing,
    required this.index,
  });
  @override
  State<GenerationMockupCard> createState() => _GenerationMockupCardState();
}

class _GenerationMockupCardState extends State<GenerationMockupCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnim;
  bool _isFlipped = false;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant GenerationMockupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card?.type == 'flashcard' &&
        widget.card!.backContent.isNotEmpty &&
        !_isFlipped) {
      setState(() => _isFlipped = true);
      _flipController.forward();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.card == null)
      return const Center(child: CircularProgressIndicator());
    final cs = Theme.of(context).colorScheme;
    return AnimatedAlign(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInQuint,
      alignment: widget.isFinishing
          ? const Alignment(0, -1.5)
          : Alignment.center,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInBack,
        scale: widget.isFinishing ? 0.3 : 1.0,
        child: AnimatedBuilder(
          animation: _flipAnim,
          builder: (context, child) {
            final angle = _flipAnim.value * 3.14159;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: angle < 1.5708
                  ? _buildFront(cs)
                  : Transform(
                      transform: Matrix4.identity()..rotateY(3.14159),
                      alignment: Alignment.center,
                      child: _buildBack(cs),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(ColorScheme cs) {
    return MockupCardContainer(
      accentColor: _getAccentColor(cs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.card?.type == 'flashcard' ? "FRONT" : "QUESTION",
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: _getAccentColor(cs).withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.card?.type == 'flashcard'
                    ? widget.card!.frontContent
                    : widget.card!.question,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(ColorScheme cs) {
    return MockupCardContainer(
      accentColor: _getAccentColor(cs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BACK",
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: _getAccentColor(cs).withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.card!.backContent,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccentColor(ColorScheme cs) {
    switch (widget.card?.type) {
      case 'flashcard':
        return const Color(0xFF4ECDC4);
      case 'multiple-choice-question':
        return const Color(0xFFFF6B6B);
      default:
        return cs.primary;
    }
  }
}

class MockupCardContainer extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  const MockupCardContainer({
    super.key,
    required this.child,
    required this.accentColor,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
      ),
      child: child,
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
