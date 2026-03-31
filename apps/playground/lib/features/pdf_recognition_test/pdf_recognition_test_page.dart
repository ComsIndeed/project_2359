import 'dart:io';
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
      });
    }
  }

  Future<List<(int, int)>> _getBoundaries(int pageNumber) async {
    if (_boundariesCache.containsKey(pageNumber)) {
      return _boundariesCache[pageNumber]!;
    }

    final page = _controller.pages[pageNumber - 1];
    final pageText = await page.loadStructuredText();
    if (pageText.fullText.isEmpty) return [];

    final List<(int, int)> boundaries = [];
    int currentIndex = 0;
    final fullLength = pageText.fullText.length;

    while (currentIndex < fullLength) {
      // Find the next boundary starting from currentIndex
      final (start, end) = _granularity == RecognitionGranularity.sentence
          ? PdfTextBoundaryDetector.findSentenceBounds(pageText, currentIndex)
          : PdfTextBoundaryDetector.findParagraphBounds(pageText, currentIndex);

      if (start >= end || start < currentIndex) {
        // Fallback or skip if boundary detection fails to progress
        currentIndex++;
        continue;
      }

      boundaries.add((start, end));
      currentIndex = end;
    }

    _boundariesCache[pageNumber] = boundaries;
    return boundaries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Recognition Test'),
        actions: [
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
                textSelectionParams: const PdfTextSelectionParams(
                  enableTextSelection: true,
                ),
                pagePaintCallbacks: [
                  (canvas, pageRect, page) {
                    _drawBoundaries(canvas, pageRect, page);
                  },
                ],
              ),
            ),
    );
  }

  Future<void> _drawBoundaries(
    Canvas canvas,
    Rect pageRect,
    PdfPage page,
  ) async {
    final boundaries = await _getBoundaries(page.pageNumber);
    final pageText = await page.loadStructuredText();

    for (int i = 0; i < boundaries.length; i++) {
      final (start, end) = boundaries[i];
      final color = _colors[i % _colors.length];
      final paint = Paint()..color = color;

      // Create a range object for the segment
      final range = pageText.getRangeFromAB(start, end - 1);

      // Enumerate rects for the range and draw them
      for (final rect in range.enumerateFragmentBoundingRects()) {
        final flutterRect = rect.bounds.toRect(
          page: page,
          scaledPageSize: pageRect.size,
        );
        canvas.drawRect(flutterRect, paint);
      }
    }
  }
}
