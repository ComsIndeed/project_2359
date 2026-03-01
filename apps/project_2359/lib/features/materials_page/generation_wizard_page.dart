import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/home_page/home_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/app_theme.dart';
import 'package:file_picker/file_picker.dart';

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
  String _genSearchQuery = '';
  bool _useFSRS = true;
  bool _showAddSources = false;

  final Map<String, String> _generationOptions = {
    'flashcards': 'Comprehensive',
    'quizzes': '10 Questions',
    'assessment': 'Full length',
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
            // --- Modern Compact Header ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _currentPage == 0
                            ? _exitWizard
                            : _previousPage,
                        icon: FaIcon(
                          _currentPage == 0
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.chevronLeft,
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          backgroundColor: cs.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        _currentPage == 0 ? "Select Sources" : "Select Format",
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      // Balance the row
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Thinner Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        height: 3,
                        width:
                            MediaQuery.of(context).size.width *
                            (_currentPage + 1) /
                            2,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(1.5),
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
    final tt = Theme.of(context).textTheme;

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
          _buildSearchBar(
            hint: 'Search formats...',
            onChanged: (val) => setState(() => _genSearchQuery = val),
          ),
          const SizedBox(height: 16),
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
                                Text(
                                  "Configuration",
                                  style: tt.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildOptionRow(
                                  "Complexity",
                                  _generationOptions[id] ?? "Standard",
                                  () {},
                                ),
                                const SizedBox(height: 8),
                                _buildOptionRow("Focus", "Everything", () {}),
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

  Widget _buildOptionRow(String label, String value, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 10,
                  color: cs.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
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
                        : "Format Details",
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    _currentPage == 0 ? "Source Selection" : "Ready to Create",
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: _currentPage == 0 ? _nextPage : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Center(
                      child: Text(
                        _currentPage == 0 ? "Next" : "Generate",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
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
