import 'package:flutter_architect_mcp/technologies/flutter/models/project_config.dart';
import 'package:flutter_architect_mcp/technologies/flutter/generators/project_generator.dart';



Future<void> main() async {
  print('Running test project generation...');
  final config = ProjectConfig(
    projectName: "mcp_first",
    architecture: "clean",
    stateManagement: "bloc",
    database: "",
    backend: "",
    network: "dio",
    router: "own_extensions",
  );

  final generator = ProjectGenerator();

  await generator.generate(config);

  print("✅ Project generated successfully.");
}