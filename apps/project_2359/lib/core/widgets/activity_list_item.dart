import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

class ActivityListItem extends StatefulWidget {
  final Widget? icon;
  final Widget? title;
  final Widget? subtitle;
  final Color? accentColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isCompact;
  final bool showChevron;
  final bool isLoading;
  final double bottomMargin;

  const ActivityListItem({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.accentColor,
    this.onTap,
    this.padding,
    this.isCompact = false,
    this.showChevron = true,
    this.isLoading = false,
    this.bottomMargin = 12,
  });

  @override
  State<ActivityListItem> createState() => _ActivityListItemState();
}

class _ActivityListItemState extends State<ActivityListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(ActivityListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _shimmerController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = widget.accentColor ?? cs.primary;
    final bool isDisabled = widget.onTap == null && !widget.isLoading;
    final contentPadding =
        widget.padding ?? EdgeInsets.all(widget.isCompact ? 12.0 : 16.0);
    final double iconContainerPadding = widget.isCompact ? 8 : 10;
    final double iconSize = widget.isCompact ? 20 : 24;
    final double skeletonIconSize = widget.isCompact ? 36 : 44;

    return Card(
      margin: EdgeInsets.only(bottom: widget.bottomMargin),
      child: PressableScale(
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: widget.isLoading
                    ? _buildShimmerGradient(_shimmerAnimation.value, cs.surface)
                    : null,
              ),
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onTap,
              customBorder: AppTheme.cardShape,
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1.0,
                child: Padding(
                  padding: contentPadding,
                  child: Row(
                    children: [
                      if (widget.isLoading)
                        _buildSkeletonIcon(skeletonIconSize, cs.surface)
                      else if (widget.icon != null)
                        Container(
                          padding: EdgeInsets.all(iconContainerPadding),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: IconTheme(
                            data: IconThemeData(color: accent, size: iconSize),
                            child: widget.icon!,
                          ),
                        ),

                      SizedBox(width: widget.isCompact ? 12 : 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isLoading)
                              _buildSkeletonText(
                                width: 0.6,
                                height: 16,
                                surfaceColor: cs.surface,
                              )
                            else if (widget.title != null)
                              DefaultTextStyle(
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ) ??
                                    const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: widget.title!,
                              ),
                            SizedBox(height: widget.isCompact ? 2 : 4),
                            if (widget.isLoading)
                              _buildSkeletonText(
                                width: 0.4,
                                height: 14,
                                surfaceColor: cs.surface,
                              )
                            else if (widget.subtitle != null)
                              DefaultTextStyle(
                                style:
                                    Theme.of(context).textTheme.bodyMedium ??
                                    const TextStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: widget.subtitle!,
                              ),
                          ],
                        ),
                      ),

                      if (widget.showChevron && !widget.isLoading)
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: cs.onSurface.withValues(alpha: 0.5),
                          size: widget.isCompact ? 14 : 16,
                        ),
                      if (widget.isLoading) _buildSkeletonChevron(cs.surface),
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

  LinearGradient _buildShimmerGradient(double animationValue, Color surface) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        surface.withValues(alpha: 0.3),
        surface.withValues(alpha: 0.5),
        Colors.white.withValues(alpha: 0.15),
        surface.withValues(alpha: 0.5),
        surface.withValues(alpha: 0.3),
      ],
      stops: [
        0.0,
        (animationValue - 0.3).clamp(0.0, 1.0),
        animationValue.clamp(0.0, 1.0),
        (animationValue + 0.3).clamp(0.0, 1.0),
        1.0,
      ],
    );
  }

  Widget _buildSkeletonIcon(double size, Color surface) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildSkeletonText({
    required double width,
    required double height,
    required Color surfaceColor,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * width,
          height: height,
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(height / 2),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonChevron(Color surface) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
