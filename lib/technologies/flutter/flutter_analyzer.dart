import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/security_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/memory/memory_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/performance/performance_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/code_quality/code_quality_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/architecture_analysis/architecture_scanner.dart';

class FlutterAnalyzer implements BaseAnalyzer {
  @override
  String get technologyId => 'flutter';

  @override
  String get technologyName => 'Flutter';

  @override
  bool canAnalyze(String projectPath) {
    final pubspec = File(p.join(projectPath, 'pubspec.yaml'));
    return pubspec.existsSync();
  }

  @override
  Future<List<Finding>> analyze(String projectPath, {String scanLevel = 'standard'}) async {
    final dir = Directory(projectPath);
    if (!dir.existsSync()) {
      throw Exception('Project directory does not exist: $projectPath');
    }

    final meta = await getMetadata(projectPath);
    final findings = <Finding>[];

    // 1. Security Scan
    final securityEngine = SecurityEngine();
    findings.addAll(await securityEngine.runAllScans(dir, hasFirebase: meta.hasFirebase));

    // 2. Memory Scan
    final memoryEngine = MemoryEngine();
    findings.addAll(await memoryEngine.scan(dir));

    // 3. Performance Scan
    final performanceEngine = PerformanceEngine();
    findings.addAll(await performanceEngine.scan(dir));

    // 4. Code Quality Scan
    final qualityScanner = CodeQualityScanner();
    findings.addAll(await qualityScanner.scan(dir));

    return findings;
  }

  @override
  Future<ProjectMetadata> getMetadata(String projectPath) async {
    final meta = ProjectDetector.detectMetadata(projectPath);
    
    // Attempt architecture scanning as well to enrich the metadata
    try {
      final archScanner = ArchitectureScanner();
      final archResult = await archScanner.scanProject(Directory(projectPath), meta);
      return ProjectMetadata(
        projectName: meta.projectName,
        flutterVersion: meta.flutterVersion,
        dartVersion: meta.dartVersion,
        dependencies: meta.dependencies,
        devDependencies: meta.devDependencies,
        detectedArchitecture: archResult.architecture,
        detectedStateManagement: archResult.stateManagement,
        detectedRouter: meta.detectedRouter,
        detectedNetwork: meta.detectedNetwork,
        detectedDatabase: meta.detectedDatabase,
        hasFirebase: meta.hasFirebase,
        hasAuthentication: meta.hasAuthentication,
        targetPlatforms: meta.targetPlatforms,
      );
    } catch (_) {
      return meta;
    }
  }
}
