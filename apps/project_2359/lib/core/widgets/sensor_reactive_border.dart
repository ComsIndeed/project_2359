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
  final bool isCircle;
  final Color? baseColor;
  final Color? shineColor;

  const SensorReactiveBorder({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.borderWidth = 2.0,
    this.colors,
    this.duration = const Duration(milliseconds: 300),
    this.innerColor,
    this.isCircle = false,
    this.baseColor,
    this.shineColor,
  });

  @override
  State<SensorReactiveBorder> createState() => _SensorReactiveBorderState();
}

class _SensorReactiveBorderState extends State<SensorReactiveBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription? _accelerometerSub;
  Offset _sensorOffset = Offset.zero;
  Offset _mouseOffset = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _accelerometerSub = accelerometerEventStream().listen((event) {
      if (mounted) {
        setState(() {
          // Sensitive tracking of phone orientation
          _sensorOffset = Offset(
            (_sensorOffset.dx * 0.6) + (event.x * 0.4),
            (_sensorOffset.dy * 0.6) + (event.y * 0.4),
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
    final isDark = theme.brightness == Brightness.dark;

    // Use provided shine color or default to theme-based bright/dark colors
    final shineColor = widget.shineColor ?? (isDark
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.black.withValues(alpha: 0.6));
    
    // Use provided base color or default to a dimmer version of the shine
    final baseBorderColor = widget.baseColor ?? shineColor.withValues(alpha: 0.3);

    final colors = widget.colors ?? [
      baseBorderColor,
      shineColor,
      baseBorderColor,
    ];

    // Combine inputs
    final combinedX = (_sensorOffset.dx * 1.5) + (_mouseOffset.dx * 5);
    final combinedY = (_sensorOffset.dy * 1.5) + (_mouseOffset.dy * 5);
    
    // 3D "Sun" effect logic: 
    // The sun is "high and to the west (left)".
    // We shift the light based on how the phone is pointing relative to that source.
    final horizontalShift = (-combinedX / 6) - 0.5; // Anchored slightly left
    final verticalShift = (combinedY / 6) - 0.8;    // Anchored high up

    // We use wide Alignment points (-2 to 2) to ensure only one "band" of light 
    // is visible on the border at any time, preventing double-highlights.
    final effectiveBegin = Alignment(horizontalShift - 1.5, verticalShift - 1.5);
    final effectiveEnd = Alignment(horizontalShift + 1.5, verticalShift + 1.5);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() {
        _isHovering = false;
        _mouseOffset = Offset.zero;
      }),
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localPos = box.globalToLocal(event.position);
          setState(() {
            _mouseOffset = Offset(
              (localPos.dx / box.size.width) * 2 - 1,
              (localPos.dy / box.size.height) * 2 - 1,
            );
          });
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _GradientBorderPainter(
              colors: colors,
              borderWidth: widget.borderWidth,
              borderRadius: widget.borderRadius,
              begin: effectiveBegin,
              end: effectiveEnd,
              // No more distracting rotation, just pure reactive light
              rotation: 0,
              isCircle: widget.isCircle,
            ),
            child: Container(
              decoration: ShapeDecoration(
                color: widget.innerColor,
                shape: widget.isCircle
                    ? const CircleBorder()
                    : ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                      ),
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }

  bool get hasActiveInput => _isHovering || _sensorOffset.distance > 0.1;
}

class _GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderWidth;
  final double borderRadius;
  final Alignment begin;
  final Alignment end;
  final double rotation;
  final bool isCircle;

  _GradientBorderPainter({
    required this.colors,
    required this.borderWidth,
    required this.borderRadius,
    required this.begin,
    required this.end,
    required this.rotation,
    this.isCircle = false,
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

    final path = isCircle
        ? (Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)))
        : ContinuousRectangleBorder(
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
        oldDelegate.rotation != rotation ||
        oldDelegate.isCircle != isCircle;
  }
}
