import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:project_2359/features/card_creation_page/pdf_occlusion_overlay.dart';

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
                  boundaryMargin: const EdgeInsets.symmetric(horizontal: 256),
                  margin: 8,
                  backgroundColor: Colors.black,
                  textSelectionParams: PdfTextSelectionParams(
                    enabled: true,
                    onTextSelectionChange: (pdfTextSelection) {
                      selectionNotifier.value = pdfTextSelection;
                      pdfTextSelection.getSelectedText().then((text) {
                        if (selectionNotifier.value == pdfTextSelection) {
                          selectedTextNotifier.value = text;
                        }
                      });
                    },
                  ),
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
