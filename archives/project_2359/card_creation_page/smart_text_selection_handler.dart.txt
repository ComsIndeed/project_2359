import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:shared_core/shared_core.dart';

/// Handles smart tap-based text selection on a PDF viewer.
///
/// Uses pdfrx's built-in tap type discrimination:
/// - **Single tap** on text → selects the enclosing **sentence**.
/// - **Double tap** on text → selects the enclosing **paragraph/block**.
/// - **Single tap** on already-selected text → **clears** selection
///   (returns to default character-level drag mode).
class SmartTextSelectionHandler {
  const SmartTextSelectionHandler();

  /// Call this from [PdfViewerParams.onGeneralTap].
  ///
  /// Returns `true` if the tap was handled (suppresses default behavior).
  bool handleTap(
    BuildContext context,
    PdfViewerController controller,
    PdfViewerGeneralTapHandlerDetails details,
  ) {
    switch (details.type) {
      case PdfViewerGeneralTapType.tap:
        if (details.tapOn == PdfViewerPart.selectedText) {
          // Tapping on already-selected text → clear selection (default).
          return false;
        }
        if (details.tapOn == PdfViewerPart.nonSelectedText) {
          _selectAtGranularity(
            controller,
            details.documentPosition,
            _SelectionGranularity.sentence,
          );
          return true;
        }
        return false;

      case PdfViewerGeneralTapType.doubleTap:
        if (details.tapOn == PdfViewerPart.nonSelectedText ||
            details.tapOn == PdfViewerPart.selectedText) {
          _selectAtGranularity(
            controller,
            details.documentPosition,
            _SelectionGranularity.paragraph,
          );
          return true;
        }
        return false;

      case PdfViewerGeneralTapType.longPress:
      case PdfViewerGeneralTapType.secondaryTap:
        // Let pdfrx handle long-press (word select) & context menu.
        return false;
    }
  }

  // ─── Internal ────────────────────────────────────────────────────

  Future<void> _selectAtGranularity(
    PdfViewerController controller,
    Offset documentPosition,
    _SelectionGranularity granularity,
  ) async {
    final pageLayouts = controller.layout.pageLayouts;
    final pages = controller.pages;

    for (var i = 0; i < pages.length; i++) {
      final pageRect = pageLayouts[i];
      if (!pageRect.contains(documentPosition)) continue;

      final page = pages[i];
      final pageText = await page.loadStructuredText();
      if (pageText.fullText.isEmpty) continue;

      // Convert document position → PDF page point → character index.
      final pagePoint = documentPosition
          .translate(-pageRect.left, -pageRect.top)
          .toPdfPoint(page: page, scaledPageSize: pageRect.size);

      final charIndex = _findNearestCharIndex(pageText, pagePoint);
      if (charIndex == null) continue;

      // Compute the selection range.
      final (start, end) = switch (granularity) {
        _SelectionGranularity.sentence =>
          PdfTextBoundaryDetector.findSentenceBounds(pageText, charIndex),
        _SelectionGranularity.paragraph =>
          PdfTextBoundaryDetector.findParagraphBounds(pageText, charIndex),
      };

      if (start >= end) continue;

      // Clamp to valid character indices.
      final clampedStart = start.clamp(0, pageText.fullText.length - 1);
      final clampedEnd = (end - 1).clamp(0, pageText.fullText.length - 1);

      final startPoint = PdfTextSelectionPoint(pageText, clampedStart);
      final endPoint = PdfTextSelectionPoint(pageText, clampedEnd);
      final range = PdfTextSelectionRange.fromPoints(startPoint, endPoint);
      await controller.textSelectionDelegate.setTextSelectionPointRange(range);
      return;
    }
  }

  /// Finds the character index nearest to [point] in PDF page coordinates.
  int? _findNearestCharIndex(PdfPageText text, PdfPoint point) {
    double minDist = double.infinity;
    int? closest;

    for (var i = 0; i < text.charRects.length; i++) {
      final rect = text.charRects[i];
      if (rect.containsPoint(point)) return i;

      final dist = rect.distanceSquaredTo(point);
      if (dist < minDist) {
        minDist = dist;
        closest = i;
      }
    }
    return closest;
  }
}

enum _SelectionGranularity { sentence, paragraph }
