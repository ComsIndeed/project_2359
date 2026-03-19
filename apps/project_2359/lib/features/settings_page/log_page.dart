import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/utils/logger.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
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
          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
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
                    'No logs yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: logs.length,
            reverse: true, // Show latest logs at the top
            itemBuilder: (context, index) {
              final logIndex = logs.length - 1 - index;
              final log = logs[logIndex];

              // Calculate difference from previous log (the one chronologically before this one)
              Duration? difference;
              if (logIndex > 0) {
                difference = log.timestamp.difference(
                  logs[logIndex - 1].timestamp,
                );
              }

              return _LogTile(log: log, difference: difference);
            },
          );
        },
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry log;
  final Duration? difference;

  const _LogTile({required this.log, this.difference});

  String _formatDuration(Duration d) {
    if (d.inDays > 0) return '+${d.inDays}d';
    if (d.inHours > 0) return '+${d.inHours}h';
    if (d.inMinutes > 0) return '+${d.inMinutes}m';
    if (d.inSeconds > 0)
      return '+${d.inSeconds}.${(d.inMilliseconds % 1000).toString().padLeft(3, '0')}s';
    return '+${d.inMilliseconds}ms';
  }

  Color _getDifferenceColor(Duration d, ColorScheme cs) {
    final ms = d.inMilliseconds;
    if (ms < 100) return cs.primary.withValues(alpha: 0.5);
    if (ms < 1000) {
      // Scale from primary to bright yellow (100ms to 1000ms)
      final t = (ms - 100) / 900;
      return Color.lerp(cs.primary.withValues(alpha: 0.5), Colors.yellow, t)!;
    }
    if (ms < 5000) {
      // Scale from yellow to bright red (1s to 5s)
      final t = (ms - 1000) / 4000;
      return Color.lerp(Colors.yellow, Colors.red, t)!;
    }
    return Colors.red;
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
              if (difference != null) ...[
                Text(
                  _formatDuration(difference!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getDifferenceColor(difference!, cs),
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
              ],
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
