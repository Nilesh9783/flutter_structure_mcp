import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

class ArchitectureScanResult {
  final String architecture;
  final int confidence;
  final String stateManagement;
  final List<String> evidence;

  ArchitectureScanResult({
    required this.architecture,
    required this.confidence,
    required this.stateManagement,
    required this.evidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'architecture': architecture,
      'confidence': confidence,
      'stateManagement': stateManagement,
      'evidence': evidence,
    };
  }
}

class ArchitectureScanner {
  Future<ArchitectureScanResult> scanProject(Directory projectDir, ProjectMetadata metadata) async {
    final evidence = <String>[];
    final libDir = Directory(p.join(projectDir.path, 'lib'));
    if (!libDir.existsSync()) {
      return ArchitectureScanResult(
        architecture: 'Unknown',
        confidence: 0,
        stateManagement: 'Unknown',
        evidence: ['No lib directory found'],
      );
    }

    // 1. Gather directory structure evidence
    final paths = <String>[];
    try {
      await for (final entity in libDir.list(recursive: true, followLinks: false)) {
        if (entity is Directory) {
          paths.add(p.relative(entity.path, from: libDir.path));
        }
      }
    } catch (_) {}

    int cleanScore = 0;
    int mvvmScore = 0;
    int mvcScore = 0;
    int featureFirstScore = 0;
    int layeredScore = 0;

    for (final path in paths) {
      final parts = p.split(path);
      // Clean structure: core, features, shared
      if (parts.contains('core') || parts.contains('features') || parts.contains('domain')) {
        cleanScore += 15;
      }
      // MVVM structure: viewmodels, views, models
      if (parts.contains('viewmodels') || parts.contains('views') || parts.contains('models')) {
        mvvmScore += 20;
      }
      // MVC structure: controllers, views, models
      if (parts.contains('controllers') || parts.contains('views') || parts.contains('models')) {
        mvcScore += 20;
      }
      // Feature-first structure: features/<feature_name>/presentation or features/<feature_name>/data
      if (parts.contains('features') && parts.length > 2 &&
          (parts.contains('presentation') || parts.contains('data') || parts.contains('domain'))) {
        featureFirstScore += 25;
      }
      // Layered structure: data, domain, presentation directly in lib
      if (parts.length == 1 && (parts.contains('data') || parts.contains('domain') || parts.contains('presentation'))) {
        layeredScore += 30;
      }
    }

    // 2. Check code keywords for patterns
    bool usesRepository = false;
    bool usesService = false;
    bool usesSetState = false;
    bool usesBloc = false;
    bool usesGetX = false;
    bool usesProvider = false;
    bool usesRiverpod = false;

    try {
      await for (final entity in libDir.list(recursive: true)) {
        if (entity is File && p.extension(entity.path) == '.dart') {
          final content = await entity.readAsString();
          if (content.contains('class') && content.contains('Repository')) {
            usesRepository = true;
          }
          if (content.contains('class') && content.contains('Service')) {
            usesService = true;
          }
          if (content.contains('setState(')) {
            usesSetState = true;
          }
          if (content.contains('BlocProvider') || content.contains('extends Bloc') || content.contains('extends Cubit')) {
            usesBloc = true;
          }
          if (content.contains('Get.put(') || content.contains('extends GetxController')) {
            usesGetX = true;
          }
          if (content.contains('ConsumerWidget') || content.contains('ref.watch(')) {
            usesRiverpod = true;
          }
          if (content.contains('ChangeNotifierProvider') || (content.contains('extends ChangeNotifier') && content.contains('Provider.of'))) {
            usesProvider = true;
          }
        }
      }
    } catch (_) {}

    if (usesRepository) {
      evidence.add('Repository pattern: found files defining *Repository classes.');
    }
    if (usesService) {
      evidence.add('Service pattern: found classes suffixing *Service.');
    }

    // Determine architecture
    String detectedArch = 'Unknown / Custom';
    int confidence = 0;

    final scores = {
      'Clean Architecture': cleanScore,
      'MVVM': mvvmScore,
      'MVC': mvcScore,
      'Feature-first': featureFirstScore,
      'Layered': layeredScore,
    };

    final sortedScores = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final highest = sortedScores.first;

    if (highest.value > 15) {
      detectedArch = highest.key;
      confidence = highest.value.clamp(20, 100);
      evidence.add('Folder matching structure score for $detectedArch is ${highest.value}.');
    } else {
      evidence.add('No distinct standard folder patterns detected in lib/. Defaults to custom structure.');
    }

    // State management detection
    final List<String> states = [];
    if (usesBloc) states.add('BLoC/Cubit');
    if (usesGetX) states.add('GetX');
    if (usesRiverpod) states.add('Riverpod');
    if (usesProvider) states.add('Provider');
    if (usesSetState) states.add('setState');

    String stateStr = 'setState';
    if (states.isEmpty) {
      stateStr = metadata.detectedStateManagement; // Fallback to pubspec metadata
    } else if (states.length == 1) {
      stateStr = states.first;
    } else {
      stateStr = 'Mixed (${states.join(" + ")})';
      evidence.add('Mixed state management styles detected: ${states.join(", ")}.');
    }

    return ArchitectureScanResult(
      architecture: detectedArch,
      confidence: confidence,
      stateManagement: stateStr,
      evidence: evidence,
    );
  }
}
