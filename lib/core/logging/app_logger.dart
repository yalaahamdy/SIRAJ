import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Abstract contract for logging in SIRAJ.
/// Strictly enforces privacy rules: NO sensitive devotions or personal credentials allowed.
abstract class AppLogger {
  void debug(String message, {String? tag, Object? error, StackTrace? stackTrace});
  void info(String message, {String? tag, Object? error, StackTrace? stackTrace});
  void warning(String message, {String? tag, Object? error, StackTrace? stackTrace});
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace});
}

/// Default logger implementation for development and runtime diagnostics.
class StandardLogger implements AppLogger {
  final LogLevel minLevel;
  final bool enableConsole;

  const StandardLogger({
    this.minLevel = kDebugMode ? LogLevel.debug : LogLevel.info,
    this.enableConsole = true,
  });

  @override
  void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;
    if (!enableConsole) return;

    final prefix = '[${level.name.toUpperCase()}]${tag != null ? ' [$tag]' : ''}';
    final logLine = '$prefix $message';

    if (kDebugMode) {
      debugPrint(logLine);
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}

/// In-memory logger for unit tests to verify logged events without console noise.
class TestLogger implements AppLogger {
  final List<LogEntry> entries = [];

  @override
  void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    entries.add(LogEntry(LogLevel.debug, message, tag, error, stackTrace));
  }

  @override
  void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    entries.add(LogEntry(LogLevel.info, message, tag, error, stackTrace));
  }

  @override
  void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    entries.add(LogEntry(LogLevel.warning, message, tag, error, stackTrace));
  }

  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    entries.add(LogEntry(LogLevel.error, message, tag, error, stackTrace));
  }

  void clear() => entries.clear();
}

class LogEntry {
  final LogLevel level;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry(this.level, this.message, this.tag, this.error, this.stackTrace)
      : timestamp = DateTime.now();

  @override
  String toString() => '${level.name.toUpperCase()}: $message';
}
