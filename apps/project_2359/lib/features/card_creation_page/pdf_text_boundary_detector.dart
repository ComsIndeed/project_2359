import 'package:pdfrx/pdfrx.dart';

/// Detects sentence and paragraph boundaries within PDF page text.
///
/// PDFs don't inherently structure text into sentences or paragraphs.
/// This utility uses heuristics on [PdfPageText.fullText] and fragment
/// positions to approximate these boundaries.
class PdfTextBoundaryDetector {
  const PdfTextBoundaryDetector._();

  // ─── Sentence Detection ──────────────────────────────────────────

  /// Finds the sentence containing the character at [charIndex].
  ///
  /// Returns a `(start, end)` range where `end` is exclusive.
  /// Sentence boundaries are: `.` `!` `?` followed by whitespace,
  /// or the start/end of the full text.
  static (int start, int end) findSentenceBounds(
    PdfPageText text,
    int charIndex,
  ) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);
    final start = _findSentenceStart(s, clamped);
    final end = _findSentenceEnd(s, clamped);
    return (start, end);
  }

  static int _findSentenceStart(String s, int from) {
    for (var i = from - 1; i >= 0; i--) {
      if (_isSentenceTerminator(s, i)) {
        // Walk past any trailing whitespace after the terminator.
        var j = i + 1;
        while (j < s.length && _isWhitespace(s.codeUnitAt(j))) {
          j++;
        }
        return j;
      }
    }
    // No terminator found; sentence starts at the beginning.
    return 0;
  }

  static int _findSentenceEnd(String s, int from) {
    for (var i = from; i < s.length; i++) {
      if (_isSentenceTerminator(s, i)) {
        // Include the terminator itself, but not trailing whitespace.
        return i + 1;
      }
    }
    // No terminator found; sentence ends at the full text.
    return s.length;
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
  ///    grouping fragments by vertical proximity — fragments whose
  ///    bounding boxes share a similar Y-band are considered part
  ///    of the same block.
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

    // Fallback: fragment Y-proximity grouping.
    return _findFragmentBlockBounds(text, clamped);
  }

  /// Searches for double-newline paragraph breaks.
  /// Returns null if `fullText` contains no double-newlines at all.
  static (int, int)? _findNewlineParagraphBounds(String s, int from) {
    // Quick check: does the text even contain double-newlines?
    if (!s.contains('\n\n') && !s.contains('\r\n\r\n')) return null;

    int start = from;
    int end = from;

    // Walk backward to find the paragraph start.
    while (start > 0) {
      if (_isDoubleNewline(s, start - 1)) break;
      start--;
    }

    // Walk forward to find the paragraph end.
    while (end < s.length) {
      if (_isDoubleNewline(s, end)) break;
      end++;
    }

    return (start, end);
  }

  static bool _isDoubleNewline(String s, int i) {
    if (i < 0 || i >= s.length) return false;
    if (s.codeUnitAt(i) == 0x0A) {
      // \n
      if (i + 1 < s.length && s.codeUnitAt(i + 1) == 0x0A) return true;
      if (i > 0 && s.codeUnitAt(i - 1) == 0x0A) return true;
    }
    return false;
  }

  /// Groups fragments by vertical proximity and returns the character
  /// range of the block containing [charIndex].
  static (int, int) _findFragmentBlockBounds(PdfPageText text, int charIndex) {
    final fragments = text.fragments;
    if (fragments.isEmpty) return (0, text.fullText.length);

    // Find the fragment containing charIndex.
    final targetIdx = text.getFragmentIndexForTextIndex(charIndex);
    if (targetIdx < 0 || targetIdx >= fragments.length) {
      return (0, text.fullText.length);
    }

    final target = fragments[targetIdx];
    final lineHeight = (target.bounds.top - target.bounds.bottom).abs();
    // Tolerance: fragments within 1.5× line height are "same block".
    final tolerance = lineHeight * 1.5;

    // Expand backward through fragments in the same Y-band.
    var blockStart = targetIdx;
    for (var i = targetIdx - 1; i >= 0; i--) {
      final f = fragments[i];
      final fMidY = (f.bounds.top + f.bounds.bottom) / 2;
      // Check if there's a significant vertical gap.
      final prevMidY =
          (fragments[i + 1].bounds.top + fragments[i + 1].bounds.bottom) / 2;
      if ((fMidY - prevMidY).abs() > tolerance) break;
      blockStart = i;
    }

    // Expand forward.
    var blockEnd = targetIdx;
    for (var i = targetIdx + 1; i < fragments.length; i++) {
      final f = fragments[i];
      final fMidY = (f.bounds.top + f.bounds.bottom) / 2;
      final prevMidY =
          (fragments[i - 1].bounds.top + fragments[i - 1].bounds.bottom) / 2;
      if ((fMidY - prevMidY).abs() > tolerance) break;
      blockEnd = i;
    }

    final startChar = fragments[blockStart].index;
    final endChar = fragments[blockEnd].end;
    return (startChar, endChar);
  }

  // ─── Helpers ─────────────────────────────────────────────────────

  static bool _isWhitespace(int c) =>
      c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D;

  static bool _isUppercase(int c) => c >= 0x41 && c <= 0x5A;
}
