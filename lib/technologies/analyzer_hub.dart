import 'base_analyzer.dart';
import 'flutter/flutter_analyzer.dart';
import 'node/node_analyzer.dart';
import 'vue/vue_analyzer.dart';
import 'laravel/laravel_analyzer.dart';
import 'python/python_analyzer.dart';

class AnalyzerHub {
  static final AnalyzerHub _instance = AnalyzerHub._internal();
  factory AnalyzerHub() => _instance;

  final List<BaseAnalyzer> analyzers;

  AnalyzerHub._internal()
      : analyzers = [
          FlutterAnalyzer(),
          NodeAnalyzer(),
          VueAnalyzer(),
          LaravelAnalyzer(),
          PythonAnalyzer(),
        ];

  BaseAnalyzer? detectTechnology(String projectPath) {
    for (final analyzer in analyzers) {
      if (analyzer.canAnalyze(projectPath)) {
        return analyzer;
      }
    }
    return null;
  }

  BaseAnalyzer? getAnalyzerById(String id) {
    for (final analyzer in analyzers) {
      if (analyzer.technologyId.toLowerCase() == id.toLowerCase()) {
        return analyzer;
      }
    }
    return null;
  }
}
