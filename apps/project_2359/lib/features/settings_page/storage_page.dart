import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';

class StoragePage extends StatefulWidget {
  final SourceService sourceService;

  const StoragePage({super.key, required this.sourceService});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  List<SourceItem> _sources = [];
  Map<String, SourceItemBlob?> _blobs = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sources = await widget.sourceService.getAllSources();
    final blobs = <String, SourceItemBlob?>{};

    for (final source in sources) {
      blobs[source.id] = await widget.sourceService.getSourceBlobBySourceId(
        source.id,
      );
    }

    if (mounted) {
      setState(() {
        _sources = sources;
        _blobs = blobs;
        _loading = false;
      });
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  int get _totalBytes {
    int total = 0;
    for (final blob in _blobs.values) {
      if (blob != null) total += blob.bytes.length;
    }
    return total;
  }

  Future<void> _deleteSource(SourceItem source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Source'),
        content: Text(
          'Delete "${source.label}" and its file data? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<SourcesPageBloc>().add(DeleteSourceEvent(source.id));
      await _loadData();
    }
  }

  Future<void> _deleteAllSources() async {
    if (_sources.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Sources'),
        content: const Text(
          'This will delete all source files and their data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete All',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      for (final source in _sources) {
        context.read<SourcesPageBloc>().add(DeleteSourceEvent(source.id));
      }
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  ProjectBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  Text('Storage', style: theme.textTheme.displaySmall),
                ],
              ),
            ),

            // Storage summary card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary.withValues(alpha: 0.15),
                      cs.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.database,
                        color: cs.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _loading ? '...' : _formatBytes(_totalBytes),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _loading
                                ? 'Loading...'
                                : '${_sources.length} source${_sources.length == 1 ? '' : 's'} stored',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_sources.isNotEmpty)
                      IconButton(
                        onPressed: _deleteAllSources,
                        icon: FaIcon(
                          FontAwesomeIcons.trashCan,
                          size: 18,
                          color: cs.error.withValues(alpha: 0.7),
                        ),
                        tooltip: 'Delete all',
                      ),
                  ],
                ),
              ),
            ),

            // File list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _sources.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.boxOpen,
                            size: 48,
                            color: cs.onSurface.withValues(alpha: 0.15),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No stored files',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Import sources to see them here',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _sources.length,
                      itemBuilder: (context, index) {
                        final source = _sources[index];
                        final blob = _blobs[source.id];
                        final fileSize = blob != null
                            ? _formatBytes(blob.bytes.length)
                            : 'Unknown';
                        final fileType = blob?.type.toUpperCase() ?? 'FILE';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.black.withValues(alpha: 0.04),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // File type badge
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: cs.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          fileType,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 9,
                                                color: cs.primary,
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // File info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            source.label,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            fileSize,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: cs.onSurface
                                                      .withValues(alpha: 0.5),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Delete button
                                    IconButton(
                                      onPressed: () => _deleteSource(source),
                                      icon: FaIcon(
                                        FontAwesomeIcons.xmark,
                                        size: 16,
                                        color: cs.onSurface.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: cs.onSurface
                                            .withValues(alpha: 0.05),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
