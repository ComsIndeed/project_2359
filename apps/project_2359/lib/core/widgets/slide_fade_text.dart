import 'package:flutter/material.dart';

class SlideFadeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const SlideFadeText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : textAlign == TextAlign.right
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeOutBack,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: textAlign == TextAlign.center
                ? Alignment.center
                : Alignment.centerLeft,
            children: [...previousChildren, ?currentChild],
          );
        },
        transitionBuilder: (child, animation) {
          final isEntering = child.key == ValueKey(text);

          final slideAnimation = Tween<Offset>(
            begin: isEntering
                ? const Offset(0.0, 0.15)
                : const Offset(0.0, -0.15),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
        child: Text(
          text,
          key: ValueKey(text),
          style: style,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
