import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show compute;
import 'package:llm_json_stream/llm_json_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/ai_helpers.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/home_page/home_page.dart';
import 'package:project_2359/features/materials_page/create_flashcards_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Parses PDF bytes in an isolate. Returns list of text strings per page.
List<String> _extractPdfText(Uint8List bytes) {
  final doc = PdfDocument(inputBytes: bytes);
  final extractor = PdfTextExtractor(doc);
  final pages = <String>[];
  for (int i = 0; i < doc.pages.count; i++) {
    pages.add(extractor.extractText(startPageIndex: i, endPageIndex: i));
  }
  doc.dispose();
  return pages;
}

class GenerateMaterialsWizardPage extends StatefulWidget {
  const GenerateMaterialsWizardPage({super.key});

  @override
  State<GenerateMaterialsWizardPage> createState() =>
      _GenerateMaterialsWizardPageState();
}

class _GenerateMaterialsWizardPageState
    extends State<GenerateMaterialsWizardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedTypeFilter = 'All';

  // Shared State
  final Set<String> _selectedSources = {};
  final Set<String> _selectedGenerationTypes = {};
  String _sourceSearchQuery = '';
  final String _genSearchQuery = '';
  String _learningMode = 'Spaced'; // 'Cram' or 'Spaced'
  bool _showAddSources = false;
  bool _isExpanded = false;

  // Auth state
  bool _authNoticeDismissed = false;

  // Generation state
  final List<StreamedStudyCard> _streamedCards = [];
  bool _isGenerating = false;
  bool _isExtracting = false;
  String? _generationError;
  GenerateMaterialMetadata? _metadata;
  StreamSubscription<GenerateMaterialEvent>? _generationSub;
  JsonStreamParser? _parser;
  StreamController<String>? _llmStreamController;

  bool get _isLoggedIn => Supabase.instance.client.auth.currentUser != null;

  final Map<String, String> _generationOptions = {
    'flashcards': 'Standard',
    'quizzes': 'Standard',
    'assessment': 'Standard',
  };

  final Map<String, String> _focusOptions = {
    'flashcards': 'General',
    'quizzes': 'General',
    'assessment': 'General',
  };

  final List<Map<String, dynamic>> _generationTypes = [
    {
      'id': 'flashcards',
      'label': 'Flashcards',
      'subLabel': 'Smart cards for efficient learning.',
      'icon': FontAwesomeIcons.layerGroup,
    },
    {
      'id': 'quizzes',
      'label': 'Practice Quiz',
      'subLabel': 'Test your knowledge with 10 questions.',
      'icon': FontAwesomeIcons.clipboardQuestion,
    },
    {
      'id': 'assessment',
      'label': 'Assessment',
      'subLabel': 'A comprehensive test of the material.',
      'icon': FontAwesomeIcons.fileCircleExclamation,
    },
  ];

  void _nextPage({Duration duration = const Duration(milliseconds: 400)}) {
    _pageController.nextPage(duration: duration, curve: Curves.fastOutSlowIn);
  }

  void _previousPage({Duration duration = const Duration(milliseconds: 400)}) {
    _pageController.previousPage(
      duration: duration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _generationSub?.cancel();
    _parser?.dispose();
    _llmStreamController?.close();
    _pageController.dispose();
    super.dispose();
  }

  void _exitWizard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  Future<void> _startGeneration() async {
    final sourceService = context.read<SourcesPageBloc>().sourceService;

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
    });

    try {
      // 1. Extract text from selected sources on-the-fly
      final extractedTexts = <Map<String, String>>[];

      for (final sourceId in _selectedSources) {
        final blob = await sourceService.getSourceBlobBySourceId(sourceId);
        final source = await sourceService.getSourceById(sourceId);
        if (blob == null || source == null) continue;

        // Parse PDF in isolate to avoid jank
        final pages = await compute(
          _extractPdfText,
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
              'No text could be extracted from the selected sources.';
        });
        return;
      }

      setState(() => _isExtracting = false);

      // 2. Build preferences from wizard state
      final preferences = <String, String>{
        'generationTypes': _selectedGenerationTypes.join(','),
        'learningMode': _learningMode,
      };

      for (final type in _selectedGenerationTypes) {
        preferences['${type}_complexity'] =
            _generationOptions[type] ?? 'Standard';
        preferences['${type}_focus'] = _focusOptions[type] ?? 'General';
      }

      // 3. Set up llm_json_stream parser
      _llmStreamController = StreamController<String>();
      _parser = JsonStreamParser(
        _llmStreamController!.stream,
        closeOnRootComplete: true,
      );

      // 4. Subscribe to study materials array reactively
      _parser!.getListProperty('studyMaterials').onElement((element, index) {
        if (!mounted) return;

        // Create a placeholder card immediately
        final card = StreamedStudyCard();
        setState(() => _streamedCards.add(card));

        final map = element.asMap;

        // Subscribe to type
        map.getStringProperty('type').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.type = (card.type ?? '') + chunk);
        });

        // Subscribe to sourceId
        map.getStringProperty('sourceId').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.sourceId = (card.sourceId ?? '') + chunk);
        });

        // Flashcard fields
        map.getStringProperty('frontContent').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.frontContent += chunk);
        });

        map.getStringProperty('backContent').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.backContent += chunk);
        });

        // Free-text fields
        map.getStringProperty('question').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.question += chunk);
        });

        map.getStringProperty('criteria').stream.listen((chunk) {
          if (!mounted) return;
          setState(() => card.criteria += chunk);
        });

        // MCQ fields
        map.getListProperty('choices').onElement((choiceElement, choiceIndex) {
          if (!mounted) return;
          // Add empty slot
          setState(() {
            while (card.choices.length <= choiceIndex) {
              card.choices.add('');
            }
          });
          choiceElement.asStr.stream.listen((chunk) {
            if (!mounted) return;
            setState(() => card.choices[choiceIndex] += chunk);
          });
        });

        map.getNumberProperty('correctAnswerIndex').future.then((value) {
          if (!mounted) return;
          setState(() => card.correctAnswerIndex = value.toInt());
        });
      });

      // 5. Stream from the API and feed chunks to the parser
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
        onError: (error) {
          if (!mounted) return;
          _llmStreamController?.close();
          setState(() {
            _isGenerating = false;
            _generationError = error.toString();
          });
        },
        onDone: () {
          if (!mounted) return;
          _llmStreamController?.close();
          setState(() => _isGenerating = false);
        },
      );
    } catch (e) {
      if (!mounted) return;
      _llmStreamController?.close();
      setState(() {
        _isExtracting = false;
        _isGenerating = false;
        _generationError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // --- Modern Compact Header ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _currentPage == 0
                              ? TextButton.icon(
                                  onPressed: _exitWizard,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: 14,
                                  ),
                                  label: const Text("Close"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: cs.onSurface,
                                    backgroundColor: cs.surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              : TextButton.icon(
                                  onPressed: _previousPage,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowUp,
                                    size: 14,
                                  ),
                                  label: const Text("Back"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: cs.onSurface,
                                    backgroundColor: cs.surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                          Text(
                            _currentPage == 0
                                ? "Select Sources"
                                : "Select Format",
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 80), // Balance the row
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Two Pills Progress Bar
                      Row(
                        children: [
                          Expanded(
                            flex: _currentPage == 0 ? 3 : 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentPage >= 0
                                    ? cs.primary
                                    : cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: _currentPage == 1 ? 3 : 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentPage >= 1
                                    ? cs.primary
                                    : cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // --- Auth Notice ---
                if (!_isLoggedIn && !_authNoticeDismissed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildAuthNotice(cs),
                  ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildSourceSelectionStep(),
                      _buildGenerationOptionsStep(),
                      const SizedBox.shrink(), // Empty page for expansion
                    ],
                  ),
                ),
              ],
            ),
            _buildAnimatedBottomBar(),
          ],
        ),
      ),
    );
  }

  // --- STEP 1: SOURCE SELECTION ---

  Widget _buildSourceSelectionStep() {
    return BlocBuilder<SourcesPageBloc, SourcesPageState>(
      builder: (context, state) {
        if (state is SourcesPageStateInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SourcesPageStateLoaded) {
          final filteredSources = state.sources
              .where(
                (s) =>
                    s.label.toLowerCase().contains(
                      _sourceSearchQuery.toLowerCase(),
                    ) &&
                    (_selectedTypeFilter == 'All' ||
                        s.type.toLowerCase() ==
                            _selectedTypeFilter.toLowerCase()),
              )
              .toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(
                  hint: 'Filter your sources...',
                  onChanged: (val) => setState(() => _sourceSearchQuery = val),
                ),
                const SizedBox(height: 12),
                _buildFilterOptions(),
                const SizedBox(height: 16),
                _buildAddMoreSourcesSection(),
                const SizedBox(height: 12),
                if (filteredSources.isEmpty)
                  _buildEmptyState()
                else
                  _buildSourceList(filteredSources),
                const SizedBox(height: 120),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSourceList(List<SourceItem> sources) {
    return Column(
      children: sources.asMap().entries.map((entry) {
        final source = entry.value;
        final isSelected = _selectedSources.contains(source.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSelectableCard(
            icon: _getSourceIcon(source.type),
            label: source.label,
            subLabel: '${source.type.toUpperCase()} • Source',
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSources.remove(source.id);
                } else {
                  _selectedSources.add(source.id);
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }

  // --- STEP 2: GENERATION OPTIONS ---

  Widget _buildGenerationOptionsStep() {
    final cs = Theme.of(context).colorScheme;

    final filtered = _generationTypes
        .where(
          (type) => type['label'].toString().toLowerCase().contains(
            _genSearchQuery.toLowerCase(),
          ),
        )
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (filtered.isEmpty)
            _buildEmptyState(isFormat: true)
          else
            ...filtered.map((type) {
              final id = type['id'] as String;
              final isSelected = _selectedGenerationTypes.contains(id);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    _buildSelectableCard(
                      icon: type['icon'] as IconData,
                      label: type['label'] as String,
                      subLabel: type['subLabel'] as String,
                      isSelected: isSelected,
                      backgroundGenerator: isSelected
                          ? GenerationSeed.useLabel()
                          : null,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedGenerationTypes.remove(id);
                          } else {
                            _selectedGenerationTypes.add(id);
                          }
                        });
                      },
                    ),
                    ClipRect(
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.topCenter,
                        heightFactor: isSelected ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRadioSwitch(
                                  label: "Complexity",
                                  options: const [
                                    "Simple",
                                    "Standard",
                                    "Advanced",
                                  ],
                                  selectedOption:
                                      _generationOptions[id] ?? "Standard",
                                  onSelected: (val) {
                                    setState(() {
                                      _generationOptions[id] = val;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildRadioSwitch(
                                  label: "Focus Area",
                                  options: const [
                                    "General",
                                    "Key Concepts",
                                    "Deep Dive",
                                  ],
                                  selectedOption:
                                      _focusOptions[id] ?? "General",
                                  onSelected: (val) {
                                    setState(() {
                                      _focusOptions[id] = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 16),
          _buildSpacedRepetitionSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSpacedRepetitionSection() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            "Learning Strategy",
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / 2;
              return Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    alignment: _learningMode == 'Cram'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: segmentWidth,
                      height: 100, // Taller
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _buildModeOption(
                        label: "Cram Mode",
                        description: "Best for quick reviews before exams.",
                        icon: FontAwesomeIcons.bolt,
                        isSelected: _learningMode == 'Cram',
                        onTap: () => setState(() => _learningMode = 'Cram'),
                      ),
                      _buildModeOption(
                        label: "Spaced Mode",
                        description: "FSRS-based long term retention.",
                        icon: FontAwesomeIcons.clockRotateLeft,
                        isSelected: _learningMode == 'Spaced',
                        onTap: () => setState(() => _learningMode = 'Spaced'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeOption({
    required String label,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 100, // Taller
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: tt.labelSmall?.copyWith(
                    color: isSelected
                        ? cs.onSurface.withValues(alpha: 0.7)
                        : cs.onSurface.withValues(alpha: 0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioSwitch({
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onSelected,
    String? label,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              label,
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
            ),
          ),
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / options.length;
              final selectedIndex = options.indexOf(selectedOption);

              return Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment(
                      -1 + (selectedIndex * 2 / (options.length - 1)),
                      0,
                    ),
                    child: Container(
                      width: segmentWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: options.map((opt) {
                      final isSelected = opt == selectedOption;
                      return Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onSelected(opt),
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Text(
                                opt,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? cs.primary
                                      : cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- SHARED WIDGETS ---

  Widget _buildSearchBar({
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurface.withValues(alpha: 0.4);

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.outfit(color: cs.onSurface, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: muted, fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: muted,
              size: 16,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSelectableCard({
    required IconData icon,
    required String label,
    required String subLabel,
    required bool isSelected,
    required VoidCallback onTap,
    GenerationSeed? backgroundGenerator,
    Widget? trailing,
  }) {
    final cs = Theme.of(context).colorScheme;

    return CardButton(
      icon: icon,
      label: label,
      subLabel: subLabel,
      isCompact: true,
      backgroundGenerator: backgroundGenerator,
      layoutDirection: CardLayoutDirection.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[trailing, const SizedBox(width: 8)],
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? cs.primary : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBottomBar() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    final bool isVisible =
        _isExpanded ||
        (_currentPage == 0 && _selectedSources.isNotEmpty) ||
        (_currentPage == 1 && _selectedGenerationTypes.isNotEmpty);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      bottom: isVisible ? 0 : -200,
      left: 0,
      right: 0,
      height: _isExpanded ? screenHeight * 0.95 : 100,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(screenWidth * 1.5, _isExpanded ? 40 : 60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Solid background layer - fills edge-to-edge
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _isExpanded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                        screenWidth * 1.5,
                        _isExpanded ? 40 : 60,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primary,
                            Color.lerp(cs.primary, cs.tertiary, 0.6)!,
                            cs.tertiary,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content layer with crossfade - has padding
              Padding(
                padding: EdgeInsets.only(
                  left: _isExpanded ? 0 : 16,
                  right: _isExpanded ? 0 : 16,
                  top: _isExpanded ? 0 : 24,
                  bottom: _isExpanded ? 0 : 12,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _isExpanded
                      ? _buildExpansionContent()
                      : SizedBox(
                          key: const ValueKey('collapsed'),
                          height: 56,
                          child: Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentPage == 0
                                        ? "${_selectedSources.length} Selected"
                                        : "Format Details",
                                    style: tt.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    _currentPage == 0
                                        ? "Source Selection"
                                        : "Ready to Create",
                                    style: tt.labelSmall?.copyWith(
                                      color: muted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_currentPage == 0) {
                                      _nextPage();
                                    } else {
                                      setState(() {
                                        _isExpanded = true;
                                      });
                                      _nextPage(
                                        duration: const Duration(
                                          milliseconds: 1200,
                                        ),
                                      );
                                      // Start generation after expansion animation
                                      _startGeneration();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape:
                                        AppTheme.buttonShape as OutlinedBorder,
                                    elevation: 8,
                                    shadowColor: cs.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentPage == 0
                                          ? "Next"
                                          : "Start the magic",
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionContent() {
    final tt = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      key: const ValueKey('expanded'),
      height: screenHeight * 0.95 - 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: IconButton(
                  onPressed: () {
                    _generationSub?.cancel();
                    _parser?.dispose();
                    _llmStreamController?.close();
                    setState(() {
                      _isExpanded = false;
                      _isGenerating = false;
                    });
                    _previousPage();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 20,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    padding: const EdgeInsets.all(12),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Status header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                FaIcon(
                  _generationError != null
                      ? FontAwesomeIcons.triangleExclamation
                      : _isExtracting
                      ? FontAwesomeIcons.fileLines
                      : _isGenerating
                      ? FontAwesomeIcons.wandMagicSparkles
                      : FontAwesomeIcons.circleCheck,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  _generationError != null
                      ? "Something went wrong"
                      : _isExtracting
                      ? "Reading your sources..."
                      : _isGenerating
                      ? "Generating ${_streamedCards.length} cards..."
                      : "${_streamedCards.length} cards generated!",
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
                if (_isGenerating || _isExtracting) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
                if (_metadata != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_metadata!.totalTokens} tokens used',
                    style: tt.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Streamed cards area
          Expanded(
            child: _generationError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _generationError!,
                            textAlign: TextAlign.center,
                            style: tt.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _startGeneration,
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowRotateRight,
                              size: 14,
                            ),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _streamedCards.isEmpty && !_isGenerating && !_isExtracting
                ? Center(
                    child: Text(
                      'Waiting for content...',
                      style: tt.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _streamedCards.length,
                    itemBuilder: (context, index) {
                      return _StreamedCardWidget(
                        key: ValueKey('card_$index'),
                        card: _streamedCards[index],
                        index: index,
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAuthNotice(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.error.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  size: 16,
                  color: cs.error,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Sign in to generate content with AI",
                    style: tt.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.error,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _authNoticeDismissed = true);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        size: 14,
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(
                "You can still create your own study materials.",
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateFlashcardsPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 14),
                label: const Text("Create your own"),
                style: TextButton.styleFrom(
                  foregroundColor: cs.primary,
                  backgroundColor: cs.primary.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isFormat = false}) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          children: [
            FaIcon(
              isFormat
                  ? FontAwesomeIcons.layerGroup
                  : FontAwesomeIcons.folderOpen,
              size: 64,
              color: cs.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 24),
            Text(
              isFormat
                  ? "No matching formats found."
                  : _sourceSearchQuery.isEmpty
                  ? "No sources found.\nAdd some in the Sources tab!"
                  : "No sources match your search.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    final types = ['All', 'Document', 'Video', 'Audio', 'Image', 'Text'];
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: types.map((type) {
          final isSelected = _selectedTypeFilter == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                type,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _selectedTypeFilter = type);
              },
              backgroundColor: cs.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              selectedColor: cs.primary,
              labelStyle: TextStyle(
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
              showCheckmark: false,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddMoreSourcesSection() {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        CardButton(
          icon: _showAddSources
              ? FontAwesomeIcons.minus
              : FontAwesomeIcons.plus,
          label: "Add More Sources",
          subLabel: "Expand to see import options",
          isCompact: true,
          layoutDirection: CardLayoutDirection.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: () {
            setState(() {
              _showAddSources = !_showAddSources;
            });
          },
          accentColor: _showAddSources ? null : cs.primary,
          trailing: FaIcon(
            _showAddSources
                ? FontAwesomeIcons.chevronUp
                : FontAwesomeIcons.chevronDown,
            size: 14,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
              padding: const EdgeInsets.all(8),
              children: [
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.fileLines,
                  label: "Document",
                  color: cs.primary,
                  onTap: () => _importDocument(context),
                ),
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.photoFilm,
                  label: "Media",
                  color: const Color(0xFFFF9F43),
                  onTap: () {},
                ),
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.clone,
                  label: "Flashcards",
                  color: AppTheme.success,
                  onTap: () {},
                ),
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.cloud,
                  label: "Cloud",
                  color: const Color(0xFF00D2D3),
                  onTap: () {},
                ),
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.link,
                  label: "Website",
                  color: const Color(0xFF5f27cd),
                  onTap: () {},
                ),
                _buildAddSourceMiniCard(
                  icon: FontAwesomeIcons.penToSquare,
                  label: "Note App",
                  color: AppTheme.warning,
                  onTap: () {},
                ),
              ],
            ),
          ),
          crossFadeState: _showAddSources
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildAddSourceMiniCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CardButton(
      icon: icon,
      label: label,
      isCompact: true,
      layoutDirection: CardLayoutDirection.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      accentColor: color,
      labelFontSize: 13,
    );
  }

  void _importDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      withData: true,
      onFileLoading: (status) {},
      allowedExtensions: ["pdf", "docx", "pptx"],
    );

    if (result == null) return;

    if (context.mounted) {
      context.read<SourcesPageBloc>().add(ImportDocumentsEvent(result.files));
    }
  }

  IconData _getSourceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'document':
        return FontAwesomeIcons.fileLines;
      case 'audio':
        return FontAwesomeIcons.microphone;
      case 'video':
        return FontAwesomeIcons.video;
      case 'image':
        return FontAwesomeIcons.image;
      case 'link':
        return FontAwesomeIcons.link;
      default:
        return FontAwesomeIcons.file;
    }
  }
}

/// A single streamed card widget with entrance animation.
class _StreamedCardWidget extends StatefulWidget {
  final StreamedStudyCard card;
  final int index;

  const _StreamedCardWidget({
    super.key,
    required this.card,
    required this.index,
  });

  @override
  State<_StreamedCardWidget> createState() => _StreamedCardWidgetState();
}

class _StreamedCardWidgetState extends State<_StreamedCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    // Staggered delay based on index
    Future.delayed(Duration(milliseconds: 50 * (widget.index % 5)), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  IconData _getCardIcon(String? type) {
    switch (type) {
      case 'flashcard':
        return FontAwesomeIcons.clone;
      case 'multiple-choice-question':
        return FontAwesomeIcons.listCheck;
      case 'free-text':
        return FontAwesomeIcons.penToSquare;
      default:
        return FontAwesomeIcons.spinner;
    }
  }

  String _getCardLabel(String? type) {
    switch (type) {
      case 'flashcard':
        return 'FLASHCARD';
      case 'multiple-choice-question':
        return 'MULTIPLE CHOICE';
      case 'free-text':
        return 'FREE TEXT';
      default:
        return 'LOADING...';
    }
  }

  Color _getAccentColor(String? type, ColorScheme cs) {
    switch (type) {
      case 'flashcard':
        return const Color(0xFF4ECDC4);
      case 'multiple-choice-question':
        return const Color(0xFFFF6B6B);
      case 'free-text':
        return const Color(0xFFFFE66D);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final cs = Theme.of(context).colorScheme;
    final accent = _getAccentColor(card.type, cs);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card type badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            _getCardIcon(card.type),
                            size: 11,
                            color: accent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getCardLabel(card.type),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: accent,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#${widget.index + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Card content based on type
                _buildCardContent(card, accent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(StreamedStudyCard card, Color accent) {
    switch (card.type) {
      case 'flashcard':
        return _buildFlashcardContent(card, accent);
      case 'multiple-choice-question':
        return _buildMcqContent(card, accent);
      case 'free-text':
        return _buildFreeTextContent(card, accent);
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Detecting card type...',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildFlashcardContent(StreamedStudyCard card, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Front
        Text(
          'FRONT',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: accent.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          card.frontContent.isEmpty ? '...' : card.frontContent,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.95),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
        const SizedBox(height: 12),
        // Back
        Text(
          'BACK',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: accent.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          card.backContent.isEmpty ? '...' : card.backContent,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMcqContent(StreamedStudyCard card, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          card.question.isEmpty ? '...' : card.question,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.95),
            height: 1.4,
          ),
        ),
        if (card.choices.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...card.choices.asMap().entries.map((entry) {
            final choiceIndex = entry.key;
            final choice = entry.value;
            final isCorrect = card.correctAnswerIndex == choiceIndex;
            final letter = String.fromCharCode(65 + choiceIndex); // A, B, C, D

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCorrect
                        ? accent.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCorrect
                            ? accent.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isCorrect
                                ? accent
                                : Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        choice.isEmpty ? '...' : choice,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: isCorrect
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isCorrect
                              ? Colors.white.withValues(alpha: 0.95)
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    if (isCorrect)
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: 14,
                        color: accent,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildFreeTextContent(StreamedStudyCard card, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          'QUESTION',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: accent.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          card.question.isEmpty ? '...' : card.question,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.95),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
        const SizedBox(height: 12),
        // Criteria
        Text(
          'CRITERIA',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: accent.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          card.criteria.isEmpty ? '...' : card.criteria,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
