import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/services/copy_service.dart';
import 'package:flutter_architect_mcp/services/pubspec_service.dart';

class StateGenerator {
  final CopyService _copyService;
  final PubspecService _pubspecService;

  StateGenerator(this._copyService, this._pubspecService);

  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required String stateManagement,
    required Map<String, dynamic> packagesConfig,
  }) async {
    if (stateManagement.isEmpty) return;

    // 1. Copy template files if they exist
    final sourceDir = Directory(p.join(templatesPath, 'state', stateManagement));
    if (await sourceDir.exists()) {
      final targetLibDir = Directory(p.join(projectPath, 'lib'));
      await _copyService.copyDirectory(sourceDir, targetLibDir);
    }

    // 2. Add dependencies from config
    final statePackages = packagesConfig['state']?[stateManagement];
    if (statePackages != null) {
      final dependencies = Map<String, String>.from(
        statePackages['dependencies'] ?? {},
      );
      final devDependencies = Map<String, String>.from(
        statePackages['dev_dependencies'] ?? {},
      );

      if (dependencies.isNotEmpty || devDependencies.isNotEmpty) {
        await _pubspecService.addDependencies(
          pubspecPath: p.join(projectPath, 'pubspec.yaml'),
          dependencies: dependencies,
          devDependencies: devDependencies,
        );
      }
    }
  }
}
