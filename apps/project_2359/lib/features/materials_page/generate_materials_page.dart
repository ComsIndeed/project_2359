import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/home_page/home_page.dart';

class GenerateMaterialsPage extends StatefulWidget {
  final Set<String> selectedSourceIds;

  const GenerateMaterialsPage({super.key, required this.selectedSourceIds});

  @override
  State<GenerateMaterialsPage> createState() => _GenerateMaterialsPageState();
}

class _GenerateMaterialsPageState extends State<GenerateMaterialsPage> {
  final Set<String> _selectedGenerationTypes = {};
  String _searchQuery = '';

  final List<Map<String, dynamic>> _generationTypes = [
    {
      'id': 'flashcards',
      'label': 'AI Flashcards',
      'subLabel': 'Smart cards for spaced repetition.',
      'icon': FontAwesomeIcons.layerGroup,
      'color': Colors.orange,
    },
    {
      'id': 'quizzes',
      'label': 'Practice Quizzes',
      'subLabel': 'Test your knowledge with 10 questions.',
      'icon': FontAwesomeIcons.clipboardQuestion,
      'color': Colors.blue,
    },
    {
      'id': 'summaries',
      'label': 'Study Summaries',
      'subLabel': 'Concise notes highlighting key points.',
      'icon': FontAwesomeIcons.fileArrowUp,
      'color': Colors.green,
    },
    {
      'id': 'mindmaps',
      'label': 'Visual Mind Maps',
      'subLabel': 'Structure concepts visually.',
      'icon': FontAwesomeIcons.diagramProject,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // User wants exiting this page to go to homepage
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const FaIcon(FontAwesomeIcons.xmark, size: 20),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(
                            backgroundColor: cs.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text("Finish", style: tt.displaySmall),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Generate Materials",
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "What would you like to create from ${widget.selectedSourceIds.length} source(s)?",
                      style: tt.bodyLarge?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.2),
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
                              "Tip: You can select multiple formats to generate them all at once.",
                              style: tt.labelSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- Options Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose Output",
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_selectedGenerationTypes.length} selected",
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSubtleSearchBar(),
                    const SizedBox(height: 24),

                    ..._buildGenerationOptions(),
                  ],
                ),
              ),
            ),

            // --- Bottom Action Bar ---
            if (_selectedGenerationTypes.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
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
                          "Ready to Create",
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "This will use AI magic",
                          style: tt.labelSmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Start generation
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Generate Now",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 12),
                            FaIcon(FontAwesomeIcons.wandSparkles, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtleSearchBar() {
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurface.withValues(alpha: 0.4);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: (value) => setState(() {
          _searchQuery = value;
        }),
        style: GoogleFonts.inter(color: cs.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search formats...',
          hintStyle: GoogleFonts.inter(color: muted, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: muted,
              size: 14,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  List<Widget> _buildGenerationOptions() {
    final filtered = _generationTypes
        .where(
          (type) => type['label'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();

    if (filtered.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              "No formats found matching your search.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ];
    }

    return filtered.map((type) {
      final id = type['id'] as String;
      final isSelected = _selectedGenerationTypes.contains(id);
      final accentColor = type['color'] as Color;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: CardButton(
          icon: type['icon'] as IconData,
          label: type['label'] as String,
          subLabel: type['subLabel'] as String,
          isCompact: true,
          layoutDirection: CardLayoutDirection.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedGenerationTypes.remove(id);
              } else {
                _selectedGenerationTypes.add(id);
              }
            });
          },
          trailing: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? accentColor : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
      );
    }).toList();
  }
}
