import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/services/copy_service.dart';
import '../architect/architecture/base_strategy.dart';
import '../architect/architecture/clean_strategy.dart';
import '../architect/architecture/mvvm_strategy.dart';
import '../architect/architecture/mvc_strategy.dart';
import '../architect/architecture/feature_first_strategy.dart';
import '../architect/architecture/layered_strategy.dart';

class ArchitectureGenerator {
  final CopyService _copyService;
  final Map<String, ArchitectureStrategy> _strategies = {};

  ArchitectureGenerator(this._copyService) {
    _registerStrategy(CleanStrategy());
    _registerStrategy(MVVMStrategy());
    _registerStrategy(MVCStrategy());
    _registerStrategy(FeatureFirstStrategy());
    _registerStrategy(LayeredStrategy());
  }

  void _registerStrategy(ArchitectureStrategy strategy) {
    _strategies[strategy.name.toLowerCase()] = strategy;
  }

  /// Registers a new custom architecture strategy dynamically at runtime.
  void registerCustomStrategy(ArchitectureStrategy strategy) {
    _strategies[strategy.name.toLowerCase()] = strategy;
  }

  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required String architecture,
  }) async {
    final key = architecture.toLowerCase().replaceAll(' ', '').replaceAll('_', '').replaceAll('-', '');
    
    // Normalize user keys to map to strategy names
    String mappedKey = key;
    if (key == 'cleanarchitecture' || key == 'clean') {
      mappedKey = 'clean';
    } else if (key == 'mvvm') {
      mappedKey = 'mvvm';
    } else if (key == 'mvc') {
      mappedKey = 'mvc';
    } else if (key == 'featurefirst') {
      mappedKey = 'feature-first';
    } else if (key == 'layered') {
      mappedKey = 'layered';
    }

    final strategy = _strategies[mappedKey];

    // Clear the default lib directory created by flutter create if it exists
    final targetLibDir = Directory(p.join(projectPath, 'lib'));
    if (await targetLibDir.exists()) {
      await targetLibDir.delete(recursive: true);
    }
    await targetLibDir.create(recursive: true);

    if (strategy != null) {
      await strategy.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        copyService: _copyService,
      );
    } else {
      // Fallback: Copy template directly if directory exists, or raise error
      final sourceDir = Directory(p.join(templatesPath, 'architecture', architecture));
      if (await sourceDir.exists()) {
        await for (var entity in sourceDir.list(recursive: false)) {
          final name = p.basename(entity.path);
          if (name == 'lib') {
            if (entity is Directory) {
              await _copyService.copyDirectory(entity, targetLibDir);
            }
          } else if (entity is Directory) {
            await _copyService.copyDirectory(entity, Directory(p.join(targetLibDir.path, name)));
          } else if (entity is File) {
            await _copyService.copyFile(entity, File(p.join(targetLibDir.path, name)));
          }
        }
      } else {
        throw Exception('Architecture "$architecture" (mapped key: "$mappedKey") is not supported and no template was found at ${sourceDir.path}.');
      }
    }
  }
}
