import 'dart:async';
import 'dart:io';
import 'package:dart_mcp/server.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:flutter_architect_mcp/models/project_config.dart';
import 'package:flutter_architect_mcp/generators/project_generator.dart';

base class FlutterArchitectMcpServer extends MCPServer with ToolsSupport {
  FlutterArchitectMcpServer(super.channel)
      : super.fromStreamChannel(
          implementation: Implementation(
            name: 'flutter-architect-mcp',
            version: '1.0.0',
            description: 'MCP Server to generate Flutter project structures.',
          ),
        ) {
    _registerTools();
  }

  void _registerTools() {
    registerTool(
      Tool(
        name: 'create_project',
        description: 'Creates a new Flutter project configured with architecture, state management, router, database, and backend.',
        inputSchema: ObjectSchema(
          properties: {
            'projectName': Schema.string(
              description: 'The name of the Flutter project to create (e.g. my_app). Must be lowercase snake_case.',
            ),
            'architecture': Schema.string(
              description: 'The architecture pattern to use. Supported: clean, mvc, mvvm.',
            ),
            'stateManagement': Schema.string(
              description: 'State management option. Supported: bloc, getx, provider, riverpod, rxdart.',
            ),
            'database': Schema.string(
              description: 'Database option. Supported: hive, isar, drift.',
            ),
            'backend': Schema.string(
              description: 'Backend integration option. Supported: firebase, supabase.',
            ),
            'network': Schema.string(
              description: 'Networking option. Supported: dio, retrofit.',
            ),
            'router': Schema.string(
              description: 'Routing option. Supported: go_router, auto_route, own_extensions.',
            ),
            'targetDirectory': Schema.string(
              description: 'Optional absolute path to the directory where the project should be generated. Defaults to the current directory.',
            ),
          },
          required: ['projectName', 'architecture'],
        ),
      ),
      _handleCreateProject,
    );
  }

  Future<CallToolResult> _handleCreateProject(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectName = args['projectName'] as String?;
    final architecture = args['architecture'] as String?;
    final stateManagement = args['stateManagement'] as String? ?? '';
    final database = args['database'] as String? ?? '';
    final backend = args['backend'] as String? ?? '';
    final network = args['network'] as String? ?? '';
    final router = args['router'] as String? ?? '';
    final targetDirectory = args['targetDirectory'] as String? ?? Directory.current.path;

    if (projectName == null || projectName.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectName is required.')],
      );
    }
    if (architecture == null || architecture.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: architecture is required.')],
      );
    }

    final config = ProjectConfig(
      projectName: projectName,
      architecture: architecture,
      stateManagement: stateManagement,
      backend: backend,
      database: database,
      router: router,
      network: network,
    );

    try {
      final generator = ProjectGenerator();
      await generator.generate(
        config,
        targetDirectory: targetDirectory,
      );

      return CallToolResult(
        content: [
          Content.text(
            text: 'Success: Flutter project "$projectName" created successfully at $targetDirectory with $architecture architecture.',
          ),
        ],
      );
    } catch (e, stackTrace) {
      return CallToolResult(
        isError: true,
        content: [
          Content.text(
            text: 'Error during project generation: $e\n$stackTrace',
          ),
        ],
      );
    }
  }
}

void main() async {
  final channel = stdioChannel(
    input: stdin,
    output: stdout,
  );
  
  final server = FlutterArchitectMcpServer(channel);
  await server.done;
}
