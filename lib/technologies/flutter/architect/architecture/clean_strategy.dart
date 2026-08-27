import 'dart:io';
import 'package:path/path.dart' as p;
import 'base_strategy.dart';
import 'package:flutter_architect_mcp/services/copy_service.dart';

class CleanStrategy implements ArchitectureStrategy {
  @override
  String get name => 'clean';

  @override
  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required CopyService copyService,
  }) async {
    final sourceDir = Directory(p.join(templatesPath, 'architecture', 'clean'));
    final targetLibDir = Directory(p.join(projectPath, 'lib'));

    if (await sourceDir.exists()) {
      await for (var entity in sourceDir.list(recursive: false)) {
        final name = p.basename(entity.path);
        if (name == 'lib') {
          if (entity is Directory) {
            await copyService.copyDirectory(entity, targetLibDir);
          }
        } else if (entity is Directory) {
          await copyService.copyDirectory(entity, Directory(p.join(targetLibDir.path, name)));
        } else if (entity is File) {
          await copyService.copyFile(entity, File(p.join(targetLibDir.path, name)));
        }
      }
    } else {
      // Fallback: Create structure programmatically
      await Directory(p.join(targetLibDir.path, 'core')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'features')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'shared')).create(recursive: true);
      final mainFile = File(p.join(targetLibDir.path, 'main.dart'));
      await mainFile.writeAsString(_defaultMainContent('Clean Architecture'));
    }
  }

  String _defaultMainContent(String archName) {
    return '''import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$archName App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$archName'),
      ),
      body: const Center(
        child: Text('Welcome to your Flutter project generated using $archName.'),
      ),
    );
  }
}
''';
  }
}
