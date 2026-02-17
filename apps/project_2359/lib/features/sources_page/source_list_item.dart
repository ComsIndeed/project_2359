import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

class SourceListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? accentColor;

  const SourceListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = FontAwesomeIcons.fileLines,
    this.onTap,
    this.onDelete,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // "Style" colors: strong highlights, no visible border
    final backgroundColor = isDark
        ? Colors.white.withValues(alpha: 0.1) // Stronger grey highlight
        : Colors.black.withValues(
            alpha: 0.08,
          ); // More pronounced dark highlight

    final borderColor = Colors.transparent; // Remove visible border

    final bool isDisabled = onTap == null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: PressableScale(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
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
                            Text(
                              title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle != null && subtitle!.isNotEmpty) ...[
                              const SizedBox(height: 1),
                              Text(
                                subtitle!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant.withValues(
                                    alpha: 0.6,
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
                      if (onDelete != null)
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
                      else
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 12,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
