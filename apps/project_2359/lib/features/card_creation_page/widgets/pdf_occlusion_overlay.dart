import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PdfOcclusionOverlay extends StatefulWidget {
  final PdfViewerController controller;
  final CardCreationToolbarController toolbarController;

  const PdfOcclusionOverlay({
    super.key,
    required this.controller,
    required this.toolbarController,
  });

  @override
  State<PdfOcclusionOverlay> createState() => _PdfOcclusionOverlayState();
}

class _PdfOcclusionOverlayState extends State<PdfOcclusionOverlay> {
  Offset? _startPos;
  Offset? _currentPos;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _startPos = details.localPosition;
          _currentPos = details.localPosition;
          _isDragging = true;
          widget.toolbarController.updateOcclusionRect(null);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentPos = details.localPosition;
        });
      },
      onPanEnd: (details) {
        if (_startPos != null && _currentPos != null) {
          final rect = Rect.fromPoints(_startPos!, _currentPos!);
          if (rect.width > 5 && rect.height > 5) {
            widget.toolbarController.updateOcclusionRect(rect);
          }
        }
        setState(() {
          _isDragging = false;
        });
      },
      child: ListenableBuilder(
        listenable: widget.toolbarController,
        builder: (context, _) {
          final selectionRect = widget.toolbarController.occlusionRect;
          final currentRect =
              (_isDragging && _startPos != null && _currentPos != null)
              ? Rect.fromPoints(_startPos!, _currentPos!)
              : selectionRect;

          return Stack(
            children: [
              // Grey Overlay with hole
              CustomPaint(
                size: Size.infinite,
                painter: _OcclusionOverlayPainter(
                  holeRect: currentRect,
                  isDragging: _isDragging,
                ),
              ),

              // Helper Text
              if (currentRect == null && !_isDragging)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Drag to select an area",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().fadeIn().scale(),
                ),

              // UI for the finalized selection
              if (selectionRect != null && !_isDragging) ...[
                // Handles (Visual only for now, can be made functional later)
                _buildHandle(selectionRect.topLeft),
                _buildHandle(selectionRect.topRight),
                _buildHandle(selectionRect.bottomLeft),
                _buildHandle(selectionRect.bottomRight),

                // Context Menu / Action Button
                Positioned(
                  left: selectionRect.center.dx - 60,
                  top: selectionRect.bottom + 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _captureSelection,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildHandle(Offset pos) {
    return Positioned(
      left: pos.dx - 6,
      top: pos.dy - 6,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _captureSelection() async {
    final rect = widget.toolbarController.occlusionRect;
    if (rect == null) return;

    // 1. Convert local Rect to Document Rect
    // We already have rect. We'll use the current zoom to find the document-space size.

    // This is a bit simplified. pdfrx has better ways to handle this.
    // Let's use the provided coordinate conversion extensions.

    final hit = widget.controller.getPdfPageHitTestResult(
      rect.center,
      useDocumentLayoutCoordinates: false,
    );
    if (hit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selection must be over a page")),
      );
      return;
    }

    // Get the page layout to find where it is in document coords
    final pageLayout =
        widget.controller.layout.pageLayouts[hit.page.pageNumber - 1];

    // Selection Rect in document coordinates (relative to the viewer origin)
    final docRect =
        widget.controller.localToDocument(rect.topLeft) &
        Size(
          rect.width / widget.controller.currentZoom,
          rect.height / widget.controller.currentZoom,
        );

    // Calculate relative selection within the page in PDF points (72dpi)
    // Document coords are same as PDF points for scale=1.0
    final relativeRect = Rect.fromLTWH(
      docRect.left - pageLayout.left,
      docRect.top - pageLayout.top,
      docRect.width,
      docRect.height,
    );

    try {
      // PdfPage.render usually expects top-left origin for x,y at fullWidth/fullHeight scale
      final image = await hit.page.render(
        x: relativeRect.left.toInt(),
        y: relativeRect.top.toInt(),
        width: relativeRect.width.toInt(),
        height: relativeRect.height.toInt(),
        fullWidth: hit.page.width,
        fullHeight: hit.page.height,
      );

      if (image != null) {
        final uiImage = await image.createImage();
        final byteData = await uiImage.toByteData(format: ImageByteFormat.png);
        if (byteData != null) {
          widget.toolbarController.setCapturedOcclusionImage(
            byteData.buffer.asUint8List(),
          );
          // Switch to a preview mode or show it in the toolbar
          widget.toolbarController.setMode(
            CardCreationToolbarMode.cardCreation,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to capture: $e")));
      }
    }
  }
}

class _OcclusionOverlayPainter extends CustomPainter {
  final Rect? holeRect;
  final bool isDragging;

  _OcclusionOverlayPainter({this.holeRect, required this.isDragging});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: isDragging ? 0.3 : 0.6);

    if (holeRect == null) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(holeRect!),
    );
    canvas.drawPath(path, paint);

    // Draw selection border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(holeRect!, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _OcclusionOverlayPainter oldDelegate) {
    return oldDelegate.holeRect != holeRect ||
        oldDelegate.isDragging != isDragging;
  }
}
