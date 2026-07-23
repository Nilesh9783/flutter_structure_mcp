import 'dart:io';
import 'package:path/path.dart' as p;
import '../services/copy_service.dart';

class FeatureGenerator {
  final CopyService _copyService;

  FeatureGenerator(this._copyService);

  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required String featureName,
  }) async {
    if (featureName.isEmpty) return;

    final targetFeatureDir = Directory(p.join(projectPath, 'lib', 'features', featureName));
    await targetFeatureDir.create(recursive: true);

    final sourceDir = Directory(p.join(templatesPath, 'feature', featureName));
    if (await sourceDir.exists()) {
      await _copyService.copyDirectory(sourceDir, targetFeatureDir);
    }
  }
}
