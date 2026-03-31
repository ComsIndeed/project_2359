import 'dart:ui';
import 'package:flutter/material.dart';

enum ExpandableContainerMode { dynamic, static }

class ExpandableContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
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
    this.duration = const Duration(milliseconds: 300),
    required this.builder,
    this.controller,
    this.initialAlignment = Alignment.bottomCenter,
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
    return Stack(
      children: [
        widget.child,
        AnimatedAlign(
          duration: widget.duration,
          alignment: _controller.alignment,
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.7),
                elevation: 8,
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedSize(
                  duration: widget.duration,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: (_controller.size == null)
                        ? widget.builder(context, _controller)
                        : AnimatedContainer(
                            duration: widget.duration,
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
      ],
    );
  }
}

class ExpandableContainerController extends ChangeNotifier {
  (double, double)? _size;
  Alignment _alignment;

  ExpandableContainerController({
    Alignment initialAlignment = Alignment.bottomCenter,
  }) : _alignment = initialAlignment;

  (double, double)? get size => _size;
  Alignment get alignment => _alignment;

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

  void unsetSize() {
    _size = null;
    notifyListeners();
  }

  ExpandableContainerMode get mode => (_size != null)
      ? ExpandableContainerMode.static
      : ExpandableContainerMode.dynamic;
}
