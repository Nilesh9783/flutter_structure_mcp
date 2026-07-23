import 'dart:io';
import 'package:path/path.dart' as p;
import '../services/copy_service.dart';

class ArchitectureGenerator {
  final CopyService _copyService;

  ArchitectureGenerator(this._copyService);

  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required String architecture,
  }) async {
    final sourceDir = Directory(p.join(templatesPath, 'architecture', architecture));
    if (!await sourceDir.exists()) {
      throw Exception('Architecture template "$architecture" not found at ${sourceDir.path}');
    }

    final targetLibDir = Directory(p.join(projectPath, 'lib'));
    
    // Clear the default lib directory created by flutter create if it exists
    if (await targetLibDir.exists()) {
      await targetLibDir.delete(recursive: true);
    }
    await targetLibDir.create(recursive: true);

    // Copy all contents except if there is a 'lib' directory to avoid nesting lib/lib/
    await for (var entity in sourceDir.list(recursive: false)) {
      final name = p.basename(entity.path);
      if (name == 'lib') {
        // If the template has a lib sub-directory, copy its contents instead
        if (entity is Directory) {
          await _copyService.copyDirectory(entity, targetLibDir);
        }
      } else if (entity is Directory) {
        await _copyService.copyDirectory(entity, Directory(p.join(targetLibDir.path, name)));
      } else if (entity is File) {
        await _copyService.copyFile(entity, File(p.join(targetLibDir.path, name)));
      }
    }
  }
}
