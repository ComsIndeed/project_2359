import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:project_2359/features/card_creation_page/pdf_occlusion_overlay.dart';
import 'package:project_2359/core/models/project_rect.dart';

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
                  calculateInitialZoom: (doc, controller, alt, cover) =>
                      cover * 1.25,
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
