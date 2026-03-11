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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget itemContent = Padding(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (leading != null) ...[
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: IconTheme(
                data: IconThemeData(
                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
                  size: 18,
                ),
                child: leading!,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ] else if (onTap != null && showChevron) ...[
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ],
        ],
      ),
    );

    Widget content = Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: itemContent),
    );

    if (showDivider) {
      content = Column(
        children: [
          content,
          Padding(
            padding: EdgeInsets.only(left: leading != null ? 60 : 16),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ],
      );
    }

    if (isSingle) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: content,
        ),
      );
    }

    return content;
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
