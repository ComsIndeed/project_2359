import 'dart:async';
import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error, debug }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
  });

  @override
  String toString() =>
      '${timestamp.toIso8601String()} [$level] ${tag != null ? '($tag) ' : ''}$message';
}

class AppLogger {
  static final List<LogEntry> _logs = [];
  static final StreamController<List<LogEntry>> _controller =
      StreamController<List<LogEntry>>.broadcast();

  static List<LogEntry> get logs => List.unmodifiable(_logs);
  static Stream<List<LogEntry>> get logStream => _controller.stream;

  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);
  static void warning(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);
  static void error(String message, {String? tag}) =>
      _log(LogLevel.error, message, tag: tag);
  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  static void _log(LogLevel level, String message, {String? tag}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
    );
    _logs.add(entry);
    if (_logs.length > 500) _logs.removeAt(0);
    _controller.add(logs);

    if (kDebugMode) {
      print(entry.toString());
    }
  }

  static void clear() {
    _logs.clear();
    _controller.add(logs);
  }
}
