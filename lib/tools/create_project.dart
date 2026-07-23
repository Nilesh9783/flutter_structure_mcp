import 'dart:io';
import '../models/project_config.dart';
import '../generators/project_generator.dart';

void main(List<String> args) async {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    print('Usage: dart run lib/tools/create_project.dart [options]');
    print('Options:');
    print('  --name <project_name>       Name of the project (required)');
    print('  --arch <architecture>       Architecture: clean, mvc, mvvm (required)');
    print('  --state <state>             State management: bloc, getx, provider, riverpod, rxdart');
    print('  --backend <backend>         Backend: firebase, supabase');
    print('  --db <database>             Database: hive, isar, drift');
    print('  --network <network>         Network: dio, retrofit');
    print('  --router <router>           Router: go_router, auto_route, own_extensions');
    print('  --target <dir>              Target directory (default: current directory)');
    return;
  }

  String projectName = '';
  String architecture = '';
  String stateManagement = '';
  String backend = '';
  String database = '';
  String network = '';
  String router = '';
  String targetDirectory = Directory.current.path;

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--name':
        if (i + 1 < args.length) projectName = args[++i];
        break;
      case '--arch':
        if (i + 1 < args.length) architecture = args[++i];
        break;
      case '--state':
        if (i + 1 < args.length) stateManagement = args[++i];
        break;
      case '--backend':
        if (i + 1 < args.length) backend = args[++i];
        break;
      case '--db':
        if (i + 1 < args.length) database = args[++i];
        break;
      case '--network':
        if (i + 1 < args.length) network = args[++i];
        break;
      case '--router':
        if (i + 1 < args.length) router = args[++i];
        break;
      case '--target':
        if (i + 1 < args.length) targetDirectory = args[++i];
        break;
    }
  }

  if (projectName.isEmpty) {
    print('❌ Error: Project name is required (--name <project_name>).');
    exit(1);
  }
  if (architecture.isEmpty) {
    print('❌ Error: Architecture is required (--arch <architecture>).');
    exit(1);
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
    await generator.generate(config, targetDirectory: targetDirectory);
  } catch (e) {
    print('❌ Project generation failed: $e');
    exit(1);
  }
}
