import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/settings/labs_settings.dart';

class SourcePreviewSheet extends StatefulWidget {
  final Uint8List pdfBytes;
  final CitationItem citation;

  const SourcePreviewSheet({
    super.key,
    required this.pdfBytes,
    required this.citation,
  });

  @override
  State<SourcePreviewSheet> createState() => _SourcePreviewSheetState();
}

class _SourcePreviewSheetState extends State<SourcePreviewSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  bool _isFlashing = false;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flashController.reverse();
      } else if (status == AnimationStatus.dismissed && _isFlashing) {
        _flashController.forward();
      }
    });
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashing = !_isFlashing;
      if (_isFlashing) {
        _flashController.forward();
      } else {
        _flashController.stop();
        _flashController.reset();
      }
    });
  }

  void _showDebugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.bug_report, size: 20),
                const SizedBox(width: 8),
                const Text("Citation Debug Data"),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.power_settings_new, size: 18),
                  tooltip: "Disable Debug Mode",
                  onPressed: () {
                    labsSettings.setDebugModeEnabled(false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _debugItem("ID", widget.citation.id),
                  _debugItem("Cited Text", widget.citation.citedText ?? "null"),
                  _debugItem(
                    "Page Numbers",
                    widget.citation.pageNumbers?.join(", ") ?? "null",
                  ),
                  _debugItem(
                    "Source IDs",
                    widget.citation.sourceIds?.join(", ") ?? "null",
                  ),
                  _debugItem(
                    "Rects Count",
                    widget.citation.rects?.length.toString() ?? "0",
                  ),
                  if (widget.citation.rects != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.citation.rects!
                            .map(
                              (r) =>
                                  "[${r.left.toStringAsFixed(1)}, ${r.top.toStringAsFixed(1)}, ${r.right.toStringAsFixed(1)}, ${r.bottom.toStringAsFixed(1)}]",
                            )
                            .join("\n"),
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: _toggleFlash,
                icon: Icon(_isFlashing ? Icons.flash_off : Icons.flash_on),
                label: Text(_isFlashing ? "Stop Flash" : "Flash Highlights"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Widget _debugItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 12),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageNumber =
        widget.citation.pageNumbers?.isNotEmpty == true
            ? widget.citation.pageNumbers!.first
            : 1;

    return ListenableBuilder(
      listenable: labsSettings,
      builder: (context, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Source Preview",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onLongPress:
                          labsSettings.debugModeEnabled
                              ? () => _showDebugDialog(context)
                              : null,
                      child: Text(
                        "Page $pageNumber",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          backgroundColor:
                              labsSettings.debugModeEnabled
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // PDF View
              Expanded(
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _flashController,
                    builder: (context, child) {
                      return PdfViewer.data(
                        sourceName: "Source Preview",
                        widget.pdfBytes,
                        params: PdfViewerParams(
                          calculateInitialPageNumber: (document, controller) =>
                              pageNumber,
                          backgroundColor: theme.colorScheme.surface,
                          textSelectionParams: const PdfTextSelectionParams(
                            enabled: true,
                          ),
                          // Draw highlights if rects exist
                          pagePaintCallbacks: [
                            (canvas, pageRect, page) {
                              if (page.pageNumber == pageNumber &&
                                  widget.citation.rects != null) {
                                final baseColor = theme.colorScheme.primary;
                                final flashColor = Colors.yellowAccent;

                                final paint =
                                    Paint()
                                      ..color =
                                          _isFlashing
                                              ? Color.lerp(
                                                baseColor,
                                                flashColor,
                                                _flashController.value,
                                              )!.withValues(alpha: 0.6)
                                              : baseColor.withValues(alpha: 0.3)
                                      ..style = PaintingStyle.fill;

                                for (final rect in widget.citation.rects!) {
                                  canvas.drawRect(
                                    Rect.fromLTRB(
                                      rect.left,
                                      rect.top,
                                      rect.right,
                                      rect.bottom,
                                    ),
                                    paint,
                                  );
                                }
                              }
                            },
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text("Close"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SourcePage(
                                fileBytes: widget.pdfBytes,
                                title: "Full Source",
                                initialPage: pageNumber,
                                highlightRects: widget.citation.rects,
                              ),
                            ),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowUpRightFromSquare,
                          size: 16,
                        ),
                        label: const Text("Open Full Source"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
