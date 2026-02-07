import 'package:flutter/material.dart';

/// A wrapper that triggers a slide-up transition (moves from bottom to top)
/// when the triggered action is called.
class TapToSlideUp extends StatelessWidget {
  final Widget page;
  final Widget Function(VoidCallback trigger) builder;
  final Duration duration;

  const TapToSlideUp({
    super.key,
    required this.page,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    void trigger() {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOutCubicEmphasized));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }

    return builder(trigger);
  }
}
