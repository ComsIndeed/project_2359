import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';

class GenerateMaterialsPage extends StatefulWidget {
  const GenerateMaterialsPage({super.key});

  @override
  State<GenerateMaterialsPage> createState() => _GenerateMaterialsPageState();
}

class _GenerateMaterialsPageState extends State<GenerateMaterialsPage> {
  // Mock Data
  final List<String> _outputTypes = ['Flashcards', 'Quiz', 'Summary'];
  String _selectedOutputType = 'Flashcards';

  bool _fsrsEnabled = true;
  bool _activeRecallEnabled = false;

  final Set<String> _selectedSources = {'Biochem'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                  color: AppTheme.surface.withValues(alpha: 0.3),
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
                    color: AppTheme.textSecondary,
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
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Filter sources...',
          hintStyle: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
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
    // Mock sources with IDs for consistent icons/colors
    final sources = [
      (
        icon: Icons.description,
        label: 'Biochemistry',
        subLabel: 'PDF • 2.4MB',
        id: 'Biochem',
      ),
      (
        icon: Icons.history_edu,
        label: 'Hist_Drama',
        subLabel: 'Doc • 15KB',
        id: 'Hist_Drama',
      ),
      (
        icon: Icons.link,
        label: 'Web Res...',
        subLabel: 'Link • 5 URLs',
        id: 'Web Res',
      ),
      (
        icon: Icons.mic,
        label: 'Lecture...',
        subLabel: 'MP3 • 45m',
        id: 'Lecture',
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: sources.map((source) {
        final isSelected = _selectedSources.contains(source.id);
        // Calculate width for 2 columns. Subtract padding (24*2) and spacing (16)
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
    return Stack(
      children: [
        // We use a Container to ensure the CardButton expands
        SizedBox(
          height: 80, // Fixed height for consistency
          child: CardButton(
            icon: icon,
            label: label,
            subLabel: subLabel,
            // Use ID for consistent background/color generation
            backgroundGenerator: GenerationSeed.fromString(id),
            isCompact: true,
            layoutDirection: CardLayoutDirection.horizontal,
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
        // Selection Indicator Overlay
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
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary
                      : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutputTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
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
                      ? AppTheme.secondarySurface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.3),
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
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeTrackColor: AppTheme.primary,
          inactiveTrackColor: AppTheme.secondarySurface,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
