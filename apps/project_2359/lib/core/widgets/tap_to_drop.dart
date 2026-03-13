import 'package:flutter/material.dart';

enum DropDirection { up, down, left, right }

/// A transition wrapper that makes the new page "drop" into place.
/// It starts slightly scaled up and offset, then settles with physics.
class TapToDrop extends StatelessWidget {
  final Widget page;
  final Widget Function(VoidCallback trigger) builder;
  final DropDirection direction;
  final Duration duration;

  const TapToDrop({
    super.key,
    required this.page,
    required this.builder,
    this.direction = DropDirection.up,
    this.duration = const Duration(milliseconds: 550),
  });

  @override
  Widget build(BuildContext context) {
    void trigger() {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          opaque: false,
          barrierColor: Colors.black.withValues(alpha: 0.1),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case DropDirection.up:
                begin = const Offset(0.0, 0.08);
                break;
              case DropDirection.down:
                begin = const Offset(0.0, -0.08);
                break;
              case DropDirection.left:
                begin = const Offset(0.08, 0.0);
                break;
              case DropDirection.right:
                begin = const Offset(-0.08, 0.0);
                break;
            }

            // Using easeOutBack for a premium "drop and settle" feel
            const mainCurve = Curves.easeOutBack;

            final slideAnimation = Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: mainCurve));

            final scaleAnimation = Tween<double>(
              begin: 1.12,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: mainCurve));

            final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
                  ),
                );

            return FadeTransition(
              opacity: opacityAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                alignment: Alignment.center,
                child: SlideTransition(position: slideAnimation, child: child),
              ),
            );
          },
        ),
      );
    }

    return builder(trigger);
  }
}
