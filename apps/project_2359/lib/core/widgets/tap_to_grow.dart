import 'package:flutter/material.dart';

class TapToGrow extends StatelessWidget {
  final Widget page;
  final Widget Function(VoidCallback trigger) builder;
  final Duration duration;

  const TapToGrow({
    super.key,
    required this.page,
    required this.builder,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    // This is the function we pass to your button
    void trigger() {
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      // 1. Get the coordinates of the wrapper widget
      final Offset position = box.localToGlobal(Offset.zero);
      final Size size = box.size;
      final Size screenSize = MediaQuery.of(context).size;

      // 2. Calculate the alignment (-1.0 to 1.0)
      final double centerX = position.dx + size.width / 2;
      final double centerY = position.dy + size.height / 2;

      final Alignment alignment = Alignment(
        (centerX / screenSize.width) * 2 - 1,
        (centerY / screenSize.height) * 2 - 1,
      );

      // 3. Push the route with the alignment
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (ctx, anim, secAnim, child) {
            return ScaleTransition(
              alignment: alignment,
              scale: CurvedAnimation(parent: anim, curve: Curves.easeOutExpo),
              child: child,
            );
          },
        ),
      );
    }

    return builder(trigger);
  }
}
