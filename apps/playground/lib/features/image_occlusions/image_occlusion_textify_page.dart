import 'dart:io';
import 'dart:ui' as ui;
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:textify/textify.dart';
import 'package:textify/models/textify_config.dart';
import 'package:textify/band.dart';
import 'package:textify/bands.dart';

class ImageOcclusionTextifyPage extends StatefulWidget {
  const ImageOcclusionTextifyPage({super.key});

  @override
  State<ImageOcclusionTextifyPage> createState() =>
      _ImageOcclusionTextifyPageState();
}

class _ImageOcclusionTextifyPageState extends State<ImageOcclusionTextifyPage> {
  String? _imagePath;
  String? _extractedText;
  List<Band>? _bands;
  bool _isProcessing = false;
  bool _showBounds = true;

  // Image dimensions for scaling
  double? _imageWidth;
  double? _imageHeight;
  TextifyConfig _config = TextifyConfig.accurate;
  String _configLabel = 'Accurate';

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _imagePath = result.files.single.path;
        _extractedText = null; // Clear previous results
        _bands = null; // Clear previous bands
        _imageWidth = null;
        _imageHeight = null;
      });
    }
  }

  Future<void> _processImage() async {
    if (_imagePath == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final file = File(_imagePath!);
      final bytes = await file.readAsBytes();

      // Perform heavy OCR in a background isolate to prevent UI lag
      final result = await Isolate.run(
        () => _performOcrBackground(bytes, _config),
      );

      setState(() {
        _imageWidth = result.imageWidth;
        _imageHeight = result.imageHeight;
        _extractedText = result.text;
        _bands = result.bands;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error processing image: $e')));
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
      appBar: AppBar(title: const Text('Image Occlusion')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Image.file(File(_imagePath!), fit: BoxFit.contain),
                            if (_showBounds &&
                                _bands != null &&
                                _imageWidth != null &&
                                _imageHeight != null)
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _BoundsPainter(
                                    bands: _bands!,
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

                // OCR Toggle and Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Textify Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_bands != null)
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
                            activeThumbColor: Colors.blueAccent,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Fast',
                      label: Text('Fast'),
                      icon: Icon(Icons.speed),
                    ),
                    ButtonSegment(
                      value: 'Accurate',
                      label: Text('Accurate'),
                      icon: Icon(Icons.high_quality),
                    ),
                    ButtonSegment(
                      value: 'Robust',
                      label: Text('Robust'),
                      icon: Icon(Icons.auto_fix_high),
                    ),
                  ],
                  selected: {_configLabel},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _configLabel = newSelection.first;
                      switch (_configLabel) {
                        case 'Fast':
                          _config = TextifyConfig.fast;
                          break;
                        case 'Accurate':
                          _config = TextifyConfig.accurate;
                          break;
                        case 'Robust':
                          _config = TextifyConfig.robust;
                          break;
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processImage,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Process with Textify',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
        side: BorderSide(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      color: Colors.blueAccent.withOpacity(0.05),
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
                    color: Colors.blueAccent,
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
            Row(
              children: [
                _buildStatChip(Icons.abc, '$charCount characters'),
                const SizedBox(width: 12),
                _buildStatChip(Icons.short_text, '$wordCount words'),
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
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  /// Internal helper for background OCR processing
  static Future<_OcrResult> _performOcrBackground(
    Uint8List bytes,
    TextifyConfig config,
  ) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    final textify = Textify(config: config);
    await textify.init();

    final text = await textify.getTextFromImage(image: uiImage);

    return _OcrResult(
      text: text,
      bands: textify.bands.list,
      imageWidth: uiImage.width.toDouble(),
      imageHeight: uiImage.height.toDouble(),
    );
  }
}

class _OcrResult {
  final String text;
  final List<Band> bands;
  final double imageWidth;
  final double imageHeight;

  _OcrResult({
    required this.text,
    required this.bands,
    required this.imageWidth,
    required this.imageHeight,
  });
}

class _BoundsPainter extends CustomPainter {
  final List<Band> bands;
  final double imageWidth;
  final double imageHeight;

  _BoundsPainter({
    required this.bands,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the fit of the image within the available size
    final double scaleX = size.width / imageWidth;
    final double scaleY = size.height / imageHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double renderedWidth = imageWidth * scale;
    final double renderedHeight = imageHeight * scale;

    final double offsetX = (size.width - renderedWidth) / 2;
    final double offsetY = (size.height - renderedHeight) / 2;

    final paintLine = Paint()
      ..color = Colors.blueAccent.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintFill = Paint()
      ..color = Colors.blueAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (final band in bands) {
      final rect = band.rectangleOriginal;

      final double left = offsetX + rect.left * scale;
      final double top = offsetY + rect.top * scale;
      final double right = offsetX + rect.right * scale;
      final double bottom = offsetY + rect.bottom * scale;

      final mappedRect = Rect.fromLTRB(left, top, right, bottom);

      canvas.drawRect(mappedRect, paintFill);
      canvas.drawRect(mappedRect, paintLine);
    }
  }

  @override
  bool shouldRepaint(covariant _BoundsPainter oldDelegate) {
    return oldDelegate.bands != bands ||
        oldDelegate.imageWidth != imageWidth ||
        oldDelegate.imageHeight != imageHeight;
  }
}
