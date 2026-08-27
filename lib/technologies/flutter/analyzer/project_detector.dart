import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:flutter_architect_mcp/core/logging/logger.dart';

enum ProjectMode { newProject, existingProject }

class ProjectMetadata {
  final String projectName;
  final String flutterVersion;
  final String dartVersion;
  final Map<String, String> dependencies;
  final Map<String, String> devDependencies;
  final String detectedArchitecture;
  final String detectedStateManagement;
  final String detectedRouter;
  final String detectedNetwork;
  final String detectedDatabase;
  final bool hasFirebase;
  final bool hasAuthentication;
  final List<String> targetPlatforms;

  ProjectMetadata({
    required this.projectName,
    required this.flutterVersion,
    required this.dartVersion,
    required this.dependencies,
    required this.devDependencies,
    required this.detectedArchitecture,
    required this.detectedStateManagement,
    required this.detectedRouter,
    required this.detectedNetwork,
    required this.detectedDatabase,
    required this.hasFirebase,
    required this.hasAuthentication,
    required this.targetPlatforms,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'flutterVersion': flutterVersion,
      'dartVersion': dartVersion,
      'dependencies': dependencies,
      'devDependencies': devDependencies,
      'detectedArchitecture': detectedArchitecture,
      'detectedStateManagement': detectedStateManagement,
      'detectedRouter': detectedRouter,
      'detectedNetwork': detectedNetwork,
      'detectedDatabase': detectedDatabase,
      'hasFirebase': hasFirebase,
      'hasAuthentication': hasAuthentication,
      'targetPlatforms': targetPlatforms,
    };
  }
}

class ProjectDetector {
  /// Determines if a user prompt implies a new project or an existing project.
  static ProjectMode detectMode(String input, {String? projectPath}) {
    if (projectPath != null && projectPath.isNotEmpty) {
      final dir = Directory(projectPath);
      if (dir.existsSync()) {
        final pubspec = File(p.join(dir.path, 'pubspec.yaml'));
        if (pubspec.existsSync()) {
          return ProjectMode.existingProject;
        }
      }
    }

    final lower = input.toLowerCase();
    if (lower.contains('create') ||
        lower.contains('generate') ||
        lower.contains('new project') ||
        lower.contains('bootstrap')) {
      return ProjectMode.newProject;
    }

    if (lower.contains('audit') ||
        lower.contains('analyze') ||
        lower.contains('scan') ||
        lower.contains('check')) {
      return ProjectMode.existingProject;
    }

    return ProjectMode.newProject;
  }

  /// Validates the structure of an existing Flutter project.
  static Map<String, bool> validateStructure(String projectPath) {
    final root = Directory(projectPath);
    if (!root.existsSync()) {
      return {'root_exists': false};
    }

    return {
      'pubspec.yaml': File(p.join(projectPath, 'pubspec.yaml')).existsSync(),
      'lib': Directory(p.join(projectPath, 'lib')).existsSync(),
      'android': Directory(p.join(projectPath, 'android')).existsSync(),
      'ios': Directory(p.join(projectPath, 'ios')).existsSync(),
      'test': Directory(p.join(projectPath, 'test')).existsSync(),
      'assets': Directory(p.join(projectPath, 'assets')).existsSync(),
      'analysis_options.yaml': File(p.join(projectPath, 'analysis_options.yaml')).existsSync(),
    };
  }

