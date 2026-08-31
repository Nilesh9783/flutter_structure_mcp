import 'dart:io';
import 'package:path/path.dart' as p;

class PathUtils {
  /// Resolves the root directory of the package, even if executing from a global snapshot.
  static String resolvePackageRoot() {
    final scriptUri = Platform.script;
    final scriptPath = scriptUri.isScheme('file') ? scriptUri.toFilePath() : '.';
    String root = p.dirname(p.dirname(scriptPath));
    
    // 1. If templates or config folder exists in root, we are running from source or path-activated
    if (Directory(p.join(root, 'templates')).existsSync() || Directory(p.join(root, 'config')).existsSync()) {
      return root;
    }
    
    // 2. If not, check if we are running from a pub-cache snapshot
    if (scriptPath.contains('.pub-cache')) {
      final pubCacheIndex = scriptPath.indexOf('.pub-cache');
      if (pubCacheIndex != -1) {
        final pubCachePath = scriptPath.substring(0, pubCacheIndex + '.pub-cache'.length);
        final hostedDir = Directory(p.join(pubCachePath, 'hosted', 'pub.dev'));
        if (hostedDir.existsSync()) {
          try {
            final entities = hostedDir.listSync();
            final matchingDirs = entities
                .whereType<Directory>()
                .where((dir) => p.basename(dir.path).startsWith('flutter_architect_mcp-'))
                .toList();
            
            if (matchingDirs.isNotEmpty) {
              // Sort by name to get the latest version if multiple exist
              matchingDirs.sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));
              final latestDir = matchingDirs.first.path;
              if (Directory(p.join(latestDir, 'templates')).existsSync() || Directory(p.join(latestDir, 'config')).existsSync()) {
                return latestDir;
              }
            }
          } catch (_) {}
        }
      }
    }

    // 3. Fallback: If templates or config exists in current working directory, use it
    final currentDir = Directory.current.path;
    if (Directory(p.join(currentDir, 'templates')).existsSync() || Directory(p.join(currentDir, 'config')).existsSync()) {
      return currentDir;
    }

    // 4. Fallback: If root is "/" or not writable, fallback to a safe user directory
    if (root == '/' || root.isEmpty) {
      final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? Directory.systemTemp.path;
      root = p.join(home, '.flutter_architect_mcp');
    }

    return root;
  }

  /// Locates the `mailman` executable by checking the system PATH and common global binary directories.
  static String findMailmanExecutable() {
    final isWindows = Platform.isWindows;
    final exeName = isWindows ? 'mailman.cmd' : 'mailman';
    
    // Check if we can find it in current PATH
    final pathEnv = Platform.environment['PATH'] ?? '';
    final separator = isWindows ? ';' : ':';
    final paths = pathEnv.split(separator);
    
    // Common global binary directories on macOS/Linux (helps when Claude Desktop strips PATH)
    final commonDirs = [
      '/usr/local/bin',
      '/opt/homebrew/bin',
      p.join(Platform.environment['HOME'] ?? '', '.npm-global', 'bin'),
      p.join(Platform.environment['HOME'] ?? '', '.config', 'yarn', 'global', 'node_modules', '.bin'),
      p.join(Platform.environment['HOME'] ?? '', '.local', 'bin'),
    ];
    
    for (final dir in commonDirs) {
      if (dir.isNotEmpty && !paths.contains(dir)) {
        paths.add(dir);
      }
    }
    
    for (final dir in paths) {
      if (dir.isEmpty) continue;
      final file = File(p.join(dir, exeName));
      if (file.existsSync()) {
        return file.path;
      }
    }
    
    // Default fallback to just the command name
    return exeName;
  }
}
