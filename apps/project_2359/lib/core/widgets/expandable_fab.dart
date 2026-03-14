import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:project_2359/app_theme.dart';

/// An expandable FAB that smoothly animates between collapsed and expanded sizes.
///
/// Uses a [GlobalKey] to measure the collapsed child's natural size after the
/// first frame, so [AnimatedContainer] always has concrete start/end values to
/// interpolate — avoiding the snap that happens when going from `null` to a
/// concrete size.
class ExpandableFab extends StatefulWidget {
  final Widget body;
  final Color? backgroundColor;
  final Duration duration;
  final Curve curve;

  final Widget collapsed;
  final Widget expanded;

  const ExpandableFab({
    required this.body,
    super.key,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutBack,
    required this.collapsed,
    required this.expanded,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isOpen = false;
  final GlobalKey _collapsedKey = GlobalKey();
  Size? _collapsedSize;

  @override
  void initState() {
    super.initState();
    // Measure the collapsed child after the first frame is laid out.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _measureCollapsed();
    });
  }

  void _measureCollapsed() {
    final renderBox =
        _collapsedKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      setState(() {
        // Add a small buffer to account for border decoration consuming space.
        _collapsedSize = renderBox.size + const Offset(4, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final expandedWidth = screenSize.width * .9;
    final expandedHeight = screenSize.height * .5;

    // Before measurement, let the collapsed child render naturally so we can
    // grab its size. After measurement, always supply concrete dimensions.
    final bool hasMeasured = _collapsedSize != null;

    // Use concrete dimensions if we have them, otherwise let it be null for measurement.
    final double? targetWidth = hasMeasured
        ? (_isOpen ? expandedWidth : _collapsedSize!.width)
        : null;
    final double? targetHeight = hasMeasured
        ? (_isOpen ? expandedHeight : _collapsedSize!.height)
        : null;

    return Stack(
      children: [
        widget.body,
        AnimatedPositioned(
          bottom: _isOpen ? 8 : 24,
          left: 0,
          right: 0,
          duration: widget.duration,
          curve: widget.curve,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicWidth(
              child: AnimatedContainer(
                width: targetWidth,
                height: targetHeight,
                decoration: ShapeDecoration(
                  color:
                      widget.backgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                duration: widget.duration,
                curve: widget.curve,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => setState(() => _isOpen = !_isOpen),
                  child: Padding(
                    key: _isOpen ? null : _collapsedKey,
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRect(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: widget.duration,
                          child: _isOpen
                              ? KeyedSubtree(
                                  key: const ValueKey("expanded"),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: expandedWidth,
                                      maxHeight: expandedHeight,
                                    ),
                                    child: widget.expanded,
                                  ),
                                )
                              : KeyedSubtree(
                                  key: const ValueKey("collapsed"),
                                  child: widget.collapsed,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
