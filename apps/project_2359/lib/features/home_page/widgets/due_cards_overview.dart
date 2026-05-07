import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class DueCardsOverview extends StatelessWidget {
  final int totalDue;
  final Map<String, int> items; // Name -> Count
  final bool isCollectionPage;

  const DueCardsOverview({
    super.key,
    required this.totalDue,
    required this.items,
    this.isCollectionPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$totalDue Cards Due",
          style: theme.textTheme.titleMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.9),
            fontWeight: FontWeight.w900,
            fontSize: 17,
            letterSpacing: -0.3,
          ),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.entries.map((entry) {
              return _DueChip(
                label: entry.key,
                count: entry.value,
                onColor: cs.onSurface,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _DueChip extends StatelessWidget {
  final String label;
  final int count;
  final Color onColor;

  const _DueChip({
    required this.label,
    required this.count,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$count",
            style: const TextStyle(
              color: AppTheme.important,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: onColor.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
