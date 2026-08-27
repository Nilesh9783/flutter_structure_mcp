import 'dart:io';

enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel currentLevel = LogLevel.info;
  static final List<String> _sensitiveTokens = [];

  static void registerSensitiveToken(String token) {
    if (token.isNotEmpty && !_sensitiveTokens.contains(token)) {
      _sensitiveTokens.add(token);
    }
  }

  static String _redact(String message) {
    var redacted = message;
    for (final token in _sensitiveTokens) {
      redacted = redacted.replaceAll(token, '[REDACTED_SECRET]');
    }
    // Also run a regex to catch typical API keys/secrets patterns
    redacted = redacted.replaceAll(
      RegExp(r'(api[_-]?key|secret|password|token|jwt|auth_token|passwd|private_key)\s*[:=]\s*[^\s,\n"''{}]+', caseSensitive: false),
      r'\1: [REDACTED_SECRET]',
    );
    return redacted;
  }

  static void debug(String message) {
    if (currentLevel.index <= LogLevel.debug.index) {
      stderr.writeln('[DEBUG] ${_redact(message)}');
    }
  }

  static void info(String message) {
    if (currentLevel.index <= LogLevel.info.index) {
      stderr.writeln('[INFO] ${_redact(message)}');
    }
  }

  static void warning(String message) {
    if (currentLevel.index <= LogLevel.warning.index) {
      stderr.writeln('[WARNING] ${_redact(message)}');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stack]) {
    if (currentLevel.index <= LogLevel.error.index) {
      stderr.writeln('[ERROR] ${_redact(message)}');
      if (error != null) {
        stderr.writeln('  Error details: $error');
      }
      if (stack != null) {
        stderr.writeln('  Stacktrace:\n$stack');
      }
    }
  }
}
