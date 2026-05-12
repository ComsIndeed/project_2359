import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_core/shared_core.dart';
import 'note_taking_page.dart';

class NoteTakingController extends ChangeNotifier {
  NoteTakingController() {
    pdfController = PdfViewerController();
    pageController = PageController(initialPage: selectedTabIndex);
  }

  late final PdfViewerController pdfController;
  late final PageController pageController;

  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();
  final TextEditingController clozeTextController = TextEditingController();
  final TextEditingController clozeExtraController = TextEditingController();
  final TextEditingController occlusionTitleController =
      TextEditingController();

  NoteType selectedNoteType = NoteType.basic;
  int selectedTabIndex = 0;
  bool isMaximized = false;
  bool isInverted = false;

  String? selectedText;
  bool isQuoteExpanded = false;
  bool isQuoteFaded = false;
  Timer? _quoteFadeTimer;

  int? hoveredDraftIndex;
  int? clickedDraftIndex;
  Timer? _previewDebounceTimer;

  void setHoveredDraftIndex(int? index) {
    if (hoveredDraftIndex == index) return;

    hoveredDraftIndex = index;

    if (index != null) {
      _previewDebounceTimer?.cancel();
      // Show instantly on hover
      notifyListeners();
    } else {
      _previewDebounceTimer?.cancel();
      // Debounce on exit to avoid flickering and bridge gaps
      _previewDebounceTimer = Timer(const Duration(milliseconds: 400), () {
        if (hoveredDraftIndex == null) {
          notifyListeners();
        }
      });
    }
  }

  void setClickedDraftIndex(int? index) {
    clickedDraftIndex = index;
    notifyListeners();
  }

  int? hoveredPageNumber;
  int? hoveredCharIndex;
  PdfPageText? hoveredPageText;
  (int, int)? hoveredSentenceBounds;
  (int, int)? hoveredParagraphBounds;

  void setNoteType(NoteType type) {
    selectedNoteType = type;
    notifyListeners();
  }

  bool _isProgrammaticScroll = false;

