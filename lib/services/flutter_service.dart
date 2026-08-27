import 'dart:io';

class FlutterService {
  static const List<String> _flutterCandidates = [
    '/Users/indianic/Documents/Flutter/flutter/bin/flutter',
    '/opt/homebrew/bin/flutter',
    '/usr/local/bin/flutter',
    '/usr/bin/flutter',
  ];

  String _resolveFlutterExecutable() {
    final envFlutter = Platform.environment['FLUTTER_PATH'];

    if (envFlutter != null &&
        envFlutter.isNotEmpty &&
        File(envFlutter).existsSync()) {
      stderr.writeln("Using FLUTTER_PATH: $envFlutter");
      return envFlutter;
    }

    for (final path in _flutterCandidates) {
      if (File(path).existsSync()) {
        stderr.writeln("Using Flutter: $path");
        return path;
      }
    }

    try {
      final res = Process.runSync('which', ['flutter']);
      if (res.exitCode == 0) {
        final path = res.stdout.toString().trim();
        if (path.isNotEmpty && File(path).existsSync()) {
          stderr.writeln("Using resolved which flutter: $path");
          return path;
        }
      }
    } catch (_) {}

    stderr.writeln("Using flutter from PATH");
    return "flutter";
  }

  String _resolveFlutterRoot(String executable) {
    if (executable != 'flutter' && File(executable).isAbsolute) {
      final file = File(executable);
      final binDir = file.parent.path;
      final rootDir = Directory(binDir).parent.path;
      return rootDir;
    }
    final envRoot = Platform.environment['FLUTTER_ROOT'];
    if (envRoot != null && envRoot.isNotEmpty && Directory(envRoot).existsSync()) {
      return envRoot;
    }
    return '/Users/indianic/Documents/Flutter/flutter';
  }

  Map<String, String> _environment(String executable) {
    final env = Map<String, String>.from(Platform.environment);

    final flutterRoot = _resolveFlutterRoot(executable);
    final flutterBin = '$flutterRoot/bin';
    final dartBin = '$flutterRoot/bin/cache/dart-sdk/bin';

    env['HOME'] ??= Platform.environment['HOME'] ?? '/Users/indianic';
    env['FLUTTER_ROOT'] = flutterRoot;
    env['FLUTTER_PATH'] = '$flutterBin/flutter';

    env['PATH'] =
        '$flutterBin:$dartBin:${env['PATH'] ?? '/usr/local/bin:/usr/bin:/bin'}';

    return env;
  }

  Future<void> _printFlutterVersion() async {
    try {
      final executable = _resolveFlutterExecutable();

      final result = await Process.run(
        executable,
        ['--version'],
        environment: _environment(executable),
      );

      stderr.writeln("========= FLUTTER VERSION =========");
      stderr.writeln(result.stdout);
      stderr.writeln(result.stderr);
      stderr.writeln("===================================");
    } catch (e) {
      stderr.writeln("Flutter version check failed: $e");
    }
  }

  Future<ProcessResult> runCreate(
    String projectName,
    String targetDirectory,
  ) async {
    await _printFlutterVersion();

    final executable = _resolveFlutterExecutable();

    stderr.writeln("=================================");
    stderr.writeln("Flutter Executable : $executable");
    stderr.writeln("Project Name       : $projectName");
    stderr.writeln("Target Directory   : $targetDirectory");
    stderr.writeln("Executable Exists  : ${File(executable).existsSync()}");
    stderr.writeln("PATH               : ${_environment(executable)['PATH']}");
    stderr.writeln("=================================");

    final result = await Process.run(
      executable,
      [
        'create',
        projectName,
      ],
      workingDirectory: targetDirectory,
      environment: _environment(executable),
    );

    stderr.writeln("========== CREATE RESULT ==========");
    stderr.writeln("Exit Code : ${result.exitCode}");
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    stderr.writeln("===================================");

    if (result.exitCode != 0) {
      throw Exception(
        '''
Flutter create failed

Exit Code : ${result.exitCode}

STDOUT:

${result.stdout}

STDERR:

${result.stderr}
''',
      );
    }

    return result;
  }

  Future<ProcessResult> runPubGet(String projectPath) async {
    final executable = _resolveFlutterExecutable();

    final result = await Process.run(
      executable,
      ['pub', 'get'],
      workingDirectory: projectPath,
      environment: _environment(executable),
    );

    stderr.writeln("========== PUB GET ==========");
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    stderr.writeln("=============================");

    if (result.exitCode != 0) {
      throw Exception(
        '''
flutter pub get failed

${result.stderr}
''',
      );
    }

    return result;
  }
}