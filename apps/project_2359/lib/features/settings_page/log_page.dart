import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<LogLevel> _activeLevels = Set.from(LogLevel.values);
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    return logs.where((log) {
      if (!_activeLevels.contains(log.level)) return false;
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return log.message.toLowerCase().contains(query) ||
          (log.tag?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ExpandableFab(
      alignment: Alignment.bottomRight,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('App Logs'),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 16),
              onPressed: () => AppLogger.clear(),
            ),
          ],
        ),
        body: StreamBuilder<List<LogEntry>>(
          stream: AppLogger.logStream,
          initialData: AppLogger.logs,
          builder: (context, snapshot) {
            final allLogs = snapshot.data ?? [];
            final logs = _filterLogs(allLogs);

            if (logs.isEmpty) {
              return _buildEmptyState(cs, theme);
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                120,
              ), // Extra bottom padding for FAB
              itemCount: logs.length,
              reverse: true, // Show latest logs at the top
              itemBuilder: (context, index) {
                final logIndex = logs.length - 1 - index;
                final log = logs[logIndex];

                Widget gap = const SizedBox.shrink();
                if (logIndex > 0) {
                  final diff = log.timestamp.difference(
                    logs[logIndex - 1].timestamp,
                  );
                  gap = _LatencySeparator(difference: diff);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    gap,
                    _LogTile(log: log),
                  ],
                );
              },
            );
          },
        ),
      ),
      collapsedBuilder: (context, isOpen, expand, close) => IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: expand,
        color: cs.onSurface,
      ),
      expandedBuilder: (context, isOpen, expand, close) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Filters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: close,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search message or tag...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: LogLevel.values.map((level) {
                final isActive = _activeLevels.contains(level);
                final color = _getLevelColor(level, cs);
                return FilterChip(
                  label: Text(
                    level.name.toUpperCase(),
                    style: TextStyle(fontSize: 10),
                  ),
                  selected: isActive,
                  selectedColor: color.withValues(alpha: 0.2),
                  checkmarkColor: color,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _activeLevels.add(level);
                      } else {
                        _activeLevels.remove(level);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.clockRotateLeft,
            size: 48,
            color: cs.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No logs yet' : 'No logs match your filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(LogLevel level, ColorScheme cs) {
    switch (level) {
      case LogLevel.error:
        return cs.error;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.info:
        return cs.primary;
      case LogLevel.debug:
        return cs.onSurface.withValues(alpha: 0.5);
    }
  }
}

class _LatencySeparator extends StatelessWidget {
  final Duration difference;
  const _LatencySeparator({required this.difference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ms = difference.inMilliseconds;

    // Hidden if almost instantaneous
    if (ms < 5) return const SizedBox(height: 4);

    final color = _getLatencyColor(difference, cs);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            color: color.withValues(alpha: 0.1),
            thickness: 1,
            indent: 24,
            endIndent: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              _formatLatency(difference),
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLatencyColor(Duration d, ColorScheme cs) {
    final ms = d.inMilliseconds;
    if (ms < 100) return cs.primary.withValues(alpha: 0.4);
    if (ms < 1000) {
      final t = (ms - 100) / 900;
      return Color.lerp(cs.primary.withValues(alpha: 0.4), Colors.yellow, t)!;
    }
    if (ms < 5000) {
      final t = (ms - 1000) / 4000;
      return Color.lerp(Colors.yellow, Colors.red, t)!;
    }
    return Colors.red;
  }

  String _formatLatency(Duration d) {
    if (d.inDays > 0) return '+${d.inDays}d';
    if (d.inHours > 0) return '+${d.inHours}h';
    if (d.inMinutes > 0) return '+${d.inMinutes}m';
    if (d.inSeconds > 0) {
      return '+${d.inSeconds}.${(d.inMilliseconds % 1000).toString().padLeft(3, '0')}s';
    }
    return '+${d.inMilliseconds}ms';
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry log;

  const _LogTile({required this.log});

  Color _getLevelColor(LogLevel level, ColorScheme cs) {
    switch (level) {
      case LogLevel.error:
        return cs.error;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.info:
        return cs.primary;
      case LogLevel.debug:
        return cs.onSurface.withValues(alpha: 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final levelColor = _getLevelColor(log.level, cs);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: levelColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: levelColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.level.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (log.tag != null) ...[
                const SizedBox(width: 8),
                Text(
                  log.tag!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}.${log.timestamp.millisecond}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.3),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            log.message,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontSize: 11,
              color: log.level == LogLevel.error ? cs.error : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
