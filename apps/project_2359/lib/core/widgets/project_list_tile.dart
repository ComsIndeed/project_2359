import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'tap_to_fade.dart';
import 'tap_to_grow.dart';
import 'tap_to_slide.dart';
import 'tap_to_drop.dart';

enum ProjectTransitionType {
  fade,
  grow,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  slideLeftUp,
  slideLeftDown,
  slideRightUp,
  slideRightDown,
  dropUp,
  dropDown,
  dropLeft,
  dropRight,
}

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
  final bool isAlert;
  final Widget? targetPage;
  final ProjectTransitionType? transitionType;
  final bool isSelected;
  final bool isSelecting;
  final bool isCompact;
  final VoidCallback? onLongPress;

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
    this.targetPage,
    this.transitionType,
    this.isSelected = false,
    this.isSelecting = false,
    this.isCompact = false,
    this.onLongPress,
  });

  /// Shorthand constructor for a simple text-based tile
  factory ProjectListTile.simple({
    Key? key,
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
    Widget? targetPage,
    ProjectTransitionType? transitionType,
    bool isSelected = false,
    bool isSelecting = false,
    VoidCallback? onLongPress,
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
      targetPage: targetPage,
      transitionType: transitionType,
      isSelected: isSelected,
      isSelecting: isSelecting,
      onLongPress: onLongPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (targetPage != null && transitionType != null) {
      if (isSelecting) {
        return _buildTile(context, onTap);
      }

      void effectiveOnTap() {
        onTap?.call();
      }

      switch (transitionType!) {
        case ProjectTransitionType.fade:
          return TapToFade(
            page: targetPage!,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.grow:
          return TapToGrow(
            page: targetPage!,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideUp:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.up,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideDown:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.down,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideLeft:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.left,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideRight:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.right,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideLeftUp:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.upLeft,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideLeftDown:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.downLeft,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideRightUp:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.upRight,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.slideRightDown:
          return TapToSlide(
            page: targetPage!,
            direction: SlideDirection.downRight,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.dropUp:
          return TapToDrop(
            page: targetPage!,
            direction: DropDirection.up,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.dropDown:
          return TapToDrop(
            page: targetPage!,
            direction: DropDirection.down,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.dropLeft:
          return TapToDrop(
            page: targetPage!,
            direction: DropDirection.left,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
        case ProjectTransitionType.dropRight:
          return TapToDrop(
            page: targetPage!,
            direction: DropDirection.right,
            builder: (trigger) => _buildTile(context, () {
              effectiveOnTap();
              trigger();
            }),
          );
      }
    }

    return _buildTile(context, onTap);
  }

  Widget _buildTile(BuildContext context, VoidCallback? onTap) {
    final theme = Theme.of(context);

    // Decoration logic
    final effectiveBgColor = isSelected
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : (backgroundColor ?? Colors.transparent);
    final borderRadius = isSingle ? BorderRadius.circular(24) : null;

    Widget innerContent = Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: 16, vertical: isCompact ? 8 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 18,
                    ),
                    child: leading!,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.9,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        child: subtitle!,
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
              ] else if (isSelecting) ...[
                const SizedBox(width: 12),
                _AnimatedCheckbox(isSelected: isSelected),
              ] else if (onTap != null && showChevron) ...[
                const SizedBox(width: 12),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
        onLongPress: onLongPress,
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
      return Material(
        color: theme.colorScheme.surface,
        shape: AppTheme.cardShape,
        clipBehavior: Clip.antiAlias,
        child: content,
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
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: backgroundColor ?? theme.colorScheme.surface,
        shape: AppTheme.cardShape,
        clipBehavior: Clip.antiAlias,
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  final bool isSelected;
  const _AnimatedCheckbox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: FaIcon(
        isSelected ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
        key: ValueKey(isSelected),
        size: 20,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}
