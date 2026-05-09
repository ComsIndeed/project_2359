import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class DotGridBackground extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final ValueListenable<Matrix4>? transform;

  const DotGridBackground({
    super.key,
    this.child,
    this.backgroundColor,
    this.transform,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor = (isDark ? Colors.white : Colors.black).withOpacity(0.2);

    final primaryBg =
        backgroundColor ??
        (isDark ? const Color(0xFF0F1115) : const Color(0xFFF8F9FA));
    final secondaryBg = isDark
        ? const Color(0xFF090A0C)
        : const Color(0xFFF1F3F5);

    final localTransform = transform;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.5),
          radius: 1.2,
          colors: [primaryBg, secondaryBg],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: localTransform != null
                ? ListenableBuilder(
                    listenable: localTransform,
                    builder: (context, _) {
                      Matrix4 matrix;
                      try {
                        matrix = localTransform.value;
                      } catch (_) {
                        matrix = Matrix4.identity();
                      }
                      return CustomPaint(
                        painter: _DotGridPainter(
                          dotColor: dotColor,
                          transform: matrix,
                        ),
                      );
                    },
                  )
                : CustomPaint(
                    painter: _DotGridPainter(dotColor: dotColor),
                  ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double dotSize;
  final Matrix4? transform;

  _DotGridPainter({
    required this.dotColor,
    this.spacing = 32.0,
    this.dotSize = 2.0,
    this.transform,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final localMatrix = transform;
    if (localMatrix != null) {
      canvas.save();
      canvas.transform(localMatrix.storage);
    }

    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Expand the grid range to cover the potentially panned/zoomed area
    // We calculate the visible bounds in the transformed space
    double left = 0;
    double top = 0;
    double right = size.width;
    double bottom = size.height;

    if (localMatrix != null) {
      final inverse = Matrix4.inverted(localMatrix);
      final topLeft = inverse.transformPoint(Offset.zero);
      final bottomRight = inverse.transformPoint(
        Offset(size.width, size.height),
      );

      left = topLeft.dx - spacing;
      top = topLeft.dy - spacing;
      right = bottomRight.dx + spacing;
      bottom = bottomRight.dy + spacing;
    }

    for (double x = (left / spacing).floor() * spacing;
        x < right;
        x += spacing) {
      for (double y = (top / spacing).floor() * spacing;
          y < bottom;
          y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }

    if (localMatrix != null) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.transform != transform;
  }
}

extension on Matrix4 {
  Offset transformPoint(Offset offset) {
    final Vector3 transformed = transform3(Vector3(offset.dx, offset.dy, 0));
    return Offset(transformed.x, transformed.y);
  }
}
