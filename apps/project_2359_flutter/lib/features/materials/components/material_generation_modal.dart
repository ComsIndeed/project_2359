import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../common/app_list_tile.dart';

class MaterialGenerationModal extends StatefulWidget {
  const MaterialGenerationModal({super.key});

  @override
  State<MaterialGenerationModal> createState() =>
      _MaterialGenerationModalState();
}

class _MaterialGenerationModalState extends State<MaterialGenerationModal> {
  final PageController _pageController = PageController();

  // Form State
  final List<String> _selectedSources = [];
  final List<int> _selectedTypeIndices = [0];
  bool _enableFsrs = false;
  double _targetRetention = 0.9;
  final TextEditingController _notesController = TextEditingController();

  // Mock Data
  final List<String> _availableSources = [
    'Lecture 1: Introduction',
    'Chapter 4: Biology',
    'Project Specs',
    'Chemistry 101 Notes',
    'History Essay Draft',
    'Calculus Cheat Sheet',
    'Physics Lab Report',
  ];

  final List<Map<String, dynamic>> _types = [
    {'icon': Icons.style, 'label': 'Flashcards'},
    {'icon': Icons.list_alt, 'label': 'Multiple Choice'},
    {'icon': Icons.fingerprint, 'label': 'Identification'},
    {'icon': Icons.join_inner, 'label': 'Matching'},
    {'icon': Icons.image_search, 'label': 'Image Occlusion'},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMainForm(context),
                _buildSourceSelectionPage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainForm(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Generate Materials',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionLabel(context, 'SOURCES'),
                const SizedBox(height: 12),
                _buildSourceSelector(context),
                const SizedBox(height: 32),
                _buildSectionLabel(context, 'TYPE'),
                const SizedBox(height: 12),
                _buildTypeSelector(context),
                const SizedBox(height: 32),
                _buildFsrsSection(context),
                const SizedBox(height: 32),
                _buildSectionLabel(context, 'ADDITIONAL NOTES'),
                const SizedBox(height: 12),
                _buildNotesInput(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildSourceSelectionPage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _goToPage(0),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Text(
                'Select Sources',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _availableSources.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final source = _availableSources[index];
              final isSelected = _selectedSources.contains(source);
              return AppListTile(
                title: source,
                icon: isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                iconColor: isSelected
                    ? AppColors.primary
                    : AppColors.textTertiary,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSources.remove(source);
                    } else {
                      _selectedSources.add(source);
                    }
                  });
                },
                trailing: const SizedBox.shrink(),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.textTertiary)),
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () => _goToPage(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Done',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(label, style: Theme.of(context).textTheme.labelSmall);
  }

  Widget _buildSourceSelector(BuildContext context) {
    String headerText;
    if (_selectedSources.isEmpty) {
      headerText = 'Select sources...';
    } else if (_selectedSources.length == 1) {
      headerText = _selectedSources.first;
    } else {
      headerText = 'Selected ${_selectedSources.length} Sources';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textTertiary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _goToPage(1),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.library_books,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      headerText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _selectedSources.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white54),
                ],
              ),
            ),
          ),
          if (_selectedSources.length > 1) ...[
            const Divider(height: 1, color: AppColors.textTertiary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: _selectedSources.map((source) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: Colors.white24,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            source,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSources.remove(source);
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.white38,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: List.generate(_types.length, (index) {
            final type = _types[index];
            final isSelected = _selectedTypeIndices.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedTypeIndices.length > 1) {
                      _selectedTypeIndices.remove(index);
                    }
                  } else {
                    _selectedTypeIndices.add(index);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1E2843)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : Border.all(color: Colors.transparent),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type['icon'] as IconData,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type['label'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFsrsSection(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: _enableFsrs
              ? Border.all(color: AppColors.primary.withOpacity(0.3))
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Scheduling (FSRS)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Optimize review intervals',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _enableFsrs,
                  onChanged: (value) => setState(() => _enableFsrs = value),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
            if (_enableFsrs) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.textTertiary),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Target Retention',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(_targetRetention * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  value: _targetRetention,
                  min: 0.7,
                  max: 0.99,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.textTertiary,
                  onChanged: (value) =>
                      setState(() => _targetRetention = value),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesInput(BuildContext context) {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'E.g., Focus on key definitions and dates...',
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.textTertiary)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle generation logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 20),
              const SizedBox(width: 8),
              Text(
                'Generate',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
