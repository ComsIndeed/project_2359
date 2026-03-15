import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// An expandable FAB that smoothly animates between collapsed and expanded sizes.
///
/// Uses [AnimatedSize] to automatically animate between whatever size the
/// current child (collapsed or expanded) occupies. When [expandedWidth] and/or
/// [expandedHeight] are provided the expanded content is forced to those exact
/// dimensions (static mode); when omitted the content sizes itself up to
/// sensible screen-based maximums (dynamic mode).
///
/// A [_SizeReporter] render object tracks each child's laid-out size and
/// exposes the values via [collapsedSize], [expandedSize], and their streams.
class ExpandableFab extends StatefulWidget {
  final Widget body;
  final Color? backgroundColor;
  final Duration duration;
  final Curve curve;
  final Widget collapsed;
  final Widget expanded;
  final double? expandedWidth;
  final double? expandedHeight;

  const ExpandableFab({
    required this.body,
    super.key,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutBack,
    required this.collapsed,
    required this.expanded,
    this.expandedWidth,
    this.expandedHeight,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isOpen = false;
  Size? _collapsedSize;
  Size? _expandedSize;

  final _collapsedSizeController = StreamController<Size>.broadcast();
  final _expandedSizeController = StreamController<Size>.broadcast();

  /// The last measured size of the collapsed widget content.
  Size? get collapsedSize => _collapsedSize;

  /// The last measured size of the expanded widget content.
  Size? get expandedSize => _expandedSize;

  /// Emits the collapsed widget's size whenever it changes.
  Stream<Size> get collapsedSizeStream => _collapsedSizeController.stream;

  /// Emits the expanded widget's size whenever it changes.
  Stream<Size> get expandedSizeStream => _expandedSizeController.stream;

  void _onCollapsedSizeChanged(Size size) {
    if (size != _collapsedSize) {
      setState(() => _collapsedSize = size);
      _collapsedSizeController.add(size);
    }
  }

  void _onExpandedSizeChanged(Size size) {
    if (size != _expandedSize) {
      _expandedSize = size;
      _expandedSizeController.add(size);
    }
  }

  @override
  void dispose() {
    _collapsedSizeController.close();
    _expandedSizeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Static mode: force exact dimensions. Dynamic mode: size to content
    // with screen-based max constraints.
    final Widget expandedChild;
    if (widget.expandedWidth != null || widget.expandedHeight != null) {
      expandedChild = SizedBox(
        width: widget.expandedWidth,
        height: widget.expandedHeight,
        child: widget.expanded,
      );
    } else {
      expandedChild = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * .9,
          maxHeight: screenSize.height * .7,
        ),
        child: widget.expanded,
      );
    }

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
                child: Container(
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
                          alpha: 0.2,
                        ),
                        width: 1.0,
                      ),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isOpen
                          ? null
                          : () => setState(() => _isOpen = true),
                      child: AnimatedPadding(
                        duration: widget.duration,
                        curve: widget.curve,
                        padding: EdgeInsets.all(_isOpen ? 4.0 : 16.0),
                        child: AnimatedSize(
                          duration: widget.duration,
                          curve: widget.curve,
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.antiAlias,
                          child: AnimatedSwitcher(
                            duration: widget.duration,
                            switchInCurve: widget.curve,
                            switchOutCurve: widget.curve,
                            layoutBuilder: (currentChild, previousChildren) =>
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    for (final child in previousChildren)
                                      Positioned(child: child),
                                    ?currentChild,
                                  ],
                                ),
                            child: _isOpen
                                ? KeyedSubtree(
                                    key: const ValueKey("expanded"),
                                    child: _SizeReporter(
                                      onSizeChanged: _onExpandedSizeChanged,
                                      child: expandedChild,
                                    ),
                                  )
                                : KeyedSubtree(
                                    key: const ValueKey("collapsed"),
                                    child: _SizeReporter(
                                      onSizeChanged: _onCollapsedSizeChanged,
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
        ),
      ),
    );
  }
}

/// Reports its child's rendered size whenever it changes.
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSizeChanged;

  const _SizeReporter({
    required this.onSizeChanged,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeReporter(onSizeChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSizeReporter renderObject,
  ) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  ValueChanged<Size> onSizeChanged;
  Size? _previousSize;

  _RenderSizeReporter(this.onSizeChanged);

  @override
  void performLayout() {
    super.performLayout();
    if (size != _previousSize) {
      _previousSize = size;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onSizeChanged(size);
      });
    }
  }
}
