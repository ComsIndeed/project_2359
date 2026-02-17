import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

enum SourceIndexingStatus {
  none, // Not indexed
  indexing, // Is being indexed
  indexed, // Indexed
}

class SourceListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? accentColor;
  final SourceIndexingStatus status;

  const SourceListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = FontAwesomeIcons.fileLines,
    this.onTap,
    this.onDelete,
    this.accentColor,
    this.status = SourceIndexingStatus.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isIndexing = status == SourceIndexingStatus.indexing;

    // "Style" colors: strong highlights, no visible border
    // Highlight even more when indexing
    final backgroundColor = isDark
        ? Colors.white.withValues(alpha: isIndexing ? 0.15 : 0.1)
        : Colors.black.withValues(alpha: isIndexing ? 0.12 : 0.08);

    final borderColor = Colors.transparent;
    final bool isDisabled = onTap == null || isIndexing;

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Compact Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.black.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 12),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(
                            alpha: isIndexing ? 0.5 : 1.0,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (status != SourceIndexingStatus.none) ...[
                      const SizedBox(width: 8),
                      _buildStatusChip(context, cs, isDark),
                    ],
                  ],
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(
                        alpha: isIndexing ? 0.3 : 0.6,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Optional Delete / Action Button
          if (onDelete != null && !isIndexing)
            IconButton(
              onPressed: onDelete,
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                size: 14,
                color: cs.error.withValues(alpha: 0.6),
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else if (!isIndexing)
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 12,
              color: cs.onSurfaceVariant.withValues(alpha: 0.3),
            ),
        ],
      ),
    );

    // Apply shimmer effect if indexing
    if (isIndexing) {
      content = content
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: 1500.ms,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: PressableScale(
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onTap,
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: isDisabled && !isIndexing ? 0.5 : 1.0,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, ColorScheme cs, bool isDark) {
    final Color chipColor;
    final Color textColor;
    final String label;

    switch (status) {
      case SourceIndexingStatus.indexing:
        chipColor = AppTheme.warning.withValues(alpha: 0.15);
        textColor = AppTheme.warning;
        label = "Indexing...";
        break;
      case SourceIndexingStatus.indexed:
        chipColor = AppTheme.success.withValues(alpha: 0.15);
        textColor = AppTheme.success;
        label = "Indexed";
        break;
      case SourceIndexingStatus.none:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
