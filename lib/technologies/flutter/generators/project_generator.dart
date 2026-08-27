import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/technologies/flutter/models/project_config.dart';
import 'package:flutter_architect_mcp/services/copy_service.dart';
import 'package:flutter_architect_mcp/services/flutter_service.dart';
import 'package:flutter_architect_mcp/services/yaml_service.dart';
import 'package:flutter_architect_mcp/services/pubspec_service.dart';
import 'architecture_generator.dart';
import 'state_generator.dart';
import 'package:flutter_architect_mcp/technologies/flutter/generators/package_generator.dart';
import 'package:flutter_architect_mcp/technologies/flutter/generators/feature_generator.dart';

class ProjectGenerator {
  final CopyService _copyService = CopyService();
  final FlutterService _flutterService = FlutterService();
  final YamlService _yamlService = YamlService();
  final PubspecService _pubspecService = PubspecService();

  late final ArchitectureGenerator _architectureGenerator;
  late final StateGenerator _stateGenerator;
  late final PackageGenerator _packageGenerator;
  late final FeatureGenerator _featureGenerator;

  ProjectGenerator() {
    _architectureGenerator = ArchitectureGenerator(_copyService);
    _stateGenerator = StateGenerator(_copyService, _pubspecService);
    _packageGenerator = PackageGenerator(_copyService, _pubspecService);
    _featureGenerator = FeatureGenerator(_copyService);
  }

  String _resolveAbsolutePath(String path) {
    if (path.startsWith('~/')) {
      final home = Platform.environment['HOME'] ?? '/Users/indianic';
      return p.absolute(p.join(home, path.substring(2)));
    } else if (path == '~') {
      return p.absolute(Platform.environment['HOME'] ?? '/Users/indianic');
    }
    return p.absolute(path);
  }

  Future<void> generate(
    ProjectConfig config, {
    String? targetDirectory,
  }) async {
    final actualTargetDir = _resolveAbsolutePath(targetDirectory ?? Directory.current.path);
    final projectName = config.projectName;
    final projectPath = p.join(actualTargetDir, projectName);

    stderr.writeln('🚀 Initializing Flutter project "$projectName" at $actualTargetDir...');
    final createResult = await _flutterService.runCreate(projectName, actualTargetDir);
    if (createResult.exitCode != 0) {
      throw Exception('Failed to run flutter create: ${createResult.stderr}');
    }

    // Resolve templates path and packages config path
    final scriptUri = Platform.script;
    final scriptPath = scriptUri.isScheme('file') ? scriptUri.toFilePath() : '.';
    String projectRoot = p.dirname(p.dirname(scriptPath));
    
    // Check if configuration exists at the resolved path, otherwise fallback to current directory
    if (!Directory(p.join(projectRoot, 'templates')).existsSync()) {
      projectRoot = Directory.current.path;
    }

    final templatesPath = p.join(projectRoot, 'templates');
    final packagesYamlPath = p.join(projectRoot, 'config', 'packages.yaml');

    stderr.writeln('📦 Loading package configurations from $packagesYamlPath...');
    final packagesConfig = _yamlService.loadYamlFile(packagesYamlPath);

    // 1. Generate Architecture
    stderr.writeln('🏛️ Generating architecture: ${config.architecture}...');
    await _architectureGenerator.generate(
      templatesPath: templatesPath,
      projectPath: projectPath,
      architecture: config.architecture,
    );

    // 2. Generate State Management
    if (config.stateManagement.isNotEmpty) {
      stderr.writeln('🧠 Configuring state management: ${config.stateManagement}...');
      await _stateGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        stateManagement: config.stateManagement,
        packagesConfig: packagesConfig,
      );
    }

    // 3. Generate Database
    if (config.database.isNotEmpty) {
      stderr.writeln('💾 Configuring database: ${config.database}...');
      await _packageGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        category: 'database',
        choice: config.database,
        packagesConfig: packagesConfig,
      );
    }

    // 4. Generate Backend
    if (config.backend.isNotEmpty) {
      stderr.writeln('☁️ Configuring backend: ${config.backend}...');
      await _packageGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        category: 'backend',
        choice: config.backend,
        packagesConfig: packagesConfig,
      );
    }

    // 5. Generate Router
    if (config.router.isNotEmpty) {
      stderr.writeln('🚦 Configuring router: ${config.router}...');
      await _packageGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        category: 'router',
        choice: config.router,
        packagesConfig: packagesConfig,
      );
    }

    // 6. Generate Network
    if (config.network.isNotEmpty) {
      stderr.writeln('🌐 Configuring network: ${config.network}...');
      await _packageGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        category: 'network',
        choice: config.network,
        packagesConfig: packagesConfig,
      );
    }

    // 7. Generate Features: login, dashboard, profile, home
    stderr.writeln('✨ Creating feature folders: login, dashboard, profile, home...');
    for (final feature in ['login', 'dashboard', 'profile', 'home']) {
      await _featureGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        featureName: feature,
      );
    }

    // Copy shared utilities, helpers, and components
    final sharedSourceDir = Directory(p.join(templatesPath, 'shared'));
    if (await sharedSourceDir.exists()) {
      stderr.writeln('🛠️ Injecting shared utilities and reusable components...');
      final targetSharedDir = Directory(p.join(projectPath, 'lib', 'shared'));
      await _copyService.copyDirectory(sharedSourceDir, targetSharedDir);
    }

    // Rewrite all expense_tracker package imports dynamically
    stderr.writeln('✏️ Rewriting imports to use package:$projectName...');
    await _copyService.rewriteImports(Directory(p.join(projectPath, 'lib')), projectName);

    // 8. Run flutter pub get
    stderr.writeln('📥 Running flutter pub get in $projectPath...');
    final pubGetResult = await _flutterService.runPubGet(projectPath);
    if (pubGetResult.exitCode != 0) {
      stderr.writeln('⚠️ Warning: flutter pub get failed with: ${pubGetResult.stderr}');
    } else {
      stderr.writeln('✅ flutter pub get completed successfully.');
    }

    stderr.writeln('🎉 Project "$projectName" generated successfully!');
  }
}