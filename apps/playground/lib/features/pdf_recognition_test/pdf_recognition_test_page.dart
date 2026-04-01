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
  String _viewMode = 'paragraph';
  bool _useLookahead = true;
  bool _showAllFragments = false;
  final Map<int, List<(int, int)>> _boundariesCache = {};
  final PdfViewerController _controller = PdfViewerController();

  ({
    String text,
    Rect rect,
    int pageNumber,
    PdfViewerGeneralTapHandlerDetails details,
  })?
  _tappedInfo;

  final Map<int, PdfPageText> _textCache = {};
  final Set<int> _loadingPages = {};

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
                _tappedInfo = null;
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
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'none', label: Text('None')),
              ButtonSegment(value: 'sentence', label: Text('Sentence')),
              ButtonSegment(value: 'paragraph', label: Text('Paragraph')),
            ],
            selected: {_viewMode},
            onSelectionChanged: (val) => setState(() {
              _viewMode = val.first;
              _boundariesCache.clear();
              _tappedInfo = null;
            }),
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
                        setState(() {
                          _tappedInfo = (
                            text: frag?.text ?? '',
                            rect:
                                frag?.bounds.toRectInDocument(
                                  page: hit.page,
                                  pageRect: Rect.fromLTWH(
                                    0,
                                    0,
                                    hit.page.width,
                                    hit.page.height,
                                  ),
                                ) ??
                                Rect.zero,
                            pageNumber: hit.page.pageNumber,
                            details: details,
                          );
                        });
                      } else {
                        setState(() => _tappedInfo = null);
                      }
                    } else {
                      setState(() => _tappedInfo = null);
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

    if (_viewMode != 'none') {
      final paint = Paint()..style = PaintingStyle.fill;
      for (int i = 0; i < boundaries.length; i++) {
        final (start, end) = boundaries[i];
        paint.color = _colors[i % _colors.length];
        try {
          final range = pageText.getRangeFromAB(start, end - 1);
          for (final rect in range.enumerateFragmentBoundingRects()) {
            canvas.drawRect(
              rect.bounds.toRectInDocument(page: page, pageRect: pageRect),
              paint,
            );
          }
        } catch (e) {
          debugPrint(
            '[PAGE ${page.pageNumber}] Error mapping range: $start-$end: $e',
          );
        }
      }
    }

    if (_showAllFragments) {
      final fragmentPaint = Paint()
        ..color = Colors.blue.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      for (final fragment in pageText.fragments) {
        final rect = fragment.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(rect, fragmentPaint);
      }
    }

    final tapped = _tappedInfo;
    if (tapped != null && tapped.pageNumber == page.pageNumber) {
      final localPos = tapped.details.documentPosition;
      final hudRect = Rect.fromCenter(center: localPos, width: 180, height: 60);
      final hudPaint = Paint()..color = Colors.black.withOpacity(0.85);
      canvas.drawRRect(
        RRect.fromRectAndRadius(hudRect, const Radius.circular(8)),
        hudPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text:
              'Fragment: "${tapped.text.substring(0, tapped.text.length.clamp(0, 15))}..."\n'
              'Pos: ${localPos.dx.toStringAsFixed(1)}, ${localPos.dy.toStringAsFixed(1)}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 170);
      textPainter.paint(canvas, hudRect.topLeft + const Offset(10, 10));
    }
  }

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
          await Future.delayed(const Duration(milliseconds: 500));
          attempts++;
          continue;
        }

        final page = pageList[pageNumber - 1];
        pageText = await page.loadStructuredText();
        if (pageText.fullText.isNotEmpty) break;

        await Future.delayed(const Duration(milliseconds: 1000));
        attempts++;
      }

      if (pageText == null || pageText.fullText.isEmpty) {
        _boundariesCache[pageNumber] = [];
        return;
      }
      _textCache[pageNumber] = pageText;

      final List<(int, int)> boundaries = [];
      int currentIndex = 0;
      final fullLength = pageText.fullText.length;

      while (currentIndex < fullLength) {
        final (start, end) = _viewMode == 'sentence'
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

        boundaries.add((start, end));
        currentIndex = end;

        // Skip whitespace between blocks
        while (currentIndex < fullLength &&
            _isWhitespace(pageText.fullText.codeUnitAt(currentIndex))) {
          currentIndex++;
        }
      }

      if (mounted) {
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
