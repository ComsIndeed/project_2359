import 'package:flutter/material.dart';

enum SlideDirection {
  left, // Slides from Right to Left
  right, // Slides from Left to Right
  up, // Slides from Bottom to Top
  down, // Slides from Top to Bottom
  upLeft, // Slides from Bottom-Right to Top-Left
  upRight, // Slides from Bottom-Left to Top-Right
  downLeft, // Slides from Top-Right to Bottom-Left
  downRight, // Slides from Top-Left to Bottom-Right
}

enum NavigationType { push, pushReplacement, pushAndRemoveUntil }

/// A unified wrapper that triggers a slide transition in a specified direction.
class TapToSlide extends StatelessWidget {
  final Widget page;
  final Widget Function(VoidCallback trigger) builder;
  final SlideDirection direction;
  final NavigationType navigationType;
  final Duration duration;
  final bool Function(Route<dynamic>)? predicate;

  const TapToSlide({
    super.key,
    required this.page,
    required this.builder,
    this.direction = SlideDirection.left,
    this.navigationType = NavigationType.push,
    this.duration = const Duration(milliseconds: 300),
    this.predicate,
  });

  @override
  Widget build(BuildContext context) {
    void trigger() {
      final route = PageRouteBuilder(
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          switch (direction) {
            case SlideDirection.left:
              begin = const Offset(1.0, 0.0);
              break;
            case SlideDirection.right:
              begin = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.up:
              begin = const Offset(0.0, 1.0);
              break;
            case SlideDirection.down:
              begin = const Offset(0.0, -1.0);
              break;
            case SlideDirection.upLeft:
              begin = const Offset(1.0, 1.0);
              break;
            case SlideDirection.upRight:
              begin = const Offset(-1.0, 1.0);
              break;
            case SlideDirection.downLeft:
              begin = const Offset(1.0, -1.0);
              break;
            case SlideDirection.downRight:
              begin = const Offset(-1.0, -1.0);
              break;
          }
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOutCubicEmphasized));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );

      switch (navigationType) {
        case NavigationType.push:
          Navigator.of(context).push(route);
          break;
        case NavigationType.pushReplacement:
          Navigator.of(context).pushReplacement(route);
          break;
        case NavigationType.pushAndRemoveUntil:
          Navigator.of(
            context,
          ).pushAndRemoveUntil(route, predicate ?? (r) => r.isFirst);
          break;
      }
    }

    return builder(trigger);
  }
}
