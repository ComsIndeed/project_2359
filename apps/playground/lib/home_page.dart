import 'package:flutter/material.dart';
import 'package:playground/features/image_occlusions/image_occlusion_textify_page.dart';
import 'package:playground/features/image_occlusions/image_occlusion_ocr_space_page.dart';
import 'package:playground/features/document_topic_selection/document_topic_selection_page.dart';
import 'package:playground/features/pdf_recognition_test/pdf_recognition_test_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageOcclusionTextifyPage(),
                ),
              );
            },
            child: const Text("Image Occlusion Textify"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageOcclusionOcrSpacePage(),
                ),
              );
            },
            child: const Text("Image Occlusion OCR.space"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentTopicSelectionPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Document Topic Selection"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PdfRecognitionTestPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("PDF Recognition Test"),
          ),
        ],
      ),
    );
  }
}
