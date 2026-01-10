/// Storage page for Project 2359
///
/// Shows database statistics including item counts and file storage usage.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/providers/datasource_providers.dart';
import '../../../core/data/config/app_config.dart';

class StoragePage extends ConsumerStatefulWidget {
  const StoragePage({super.key});

  @override
  ConsumerState<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends ConsumerState<StoragePage> {
  Map<String, int>? _stats;
  int? _totalFileSize;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (kTestMode) {
      // In test mode, show mock data counts
      setState(() {
        _stats = {
          'sources': 6,
          'flashcards': 5,
          'quizQuestions': 3,
          'identificationQuestions': 2,
          'imageOcclusions': 0,
          'matchingSets': 2,
        };
        _totalFileSize = 0;
        _loading = false;
      });
      return;
    }

    // In production mode, query the database
    final db = ref.read(appDatabaseProvider);
    final stats = await db.getStorageStats();
    final fileSize = await db.getTotalSourceFilesSize();

    if (mounted) {
      setState(() {
        _stats = stats;
        _totalFileSize = fileSize;
        _loading = false;
      });
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E14),
        title: const Text(
          'Storage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModeIndicator(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Study Materials'),
                  const SizedBox(height: 12),
                  _buildStatsCard([
                    _buildStatRow(
                      Icons.lightbulb,
                      'Flashcards',
                      _stats?['flashcards'],
                    ),
                    _buildStatRow(
                      Icons.quiz,
                      'Quiz Questions',
                      _stats?['quizQuestions'],
                    ),
                    _buildStatRow(
                      Icons.question_answer,
                      'Identification',
                      _stats?['identificationQuestions'],
                    ),
                    _buildStatRow(
                      Icons.image,
                      'Image Occlusions',
                      _stats?['imageOcclusions'],
                    ),
                    _buildStatRow(
                      Icons.compare_arrows,
                      'Matching Sets',
                      _stats?['matchingSets'],
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Sources'),
                  const SizedBox(height: 12),
                  _buildStatsCard([
                    _buildStatRow(
                      Icons.folder,
                      'Total Sources',
                      _stats?['sources'],
                    ),
                    _buildStatRow(
                      Icons.storage,
                      'File Storage',
                      null,
                      suffix: _formatBytes(_totalFileSize ?? 0),
                    ),
                  ]),
                  const SizedBox(height: 32),
                  if (!kTestMode) ...[_buildDangerZone()],
                ],
              ),
            ),
    );
  }

  Widget _buildModeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kTestMode
            ? Colors.amber.withOpacity(0.15)
            : Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kTestMode
              ? Colors.amber.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            kTestMode ? Icons.science : Icons.storage,
            color: kTestMode ? Colors.amber : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kTestMode ? 'Test Mode' : 'Production Mode',
                  style: TextStyle(
                    color: kTestMode ? Colors.amber : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kTestMode
                      ? 'Using in-memory mock data (resets on restart)'
                      : 'Using SQLite database (data persists)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildStatsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  color: Colors.white.withOpacity(0.05),
                  height: 1,
                  indent: 56,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatRow(
    IconData icon,
    String label,
    int? count, {
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7DFF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2E7DFF), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Text(
            suffix ?? count?.toString() ?? '0',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Danger Zone'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF4B4B).withOpacity(0.2)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showClearDataDialog(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4B4B).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Color(0xFFFF4B4B),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clear All Data',
                            style: TextStyle(
                              color: Color(0xFFFF4B4B),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Permanently delete all stored data',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white24,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Data?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete all your sources, flashcards, quizzes, and other study materials. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement data clearing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data clearing not yet implemented'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}
