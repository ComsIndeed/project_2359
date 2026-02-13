import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({super.key, required this.fileBytes});

  final Uint8List fileBytes;

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  final AdvancedDrawerController controller = AdvancedDrawerController();
  late final PdfDocument document;

  @override
  void initState() {
    super.initState();
    document = PdfDocument(inputBytes: widget.fileBytes);
  }

  @override
  void dispose() {
    document.dispose();
    super.dispose();
  }

  String get documentText => PdfTextExtractor(document).extractText();
  List<TextLine> get documentTextLines =>
      PdfTextExtractor(document).extractTextLines();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdvancedDrawer(
        animationDuration: Durations.short4,
        animationCurve: Curves.easeInOutCubic,
        openScale: 1,
        openRatio: 1,
        rtlOpening: true,
        controller: controller,
        drawer: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    controller.hideDrawer();
                  },
                ),
                // Text(documentTextLines.map((e) => "${e.text}\n\n").join()),
                Text(documentText),
              ],
            ),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 800,
                    width: double.infinity,
                    child: SfPdfViewerTheme(
                      data: const SfPdfViewerThemeData(),
                      child: SfPdfViewer.memory(widget.fileBytes),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  child: Icon(Icons.arrow_left),
                  onPressed: () {
                    controller.showDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
