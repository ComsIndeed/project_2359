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
        _TapToGrowRoute(page: page, alignment: alignment, duration: duration),
      );
    }

    return builder(trigger);
  }
}

/// Custom route that supports predictive back while keeping the scale-from-origin
/// animation when pushing. Uses the theme's page transitions for pop animations.
class _TapToGrowRoute<T> extends PageRoute<T> {
  final Widget page;
  final Alignment alignment;
  final Duration duration;

  _TapToGrowRoute({
    required this.page,
    required this.alignment,
    required this.duration,
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = Theme.of(context).pageTransitionsTheme;

    // Get the platform's transition builder from the theme
    // This will be PredictiveBackPageTransitionsBuilder on Android
    final platformTransitionBuilder =
        theme.builders[Theme.of(context).platform];

    // For the pop animation (when animation is reversing), use the theme's
    // transition builder to support predictive back
    if (animation.status == AnimationStatus.reverse) {
      if (platformTransitionBuilder != null) {
        return platformTransitionBuilder.buildTransitions(
          this,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      }
    }

    // For the push animation, use our custom scale animation
    return ScaleTransition(
      alignment: alignment,
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutExpo,
        reverseCurve: Curves.easeInOut,
      ),
      child: child,
    );
  }
}
