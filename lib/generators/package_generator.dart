import 'dart:io';
import 'package:path/path.dart' as p;
import '../services/copy_service.dart';
import '../services/pubspec_service.dart';

class PackageGenerator {
  final CopyService _copyService;
  final PubspecService _pubspecService;

  PackageGenerator(this._copyService, this._pubspecService);

  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required String category,
    required String choice,
    required Map<String, dynamic> packagesConfig,
  }) async {
    if (choice.isEmpty) return;

    // 1. Copy template files if they exist
    final sourceDir = Directory(p.join(templatesPath, category, choice));
    if (await sourceDir.exists()) {
      final targetLibDir = Directory(p.join(projectPath, 'lib'));
      await _copyService.copyDirectory(sourceDir, targetLibDir);
    }

    // 2. Add dependencies from config
    final categoryPackages = packagesConfig[category]?[choice];
    if (categoryPackages != null) {
      final dependencies = Map<String, String>.from(
        categoryPackages['dependencies'] ?? {},
      );
      final devDependencies = Map<String, String>.from(
        categoryPackages['dev_dependencies'] ?? {},
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
