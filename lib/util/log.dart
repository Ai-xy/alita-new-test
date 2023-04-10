import 'dart:developer' as developer;

enum LogLevel {
  verbose(tag: '[VERBOSE]', abbreviation: 'V'),
  info(tag: '[INFO]   ', abbreviation: 'I'),
  debug(tag: '[DEBUG]  ', abbreviation: 'D'),
  warn(tag: '[WARN]   ', abbreviation: 'W'),
  error(tag: '[ERROR]  ', abbreviation: 'E');

  final String tag;
  final String abbreviation;

  const LogLevel({required this.tag, required this.abbreviation});
}

class Log {
  static void v(String msg, {bool? logcat, String? tag}) {
    log(msg, LogLevel.verbose, logcat: logcat, tag: tag);
  }

  static void i(String msg, {bool? logcat, String? tag}) {
    log(msg, LogLevel.info, logcat: logcat, tag: tag);
  }

  static void d(String msg, {bool? logcat, String? tag}) {
    log(msg, LogLevel.debug, logcat: logcat, tag: tag);
  }

  static void w(String msg, {bool? logcat, String? tag}) {
    log(msg, LogLevel.warn, logcat: logcat, tag: tag);
  }

  static void e(String msg,
      {bool? logcat, StackTrace? stackTrace, String? tag, Object? error}) {
    log('', LogLevel.error, logcat: logcat, tag: tag, error: error);
  }

  static void log(
    String msg,
    LogLevel level, {
    bool? logcat,
    StackTrace? stackTrace,
    String? tag,
    Object? error,
  }) {
    developer.log('$msg===${DateTime.now()} ===',
        stackTrace: stackTrace, name: tag ?? 'Alita', error: error);
  }
}
