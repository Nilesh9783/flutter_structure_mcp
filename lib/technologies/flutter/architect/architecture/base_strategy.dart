import 'package:flutter_architect_mcp/services/copy_service.dart';

abstract class ArchitectureStrategy {
  String get name;
  Future<void> generate({
    required String templatesPath,
    required String projectPath,
    required CopyService copyService,
  });
}
