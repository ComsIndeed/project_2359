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
    final onImportantColor = Colors.black87; // Good contrast on pastel red

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$totalDue Cards Due",
          style: theme.textTheme.titleMedium?.copyWith(
            color: onImportantColor,
            fontWeight: FontWeight.w900,
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
                onColor: onImportantColor,
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
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: Center(
              child: Text(
                "$count",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: onColor,
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
