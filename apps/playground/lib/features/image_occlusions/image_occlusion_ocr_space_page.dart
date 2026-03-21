import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'models/ocr_space_response.dart';
import 'services/ocr_space_service.dart';

class ImageOcclusionOcrSpacePage extends StatefulWidget {
  const ImageOcclusionOcrSpacePage({super.key});

  @override
  State<ImageOcclusionOcrSpacePage> createState() =>
      _ImageOcclusionOcrSpacePageState();
}

class _ImageOcclusionOcrSpacePageState
    extends State<ImageOcclusionOcrSpacePage> {
  final _service = OcrSpaceService();
  final _apiKeyController = TextEditingController(text: 'helloworld');

  String? _imagePath;
  String? _extractedText;
  List<OcrWord>? _ocrWords;
  bool _isProcessing = false;
  bool _showBounds = true;

  // Image dimensions for scaling
  double? _imageWidth;
  double? _imageHeight;
  String _ocrEngine = '2';

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;

      // Get image dimensions
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final uiImage = frame.image;

      setState(() {
        _imagePath = path;
        _extractedText = null;
        _ocrWords = null;
        _imageWidth = uiImage.width.toDouble();
        _imageHeight = uiImage.height.toDouble();
      });
    }
  }

  Future<void> _processImage() async {
    if (_imagePath == null) return;
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an API key')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final response = await _service.processImage(
        apiKey: _apiKeyController.text,
        imageFile: File(_imagePath!),
        ocrEngine: _ocrEngine,
      );

      if (response.isErroredOnProcessing) {
        throw Exception(response.errorMessage ?? 'Unknown error');
      }

      if (response.parsedResults.isEmpty) {
        throw Exception('No results found');
      }

      final result = response.parsedResults.first;
      final words = <OcrWord>[];
      if (result.textOverlay != null) {
        for (final line in result.textOverlay!.lines) {
          words.addAll(line.words);
        }
      }

      setState(() {
        _extractedText = result.parsedText;
        _ocrWords = words;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_extractedText != null) {
      Clipboard.setData(ClipboardData(text: _extractedText!));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR.space Occlusion')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: Colors.grey.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OCR.space Settings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _apiKeyController,
                        decoration: const InputDecoration(
                          labelText: 'API Key',
                          hintText: 'Enter your ocr.space API key',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('OCR Engine: '),
                          const SizedBox(width: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: '1',
                                label: Text('Engine 1'),
                              ),
                              ButtonSegment(
                                value: '2',
                                label: Text('Engine 2'),
                              ),
                            ],
                            selected: {_ocrEngine},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() => _ocrEngine = newSelection.first);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Image.file(File(_imagePath!), fit: BoxFit.contain),
                            if (_showBounds &&
                                _ocrWords != null &&
                                _imageWidth != null &&
                                _imageHeight != null)
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _OcrBoundsPainter(
                                    words: _ocrWords!,
                                    imageWidth: _imageWidth!,
                                    imageHeight: _imageHeight!,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Results',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_ocrWords != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Show Bounds',
                            style: TextStyle(fontSize: 12),
                          ),
                          Switch(
                            value: _showBounds,
                            onChanged: (val) =>
                                setState(() => _showBounds = val),
                            activeThumbColor: Colors.deepPurpleAccent,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processImage,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Process with OCR.space',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
              if (_extractedText != null) ...[_buildResultsView()],
              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                    _imagePath == null ? 'Select Image' : 'Change Image',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    final wordCount =
        _extractedText
            ?.split(RegExp(r'\s+'))
            .where((s) => s.isNotEmpty)
            .length ??
        0;
    final charCount = _extractedText?.length ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.2)),
      ),
      color: Colors.deepPurpleAccent.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extracted Text',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy to Clipboard',
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _extractedText!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatChip(Icons.abc, '$charCount characters'),
                _buildStatChip(Icons.short_text, '$wordCount words'),
                _buildStatChip(
                  Icons.grid_on,
                  '${_ocrWords?.length ?? 0} boxes',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepPurpleAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _OcrBoundsPainter extends CustomPainter {
  final List<OcrWord> words;
  final double imageWidth;
  final double imageHeight;

  _OcrBoundsPainter({
    required this.words,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / imageWidth;
    final double scaleY = size.height / imageHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double renderedWidth = imageWidth * scale;
    final double renderedHeight = imageHeight * scale;

    final double offsetX = (size.width - renderedWidth) / 2;
    final double offsetY = (size.height - renderedHeight) / 2;

    final paintLine = Paint()
      ..color = Colors.deepPurpleAccent.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final paintFill = Paint()
      ..color = Colors.deepPurpleAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (final word in words) {
      final double left = offsetX + word.left * scale;
      final double top = offsetY + word.top * scale;
      final double width = word.width * scale;
      final double height = word.height * scale;

      final rect = Rect.fromLTWH(left, top, width, height);

      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintLine);
    }
  }

  @override
  bool shouldRepaint(covariant _OcrBoundsPainter oldDelegate) {
    return oldDelegate.words != words ||
        oldDelegate.imageWidth != imageWidth ||
        oldDelegate.imageHeight != imageHeight;
  }
}
