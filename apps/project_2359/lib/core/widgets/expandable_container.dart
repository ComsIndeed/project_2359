import 'dart:ui';
import 'package:flutter/material.dart';

enum ExpandableContainerMode { dynamic, static }

class ExpandableContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final EdgeInsets boundaryMargins;
  final Widget Function(
    BuildContext context,
    ExpandableContainerController controller,
  )
  builder;
  final ExpandableContainerController? controller;
  final Alignment initialAlignment;

  const ExpandableContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubicEmphasized,
    required this.builder,
    this.controller,
    this.initialAlignment = Alignment.bottomCenter,
    this.boundaryMargins = const EdgeInsets.all(12),
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  late ExpandableContainerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        ExpandableContainerController(
          initialAlignment: widget.initialAlignment,
        );
    _controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(ExpandableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_rebuild);
      _controller =
          widget.controller ??
          ExpandableContainerController(
            initialAlignment: widget.initialAlignment,
          );
      _controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final color =
        _controller.color ??
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.7);
    final padding = _controller.padding ?? const EdgeInsets.all(12);
    final blur = _controller.blur ?? 10.0;

    return Stack(
      children: [
        widget.child,
        SizedBox.expand(
          child: Padding(
            padding: widget.boundaryMargins,
            child: AnimatedAlign(
              duration: widget.duration,
              alignment: _controller.alignment,
              curve: widget.curve,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: TweenAnimationBuilder<double>(
                  duration: widget.duration,
                  curve: widget.curve,
                  tween: Tween<double>(end: blur),
                  builder: (context, blurValue, child) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurValue,
                        sigmaY: blurValue,
                      ),
                      child: child!,
                    );
                  },
                  child: AnimatedContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      type: MaterialType.transparency,
                      child: AnimatedSize(
                        duration: widget.duration,
                        curve: widget.curve,
                        child: AnimatedPadding(
                          duration: widget.duration,
                          curve: widget.curve,
                          padding: padding,
                          child: (_controller.size == null)
                              ? widget.builder(context, _controller)
                              : AnimatedContainer(
                                  duration: widget.duration,
                                  curve: widget.curve,
                                  width: _controller.size!.$1,
                                  height: _controller.size!.$2,
                                  child: widget.builder(context, _controller),
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

class ExpandableContainerController extends ChangeNotifier {
  (double, double)? _size;
  Alignment _alignment;
  EdgeInsets? _padding;
  double? _blur;
  Color? _color;

  ExpandableContainerController({
    Alignment initialAlignment = Alignment.bottomCenter,
    EdgeInsets? padding,
    double? blur,
    Color? color,
  }) : _alignment = initialAlignment,
       _padding = padding,
       _blur = blur,
       _color = color;

  (double, double)? get size => _size;
  Alignment get alignment => _alignment;
  EdgeInsets? get padding => _padding;
  double? get blur => _blur;
  Color? get color => _color;

  void setSize({double? width, double? height}) {
    if (width != null && height != null) {
      _size = (width, height);
    } else {
      _size = null;
    }
    notifyListeners();
  }

  void setAlignment(Alignment alignment) {
    _alignment = alignment;
    notifyListeners();
  }

  void setPadding(EdgeInsets? padding) {
    _padding = padding;
    notifyListeners();
  }

  void setBlur(double? blur) {
    _blur = blur;
    notifyListeners();
  }

  void setColor(Color? color) {
    _color = color;
    notifyListeners();
  }

  void unsetSize() {
    _size = null;
    notifyListeners();
  }

  ExpandableContainerMode get mode => (_size != null)
      ? ExpandableContainerMode.static
      : ExpandableContainerMode.dynamic;
}
