import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

// TODO: This file is largely vibecoded right now. Review everything

class SpecialSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SpecialSearchBar({
    super.key,
    this.hintText = "Search...",
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barHintText: hintText,
      isFullScreen: true,
      barBackgroundColor: WidgetStateProperty.all(AppTheme.secondarySurface),
      barElevation: WidgetStateProperty.all(0),
      barShape: WidgetStateProperty.all(
        RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      barTextStyle: WidgetStateProperty.all(
        Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppTheme.textPrimary),
      ),
      barHintStyle: WidgetStateProperty.all(
        Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
      ),
      barLeading: const Icon(Icons.search_rounded, color: AppTheme.primary),
      barTrailing: [
        if (onFilterTap != null)
          IconButton(
            onPressed: onFilterTap,
            icon: const Icon(Icons.tune_rounded, color: AppTheme.textSecondary),
          ),
      ],
      dividerColor: Colors.transparent,
      viewLeading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary),
      ),
      viewHintText: hintText,
      viewBackgroundColor: AppTheme.surface,
      viewElevation: 0,
      viewShape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadius.zero,
      ),
      suggestionsBuilder: (context, controller) {
        if (onChanged != null) {
          onChanged!(controller.text);
        }

        final text = controller.text;
        final List<Widget> children = [];

        // Add some top spacing
        children.add(const SizedBox(height: 24));

        if (text.isEmpty) {
          // Recent Searches Section
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Recent",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );

          // Mock Recent Items
          final recent = [
            "Calculus II Notes",
            "Physics Formula Sheet",
            "Study Group A",
          ];
          for (var item in recent) {
            children.add(_buildSuggestionItem(context, item, Icons.history));
          }

          children.add(const SizedBox(height: 32));

          // Discover / Quick Actions Section
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.explore_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Discover",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );

          children.add(
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildQuickAction(context, "Notes", Icons.note_alt_outlined),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context,
                    "Tasks",
                    Icons.check_circle_outline,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context,
                    "Flashcards",
                    Icons.style_outlined,
                  ),
                ],
              ),
            ),
          );
        } else {
          // Search Results Section
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Results for \"$text\"",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ),
          );

          // Mock Results
          final suggestions = [
            "Math formulas",
            "History notes",
            "Chemistry lab",
            "Linear Algebra",
          ];

          bool foundAny = false;
          for (var item in suggestions) {
            if (item.toLowerCase().contains(text.toLowerCase())) {
              children.add(
                _buildSuggestionItem(
                  context,
                  item,
                  Icons.insert_drive_file_outlined,
                ),
              );
              foundAny = true;
            }
          }

          if (!foundAny) {
            children.add(
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        size: 48,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No results found",
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // specific "Search for" action
          children.add(const SizedBox(height: 16));
          children.add(
            _buildSuggestionItem(
              context,
              "Search everywhere for \"$text\"",
              Icons.travel_explore,
            ),
          );
        }

        return children;
      },
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle tap
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: AppTheme.primary.withValues(alpha: 0.1),
          highlightColor: AppTheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.secondarySurface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.north_west_rounded,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.secondarySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
