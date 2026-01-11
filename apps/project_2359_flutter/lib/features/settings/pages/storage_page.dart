import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/providers/datasource_providers.dart';
import '../../../core/data/config/app_config.dart';
import '../../../core/services/source_storage_service.dart';
import '../../common/app_list_tile.dart';
import '../../common/app_header.dart';
import '../../../core/core.dart';

class StoragePage extends ConsumerStatefulWidget {
  const StoragePage({super.key});

  @override
  ConsumerState<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends ConsumerState<StoragePage> {
  Map<String, int>? _stats;
  int? _totalFileSize;
  bool _loading = true;
  List<StoredFileInfo> _storedFiles = [];
  bool _showFiles = false;
  final _storageService = SourceStorageService();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);

    // Load stored files info
    try {
      _storedFiles = await _storageService.listStoredFiles();
      _totalFileSize = await _storageService.getTotalStorageSize();
    } catch (e) {
      _storedFiles = [];
      _totalFileSize = 0;
    }

    if (kTestMode) {
      // In test mode, show mock data counts
      if (mounted) {
        setState(() {
          _stats = {
            'sources': 6,
            'flashcards': 5,
            'quizQuestions': 3,
            'identificationQuestions': 2,
            'imageOcclusions': 0,
            'matchingSets': 2,
          };
          _loading = false;
        });
      }
      return;
    }

    // In production mode, query the database
    final db = ref.read(appDatabaseProvider);
    final stats = await db.getStorageStats();

    if (mounted) {
      setState(() {
        _stats = stats;
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

  Future<void> _deleteFile(StoredFileInfo file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete File?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete "${file.name}"? This cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteFile(file.path);
      await _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted ${file.name}')));
      }
    }
  }

  Future<void> _clearAllStorage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Storage?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete ALL stored source files. Your database records will remain but file references will be broken. This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All Files'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.clearAllStorage();
      await _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All stored files deleted')),
        );
      }
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _loadStats,
            tooltip: 'Refresh',
          ),
        ],
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
                  _buildSectionHeader('Source Files'),
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
                    _buildStatRow(
                      Icons.insert_drive_file,
                      'Stored Files',
                      _storedFiles.length,
                    ),
                  ]),
                  if (_storedFiles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildFileManager(),
                  ],
                  const SizedBox(height: 32),
                  _buildDangerZone(),
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
            ? Colors.amber.withValues(alpha: 0.15)
            : Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kTestMode
              ? Colors.amber.withValues(alpha: 0.3)
              : Colors.green.withValues(alpha: 0.3),
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
    return AppSectionHeader(title: title);
  }

  Widget _buildStatsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  color: Colors.white.withValues(alpha: 0.05),
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
              color: const Color(0xFF2E7DFF).withValues(alpha: 0.15),
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
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _showFiles = !_showFiles),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(
                    _showFiles ? Icons.folder_open : Icons.folder,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _showFiles ? 'Hide Files' : 'Browse Files',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Icon(
                    _showFiles ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white38,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _showFiles
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _storedFiles.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.white.withValues(alpha: 0.05),
                      height: 1,
                      indent: 56,
                    ),
                    itemBuilder: (context, index) {
                      final file = _storedFiles[index];
                      return AppListTile(
                        title: file.name,
                        subtitle:
                            '${file.type?.name.toUpperCase() ?? 'Unknown'} • ${file.formattedSize}',
                        icon: _getTypeIcon(file.type),
                        iconColor: _getTypeColor(file.type),
                        trailing: IconButton(
                          onPressed: () => _deleteFile(file),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  IconData _getTypeIcon(dynamic type) {
    if (type == null) return Icons.insert_drive_file;
    final name = type.toString().split('.').last;
    switch (name) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'audio':
        return Icons.audio_file;
      case 'video':
        return Icons.video_file;
      case 'image':
        return Icons.image;
      case 'note':
        return Icons.description;
      case 'link':
        return Icons.link;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getTypeColor(dynamic type) {
    if (type == null) return Colors.grey;
    final name = type.toString().split('.').last;
    switch (name) {
      case 'pdf':
        return Colors.redAccent;
      case 'audio':
        return Colors.purpleAccent;
      case 'video':
        return Colors.tealAccent;
      case 'image':
        return Colors.pinkAccent;
      case 'note':
        return Colors.orangeAccent;
      case 'link':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
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
            border: Border.all(
              color: const Color(0xFFFF4B4B).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  onTap: _clearAllStorage,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFF4B4B,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.folder_delete,
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
                                'Clear File Storage',
                                style: TextStyle(
                                  color: Color(0xFFFF4B4B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Delete all stored source files',
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
              if (!kTestMode) ...[
                Divider(
                  color: const Color(0xFFFF4B4B).withOpacity(0.1),
                  height: 1,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    onTap: _showClearDataDialog,
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
                                  'Delete database and all files',
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
              ],
            ],
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
            onPressed: () async {
              Navigator.pop(context);
              // Clear storage first
              await _storageService.clearAllStorage();
              // TODO: Clear database tables
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Storage cleared. Database clearing not yet implemented.',
                    ),
                  ),
                );
                _loadStats();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}
