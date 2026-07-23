import 'dart:io';
import 'package:path/path.dart' as p;

class CopyService {
  Future<void> copyDirectory(Directory source, Directory destination) async {
    if (!await source.exists()) return;
    await destination.create(recursive: true);

    await for (var entity in source.list(recursive: false)) {
      final name = p.basename(entity.path);
      if (name == '.DS_Store') continue;

      if (entity is Directory) {
        final newDirectory = Directory(p.join(destination.path, name));
        await copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        final newFile = File(p.join(destination.path, name));
        await entity.copy(newFile.path);
      }
    }
  }

  Future<void> copyFile(File source, File destination) async {
    if (!await source.exists()) return;
    await destination.parent.create(recursive: true);
    await source.copy(destination.path);
  }

  Future<void> rewriteImports(Directory directory, String projectName) async {
    if (!await directory.exists()) return;
    await for (var entity in directory.list(recursive: true)) {
      if (entity is File && p.extension(entity.path) == '.dart') {
        final content = await entity.readAsString();
        var updated = content;
        
        // Rewrite import paths to refer to the generated project structure
        updated = updated.replaceAll(
          'package:expense_tracker/reusable_component/',
          'package:$projectName/shared/common/reusable_component/',
        );
        updated = updated.replaceAll(
          'package:expense_tracker/utils/',
          'package:$projectName/shared/utils/',
        );
        updated = updated.replaceAll(
          'package:expense_tracker/common/',
          'package:$projectName/shared/common/',
        );
        updated = updated.replaceAll(
          'package:expense_tracker/',
          'package:$projectName/',
        );

        if (updated != content) {
          await entity.writeAsString(updated);
        }
      }
    }
  }
}
