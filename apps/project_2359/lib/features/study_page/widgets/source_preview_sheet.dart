import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SourcePreviewSheet extends StatelessWidget {
  final Uint8List pdfBytes;
  final CitationItem citation;

  const SourcePreviewSheet({
    super.key,
    required this.pdfBytes,
    required this.citation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageNumber = citation.pageNumbers?.isNotEmpty == true
        ? citation.pageNumbers!.first
        : 1;

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
                Text(
                  "Page $pageNumber",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // PDF View
          Expanded(
            child: ClipRect(
              child: PdfViewer.data(
                sourceName: "Source Preview",
                pdfBytes,
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
                          citation.rects != null) {
                        final paint = Paint()
                          ..color = theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          )
                          ..style = PaintingStyle.fill;

                        for (final rect in citation.rects!) {
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
                            fileBytes: pdfBytes,
                            title: "Full Source",
                            initialPage: pageNumber,
                            highlightRects: citation.rects,
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
  }
}
