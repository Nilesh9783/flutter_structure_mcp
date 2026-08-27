import 'dart:io';
import '../logging/logger.dart';

class ProcessRunner {
  static const List<String> _executableAllowlist = ['flutter', 'dart', 'git'];

  /// Validates and runs a process safely, avoiding shell executions.
  static Future<ProcessResult> run(
    String executableName,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
  }) async {
    // 1. Verify executable is in allowlist
    final baseName = executableName.split('/').last.split('\\').last;
    if (!_executableAllowlist.contains(baseName)) {
      throw SecurityException('Executable "$executableName" is not allowed.');
    }

    // 2. Prevent path traversal / argument injection attempts
    for (final arg in arguments) {
      if (arg.contains(';') || arg.contains('&') || arg.contains('|') || arg.contains('`')) {
        throw SecurityException('Dangerous character detected in argument: "$arg"');
      }
    }

    Logger.debug('Executing process: $executableName with args $arguments in working dir: $workingDirectory');

    try {
      final result = await Process.run(
        executableName,
        arguments,
        workingDirectory: workingDirectory,
        environment: environment,
      );
      return result;
    } catch (e, stackTrace) {
      Logger.error('Failed to run process: $executableName', e, stackTrace);
      rethrow;
    }
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
