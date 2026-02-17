import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

enum SourceIndexingStatus {
  none, // Not indexed
  indexing, // Is being indexing
  indexed, // Indexed
}

class SourceListItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? accentColor;
  final SourceIndexingStatus initialStatus;

  const SourceListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = FontAwesomeIcons.fileLines,
    this.onTap,
    this.onDelete,
    this.accentColor,
    this.initialStatus = SourceIndexingStatus.none,
  });

  @override
  State<SourceListItem> createState() => _SourceListItemState();
}

class _SourceListItemState extends State<SourceListItem> {
  late SourceIndexingStatus status;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
  }

  void _startIndexing() async {
    if (status != SourceIndexingStatus.none) return;

    setState(() {
      status = SourceIndexingStatus.indexing;
    });

    // TODO: Handle actual indexing logic with LLM
    // For now, simulate a delay and then set to indexed
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        status = SourceIndexingStatus.indexed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isIndexing = status == SourceIndexingStatus.indexing;

    // Background colors
    final backgroundColor = isDark
        ? Colors.white.withValues(alpha: isIndexing ? 0.15 : 0.1)
        : Colors.black.withValues(alpha: isIndexing ? 0.12 : 0.08);

    Widget itemContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              widget.icon,
              size: 18,
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
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(
                      alpha: isIndexing ? 0.5 : 1.0,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
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

          const SizedBox(width: 12),

          // Action Area with smooth transition
          AnimatedSwitcher(
            duration: 400.ms,
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _buildStatusArea(context, cs, isDark),
          ),
        ],
      ),
    );

    if (isIndexing) {
      itemContent = itemContent
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
        onTap: isIndexing ? null : widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isIndexing ? null : widget.onTap,
              borderRadius: BorderRadius.circular(20),
              child: itemContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusArea(BuildContext context, ColorScheme cs, bool isDark) {
    // We use Keys to help AnimatedSwitcher identify different widgets
    switch (status) {
      case SourceIndexingStatus.none:
        return _buildChip(
          key: const ValueKey('none'),
          context: context,
          cs: cs,
          isDark: isDark,
          label: "Index",
          icon: FontAwesomeIcons.magnifyingGlassChart,
          onTap: _startIndexing,
          highlighted: true,
        );
      case SourceIndexingStatus.indexing:
        return _buildChip(
          key: const ValueKey('indexing'),
          context: context,
          cs: cs,
          isDark: isDark,
          label: "Indexing",
          color: AppTheme.warning,
          isGhost: true,
        );
      case SourceIndexingStatus.indexed:
        return Row(
          key: const ValueKey('indexed_area'),
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChip(
              context: context,
              cs: cs,
              isDark: isDark,
              label: "Indexed",
              color: AppTheme.success,
              isGhost: true,
            ),
            if (widget.onDelete != null) ...[
              const SizedBox(width: 4),
              IconButton(
                onPressed: widget.onDelete,
                icon: FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: 14,
                  color: cs.error.withValues(alpha: 0.6),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        );
    }
  }

  Widget _buildChip({
    Key? key,
    required BuildContext context,
    required ColorScheme cs,
    required bool isDark,
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    Color? color,
    bool highlighted = false,
    bool isGhost = false,
  }) {
    final textColor = color ?? cs.onSurface.withValues(alpha: 0.8);
    final bgColor = isGhost
        ? (color ?? cs.onSurface).withValues(alpha: 0.1)
        : highlighted
        ? (isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.12))
        : (isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08));

    Widget chip = Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isGhost
            ? Border.all(color: textColor.withValues(alpha: 0.2), width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            FaIcon(icon, size: 10, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return PressableScale(onTap: onTap, child: chip);
    }

    return chip;
  }
}