  void setTabIndex(int index, {bool animate = true}) {
    if (selectedTabIndex == index) return;

    if (animate) {
      _isProgrammaticScroll = true;
      selectedTabIndex = index;
      notifyListeners();

      if (pageController.hasClients) {
        pageController
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) {
              _isProgrammaticScroll = false;
            });
      } else {
        _isProgrammaticScroll = false;
      }
    } else {
      if (!_isProgrammaticScroll) {
        selectedTabIndex = index;
        notifyListeners();
      }
    }
  }

  void toggleMaximize() {
    isMaximized = !isMaximized;
    notifyListeners();
  }

  void toggleInvert() {
    isInverted = !isInverted;
    notifyListeners();
  }

  Future<void> onSelectionChanged(PdfTextSelection selection) async {
    _quoteFadeTimer?.cancel();
    if (selection.hasSelectedText) {
      final text = await selection.getSelectedText();
      selectedText = text;
      isQuoteFaded = false;
      isQuoteExpanded = false;

      _quoteFadeTimer = Timer(const Duration(seconds: 5), () {
        isQuoteFaded = true;
        notifyListeners();
      });
      notifyListeners();
    } else {
      selectedText = null;
      isQuoteFaded = false;
      isQuoteExpanded = false;
      notifyListeners();
    }
  }

  void setQuoteExpanded(bool expanded) {
    isQuoteExpanded = expanded;
    if (expanded) {
      isQuoteFaded = false;
      _quoteFadeTimer?.cancel();
    } else {
      _quoteFadeTimer?.cancel();
      _quoteFadeTimer = Timer(const Duration(seconds: 5), () {
        isQuoteFaded = true;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void handleHover(int? pageNumber, int? charIndex, PdfPageText? pageText) {
    if (pageNumber == null || charIndex == null || pageText == null) {
      clearHover();
      return;
    }

    if (hoveredPageNumber != pageNumber || hoveredCharIndex != charIndex) {
      hoveredPageNumber = pageNumber;
      hoveredCharIndex = charIndex;
      hoveredPageText = pageText;
      hoveredSentenceBounds = PdfTextBoundaryDetector.findSentenceBounds(
        pageText,
        charIndex,
      );
      hoveredParagraphBounds = PdfTextBoundaryDetector.findParagraphBounds(
        pageText,
        charIndex,
      );
      notifyListeners();
    }
  }

  void clearHover() {
    if (hoveredCharIndex != null) {
      hoveredPageNumber = null;
      hoveredCharIndex = null;
      hoveredPageText = null;
      hoveredSentenceBounds = null;
      hoveredParagraphBounds = null;
      notifyListeners();
    }
  }

  Future<void> handleTap(PdfViewerGeneralTapHandlerDetails details) async {
    if (details.type == PdfViewerGeneralTapType.tap) {
      final hit = pdfController.getPdfPageHitTestResult(
        details.documentPosition,
        useDocumentLayoutCoordinates: true,
      );
      if (hit != null) {
        final pageText = await hit.page.loadStructuredText();
        final charIndex = PdfTextBoundaryDetector.findNearestCharIndex(
          pageText,
          hit.offset,
        );
        if (charIndex != null) {
          _selectSmartly(pageText, charIndex, isParagraph: false);
          return;
        }
      }
    } else if (details.type == PdfViewerGeneralTapType.doubleTap) {
      final hit = pdfController.getPdfPageHitTestResult(
        details.documentPosition,
        useDocumentLayoutCoordinates: true,
      );
      if (hit != null) {
        final pageText = await hit.page.loadStructuredText();
        final charIndex = PdfTextBoundaryDetector.findNearestCharIndex(
          pageText,
          hit.offset,
        );
        if (charIndex != null) {
          _selectSmartly(pageText, charIndex, isParagraph: true);
          return;
        }
      }
    }
  }

  void _selectSmartly(
    PdfPageText pageText,
    int charIndex, {
    required bool isParagraph,
  }) {
    final bounds = isParagraph
        ? PdfTextBoundaryDetector.findParagraphBounds(pageText, charIndex)
        : PdfTextBoundaryDetector.findSentenceBounds(pageText, charIndex);

    final (start, end) = bounds;
    final range = PdfTextSelectionRange.fromPoints(
      PdfTextSelectionPoint(pageText, start),
      PdfTextSelectionPoint(pageText, end - 1),
    );

    pdfController.textSelectionDelegate.setTextSelectionPointRange(range);
  }

  void pasteCitation(TextEditingController fieldController) {
    if (selectedText == null) return;

    final text = fieldController.text;
    final selection = fieldController.selection;
    final cited = selectedText!;

    if (selection.isValid) {
      final newText = text.replaceRange(selection.start, selection.end, cited);
      fieldController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + cited.length,
        ),
      );
    } else {
      fieldController.text = text + cited;
    }
  }

  void paintHoverHighlight(
    Canvas canvas,
    Rect pageRect,
    PdfPage page,
    Color primaryColor,
  ) {
    if (hoveredPageNumber != page.pageNumber || hoveredPageText == null) {
      return;
    }

    // 1. Draw Paragraph (Subtle)
    if (hoveredParagraphBounds != null) {
      final (start, end) = hoveredParagraphBounds!;
      final range = hoveredPageText!.getRangeFromAB(start, end - 1);
      final paint = Paint()
        ..color = primaryColor.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill;

      for (final rect in range.enumerateFragmentBoundingRects()) {
        final flutterRect = rect.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(flutterRect, paint);
      }
    }

    // 2. Draw Sentence (More Visible)
    if (hoveredSentenceBounds != null) {
      final (start, end) = hoveredSentenceBounds!;
      final range = hoveredPageText!.getRangeFromAB(start, end - 1);
      final paint = Paint()
        ..color = primaryColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;

      for (final rect in range.enumerateFragmentBoundingRects()) {
        final flutterRect = rect.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(flutterRect, paint);
      }
    }
  }

  @override
  void dispose() {
    _quoteFadeTimer?.cancel();
    // PdfViewerController does not have a dispose method
    pageController.dispose();
    frontController.dispose();
    backController.dispose();
    clozeTextController.dispose();
    clozeExtraController.dispose();
    occlusionTitleController.dispose();
    super.dispose();
  }
}
