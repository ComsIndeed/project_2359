import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ImageOcclusionEditor extends StatefulWidget {
  final CardCreationToolbarController controller;
  const ImageOcclusionEditor({super.key, required this.controller});

  @override
  State<ImageOcclusionEditor> createState() => _ImageOcclusionEditorState();
}

class _ImageOcclusionEditorState extends State<ImageOcclusionEditor> {
  final List<Rect> _boxes = [];
  Rect? _currentBox;
  Offset? _startPos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final imageBytes = widget.controller.capturedOcclusionImage;

    if (imageBytes == null) {
      return const Center(child: Text("No image captured"));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.layers_outlined, size: 14, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              "IMAGE OCCLUSION",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.1),

        const SizedBox(height: 12),

        // Image Editor Area
        LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _startPos = details.localPosition;
                      _currentBox = Rect.fromPoints(_startPos!, _startPos!);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (_startPos != null) {
                        _currentBox = Rect.fromPoints(
                          _startPos!,
                          details.localPosition,
                        );
                      }
                    });
                  },
                  onPanEnd: (details) {
                    if (_currentBox != null &&
                        _currentBox!.width > 5 &&
                        _currentBox!.height > 5) {
                      setState(() {
                        _boxes.add(_currentBox!);
                        _currentBox = null;
                      });
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.memory(
                          imageBytes,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth,
                        ),

                        // Existing Boxes
                        ..._boxes.map(
                          (rect) => Positioned.fromRect(
                            rect: rect,
                            child: _buildOcclusionBox(cs),
                          ),
                        ),

                        // Current Dragging Box
                        if (_currentBox != null)
                          Positioned.fromRect(
                            rect: _currentBox!,
                            child: _buildOcclusionBox(cs, isCurrent: true),
                          ),

                        // Instructions Overlay (fades out when boxes exist)
                        if (_boxes.isEmpty && _currentBox == null)
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Draw boxes to hide content",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
            .animate()
            .fadeIn(delay: 100.ms)
            .scale(begin: const Offset(0.98, 0.98)),

        const SizedBox(height: 16),

        // Actions
        Row(
          children: [
            if (_boxes.isNotEmpty)
              IconButton(
                onPressed: () => setState(() => _boxes.removeLast()),
                icon: const Icon(Icons.undo, size: 20),
                tooltip: "Undo last box",
              ).animate().fadeIn(),
            const Spacer(),
            TextButton(
              onPressed: () {
                widget.controller.setCapturedOcclusionImage(null);
                widget.controller.setMode(CardCreationToolbarMode.collapsed);
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {
                // TODO: Save image occlusion card
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Created Image Occlusion with ${_boxes.length} boxes!",
                    ),
                  ),
                );
                widget.controller.setCapturedOcclusionImage(null);
                widget.controller.setMode(CardCreationToolbarMode.collapsed);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Card"),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildOcclusionBox(ColorScheme cs, {bool isCurrent = false}) {
    return Container(
      decoration: BoxDecoration(
        color: (isCurrent ? Colors.amber : Colors.redAccent).withValues(
          alpha: 0.8,
        ),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
