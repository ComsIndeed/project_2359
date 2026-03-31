import 'package:pdfrx/pdfrx.dart';

/// Detects sentence and paragraph boundaries within PDF page text.
///
/// PDFs don't inherently structure text into sentences or paragraphs.
/// This utility uses heuristics on [PdfPageText.fullText], fragment
/// positions, and character sizing to approximate these boundaries.
///
/// Character bounding-box heights are used as a proxy for font size,
/// which helps separate headers, body text, tables, etc.
class PdfTextBoundaryDetector {
  const PdfTextBoundaryDetector._();

  /// Ratio threshold: if a fragment's char height differs from the
  /// reference by more than this factor, it's considered a different
  /// text block (e.g. header vs body).
  static const _fontSizeRatioThreshold = 1.35;

  /// Maximum Y-gap (in multiples of reference line height) allowed
  /// between consecutive fragments within the same paragraph.
  /// Normal line spacing is ~1.2–1.5× font size, so 2.5× handles
  /// most body-text line wrapping while still breaking on paragraph gaps.
  static const _paragraphGapMultiplier = 2.5;

  // ─── Sentence Detection ──────────────────────────────────────────

  /// Finds the sentence containing the character at [charIndex].
  ///
  /// Returns a `(start, end)` range where `end` is exclusive.
  ///
  /// Boundaries are:
  /// - Punctuation terminators (`.` `!` `?`) followed by whitespace.
  /// - Font-size changes (detected via character bounding-box heights).
  /// - Start / end of the full text.
  static (int start, int end) findSentenceBounds(
    PdfPageText text,
    int charIndex,
  ) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);

    // Get the "visual block" that shares the same font size first,
    // then narrow down to sentence within that block.
    final (blockStart, blockEnd) = _findSameSizeBlock(text, clamped);

    final start = _findSentenceStart(s, clamped, lowerBound: blockStart);
    final end = _findSentenceEnd(s, clamped, upperBound: blockEnd);
    return (start, end);
  }

  static int _findSentenceStart(String s, int from, {required int lowerBound}) {
    for (var i = from - 1; i >= lowerBound; i--) {
      if (_isSentenceTerminator(s, i)) {
        // Walk past any trailing whitespace after the terminator.
        var j = i + 1;
        while (j < s.length && _isWhitespace(s.codeUnitAt(j))) {
          j++;
        }
        return j;
      }
    }
    return lowerBound;
  }

  static int _findSentenceEnd(String s, int from, {required int upperBound}) {
    for (var i = from; i < upperBound; i++) {
      if (_isSentenceTerminator(s, i)) {
        return i + 1;
      }
    }
    return upperBound;
  }

  /// A character is a sentence terminator if it's `.` `!` `?`
  /// and the next character is whitespace, end-of-string, or an
  /// uppercase letter (new sentence). Also handles `...` ellipsis.
  static bool _isSentenceTerminator(String s, int i) {
    final c = s.codeUnitAt(i);
    if (c != 0x2E && c != 0x21 && c != 0x3F) return false; // . ! ?

    // Skip ellipsis: if the next char is also a period, not a terminator.
    if (c == 0x2E && i + 1 < s.length && s.codeUnitAt(i + 1) == 0x2E) {
      return false;
    }

    // Must be followed by whitespace, uppercase, or end-of-text.
    if (i + 1 >= s.length) return true;
    final next = s.codeUnitAt(i + 1);
    return _isWhitespace(next) || _isUppercase(next);
  }

  // ─── Paragraph Detection ─────────────────────────────────────────

  /// Finds the paragraph/block containing the character at [charIndex].
  ///
  /// Returns a `(start, end)` range where `end` is exclusive.
  ///
  /// Strategy:
  /// 1. Try newline-based boundaries (`\n\n` or `\r\n\r\n`).
  /// 2. If no double-newlines exist (common in PDFs), fall back to
  ///    grouping fragments by **font-size consistency** AND
  ///    **vertical proximity**.
  static (int start, int end) findParagraphBounds(
    PdfPageText text,
    int charIndex,
  ) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);

    // Try newline-based detection first.
    final newlineBounds = _findNewlineParagraphBounds(s, clamped);
    if (newlineBounds != null) return newlineBounds;

    // Fallback: fragment grouping by size + proximity.
    return _findFragmentBlockBounds(text, clamped);
  }

  /// Searches for double-newline paragraph breaks.
  /// Returns null if `fullText` contains no double-newlines at all.
  static (int, int)? _findNewlineParagraphBounds(String s, int from) {
    if (!s.contains('\n\n') && !s.contains('\r\n\r\n')) return null;

    int start = from;
    int end = from;

    while (start > 0) {
      if (_isDoubleNewline(s, start - 1)) break;
      start--;
    }

    while (end < s.length) {
      if (_isDoubleNewline(s, end)) break;
      end++;
    }

    return (start, end);
  }

  static bool _isDoubleNewline(String s, int i) {
    if (i < 0 || i >= s.length) return false;
    if (s.codeUnitAt(i) == 0x0A) {
      if (i + 1 < s.length && s.codeUnitAt(i + 1) == 0x0A) return true;
      if (i > 0 && s.codeUnitAt(i - 1) == 0x0A) return true;
    }
    return false;
  }

  // ─── Shared: Font-Size-Aware Block Detection ─────────────────────

  /// Returns the character range of the contiguous block around
  /// [charIndex] that shares the same approximate font size.
  ///
  /// Used by both sentence (to clamp bounds) and paragraph detection.
  static (int, int) _findSameSizeBlock(PdfPageText text, int charIndex) {
    final fragments = text.fragments;
    if (fragments.isEmpty) return (0, text.fullText.length);

    final targetIdx = text.getFragmentIndexForTextIndex(charIndex);
    if (targetIdx < 0 || targetIdx >= fragments.length) {
      return (0, text.fullText.length);
    }

    final refHeight = _fragmentCharHeight(fragments[targetIdx]);

    // Walk backward.
    var blockStart = targetIdx;
    for (var i = targetIdx - 1; i >= 0; i--) {
      if (!_isSimilarSize(refHeight, _fragmentCharHeight(fragments[i]))) break;
      blockStart = i;
    }

    // Walk forward.
    var blockEnd = targetIdx;
    for (var i = targetIdx + 1; i < fragments.length; i++) {
      if (!_isSimilarSize(refHeight, _fragmentCharHeight(fragments[i]))) break;
      blockEnd = i;
    }

    return (fragments[blockStart].index, fragments[blockEnd].end);
  }

  /// Groups fragments by **font-size similarity** AND **vertical
  /// proximity** to find the paragraph block at [charIndex].
  static (int, int) _findFragmentBlockBounds(PdfPageText text, int charIndex) {
    final fragments = text.fragments;
    if (fragments.isEmpty) return (0, text.fullText.length);

    final targetIdx = text.getFragmentIndexForTextIndex(charIndex);
    if (targetIdx < 0 || targetIdx >= fragments.length) {
      return (0, text.fullText.length);
    }

    final target = fragments[targetIdx];
    final refHeight = _fragmentCharHeight(target);
    final maxGap = refHeight * _paragraphGapMultiplier;

    // Walk backward: include fragment if same font size AND close Y.
    var blockStart = targetIdx;
    for (var i = targetIdx - 1; i >= 0; i--) {
      final f = fragments[i];
      // Font size check.
      if (!_isSimilarSize(refHeight, _fragmentCharHeight(f))) break;
      // Vertical gap check: compare with its neighbor.
      final gap = _verticalGap(f, fragments[i + 1]);
      if (gap > maxGap) break;
      blockStart = i;
    }

    // Walk forward.
    var blockEnd = targetIdx;
    for (var i = targetIdx + 1; i < fragments.length; i++) {
      final f = fragments[i];
      if (!_isSimilarSize(refHeight, _fragmentCharHeight(f))) break;
      final gap = _verticalGap(fragments[i - 1], f);
      if (gap > maxGap) break;
      blockEnd = i;
    }

    return (fragments[blockStart].index, fragments[blockEnd].end);
  }

  // ─── Fragment Measurement Helpers ────────────────────────────────

  /// Estimates the "font size" of a fragment from its bounding-box
  /// height. Uses the fragment's bounds (top − bottom in PDF coords).
  static double _fragmentCharHeight(PdfPageTextFragment f) {
    return (f.bounds.top - f.bounds.bottom).abs();
  }

  /// Whether two heights are "close enough" to be the same font size.
  static bool _isSimilarSize(double refHeight, double otherHeight) {
    if (refHeight <= 0 || otherHeight <= 0) return true;
    final ratio = otherHeight / refHeight;
    return ratio > (1 / _fontSizeRatioThreshold) &&
        ratio < _fontSizeRatioThreshold;
  }

  /// The vertical gap between two fragments. Uses their bounding-box
  /// edges rather than midpoints, so overlapping lines return ~0.
  static double _verticalGap(PdfPageTextFragment a, PdfPageTextFragment b) {
    // PDF coords: top > bottom.  Laid-out order: a comes before b.
    // Gap = space between the bottom of the higher fragment and
    //        the top of the lower fragment.
    final aMin = a.bounds.bottom < a.bounds.top
        ? a.bounds.bottom
        : a.bounds.top;
    final aMax = a.bounds.bottom < a.bounds.top
        ? a.bounds.top
        : a.bounds.bottom;
    final bMin = b.bounds.bottom < b.bounds.top
        ? b.bounds.bottom
        : b.bounds.top;
    final bMax = b.bounds.bottom < b.bounds.top
        ? b.bounds.top
        : b.bounds.bottom;

    // If they overlap vertically, gap is 0 (same line or adjacent).
    if (aMax >= bMin && bMax >= aMin) return 0;

    // Otherwise, the gap is the distance between the closest edges.
    return (aMin > bMax) ? (aMin - bMax) : (bMin - aMax);
  }

  // ─── Text Helpers ────────────────────────────────────────────────

  static bool _isWhitespace(int c) =>
      c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D;

  static bool _isUppercase(int c) => c >= 0x41 && c <= 0x5A;
}
