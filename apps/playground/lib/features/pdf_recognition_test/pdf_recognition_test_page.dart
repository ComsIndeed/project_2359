import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_core/shared_core.dart';

enum RecognitionGranularity { sentence, paragraph }

class PdfRecognitionTestPage extends StatefulWidget {
  const PdfRecognitionTestPage({super.key});

  @override
  State<PdfRecognitionTestPage> createState() => _PdfRecognitionTestPageState();
}

class _PdfRecognitionTestPageState extends State<PdfRecognitionTestPage> {
  String? _pdfPath;
  RecognitionGranularity _granularity = RecognitionGranularity.sentence;
  bool _useLookahead = true;
  bool _showAllFragments = false;
  final Map<int, List<(int, int)>> _boundariesCache = {};
  final PdfViewerController _controller = PdfViewerController();

  final List<Color> _colors = [
    Colors.red.withOpacity(0.3),
    Colors.green.withOpacity(0.3),
    Colors.blue.withOpacity(0.3),
    Colors.yellow.withOpacity(0.3),
    Colors.purple.withOpacity(0.3),
    Colors.orange.withOpacity(0.3),
    Colors.cyan.withOpacity(0.3),
    Colors.pink.withOpacity(0.3),
  ];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfPath = result.files.single.path;
        _boundariesCache.clear();
        _textCache.clear();
        _loadingPages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PDF Recognition Test'),
            Text(
              'Algo: ${PdfTextBoundaryDetector.algorithmVersion}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showAllFragments ? Icons.visibility : Icons.visibility_off,
              color: _showAllFragments ? Colors.blue : null,
            ),
            tooltip: 'Show All Fragments (Wireframe)',
            onPressed: () {
              setState(() {
                _showAllFragments = !_showAllFragments;
              });
              _controller.invalidate();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.bolt,
              color: _useLookahead ? Colors.orange : Colors.grey,
            ),
            tooltip: 'Use Lookahead (Spacial Logic)',
            onPressed: () {
              setState(() {
                _useLookahead = !_useLookahead;
                _boundariesCache.clear();
                _textCache.clear();
                _loadingPages.clear();
              });
              debugPrint(
                '[LOOKAHEAD] ${_useLookahead ? "ENABLED" : "DISABLED"}',
              );
              _controller.invalidate();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload & Re-analyze',
            onPressed: () {
              setState(() {
                _boundariesCache.clear();
                _textCache.clear();
                _loadingPages.clear();
              });
              _controller.invalidate();
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_open),
            onPressed: _pickFile,
            tooltip: 'Import PDF',
          ),
          const SizedBox(width: 8),
          SegmentedButton<RecognitionGranularity>(
            segments: const [
              ButtonSegment(
                value: RecognitionGranularity.sentence,
                label: Text('Sentence'),
                icon: Icon(Icons.short_text),
              ),
              ButtonSegment(
                value: RecognitionGranularity.paragraph,
                label: Text('Paragraph'),
                icon: Icon(Icons.notes),
              ),
            ],
            selected: {_granularity},
            onSelectionChanged: (value) {
              setState(() {
                _granularity = value.first;
                _boundariesCache.clear();
                _textCache.clear();
                _loadingPages.clear();
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _pdfPath == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Import PDF to Test'),
                  ),
                ],
              ),
            )
          : PdfViewer.file(
              _pdfPath!,
              controller: _controller,
              params: PdfViewerParams(
                textSelectionParams: const PdfTextSelectionParams(),
                onGeneralTap: (context, controller, details) {
                  Future.microtask(() async {
                    final hit = controller.getPdfPageHitTestResult(
                      details.documentPosition,
                      useDocumentLayoutCoordinates: true,
                    );
                    if (hit != null) {
                      final pageText = await hit.page.loadStructuredText();
                      final charIndex = _findCharIndex(pageText, hit.offset);
                      if (charIndex >= 0) {
                        final frag = pageText.getFragmentForTextIndex(
                          charIndex,
                        );
                        debugPrint(
                          '[INSPECT] Tapped Fragment: "${frag?.text}"\n'
                          'PDF Coords: ${hit.offset}\n'
                          'CharIndex: $charIndex\n'
                          'FragBounds: ${frag?.bounds}',
                        );
                      } else {
                        debugPrint(
                          '[INSPECT] No fragment found at ${hit.offset}',
                        );
                      }
                    } else {
                      debugPrint('[INSPECT] No hit detected');
                    }
                  });
                  return false;
                },
                pagePaintCallbacks: [
                  (canvas, pageRect, page) {
                    _drawBoundaries(canvas, pageRect, page);
                  },
                ],
              ),
            ),
    );
  }

  void _drawBoundaries(Canvas canvas, Rect pageRect, PdfPage page) {
    final pageText = _textCache[page.pageNumber];
    final boundaries = _boundariesCache[page.pageNumber];

    if (pageText == null || boundaries == null) {
      _loadPageBoundaries(page.pageNumber);
      return;
    }

    // DEBUG: Show all detected fragments as wireframes (THICKER v1.3.3)
    if (_showAllFragments) {
      final fragmentPaint = Paint()
        ..color = Colors.blue.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      for (final fragment in pageText.fragments) {
        final rect = fragment.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(rect, fragmentPaint);
      }
    }

    for (int i = 0; i < boundaries.length; i++) {
      final (start, end) = boundaries[i];
      final color = _colors[i % _colors.length];
      final paint = Paint()..color = color;

      try {
        final range = pageText.getRangeFromAB(start, end - 1);
        for (final rect in range.enumerateFragmentBoundingRects()) {
          final rectInDoc = rect.bounds.toRectInDocument(
            page: page,
            pageRect: pageRect,
          );
          canvas.drawRect(rectInDoc, paint);
        }
      } catch (e) {
        debugPrint(
          '[PAGE ${page.pageNumber}] Error mapping range: $start-$end: $e',
        );
      }
    }
  }

  final Map<int, PdfPageText> _textCache = {};
  final Set<int> _loadingPages = {};

  Future<void> _loadPageBoundaries(int pageNumber) async {
    if (_loadingPages.contains(pageNumber)) return;
    _loadingPages.add(pageNumber);

    try {
      PdfPageText? pageText;
      int attempts = 0;
      const maxAttempts = 3;

      while (attempts < maxAttempts) {
        final pageList = _controller.pages;
        if (pageNumber > pageList.length) {
          debugPrint(
            '[_loadPageBoundaries] Page $pageNumber not in list yet (len: ${pageList.length})',
          );
          await Future.delayed(const Duration(milliseconds: 500));
          attempts++;
          continue;
        }

        final page = pageList[pageNumber - 1];
        pageText = await page.loadStructuredText();

        if (pageText.fullText.isNotEmpty) break;

        debugPrint(
          '[_loadPageBoundaries] Page $pageNumber returned empty text. Retry ${attempts + 1}/$maxAttempts...',
        );
        await Future.delayed(const Duration(milliseconds: 1000));
        attempts++;
      }

      if (pageText == null || pageText.fullText.isEmpty) {
        debugPrint(
          '[_loadPageBoundaries] Page $pageNumber: Giving up after $attempts attempts. Text is empty.',
        );
        _boundariesCache[pageNumber] =
            []; // Cache empty to avoid infinite retries
        return;
      }

      final List<(int, int)> boundaries = [];
      int currentIndex = 0;
      final fullLength = pageText.fullText.length;

      while (currentIndex < fullLength) {
        final (start, end) = _granularity == RecognitionGranularity.sentence
            ? PdfTextBoundaryDetector.findSentenceBounds(
                pageText,
                currentIndex,
                useLookahead: _useLookahead,
              )
            : PdfTextBoundaryDetector.findParagraphBounds(
                pageText,
                currentIndex,
                useLookahead: _useLookahead,
              );

        if (start >= end) {
          currentIndex++;
          continue;
        }

        final effectiveEnd = end.clamp(currentIndex + 1, fullLength);
        final effectiveStart = start.clamp(currentIndex, effectiveEnd - 1);

        boundaries.add((effectiveStart, effectiveEnd));
        currentIndex = effectiveEnd;

        while (currentIndex < fullLength &&
            _isWhitespace(pageText.fullText.codeUnitAt(currentIndex))) {
          currentIndex++;
        }
      }

      if (mounted) {
        debugPrint(
          '[PAGE $pageNumber] Analysis complete. Boundaries: ${boundaries.length}, Text length: $fullLength',
        );
        setState(() {
          _textCache[pageNumber] = pageText!;
          _boundariesCache[pageNumber] = boundaries;
        });
        _controller.invalidate();
      }
    } catch (e, stack) {
      debugPrint('[PAGE $pageNumber] Analysis error: $e');
      debugPrint(stack.toString());
    } finally {
      _loadingPages.remove(pageNumber);
    }
  }

  int _findCharIndex(PdfPageText text, PdfPoint point) {
    for (int i = 0; i < text.charRects.length; i++) {
      if (text.charRects[i].containsPoint(point)) return i;
    }
    return -1;
  }

  bool _isWhitespace(int c) => c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D;
}
