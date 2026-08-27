import 'dart:io';
import 'package:path/path.dart' as p;
import 'base_strategy.dart';
import 'package:flutter_architect_mcp/services/copy_service.dart';

class FeatureFirstStrategy implements ArchitectureStrategy {
  @override
  String get name => 'feature-first';

  @override
  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required CopyService copyService,
  }) async {
    final sourceDir = Directory(p.join(templatesPath, 'architecture', 'feature-first'));
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
      // Programmatic setup
      await Directory(p.join(targetLibDir.path, 'core', 'services')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'core', 'theme')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'features', 'home', 'presentation')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'features', 'home', 'domain')).create(recursive: true);
      await Directory(p.join(targetLibDir.path, 'features', 'home', 'data')).create(recursive: true);
      
      final mainFile = File(p.join(targetLibDir.path, 'main.dart'));
      await mainFile.writeAsString(_defaultMainContent('Feature-first'));
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
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
        title: const Text('$archName Architecture'),
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
