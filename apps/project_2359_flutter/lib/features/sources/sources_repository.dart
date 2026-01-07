import 'package:flutter/material.dart';
import 'models/sources_models.dart';

class SourcesRepository {
  List<SourceCategory> getCategories() {
    return const [
      SourceCategory(title: 'All', icon: Icons.check),
      SourceCategory(
        title: 'PDFs',
        icon: Icons.picture_as_pdf,
        type: SourceType.pdf,
      ),
      SourceCategory(title: 'Links', icon: Icons.link, type: SourceType.link),
      SourceCategory(
        title: 'Notes',
        icon: Icons.description,
        type: SourceType.note,
      ),
    ];
  }

  List<SourceMaterial> getRecentSources() {
    return [
      SourceMaterial(
        id: '1',
        title: 'Intro to Macroeconomics',
        type: SourceType.pdf,
        metadata: 'Accessed 2h ago • 3.2MB',
        imageUrl: 'assets/images/source_macroeconomics.png',
        lastAccessed: DateTime.now().subtract(const Duration(hours: 2)),
        size: '3.2MB',
      ),
      SourceMaterial(
        id: '2',
        title: 'Organic Chemistry',
        type: SourceType.note,
        metadata: 'Accessed 5h ago',
        imageUrl: 'assets/images/source_chemistry.png',
        lastAccessed: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  List<SourceMaterial> getAllMaterials() {
    return [
      SourceMaterial(
        id: '3',
        title: 'Advanced Calculus.pdf',
        type: SourceType.pdf,
        metadata: 'Mathematics • 4.5MB',
        lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
        size: '4.5MB',
      ),
      SourceMaterial(
        id: '4',
        title: 'History of Modern Art',
        type: SourceType.link,
        metadata: 'External Link • art-history.org',
        lastAccessed: DateTime.now().subtract(const Duration(days: 2)),
        url: 'art-history.org',
      ),
      SourceMaterial(
        id: '5',
        title: 'Lecture 4: Cognitive Psych',
        type: SourceType.note,
        metadata: 'Notes • Last edited 1d ago',
        lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SourceMaterial(
        id: '6',
        title: 'Week 2 Reading Materials.pdf',
        type: SourceType.pdf,
        metadata: 'English Lit • 1.2MB',
        lastAccessed: DateTime.now().subtract(const Duration(days: 3)),
        size: '1.2MB',
      ),
    ];
  }
}
