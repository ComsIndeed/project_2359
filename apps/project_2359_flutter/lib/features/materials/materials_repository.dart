import 'package:flutter/material.dart';
import 'models/materials_models.dart';

class MaterialsRepository {
  List<SourceItem> getSourceItems() {
    return [
      const SourceItem(
        title: 'Scan Doc',
        subtitle: 'Camera Input',
        icon: Icons.document_scanner_outlined,
        backgroundImage:
            'https://images.unsplash.com/photo-1586769852836-bc069f19e1b6?q=80&w=2070&auto=format&fit=crop',
      ),
      const SourceItem(
        title: 'Upload PDF',
        subtitle: 'File system',
        icon: Icons.upload_file_outlined,
        backgroundImage:
            'https://images.unsplash.com/photo-1568667256549-094345857637?q=80&w=2030&auto=format&fit=crop',
      ),
      const SourceItem(
        title: 'Paste Text',
        subtitle: 'Clipboard',
        icon: Icons.assignment_outlined,
        backgroundImage:
            'https://images.unsplash.com/photo-1517842645767-c639042777db?q=80&w=2070&auto=format&fit=crop',
      ),
      const SourceItem(
        title: 'Library',
        subtitle: 'Saved sources',
        icon: Icons.folder_outlined,
        backgroundImage:
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?q=80&w=2056&auto=format&fit=crop',
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
