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

  /// Algorithm Version: 1.2.0
  /// Updated: 2026-03-31 21:35
  /// NOTE: Increment this version whenever the heuristic logic is modified.
  static const algorithmVersion = '1.2.0-20260331';

  /// Ratio threshold for font size similarity.
  static const _fontSizeRatioThreshold = 1.35;

  /// Tolerance for line-spacing consistency (as percentage of line height).
  /// If spacing changes by more than this, we check for paragraph breaks.
  static const _spacingConsistencyThreshold = 0.6;

  // ─── Sentence Detection ──────────────────────────────────────────

  /// Finds the sentence containing the character at [charIndex].
  ///
  /// Returns a `(start, end)` range where `end` is exclusive.
  static (int start, int end) findSentenceBounds(
    PdfPageText text,
    int charIndex,
  ) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);

    // Get the paragraph block first, then find sentence within it.
    final (paraStart, paraEnd) = findParagraphBounds(text, clamped);

    final start = _findSentenceStart(s, clamped, lowerBound: paraStart);
    final end = _findSentenceEnd(s, clamped, upperBound: paraEnd);
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

    // Fallback: line-based grouping by proximity and consistency.
    return _findFragmentBlockBounds(text, clamped);
  }

  /// Searches for double-newline paragraph breaks.
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

  /// Groups fragments by **line-spacing consistency** and **alignment**
  /// to find the paragraph block at [charIndex].
  static (int, int) _findFragmentBlockBounds(PdfPageText text, int charIndex) {
    final fragments = text.fragments;
    if (fragments.isEmpty) return (0, text.fullText.length);

    final targetFragIdx = text.getFragmentIndexForTextIndex(charIndex);
    if (targetFragIdx < 0 || targetFragIdx >= fragments.length) {
      return (0, text.fullText.length);
    }

    // 1. Group ALL fragments on the page into logical lines.
    final lines = _groupIntoLines(fragments);
    if (lines.isEmpty) return (0, text.fullText.length);

    // 2. Find which line contains our target fragment.
    final targetFragment = fragments[targetFragIdx];
    int lineIdx = -1;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].fragments.contains(targetFragment)) {
        lineIdx = i;
        break;
      }
    }
    if (lineIdx == -1) return (0, text.fullText.length);

    final refLine = lines[lineIdx];
    final refHeight = _lineHeight(refLine);

    // 3. Expand backward.
    var startLineIdx = lineIdx;
    double? lastGap;
    for (var i = lineIdx - 1; i >= 0; i--) {
      final line = lines[i];
      final nextLine = lines[i + 1];

      if (!_isLineSimilar(refLine, line)) break;

      final gap = _verticalLineGap(line, nextLine);

      // Paragraph break check.
      // A break occurs if:
      // - The gap is significantly larger than previous gaps (or line height).
      // - The alignment shifts significantly.
      if (gap > refHeight * 1.5) break;

      if (lastGap != null &&
          (gap - lastGap).abs() > refHeight * _spacingConsistencyThreshold) {
        // Spacing jump. Check "sides of sides" (lookahead) to see if it restores.
        if (i > 0) {
          final prevLine = lines[i - 1];
          final prevGap = _verticalLineGap(prevLine, line);
          if ((prevGap - lastGap).abs() >
              refHeight * _spacingConsistencyThreshold) {
            // Trend definitely changed.
            break;
          }
          // The current line 'i' is the "random thing" but spacing restores.
        } else {
          break;
        }
      }

      // Alignment check.
      if ((line.bounds.left - nextLine.bounds.left).abs() > refHeight * 2.0)
        break;

      lastGap = gap;
      startLineIdx = i;
    }

    // 4. Expand forward.
    var endLineIdx = lineIdx;
    lastGap = null;
    for (var i = lineIdx + 1; i < lines.length; i++) {
      final line = lines[i];
      final prevLine = lines[i - 1];

      if (!_isLineSimilar(refLine, line)) break;

      final gap = _verticalLineGap(prevLine, line);
      if (gap > refHeight * 1.5) break;

      if (lastGap != null &&
          (gap - lastGap).abs() > refHeight * _spacingConsistencyThreshold) {
        if (i < lines.length - 1) {
          final nextLine = lines[i + 1];
          final nextGap = _verticalLineGap(line, nextLine);
          if ((nextGap - lastGap).abs() >
              refHeight * _spacingConsistencyThreshold) {
            break;
          }
        } else {
          break;
        }
      }

      if ((line.bounds.left - prevLine.bounds.left).abs() > refHeight * 2.0)
        break;

      lastGap = gap;
      endLineIdx = i;
    }

    return (
      lines[startLineIdx].fragments.first.index,
      lines[endLineIdx].fragments.last.end,
    );
  }

  // ─── Line Grouping Helpers ───────────────────────────────────────

  static List<_Line> _groupIntoLines(List<PdfPageTextFragment> fragments) {
    if (fragments.isEmpty) return [];
    final lines = <_Line>[];

    var currentFragments = <PdfPageTextFragment>[fragments.first];
    var currentBounds = fragments.first.bounds;

    for (var i = 1; i < fragments.length; i++) {
      final f = fragments[i];

      // Two fragments are on the same line if they overlap vertically
      // by more than 50% of the smaller fragment's height.
      final h1 = (currentBounds.top - currentBounds.bottom).abs();
      final h2 = (f.bounds.top - f.bounds.bottom).abs();
      final overlap = _verticalOverlap(currentBounds, f.bounds);

      if (overlap > (h1 < h2 ? h1 : h2) * 0.5) {
        currentFragments.add(f);
        currentBounds = _union(currentBounds, f.bounds);
      } else {
        lines.add(_Line(currentFragments, currentBounds));
        currentFragments = [f];
        currentBounds = f.bounds;
      }
    }
    lines.add(_Line(currentFragments, currentBounds));
    return lines;
  }

  static double _verticalOverlap(PdfRect a, PdfRect b) {
    final aMin = a.bottom < a.top ? a.bottom : a.top;
    final aMax = a.bottom < a.top ? a.top : a.bottom;
    final bMin = b.bottom < b.top ? b.bottom : b.top;
    final bMax = b.bottom < b.top ? b.top : b.bottom;

    final intersectionMin = aMin > bMin ? aMin : bMin;
    final intersectionMax = aMax < bMax ? aMax : bMax;

    return (intersectionMax - intersectionMin).clamp(0, double.infinity);
  }

  static PdfRect _union(PdfRect a, PdfRect b) {
    return PdfRect(
      a.left < b.left ? a.left : b.left,
      a.top > b.top ? a.top : b.top,
      a.right > b.right ? a.right : b.right,
      a.bottom < b.bottom ? a.bottom : b.bottom,
    );
  }

  static double _lineHeight(_Line line) =>
      (line.bounds.top - line.bounds.bottom).abs();

  static double _verticalLineGap(_Line a, _Line b) {
    final aBottom = a.bounds.bottom < a.bounds.top
        ? a.bounds.bottom
        : a.bounds.top;
    final bTop = b.bounds.bottom < b.bounds.top
        ? b.bounds.top
        : b.bounds.bottom;
    return (aBottom - bTop).abs();
  }

  static bool _isLineSimilar(_Line ref, _Line other) {
    final h1 = _lineHeight(ref);
    final h2 = _lineHeight(other);
    if (h1 <= 0 || h2 <= 0) return true;
    final ratio = h2 / h1;
    return ratio > (1 / _fontSizeRatioThreshold) &&
        ratio < _fontSizeRatioThreshold;
  }

  static bool _isWhitespace(int c) =>
      c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D;

  static bool _isUppercase(int c) => c >= 0x41 && c <= 0x5A;
}

class _Line {
  final List<PdfPageTextFragment> fragments;
  final PdfRect bounds;
  _Line(this.fragments, this.bounds);
}
