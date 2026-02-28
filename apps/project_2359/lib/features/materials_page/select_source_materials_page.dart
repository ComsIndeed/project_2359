import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/tap_to_slide.dart';
import 'package:project_2359/features/materials_page/generate_materials_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

class SelectSourceMaterialsPage extends StatefulWidget {
  const SelectSourceMaterialsPage({super.key});

  @override
  State<SelectSourceMaterialsPage> createState() =>
      _SelectSourceMaterialsPageState();
}

class _SelectSourceMaterialsPageState extends State<SelectSourceMaterialsPage> {
  final Set<String> _selectedSources = {};
  String _searchQuery = '';

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
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            size: 20,
                          ),
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
                        Text("Generate", style: tt.displaySmall),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Source Selection",
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select the reference materials for your study session.",
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
                              "Tip: Long-press a source to refine specific subtopics.",
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

                    // --- Selection Section ---
                    BlocBuilder<SourcesPageBloc, SourcesPageState>(
                      builder: (context, state) {
                        if (state is SourcesPageStateInitial) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is SourcesPageStateLoaded) {
                          final filteredSources = state.sources
                              .where(
                                (s) => s.label.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ),
                              )
                              .toList();

                          return _buildSourceSection(filteredSources);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Action Bar ---
            if (_selectedSources.isNotEmpty)
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
                          "${_selectedSources.length} Selected",
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Ready to generate",
                          style: tt.labelSmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TapToSlide(
                        page: GenerateMaterialsPage(
                          selectedSourceIds: _selectedSources,
                        ),
                        direction: SlideDirection.left,
                        builder: (pushPage) {
                          return ElevatedButton(
                            onPressed: pushPage,
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
                                  "Continue",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 12),
                                FaIcon(FontAwesomeIcons.arrowRight, size: 16),
                              ],
                            ),
                          );
                        },
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

  Widget _buildEmptyState() {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.folderOpen,
              size: 48,
              color: cs.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? "No sources found. Add some in the Sources tab!"
                  : "No sources match your search.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: cs.onSurface.withValues(alpha: 0.5),
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
      height: 48, // Slightly taller for better touch target
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
          hintText: 'Filter your sources...',
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

  Widget _buildSourceSection(List<SourceItem> sources) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Sources",
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (sources.isNotEmpty)
              Text(
                "${sources.length} total",
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSubtleSearchBar(),
        const SizedBox(height: 24),
        if (sources.isEmpty) _buildEmptyState() else _buildSourceList(sources),
      ],
    );
  }

  Widget _buildSourceList(List<SourceItem> sources) {
    return Column(
      children: sources.asMap().entries.map((entry) {
        final index = entry.key;
        final source = entry.value;
        final isSelected = _selectedSources.contains(source.id);
        final isLast = index == sources.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
          child: _buildSourceCard(source, isSelected),
        );
      }).toList(),
    );
  }

  void _showSubtopicPicker(SourceItem source) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final subtopics = [
      {
        'title': "Introduction & Overview",
        'desc': "Basic context and fundamental goals.",
        'icon': FontAwesomeIcons.circleInfo,
      },
      {
        'title': "Key Concepts & Definitions",
        'desc': "Important terminology and core theories.",
        'icon': FontAwesomeIcons.key,
      },
      {
        'title': "Practical & Case Studies",
        'desc': "Real-world applications and examples.",
        'icon': FontAwesomeIcons.flask,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // WIP Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.hammer,
                      size: 12,
                      color: cs.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "FEATURE IN PROGRESS",
                      style: tt.labelSmall?.copyWith(
                        color: cs.tertiary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.sliders,
                            size: 20,
                            color: cs.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Content Control",
                                style: tt.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                              Text(
                                source.label,
                                style: tt.bodySmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.3),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AbsorbPointer(
                      child: Opacity(
                        opacity: 0.5,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "SELECT SUBTOPICS",
                                  style: tt.labelSmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: 12,
                                  ),
                                  label: const Text("Select All"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(subtopics.length, (index) {
                              final item = subtopics[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: CardButton(
                                  icon: item['icon'] as IconData,
                                  label: item['title'] as String,
                                  subLabel: item['desc'] as String,
                                  isCompact: true,
                                  layoutDirection:
                                      CardLayoutDirection.horizontal,
                                  padding: const EdgeInsets.all(16),
                                  onTap: null,
                                  trailing: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: cs.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          side: BorderSide(
                            color: cs.onSurface.withValues(alpha: 0.1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Go Back",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceCard(SourceItem source, bool isSelected) {
    final cs = Theme.of(context).colorScheme;

    IconData icon;
    switch (source.type.toLowerCase()) {
      case 'document':
        icon = FontAwesomeIcons.fileLines;
        break;
      case 'audio':
        icon = FontAwesomeIcons.microphone;
        break;
      case 'video':
        icon = FontAwesomeIcons.video;
        break;
      case 'image':
        icon = FontAwesomeIcons.image;
        break;
      case 'link':
        icon = FontAwesomeIcons.link;
        break;
      default:
        icon = FontAwesomeIcons.file;
    }

    final subLabel = '${source.type.toUpperCase()} • Source';

    return CardButton(
      icon: icon,
      label: source.label,
      subLabel: subLabel,
      isCompact: true,
      layoutDirection: CardLayoutDirection.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSources.remove(source.id);
          } else {
            _selectedSources.add(source.id);
          }
        });
      },
      onLongPress: () => _showSubtopicPicker(source),
      trailing: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? cs.primary : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? cs.primary
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
    );
  }
}
