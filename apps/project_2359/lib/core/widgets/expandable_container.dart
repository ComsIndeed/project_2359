import 'package:flutter/material.dart';

enum ExpandableContainerMode { collapsed, dynamic, freeform, fullscreen }

class ExpandableContainer extends StatelessWidget {
  final ExpandableContainerMode mode;
  final Widget body;
  final Widget expandedChild;
  final Widget collapsedChild;
  final double freeformHeightFactor;
  final double freeformWidthFactor;
  final Duration duration;
  final Curve curve;
  final EdgeInsets padding;
  final bool isLandscape;
  final VoidCallback? onCollapse;
  final VoidCallback? onExpand;

  const ExpandableContainer({
    super.key,
    required this.mode,
    required this.body,
    required this.expandedChild,
    required this.collapsedChild,
    this.freeformHeightFactor = 0.45,
    this.freeformWidthFactor = 0.35,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCubicEmphasized,
    this.padding = const EdgeInsets.all(16.0),
    this.isLandscape = false,
    this.onCollapse,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    double? top, bottom, left, right, width, height;
    double borderRadius = 24.0;

    switch (mode) {
      case ExpandableContainerMode.collapsed:
        if (isLandscape) {
          right = padding.right;
          top = screenSize.height * 0.25;
          bottom = screenSize.height * 0.25;
          width = 72;
        } else {
          bottom = padding.bottom;
          left = padding.left;
          right = padding.right;
          height = 72;
        }
        break;
      case ExpandableContainerMode.dynamic:
        if (isLandscape) {
          right = padding.right;
          top = padding.top + 80;
          bottom = padding.bottom + 20;
          width = screenSize.width * 0.3;
        } else {
          bottom = padding.bottom;
          left = padding.left;
          right = padding.right;
          height = screenSize.height * 0.4;
        }
        break;
      case ExpandableContainerMode.freeform:
        if (isLandscape) {
          right = padding.right;
          top = padding.top + 80;
          bottom = padding.bottom + 20;
          width = screenSize.width * freeformWidthFactor;
        } else {
          bottom = padding.bottom;
          left = padding.left;
          right = padding.right;
          height = screenSize.height * freeformHeightFactor;
        }
        break;
      case ExpandableContainerMode.fullscreen:
        top = 0;
        bottom = 0;
        left = 0;
        right = 0;
        borderRadius = 0;
        break;
    }

    return Stack(
      children: [
        body,
        if (mode == ExpandableContainerMode.fullscreen)
          GestureDetector(
            onTap: onCollapse,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: duration,
              child: Container(color: Colors.black54),
            ),
          ),
        AnimatedPositioned(
          duration: duration,
          curve: curve,
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          width: width,
          height: height,
          child: AnimatedContainer(
            duration: duration,
            curve: curve,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(
                mode == ExpandableContainerMode.fullscreen ? 1.0 : 0.96,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                width: 1.0,
              ),
              boxShadow: [
                if (mode != ExpandableContainerMode.fullscreen)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: curve,
                switchOutCurve: curve,
                child: mode == ExpandableContainerMode.collapsed
                    ? KeyedSubtree(
                        key: const ValueKey('collapsed'),
                        child: collapsedChild,
                      )
                    : KeyedSubtree(
                        key: const ValueKey('expanded'),
                        child: expandedChild,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
