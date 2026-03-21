import 'package:flutter/material.dart';
import 'package:playground/features/image_occlusions/image_occlusion_textify_page.dart';
import 'package:playground/features/image_occlusions/image_occlusion_ocr_space_page.dart';

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
        ],
      ),
    );
  }
}
