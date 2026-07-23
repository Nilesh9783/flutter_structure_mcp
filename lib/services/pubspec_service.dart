import 'dart:io';

class PubspecService {
  Future<void> addDependencies({
    required String pubspecPath,
    Map<String, String> dependencies = const {},
    Map<String, String> devDependencies = const {},
  }) async {
    final file = File(pubspecPath);
    if (!file.existsSync()) {
      throw Exception('pubspec.yaml not found at $pubspecPath');
    }

    List<String> lines = await file.readAsLines();

    void insertDeps(String section, Map<String, String> deps) {
      if (deps.isEmpty) return;

      int index = lines.indexWhere((l) => l.trim() == section);
      if (index != -1) {
        List<String> added = [];
        for (var entry in deps.entries) {
          // Check if already exists in subsequent lines until we hit another section or end
          bool exists = false;
          for (int i = index + 1; i < lines.length; i++) {
            final trimLine = lines[i].trim();
            if (trimLine.startsWith('${entry.key}:') ||
                trimLine.startsWith('"${entry.key}":') ||
                trimLine.startsWith("'${entry.key}':")) {
              exists = true;
              break;
            }
            if (lines[i].isNotEmpty && !lines[i].startsWith(' ') && !lines[i].startsWith('#')) {
              break; // Next root-level key
            }
          }
          if (!exists) {
            added.add('  ${entry.key}: ${entry.value}');
          }
        }
        lines.insertAll(index + 1, added);
      } else {
        // Section not found, append section and dependencies
        lines.add(section);
        for (var entry in deps.entries) {
          lines.add('  ${entry.key}: ${entry.value}');
        }
      }
    }

    insertDeps('dependencies:', dependencies);
    insertDeps('dev_dependencies:', devDependencies);

    await file.writeAsString('${lines.join('\n')}\n');
  }
}
