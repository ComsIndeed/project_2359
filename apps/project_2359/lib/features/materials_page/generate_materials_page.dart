import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/widgets/card_button.dart';

class GenerateMaterialsPage extends StatefulWidget {
  const GenerateMaterialsPage({super.key});

  @override
  State<GenerateMaterialsPage> createState() => _GenerateMaterialsPageState();
}

class _GenerateMaterialsPageState extends State<GenerateMaterialsPage> {
  final Set<String> _selectedSources = {'Biochem'};
  int _currentSourcePage = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Custom Header ---
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 24),
                    padding: const EdgeInsets.all(8),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Generate Materials",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDummySourceContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDummySourceContent() {
    final List<({IconData icon, String label, String subLabel, String id})>
    dummySources = [
      (
        icon: FontAwesomeIcons.fileLines,
        label: 'Biochemistry',
        subLabel: 'PDF • 2.4MB',
        id: 'Biochem',
      ),
      (
        icon: FontAwesomeIcons.bookOpen,
        label: 'Hist_Drama',
        subLabel: 'Doc • 15KB',
        id: 'Hist_Drama',
      ),
      (
        icon: FontAwesomeIcons.link,
        label: 'Web Resources',
        subLabel: 'Link • 5 URLs',
        id: 'WebRes',
      ),
      (
        icon: FontAwesomeIcons.microphone,
        label: 'Lecture Recording',
        subLabel: 'MP3 • 45m',
        id: 'Lecture',
      ),
      (
        icon: FontAwesomeIcons.filePdf,
        label: 'Human Anatomy',
        subLabel: 'PDF • 12MB',
        id: 'Anatomy',
      ),
      (
        icon: FontAwesomeIcons.fileLines,
        label: 'Neural Networks',
        subLabel: 'Notes • 240KB',
        id: 'Neural',
      ),
      (
        icon: FontAwesomeIcons.filePowerpoint,
        label: 'Cell Biology',
        subLabel: 'PPT • 5.1MB',
        id: 'CellBio',
      ),
      (
        icon: FontAwesomeIcons.fileWord,
        label: 'Lab Protocol',
        subLabel: 'Doc • 42KB',
        id: 'Lab',
      ),
      (
        icon: FontAwesomeIcons.filePdf,
        label: 'Organic Chemistry',
        subLabel: 'PDF • 8.2MB',
        id: 'OrgChem',
      ),
      (
        icon: FontAwesomeIcons.link,
        label: 'Research Papers',
        subLabel: 'Link • 12 URLs',
        id: 'Research',
      ),
    ];

    final filteredSources = dummySources
        .where(
          (s) => s.label.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    if (filteredSources.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSourceGrid(filteredSources);
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
                  ? "No sources found."
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
    final muted = cs.onSurface.withValues(alpha: 0.3);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
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
        style: GoogleFonts.inter(color: cs.onSurface, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Filter sources...',
          hintStyle: GoogleFonts.inter(color: muted, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: muted,
              size: 12,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }

  Widget _buildSourceGrid(
    List<({IconData icon, String label, String subLabel, String id})> sources,
  ) {
    final List<
      List<({IconData icon, String label, String subLabel, String id})>
    >
    groupsOfFour = [];
    for (var i = 0; i < sources.length; i += 4) {
      groupsOfFour.add(
        sources.sublist(i, i + 4 > sources.length ? sources.length : i + 4),
      );
    }

    if (_currentSourcePage >= groupsOfFour.length) {
      _currentSourcePage = 0;
    }

    final currentChunkSize = groupsOfFour[_currentSourcePage].length;
    final double targetHeight = currentChunkSize * 72.0;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: targetHeight,
          child: PageView.builder(
            itemCount: groupsOfFour.length,
            onPageChanged: (index) =>
                setState(() => _currentSourcePage = index),
            itemBuilder: (context, pageIndex) {
              final chunk = groupsOfFour[pageIndex];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: chunk.map((source) {
                  final isSelected = _selectedSources.contains(source.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildSourceCard(source, isSelected),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildSubtleSearchBar()),
            const SizedBox(width: 16),
            if (groupsOfFour.length > 1)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(groupsOfFour.length, (index) {
                  final cs = Theme.of(context).colorScheme;
                  final isActive = index == _currentSourcePage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 24 : 8,
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
          ],
        ),
      ],
    );
  }

  Widget _buildSourceCard(
    ({IconData icon, String label, String subLabel, String id}) source,
    bool isSelected,
  ) {
    final cs = Theme.of(context).colorScheme;

    return CardButton(
      icon: source.icon,
      label: source.label,
      subLabel: source.subLabel,
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
