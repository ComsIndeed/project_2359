import 'package:flutter/cupertino.dart';
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
  final List<String> _outputTypes = ['Flashcards', 'Quiz', 'Summary'];
  String _selectedOutputType = 'Flashcards';

  bool _fsrsEnabled = true;
  bool _activeRecallEnabled = false;

  final Set<String> _selectedSources = {'Biochem'};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Generate Materials",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("1. SELECT SOURCES"),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildSourceGrid(),
              const SizedBox(height: 40),
              _buildSectionHeader("2. CONFIGURATION"),
              const SizedBox(height: 24),
              _buildOutputTypeSelector(),
              const SizedBox(height: 24),
              _buildConfigurationOptions(),
              const SizedBox(height: 40),
              _buildSectionHeader("PREVIEW OUTPUT"),
              const SizedBox(height: 16),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: cs.surface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Preview content based on selection",
                  style: GoogleFonts.inter(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: cs.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildSearchBar() {
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        style: TextStyle(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'Filter sources...',
          hintStyle: TextStyle(color: muted),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: muted,
              size: 18,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSourceGrid() {
    final sources = [
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
        id: 'Web Res',
      ),
      (
        icon: FontAwesomeIcons.microphone,
        label: 'Lecture Recording',
        subLabel: 'MP3 • 45m',
        id: 'Lecture',
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: sources.map((source) {
        final isSelected = _selectedSources.contains(source.id);
        final width = (MediaQuery.of(context).size.width - 48 - 16) / 2;

        return SizedBox(
          width: width,
          child: _buildSourceCard(
            source.icon,
            source.label,
            source.subLabel,
            source.id,
            isSelected,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSourceCard(
    IconData icon,
    String label,
    String subLabel,
    String id,
    bool isSelected,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SizedBox(
          height: 80,
          child: CardButton(
            icon: icon,
            label: label,
            subLabel: subLabel,
            backgroundGenerator: GenerationSeed.fromString(id),
            isCompact: true,
            layoutDirection: CardLayoutDirection.horizontal,
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
              bottom: 12,
              right: 44,
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedSources.remove(id);
                } else {
                  _selectedSources.add(id);
                }
              });
            },
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: AnimatedContainer(
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
                  ? const FaIcon(
                      FontAwesomeIcons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutputTypeSelector() {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: _outputTypes.map((type) {
          final isSelected = _selectedOutputType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedOutputType = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.surfaceContainerHighest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.5),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConfigurationOptions() {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSwitchOption(
            "FSRS Scheduling",
            "AI-optimized interval spacing",
            _fsrsEnabled,
            (val) => setState(() => _fsrsEnabled = val),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.05),
              height: 1,
            ),
          ),
          _buildSwitchOption(
            "Active Recall Mode",
            "Force answer generation before reveal",
            _activeRecallEnabled,
            (val) => setState(() => _activeRecallEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool>? onChanged,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeTrackColor: cs.primary,
          inactiveTrackColor: cs.surfaceContainerHighest,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
