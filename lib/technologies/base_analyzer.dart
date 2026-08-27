import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

abstract class BaseAnalyzer {
  String get technologyId; // e.g. "flutter", "node", "vue", "laravel", "python"
  String get technologyName; // e.g. "Flutter", "Node.js", "Vue.js", "Laravel", "Python"

  /// Returns true if this analyzer is suitable for the project at [projectPath].
  bool canAnalyze(String projectPath);

  /// Scans the project and returns a list of findings.
  Future<List<Finding>> analyze(String projectPath, {String scanLevel = 'standard'});

  /// Extracts project metadata.
  Future<ProjectMetadata> getMetadata(String projectPath);
}
