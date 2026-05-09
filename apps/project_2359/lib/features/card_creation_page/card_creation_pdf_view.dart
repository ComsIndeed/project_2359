import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:project_2359/features/card_creation_page/pdf_occlusion_overlay.dart';
import 'package:project_2359/core/models/project_rect.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CardCreationPdfView extends StatelessWidget {
  final Uint8List? pdfBytes;
  final int pdfKey;
  final String? currentSourceId;
  final PdfViewerController controller;
  final CardCreationToolbarController toolbarController;
  final ValueNotifier<dynamic> selectionNotifier;
  final ValueNotifier<String?> selectedTextNotifier;
  final SmartTextSelectionHandler smartSelection;

  const CardCreationPdfView({
    super.key,
    required this.pdfBytes,
    required this.pdfKey,
    required this.currentSourceId,
    required this.controller,
    required this.toolbarController,
    required this.selectionNotifier,
    required this.selectedTextNotifier,
    required this.smartSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (pdfBytes == null) {
      return Container(color: Colors.black);
    }

    return KeyedSubtree(
      key: ValueKey(pdfKey),
      child: ListenableBuilder(
        listenable: toolbarController,
        builder: (context, _) {
          return Stack(
            children: [
              PdfViewer.data(
                pdfBytes!,
                sourceName: 'pdf_$currentSourceId',
                controller: controller,
                useProgressiveLoading: true,
                params: PdfViewerParams(
                  calculateInitialZoom: (doc, controller, alt, cover) {
                    final isDesktop =
                        ResponsiveBreakpoints.of(context).largerThan(MOBILE);

                    if (isDesktop && doc.pages.isNotEmpty) {
                      // Calculate zoom to fit the page width into the viewport
                      // (excluding the sidebar space)
                      final viewportWidth = controller.viewSize.width > 0
                          ? controller.viewSize.width
                          : 1000.0; // Fallback for first frame
                      final pageWidth = doc.pages[0].width;
                      if (pageWidth > 0) {
                        // Fit page with 48px padding on both sides in the left area
                        return (viewportWidth - 450) / (pageWidth + 120);
                      }
                    }
                    return cover * 1.25;
                  },
                  onViewerReady: (doc, controller) {
                    final isDesktop =
                        ResponsiveBreakpoints.of(context).largerThan(MOBILE);
                    if (isDesktop && doc.pages.isNotEmpty) {
                      // Align the first page to the left of the viewport
                      // with a small margin.
                      controller.goToPage(
                        pageNumber: 1,
                        anchor: PdfPageAnchor.topLeft,
                      );
                    }
                  },
                  layoutPages: (pages, params) {
                    final isDesktop =
                        ResponsiveBreakpoints.of(context).largerThan(MOBILE);

                    double height = 0;
                    double maxWidth = 0;
                    final layouts = <Rect>[];
                    final margin = params.margin;

                    for (final page in pages) {
                      final pageW = page.width;
                      final pageH = page.height;

                      // Position pages vertically
                      // On desktop, shift pages to the left by adding a fixed margin
                      // and adding "phantom" width on the right to the document size.
                      final x = isDesktop ? 48.0 : 0.0;
                      layouts.add(
                        Rect.fromLTWH(x, height + margin, pageW, pageH),
                      );

                      height += pageH + margin;
                      if (pageW > maxWidth) maxWidth = pageW;
                    }

                    final documentWidth =
                        isDesktop ? maxWidth + 48.0 + 450.0 : maxWidth;

                    return PdfPageLayout(
                      documentSize: Size(documentWidth, height + margin),
                      pageLayouts: layouts,
                    );
                  },
                  boundaryMargin: const EdgeInsets.symmetric(horizontal: 2096),
                  margin: 8,
                  backgroundColor: Colors.black,
                  textSelectionParams: PdfTextSelectionParams(
                    enabled: true,
                    onTextSelectionChange: (pdfTextSelection) async {
                      selectionNotifier.value = pdfTextSelection;

                      final text = await pdfTextSelection.getSelectedText();
                      if (selectionNotifier.value == pdfTextSelection) {
                        selectedTextNotifier.value = text;

                        // Capture Citation Metadata
                        final List<int> pageNumbers = [];
                        final List<ProjectRect> rects = [];

                        final ranges =
                            await controller.textSelectionDelegate
                                .getSelectedTextRanges();

                        for (final selection in ranges) {
                          if (!pageNumbers.contains(selection.pageNumber)) {
                            pageNumbers.add(selection.pageNumber);
                          }
                          final fragments =
                              selection.enumerateFragmentBoundingRects();
                          for (final fragment in fragments) {
                            rects.add(
                              ProjectRect(
                                left: fragment.bounds.left,
                                top: fragment.bounds.top,
                                right: fragment.bounds.right,
                                bottom: fragment.bounds.bottom,
                              ),
                            );
                          }
                        }

                        toolbarController.updateCitationMetadata(
                          sourceId: currentSourceId,
                          pageNumbers: pageNumbers,
                          rects: rects,
                        );
                      }
                    },
                  ),
                  pagePaintCallbacks: [],
                  onGeneralTap: labsSettings.smartSelectionEnabled
                      ? smartSelection.handleTap
                      : null,
                ),
              ),
              if (toolbarController.mode ==
                  CardCreationToolbarMode.imageOcclusion)
                PdfOcclusionOverlay(
                  controller: controller,
                  toolbarController: toolbarController,
                ),
            ],
          );
        },
      ),
    );
  }
}
