import 'package:flutter/material.dart';

/// A wrapper that triggers a fade transition
/// when the triggered action is called.
class TapToFade extends StatelessWidget {
  final Widget page;
  final Widget Function(VoidCallback trigger) builder;
  final Duration duration;

  const TapToFade({
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
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubicEmphasized,
              ),
              child: child,
            );
          },
        ),
      );
    }

    return builder(trigger);
  }
}
