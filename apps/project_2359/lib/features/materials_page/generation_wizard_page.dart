import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/home_page/home_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

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

  // Shared State
  final Set<String> _selectedSources = {};
  final Set<String> _selectedGenerationTypes = {};
  String _sourceSearchQuery = '';
  String _genSearchQuery = '';
  bool _useFSRS = true;

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

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _exitWizard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- Refined Header with Progress Indicator ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _currentPage == 0
                            ? _exitWizard
                            : _previousPage,
                        icon: FaIcon(
                          _currentPage == 0
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.chevronLeft,
                          size: 18,
                        ),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          backgroundColor: cs.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentPage == 0
                                  ? "Step 1: Sources"
                                  : "Step 2: Format",
                              style: tt.labelLarge?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _currentPage == 0
                                  ? "What are we studying?"
                                  : "How should we learn?",
                              style: tt.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        height: 4,
                        width:
                            MediaQuery.of(context).size.width *
                            (_currentPage + 1) /
                            2,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildSourceSelectionStep(),
                  _buildGenerationOptionsStep(),
                ],
              ),
            ),

            // --- Animated Bottom Action Bar ---
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
                (s) => s.label.toLowerCase().contains(
                  _sourceSearchQuery.toLowerCase(),
                ),
              )
              .toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(
                  hint: 'Filter your sources...',
                  onChanged: (val) => setState(() => _sourceSearchQuery = val),
                ),
                const SizedBox(height: 24),
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
    final filtered = _generationTypes
        .where(
          (type) => type['label'].toString().toLowerCase().contains(
            _genSearchQuery.toLowerCase(),
          ),
        )
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(
            hint: 'Search formats...',
            onChanged: (val) => setState(() => _genSearchQuery = val),
          ),
          const SizedBox(height: 24),
          if (filtered.isEmpty)
            _buildEmptyState(isFormat: true)
          else
            ...filtered.map((type) {
              final id = type['id'] as String;
              final isSelected = _selectedGenerationTypes.contains(id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSelectableCard(
                  icon: type['icon'] as IconData,
                  label: type['label'] as String,
                  subLabel: type['subLabel'] as String,
                  isSelected: isSelected,
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
        CardButton(
          icon: FontAwesomeIcons.clockRotateLeft,
          label: "Spaced Repetition",
          subLabel: "Optimize review cycles using FSRS algorithm",
          isCompact: true,
          layoutDirection: CardLayoutDirection.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: () {
            setState(() {
              _useFSRS = !_useFSRS;
            });
          },
          trailing: Switch(
            value: _useFSRS,
            onChanged: (val) {
              setState(() {
                _useFSRS = val;
              });
            },
            activeThumbColor: cs.primary,
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
  }) {
    final cs = Theme.of(context).colorScheme;

    return CardButton(
      icon: icon,
      label: label,
      subLabel: subLabel,
      isCompact: true,
      layoutDirection: CardLayoutDirection.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      trailing: AnimatedContainer(
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
    );
  }

  Widget _buildAnimatedBottomBar() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    final bool isVisible =
        (_currentPage == 0 && _selectedSources.isNotEmpty) ||
        (_currentPage == 1 && _selectedGenerationTypes.isNotEmpty);

    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentPage == 0
                        ? "${_selectedSources.length} Selected"
                        : "Ready to Create",
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    _currentPage == 0
                        ? "Let's move to formats"
                        : "This will use AI intelligence",
                    style: tt.labelSmall?.copyWith(
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _currentPage == 0 ? _nextPage : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == 0 ? "Continue" : "Generate Now",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FaIcon(
                          _currentPage == 0
                              ? FontAwesomeIcons.arrowRight
                              : FontAwesomeIcons.wandSparkles,
                          size: 16,
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
