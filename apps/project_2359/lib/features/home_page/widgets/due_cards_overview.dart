import 'package:flutter/material.dart';

class DueCardsOverview extends StatelessWidget {
  final int totalDue;
  final Map<String, int> items; // Name -> Count
  final bool isFolderPage;

  const DueCardsOverview({
    super.key,
    required this.totalDue,
    required this.items,
    this.isFolderPage = false,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: onColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: onColor.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black, // Dark circle as requested
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: Center(
              child: Text(
                "$count",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: onColor.withValues(alpha: 0.7),
                fontSize: 12,
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
