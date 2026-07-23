import 'dart:io';

class FlutterService {
  String _resolveFlutterExecutable() {
    // 1. Check if 'flutter' is directly executable on PATH
    try {
      final res = Process.runSync('which', ['flutter']);
      if (res.exitCode == 0 && res.stdout.toString().trim().isNotEmpty) {
        return 'flutter';
      }
    } catch (_) {}

    // 2. Check the specific user path found in .zshrc
    final userFlutterPath = '/Users/indianic/Documents/Flutter/flutter/bin/flutter';
    if (File(userFlutterPath).existsSync()) {
      return userFlutterPath;
    }

    // 3. Fallback to default name
    return 'flutter';
  }

  Map<String, String> _getModifiedEnvironment() {
    final env = Map<String, String>.from(Platform.environment);
    final flutterBinDir = '/Users/indianic/Documents/Flutter/flutter/bin';
    final dartBinDir = '/Users/indianic/Documents/Flutter/flutter/bin/cache/dart-sdk/bin';
    final currentPath = env['PATH'] ?? '';
    
    if (!currentPath.contains(flutterBinDir)) {
      env['PATH'] = '$flutterBinDir:$dartBinDir:$currentPath';
    }
    return env;
  }

  Future<ProcessResult> runCreate(String projectName, String targetDirectory) async {
    final executable = _resolveFlutterExecutable();
    return Process.run(
      executable,
      ['create', projectName],
      workingDirectory: targetDirectory,
      environment: _getModifiedEnvironment(),
      runInShell: true,
    );
  }

  Future<ProcessResult> runPubGet(String projectPath) async {
    final executable = _resolveFlutterExecutable();
    return Process.run(
      executable,
      ['pub', 'get'],
      workingDirectory: projectPath,
      environment: _getModifiedEnvironment(),
      runInShell: true,
    );
  }
}
