import 'package:flutter/material.dart';
import 'models/materials_models.dart';

class MaterialsRepository {
  List<SourceItem> getSourceItems() {
    return [
      const SourceItem(
        title: 'Scan Doc',
        subtitle: 'Camera Input',
        icon: Icons.document_scanner_outlined,
        backgroundImage: 'assets/images/hero_biology.png',
      ),
      const SourceItem(
        title: 'Upload PDF',
        subtitle: 'File system',
        icon: Icons.upload_file_outlined,
        backgroundImage: 'assets/images/source_macroeconomics.png',
      ),
      const SourceItem(
        title: 'Paste Text',
        subtitle: 'Clipboard',
        icon: Icons.assignment_outlined,
        backgroundImage: 'assets/images/source_chemistry.png',
      ),
      const SourceItem(
        title: 'Library',
        subtitle: 'Saved sources',
        icon: Icons.folder_outlined,
        backgroundImage: 'assets/images/hero_biology.png',
      ),
    ];
  }

  List<OutputFormat> getOutputFormats() {
    return [
      const OutputFormat(
        title: 'Flashcards',
        icon: Icons.style_outlined,
        color: Color(0xFF2E7DFF),
      ),
      const OutputFormat(
        title: 'Quiz',
        icon: Icons.quiz_outlined,
        color: Color(0xFFEC4899),
      ),
      const OutputFormat(
        title: 'Summary',
        icon: Icons.description_outlined,
        color: Color(0xFF06B6D4),
      ),
      const OutputFormat(
        title: 'Mind Map',
        icon: Icons.account_tree_outlined,
        color: Color(0xFFA855F7),
      ),
    ];
  }

  List<RecentGeneration> getRecentGenerations() {
    return [
      const RecentGeneration(
        title: 'Biology Ch.4 Quiz',
        subtitle: 'Generated 2h ago • 15 Qs',
        icon: Icons.quiz,
        iconColor: Color(0xFF4ADE80),
      ),
      const RecentGeneration(
        title: 'History Essay Outline',
        subtitle: 'Generated 5h ago • 24 Cards',
        icon: Icons.style,
        iconColor: Color(0xFFFB923C),
      ),
      const RecentGeneration(
        title: 'Calculus Concepts',
        subtitle: 'Generated 1d ago • Summary',
        icon: Icons.description,
        iconColor: Color(0xFFA855F7),
      ),
    ];
  }
}