  /// Extracts project metadata from pubspec.yaml and directories.
  static ProjectMetadata detectMetadata(String projectPath) {
    final pubspecFile = File(p.join(projectPath, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw Exception('Not a valid Flutter project: pubspec.yaml is missing.');
    }

    String projectName = '';
    String dartVersion = 'unknown';
    String flutterVersion = 'unknown';
    final Map<String, String> dependencies = {};
    final Map<String, String> devDependencies = {};

    try {
      final doc = loadYaml(pubspecFile.readAsStringSync());
      if (doc is YamlMap) {
        projectName = doc['name']?.toString() ?? '';
        final env = doc['environment'];
        if (env is YamlMap) {
          dartVersion = env['sdk']?.toString() ?? 'unknown';
          flutterVersion = env['flutter']?.toString() ?? 'unknown';
        }

        final deps = doc['dependencies'];
        if (deps is YamlMap) {
          for (final key in deps.keys) {
            dependencies[key.toString()] = deps[key]?.toString() ?? '';
          }
        }

        final devDeps = doc['dev_dependencies'];
        if (devDeps is YamlMap) {
          for (final key in devDeps.keys) {
            devDependencies[key.toString()] = devDeps[key]?.toString() ?? '';
          }
        }
      }
    } catch (e) {
      Logger.error('Failed to parse pubspec.yaml metadata', e);
    }

    if (projectName.isEmpty) {
      projectName = p.basename(projectPath);
    }

    // Attempt to parse Flutter version from .metadata if available
    final metadataFile = File(p.join(projectPath, '.metadata'));
    if (metadataFile.existsSync()) {
      try {
        final content = metadataFile.readAsStringSync();
        final match = RegExp(r'version:\s*([^\s]+)').firstMatch(content);
        if (match != null) {
          flutterVersion = match.group(1) ?? flutterVersion;
        }
      } catch (_) {}
    }

    // Robust fallback for Flutter SDK version
    if (flutterVersion == 'unknown' || flutterVersion.trim().isEmpty) {
      // Fallback 1: Climb 4 levels up from Platform.resolvedExecutable (e.g. from bin/cache/dart-sdk/bin/dart -> flutter root)
      try {
        final dartExe = Platform.resolvedExecutable;
        Directory dir = Directory(p.dirname(dartExe));
        for (int i = 0; i < 4; i++) {
          if (dir.parent.path == dir.path) break;
          dir = dir.parent;
        }
        final versionFile = File(p.join(dir.path, 'version'));
        if (versionFile.existsSync()) {
          flutterVersion = versionFile.readAsStringSync().trim();
        }
      } catch (_) {}
    }

    if (flutterVersion == 'unknown' || flutterVersion.trim().isEmpty) {
      // Fallback 2: Search for 'flutter' segment in resolved path
      try {
        final segments = p.split(Platform.resolvedExecutable);
        for (int i = segments.length - 1; i >= 0; i--) {
          if (segments[i] == 'flutter') {
            final path = p.joinAll(segments.sublist(0, i + 1));
            final versionFile = File(p.join(path, 'version'));
            if (versionFile.existsSync()) {
              flutterVersion = versionFile.readAsStringSync().trim();
              break;
            }
          }
        }
      } catch (_) {}
    }

    if (flutterVersion == 'unknown' || flutterVersion.trim().isEmpty) {
      // Fallback 3: Run Process to execute 'flutter --version'
      try {
        final res = Process.runSync('flutter', ['--version']);
        if (res.exitCode == 0) {
          final output = res.stdout.toString();
          final match = RegExp(r'Flutter\s+([0-9\.]+)').firstMatch(output);
          if (match != null) {
            flutterVersion = match.group(1)!;
          }
        }
      } catch (_) {}
    }

    // Detect state management
    String stateManagement = 'setState';
    if (dependencies.containsKey('flutter_bloc') || dependencies.containsKey('bloc')) {
      stateManagement = 'BLoC';
    } else if (dependencies.containsKey('get')) {
      stateManagement = 'GetX';
    } else if (dependencies.containsKey('flutter_riverpod') || dependencies.containsKey('riverpod')) {
      stateManagement = 'Riverpod';
    } else if (dependencies.containsKey('provider')) {
      stateManagement = 'Provider';
    } else if (dependencies.containsKey('rxdart')) {
      stateManagement = 'RxDart';
    }

    // Detect Router
    String router = 'Navigator (Default)';
    if (dependencies.containsKey('go_router')) {
      router = 'go_router';
    } else if (dependencies.containsKey('auto_route')) {
      router = 'auto_route';
    }

    // Detect Network
    String network = 'HttpClient (Default)';
    if (dependencies.containsKey('dio')) {
      network = 'dio';
    } else if (dependencies.containsKey('retrofit')) {
      network = 'retrofit';
    }

    // Detect Database
    String database = 'None';
    if (dependencies.containsKey('hive') || dependencies.containsKey('hive_flutter')) {
      database = 'hive';
    } else if (dependencies.containsKey('isar')) {
      database = 'isar';
    } else if (dependencies.containsKey('drift')) {
      database = 'drift';
    } else if (dependencies.containsKey('sqflite')) {
      database = 'sqflite';
    }

    // Firebase detection
    final hasFirebase = dependencies.keys.any((key) => key.startsWith('firebase_')) ||
        dependencies.containsKey('cloud_firestore');

    // Auth detection
    final hasAuthentication = dependencies.containsKey('firebase_auth') ||
        dependencies.containsKey('supabase_flutter') ||
        dependencies.keys.any((key) => key.contains('auth'));

    // Platforms detection
    final List<String> targetPlatforms = [];
    if (Directory(p.join(projectPath, 'android')).existsSync()) targetPlatforms.add('android');
    if (Directory(p.join(projectPath, 'ios')).existsSync()) targetPlatforms.add('ios');
    if (Directory(p.join(projectPath, 'web')).existsSync()) targetPlatforms.add('web');
    if (Directory(p.join(projectPath, 'macos')).existsSync()) targetPlatforms.add('macos');
    if (Directory(p.join(projectPath, 'windows')).existsSync()) targetPlatforms.add('windows');
    if (Directory(p.join(projectPath, 'linux')).existsSync()) targetPlatforms.add('linux');

    return ProjectMetadata(
      projectName: projectName,
      flutterVersion: flutterVersion,
      dartVersion: dartVersion,
      dependencies: dependencies,
      devDependencies: devDependencies,
      detectedArchitecture: 'Unknown', // Detected by architecture scanner
      detectedStateManagement: stateManagement,
      detectedRouter: router,
      detectedNetwork: network,
      detectedDatabase: database,
      hasFirebase: hasFirebase,
      hasAuthentication: hasAuthentication,
      targetPlatforms: targetPlatforms,
    );
  }
}
