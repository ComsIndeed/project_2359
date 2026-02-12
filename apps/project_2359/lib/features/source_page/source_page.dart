import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SourcePage extends StatelessWidget {
  const SourcePage({super.key, required this.fileBytes});

  final Uint8List fileBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SfPdfViewer.memory(fileBytes),
          ],
        ),
      ),
    );
  }
}
