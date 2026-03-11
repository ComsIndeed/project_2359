import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A reusable list tile widget that follows the project's iOS-inspired
/// grouped layout and border rules.
class ProjectListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isSingle;
  final EdgeInsetsGeometry? padding;
  final bool showChevron;
  final Color? backgroundColor;
  final String? date;
  final List<({String label, IconData icon})>? sources;
  final Widget? expandedContent;
  final String? emoji;
  final bool isAlert;
  final int? dueCount;

  const ProjectListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.isSingle = false,
    this.padding,
    this.showChevron = true,
    this.backgroundColor,
    this.date,
    this.sources,
    this.isAlert = false,
    this.expandedContent,
    this.emoji,
    this.dueCount,
  });

  /// Shorthand constructor for a simple text-based tile
  factory ProjectListTile.simple({
    key,
    required String label,
    String? subLabel,
    IconData? icon,
    VoidCallback? onTap,
    bool showDivider = false,
    bool isSingle = false,
    Widget? trailing,
    bool showChevron = true,
    Color? backgroundColor,
    String? date,
    List<({String label, IconData icon})>? sources,
    bool isAlert = false,
    Widget? expandedContent,
    String? emoji,
    int? dueCount,
  }) {
    return ProjectListTile(
      key: key,
      title: Text(label),
      subtitle: subLabel != null ? Text(subLabel) : null,
      leading: icon != null ? FaIcon(icon, size: 18) : null,
      trailing: trailing,
      onTap: onTap,
      showDivider: showDivider,
      isSingle: isSingle,
      showChevron: showChevron,
      backgroundColor: backgroundColor,
      date: date,
      sources: sources,
      isAlert: isAlert,
      expandedContent: expandedContent,
      emoji: emoji,
      dueCount: dueCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Decoration logic
    final effectiveBgColor = backgroundColor ?? Colors.transparent;
    final borderRadius = isSingle ? BorderRadius.circular(16) : null;

    Widget innerContent = Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: DefaultTextStyle(
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.9,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        child: title,
                      ),
                    ),
                    if (dueCount != null && dueCount! > 0) ...[
                      const SizedBox(width: 8),
                      // Small indicator
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            size: 9,
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "$dueCount",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (date != null) ...[
                const SizedBox(width: 8),
                Text(
                  date!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else if (onTap != null && showChevron) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ],
            ],
          ),
          if (sources != null && sources!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (
                  int i = 0;
                  i < (sources!.length > 3 ? 3 : sources!.length);
                  i++
                )
                  if (i < 2 || sources!.length == 3)
                    _SourceChip(
                      label: sources![i].label,
                      icon: sources![i].icon,
                    )
                  else
                    _SourceChip(label: "+${sources!.length - 2} more"),
              ],
            ),
          ] else if (subtitle != null) ...[
            const SizedBox(height: 4),
            DefaultTextStyle(
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              child: subtitle!,
            ),
          ],
          if (isAlert && expandedContent != null) ...[
            const SizedBox(height: 12),
            expandedContent!,
          ],
        ],
      ),
    );

    Widget content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: borderRadius,
          ),
          child: innerContent,
        ),
      ),
    );

    if (showDivider) {
      content = Column(
        children: [
          content,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
        ],
      );
    }

    if (isSingle) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _SourceChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _SourceChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: FaIcon(
                icon!,
                size: 9,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

/// A helper widget to wrap multiple [ProjectListTile]s in a grouped container.
class ProjectListGroup extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const ProjectListGroup({
    super.key,
    required this.children,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
