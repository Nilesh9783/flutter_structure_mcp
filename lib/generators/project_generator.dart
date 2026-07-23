import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/project_config.dart';
import '../services/copy_service.dart';
import '../services/flutter_service.dart';
import '../services/yaml_service.dart';
import '../services/pubspec_service.dart';
import 'architecture_generator.dart';
import 'state_generator.dart';
import 'package:flutter_architect_mcp/generators/package_generator.dart';
import 'package:flutter_architect_mcp/generators/feature_generator.dart';

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

  Future<void> generate(
    ProjectConfig config, {
    String? targetDirectory,
  }) async {
    final actualTargetDir = targetDirectory ?? Directory.current.path;
    final projectName = config.projectName;
    final projectPath = p.join(actualTargetDir, projectName);

    print('🚀 Initializing Flutter project "$projectName" at $actualTargetDir...');
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

    print('📦 Loading package configurations from $packagesYamlPath...');
    final packagesConfig = _yamlService.loadYamlFile(packagesYamlPath);

    // 1. Generate Architecture
    print('🏛️ Generating architecture: ${config.architecture}...');
    await _architectureGenerator.generate(
      templatesPath: templatesPath,
      projectPath: projectPath,
      architecture: config.architecture,
    );

    // 2. Generate State Management
    if (config.stateManagement.isNotEmpty) {
      print('🧠 Configuring state management: ${config.stateManagement}...');
      await _stateGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        stateManagement: config.stateManagement,
        packagesConfig: packagesConfig,
      );
    }

    // 3. Generate Database
    if (config.database.isNotEmpty) {
      print('💾 Configuring database: ${config.database}...');
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
      print('☁️ Configuring backend: ${config.backend}...');
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
      print('🚦 Configuring router: ${config.router}...');
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
      print('🌐 Configuring network: ${config.network}...');
      await _packageGenerator.generate(
        templatesPath: templatesPath,
        projectPath: projectPath,
        category: 'network',
        choice: config.network,
        packagesConfig: packagesConfig,
      );
    }

    // 7. Generate Features: login, dashboard, profile, home
    print('✨ Creating feature folders: login, dashboard, profile, home...');
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
      print('🛠️ Injecting shared utilities and reusable components...');
      final targetSharedDir = Directory(p.join(projectPath, 'lib', 'shared'));
      await _copyService.copyDirectory(sharedSourceDir, targetSharedDir);
    }

    // Rewrite all expense_tracker package imports dynamically
    print('✏️ Rewriting imports to use package:$projectName...');
    await _copyService.rewriteImports(Directory(p.join(projectPath, 'lib')), projectName);

    // 8. Run flutter pub get
    print('📥 Running flutter pub get in $projectPath...');
    final pubGetResult = await _flutterService.runPubGet(projectPath);
    if (pubGetResult.exitCode != 0) {
      print('⚠️ Warning: flutter pub get failed with: ${pubGetResult.stderr}');
    } else {
      print('✅ flutter pub get completed successfully.');
    }

    print('🎉 Project "$projectName" generated successfully!');
  }
}