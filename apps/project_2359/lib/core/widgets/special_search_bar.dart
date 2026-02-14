import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    return SearchAnchor.bar(
      barHintText: hintText,
      isFullScreen: true,
      barBackgroundColor: WidgetStateProperty.all(cs.surfaceContainerHighest),
      barElevation: WidgetStateProperty.all(0),
      barShape: WidgetStateProperty.all(
        RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      barTextStyle: WidgetStateProperty.all(
        tt.bodyLarge?.copyWith(color: cs.onSurface),
      ),
      barHintStyle: WidgetStateProperty.all(
        tt.bodyMedium?.copyWith(color: muted),
      ),
      barLeading: FaIcon(
        FontAwesomeIcons.magnifyingGlass,
        color: cs.primary,
        size: 18,
      ),
      barTrailing: [
        if (onFilterTap != null)
          IconButton(
            onPressed: onFilterTap,
            icon: FaIcon(FontAwesomeIcons.sliders, color: muted, size: 18),
          ),
      ],
      dividerColor: Colors.transparent,
      viewLeading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: FaIcon(FontAwesomeIcons.arrowLeft, color: cs.primary, size: 18),
      ),
      viewHintText: hintText,
      viewBackgroundColor: cs.surface,
      viewElevation: 0,
      viewShape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadius.zero,
      ),
      suggestionsBuilder: (context, controller) {
        if (onChanged != null) {
          onChanged!(controller.text);
        }

        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;
        final muted = cs.onSurface.withValues(alpha: 0.5);
        final text = controller.text;
        final List<Widget> children = [];

        children.add(const SizedBox(height: 24));

        if (text.isEmpty) {
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.clockRotateLeft,
                    size: 14,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Recent",
                    style: tt.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );

          final recent = [
            "Calculus II Notes",
            "Physics Formula Sheet",
            "Study Group A",
          ];
          for (var item in recent) {
            children.add(
              _buildSuggestionItem(
                context,
                item,
                FontAwesomeIcons.clockRotateLeft,
              ),
            );
          }

          children.add(const SizedBox(height: 32));

          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.compass, size: 14, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Discover",
                    style: tt.titleMedium?.copyWith(
                      color: cs.primary,
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
                  _buildQuickAction(
                    context,
                    "Notes",
                    FontAwesomeIcons.noteSticky,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context,
                    "Tasks",
                    FontAwesomeIcons.circleCheck,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context,
                    "Flashcards",
                    FontAwesomeIcons.clone,
                  ),
                ],
              ),
            ),
          );
        } else {
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Results for \"$text\"",
                style: tt.bodyMedium?.copyWith(color: muted),
              ),
            ),
          );

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
                _buildSuggestionItem(context, item, FontAwesomeIcons.file),
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
                      FaIcon(
                        FontAwesomeIcons.faceFrown,
                        size: 48,
                        color: muted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text("No results found", style: TextStyle(color: muted)),
                    ],
                  ),
                ),
              ),
            );
          }

          children.add(const SizedBox(height: 16));
          children.add(
            _buildSuggestionItem(
              context,
              "Search everywhere for \"$text\"",
              FontAwesomeIcons.earthAmericas,
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
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurface.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          splashColor: cs.primary.withValues(alpha: 0.1),
          highlightColor: cs.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(icon, color: cs.primary, size: 18),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowTurnUp,
                  color: muted.withValues(alpha: 0.5),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.2),
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
              FaIcon(icon, color: cs.primary, size: 18),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface,
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
