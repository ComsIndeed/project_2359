import 'package:pdfrx/pdfrx.dart';

/// TODO: FOllow up with this:
// Lets make the look ahead stuff more obvious because I cant see anything changing from it. I love how thoughtful you were with these tho
// But anyway
// YOO I THINK I KNOW THE ISSUE:
// Its not that the problem is the bold texts, ITS THAT INDENTS CAUSES IT I THINK???? Can we handle that for a second?
// Because notice the text after the SOP header, its treated as a seperate paragraph for some reason
// But on the items on the significance of the study, that has bold texts but they get read just fine

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

  /// Algorithm Version: 1.3.3
  /// Updated: 2026-04-01 12:03
  /// NOTE: Increment this version whenever the heuristic logic is modified.
  static const algorithmVersion = '1.3.3-20260401';

  /// Ratio threshold for font size similarity.
  /// Relaxed to 1.6 to allow for Bold/Style variations and sub-headers.
  static const _fontSizeRatioThreshold = 1.6;

  /// Common abbreviations that contain periods but do NOT end sentences.
  static const _abbreviations = {
    'et al.',
    'e.g.',
    'i.e.',
    'vs.',
    'prof.',
    'dr.',
    'mr.',
    'ms.',
    'mrs.',
    'inc.',
    'ltd.',
    'approx.',
    'cf.',
    'ibid.',
    'op. cit.',
    'vol.',
    'no.',
  };

  /// Tolerance for line-spacing consistency (as percentage of line height).
  /// If spacing changes by more than this, we check for paragraph breaks.
  static const _spacingConsistencyThreshold = 0.6;

  // ─── Sentence Detection ──────────────────────────────────────────

  /// Finds the sentence containing the character at [charIndex].
  ///
  /// Returns a `(start, end)` range where `end` is exclusive.
  static (int start, int end) findSentenceBounds(
    PdfPageText text,
    int charIndex, {
    bool useLookahead = true,
  }) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);

    // Get the paragraph block first, then find sentence within it.
    final (paraStart, paraEnd) = findParagraphBounds(
      text,
      clamped,
      useLookahead: useLookahead,
    );

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

    // Abbreviation check (Academic): if the text preceding '.' is "et al", "dr", etc.
    if (c == 0x2E) {
      for (final abbrev in _abbreviations) {
        final lastBit = abbrev.substring(0, abbrev.length - 1);
        if (i >= lastBit.length) {
          final prefix = s.substring(i - lastBit.length, i).toLowerCase();
          if (prefix == lastBit.toLowerCase()) {
            // Check that it's a word boundary before the abbreviation.
            if (i - lastBit.length == 0 ||
                _isWhitespace(s.codeUnitAt(i - lastBit.length - 1)) ||
                s.codeUnitAt(i - lastBit.length - 1) == 0x28 /* '(' */ ) {
              return false;
            }
          }
        }
      }
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
    int charIndex, {
    bool useLookahead = true,
  }) {
    final s = text.fullText;
    if (s.isEmpty) return (0, 0);

    final clamped = charIndex.clamp(0, s.length - 1);

    // Try newline-based detection first.
    final newlineBounds = _findNewlineParagraphBounds(s, clamped);
    if (newlineBounds != null) return newlineBounds;

    // Fallback: line-based grouping by proximity and consistency.
    return _findFragmentBlockBounds(text, clamped, useLookahead: useLookahead);
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

  /// TODO: MISSION LOG - Improving PDF Text Selection
  /// Current Heuristics:
  /// - Geometric Pre-Sorting (v1.3.0): Since PDF stream order != visual order,
  ///   we sort fragments by [top-desc, left-asc] before grouping.
  /// - Line-Based Consistency (v1.2.x): We group segments into lines, then
  ///   detect paragraph breaks via vertical spacing "massive leaps".
  /// - Asymmetric Spacing (v1.2.1): Only ignore spacing fluctuations that
  ///   are smaller than the current trend. Significant increases (leaps)
  ///   are forced breaks.
  /// - Short-Line Trigger (v1.2.1): Break when a line ends early and gap increases.
  /// - Formatting Immunity (v1.2.2): Ignore font size shifts on the SAME line.
  /// - Abbreviation Check (v1.3.0): academic citations like 'et al.' don't
  ///   break sentences.
  /// - KNOWN LIMITATION: If a first line has a different point size (header),
  ///   it might still break if it's significantly larger (>60%) than body.
  static (int, int) _findFragmentBlockBounds(
    PdfPageText text,
    int charIndex, {
    bool useLookahead = true,
  }) {
    var fragments = List<PdfPageTextFragment>.from(text.fragments);
    if (fragments.isEmpty) return (0, text.fullText.length);

    // SORT GEOMETRICALLY: Essential because PDF data streams are often
    // out of visual order. Visual consistency depends on geometric order.
    fragments.sort((a, b) {
      // Fuzzy Y-sort: If two fragments are within 3px vertically,
      // treat them as being on the same line for sorting purposes.
      final yDiff = (a.bounds.top - b.bounds.top).abs();
      if (yDiff < 3.0) {
        return a.bounds.left.compareTo(b.bounds.left);
      }
      return b.bounds.top.compareTo(a.bounds.top);
    });

    final targetFragIdx = text.getFragmentIndexForTextIndex(charIndex);
    // Find the fragment in our SORTED list that matches the original fragment.
    final originalTarget =
        text.fragments[targetFragIdx < 0 ? 0 : targetFragIdx];

    // 1. Group ALL fragments on the page into logical lines.
    final lines = _groupIntoLines(fragments);
    if (lines.isEmpty) return (0, text.fullText.length);

    // 2. Find which line contains our original target fragment.
    int lineIdx = -1;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].fragments.contains(originalTarget)) {
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

      // Absolute break thresholds.
      if (gap > refHeight * 1.5) {
        break;
      }

      // Relative break threshold (Asymmetric).
      // We break immediately on significant spacing INCREASES (leaps).
      if (lastGap != null) {
        final jump = gap - lastGap;
        if (jump > refHeight * 0.3) {
          break; // Leap detected. Break.
        }

        // Minor noise or reduction. Use lookahead for consistency.
        if (useLookahead &&
            jump.abs() > refHeight * _spacingConsistencyThreshold) {
          if (i > 0) {
            final prevLine = lines[i - 1];
            final prevGap = _verticalLineGap(prevLine, line);
            if ((prevGap - lastGap).abs() >
                refHeight * _spacingConsistencyThreshold) {
              break;
            }
          } else {
            break;
          }
        }
      }

      // Alignment check (v1.3.3 Relaxed to 5.0 to handle deep indents).
      if ((line.bounds.left - nextLine.bounds.left).abs() > refHeight * 5.0) {
        break;
      }

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

      if (gap > refHeight * 1.5) {
        break;
      }

      if (lastGap != null) {
        final jump = gap - lastGap;
        if (jump > refHeight * 0.3) {
          break; // Leap detected. Break.
        }

        if (useLookahead &&
            jump.abs() > refHeight * _spacingConsistencyThreshold) {
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
      }

      // Trailing short line detection: if the previous line ended very early,
      // and we just saw a gap increase (even a small one), break.
      if (lastGap != null && _isShortLine(prevLine, refLine)) {
        if (gap > lastGap + 1.0) {
          break;
        }
      }

      // Alignment check (v1.3.3 Relaxed to 5.0 to handle deep indents).
      if ((line.bounds.left - prevLine.bounds.left).abs() > refHeight * 5.0) {
        break;
      }

      lastGap = gap;
      endLineIdx = i;
    }

    return (
      lines[startLineIdx].fragments.first.index,
      lines[endLineIdx].fragments.last.end,
    );
  }

  // ─── Line Measurement Helpers ────────────────────────────────────

  /// Returns true if a line is significantly shorter than the reference line.
  static bool _isShortLine(_Line line, _Line ref) {
    final w1 = (line.bounds.right - line.bounds.left).abs();
    final w2 = (ref.bounds.right - ref.bounds.left).abs();
    if (w2 <= 0) return false;
    return w1 < w2 * 0.75; // Less than 75% width.
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
      // even slightly (15% height). This handles Bold/Italic baseline shifts.
      final h1 = (currentBounds.top - currentBounds.bottom).abs();
      final h2 = (f.bounds.top - f.bounds.bottom).abs();
      final overlap = _verticalOverlap(currentBounds, f.bounds);

      if (overlap > (h1 < h2 ? h1 : h2) * 0.15) {
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
