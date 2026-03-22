import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorReactiveBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final List<Color>? colors;
  final Duration duration;
  final Color? innerColor;

  const SensorReactiveBorder({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.borderWidth = 2.0,
    this.colors,
    this.duration = const Duration(milliseconds: 300),
    this.innerColor,
  });

  @override
  State<SensorReactiveBorder> createState() => _SensorReactiveBorderState();
}

class _SensorReactiveBorderState extends State<SensorReactiveBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription? _accelerometerSub;
  Offset _sensorOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _accelerometerSub = accelerometerEventStream().listen((event) {
      if (mounted) {
        setState(() {
          // Subtle movement
          _sensorOffset = Offset(
            (_sensorOffset.dx * 0.9) + (event.x * 0.1),
            (_sensorOffset.dy * 0.9) + (event.y * 0.1),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _accelerometerSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.primary,
    ];

    final colors = widget.colors ?? defaultColors;

    final alignment = Alignment(
      (_sensorOffset.dx / 10).clamp(-1.0, 1.0),
      (_sensorOffset.dy / 10).clamp(-1.0, 1.0),
    );

    final hasSensor = alignment.x != 0 || alignment.y != 0;
    final effectiveBegin = hasSensor ? alignment : Alignment.topLeft;
    final effectiveEnd = hasSensor
        ? Alignment(-alignment.x, -alignment.y)
        : Alignment.bottomRight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GradientBorderPainter(
            colors: colors,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            begin: effectiveBegin,
            end: effectiveEnd,
            rotation: _controller.value * 2 * 3.141592653589793,
          ),
          child: Container(
            decoration: ShapeDecoration(
              color: widget.innerColor,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final double borderRadius;
  final Alignment begin;
  final Alignment end;
  final double rotation;

  _GradientBorderPainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    required this.begin,
    required this.end,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0) return;

    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        transform: GradientRotation(rotation),
      ).createShader(rect);

    final path = ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ).getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));

    // We need to handle the stroke alignment for paths.
    // Usually drawing the path with a stroke paint works fine.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.begin != begin ||
        oldDelegate.rotation != rotation;
  }
}
