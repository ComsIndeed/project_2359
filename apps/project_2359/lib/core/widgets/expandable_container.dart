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

  const ExpandableContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    required this.builder,
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  ExpandableContainerMode mode = ExpandableContainerMode.dynamic;
  final controller = ExpandableContainerController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: widget.duration,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: AnimatedSize(
              duration: widget.duration,
              child: mode == ExpandableContainerMode.dynamic
                  ? widget.builder(context, controller)
                  : AnimatedContainer(
                      duration: widget.duration,
                      width: controller.size?.$1,
                      height: controller.size?.$2,
                      child: widget.builder(context, controller),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandableContainerController extends ChangeNotifier {
  (double, double)? size;

  void setSize({double? width, double? height}) {
    if (width != null && height != null) {
      size = (width, height);
    } else {
      size = null;
    }
    notifyListeners();
  }

  void unsetSize() {
    size = null;
    notifyListeners();
  }

  ExpandableContainerMode get mode => (size != null)
      ? ExpandableContainerMode.dynamic
      : ExpandableContainerMode.static;
}
