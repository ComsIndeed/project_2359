import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    this.duration = const Duration(milliseconds: 400),
    this.curve = const Cubic(0.4, 0.0, 0.2, 1.12),
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
    final expandedHeight = screenSize.height * .7;

    // Before measurement, let the collapsed child render naturally so we can
    // grab its size. After measurement, always supply concrete dimensions.
    final bool hasMeasured = _collapsedSize != null;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use concrete dimensions if we have them, otherwise let it be null for measurement.
    final double? targetWidth = hasMeasured
        ? (_isOpen ? expandedWidth : _collapsedSize!.width)
        : null;
    final double? targetHeight = hasMeasured
        ? (_isOpen ? expandedHeight : _collapsedSize!.height)
        : null;

    return PopScope(
      canPop: !_isOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isOpen) {
          setState(() => _isOpen = false);
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            AnimatedScale(
              scale: _isOpen ? 0.98 : 1.0,
              duration: widget.duration,
              curve: widget.curve,
              child: AnimatedContainer(
                duration: widget.duration,
                curve: widget.curve,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_isOpen ? 32 : 0),
                ),
                child: widget.body,
              ),
            ),
            IgnorePointer(
              ignoring: !_isOpen,
              child: GestureDetector(
                onTap: () => setState(() => _isOpen = false),
                behavior: HitTestBehavior.opaque,
                child: AnimatedOpacity(
                  opacity: _isOpen ? 0.7 : 0.0,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Container(color: Colors.black),
                ),
              ),
            ),
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
                          theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.98,
                          ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.4 : 0.12,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                          spreadRadius: -2,
                        ),
                      ],
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha:
                                0.2, // Slightly more prominent than 0.1 used elsewhere
                          ),
                          width: 1.0, // Slightly thicker to stand out
                        ),
                      ),
                    ),
                    duration: widget.duration,
                    curve: widget.curve,
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isOpen
                            ? null
                            : () => setState(() => _isOpen = true),
                        child: Padding(
                          key: _isOpen ? null : _collapsedKey,
                          padding: EdgeInsets.all(_isOpen ? 8.0 : 16.0),
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedSwitcher(
                                duration: widget.duration,
                                layoutBuilder:
                                    (currentChild, previousChildren) => Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        ...previousChildren,
                                        ?currentChild,
                                      ],
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
