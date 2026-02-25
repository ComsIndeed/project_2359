import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

class GenerateMaterialsPage extends StatefulWidget {
  const GenerateMaterialsPage({super.key});

  @override
  State<GenerateMaterialsPage> createState() => _GenerateMaterialsPageState();
}

class _GenerateMaterialsPageState extends State<GenerateMaterialsPage> {
  final Set<String> _selectedSources = {};
  int _currentSourcePage = 0;
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
                      "Choose the materials you want to use as context. The AI will use these to generate study notes, questions, and summaries tailored to your style.",
                      style: tt.bodyMedium?.copyWith(color: muted, height: 1.5),
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
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement generation trigger
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
          _currentSourcePage = 0;
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
              "Your Library",
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
        if (sources.isEmpty) _buildEmptyState() else _buildSourceGrid(sources),
      ],
    );
  }

  Widget _buildSourceGrid(List<SourceItem> sources) {
    final List<List<SourceItem>> groupsOfFour = [];
    for (var i = 0; i < sources.length; i += 4) {
      groupsOfFour.add(
        sources.sublist(i, i + 4 > sources.length ? sources.length : i + 4),
      );
    }

    if (_currentSourcePage >= groupsOfFour.length) {
      _currentSourcePage = 0;
    }

    final currentChunkSize = groupsOfFour[_currentSourcePage].length;
    // Standardize item height to prevent jumping
    const double itemHeight = 72.0;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height:
              (currentChunkSize * itemHeight) - (currentChunkSize > 0 ? 8 : 0),
          child: PageView.builder(
            itemCount: groupsOfFour.length,
            onPageChanged: (index) =>
                setState(() => _currentSourcePage = index),
            itemBuilder: (context, pageIndex) {
              final chunk = groupsOfFour[pageIndex];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: chunk.asMap().entries.map((entry) {
                  final index = entry.key;
                  final source = entry.value;
                  final isSelected = _selectedSources.contains(source.id);
                  final isLast = index == chunk.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    child: _buildSourceCard(source, isSelected),
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (groupsOfFour.length > 1) ...[
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(groupsOfFour.length, (index) {
                final cs = Theme.of(context).colorScheme;
                final isActive = index == _currentSourcePage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isActive
                        ? cs.primary
                        : cs.primary.withValues(alpha: 0.2),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
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
