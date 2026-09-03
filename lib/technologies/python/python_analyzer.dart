import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class PythonAnalyzer implements BaseAnalyzer {
  @override
  String get technologyId => 'python';

  @override
  String get technologyName => 'Python';

  @override
  bool canAnalyze(String projectPath) {
    // Check files like requirements.txt, setup.py, pyproject.toml
    final reqs = File(p.join(projectPath, 'requirements.txt'));
    final setup = File(p.join(projectPath, 'setup.py'));
    final pyproj = File(p.join(projectPath, 'pyproject.toml'));
    if (reqs.existsSync() || setup.existsSync() || pyproj.existsSync()) return true;

    // Check if there are any .py files in the directory
    final dir = Directory(projectPath);
    if (dir.existsSync()) {
      try {
        final files = dir.listSync(recursive: true, followLinks: false);
        return files.any((file) => file is File && p.extension(file.path).toLowerCase() == '.py');
      } catch (_) {}
    }
    return false;
  }

  @override
  Future<List<Finding>> analyze(String projectPath, {String scanLevel = 'standard'}) async {
    final findings = <Finding>[];
    final dir = Directory(projectPath);
    if (!dir.existsSync()) return findings;

    await _scanDirectory(dir, projectPath, findings);
    await _scanDependencies(projectPath, findings);

    return findings.map((f) => SolutionGenerator.attachSolutionAndPrompt(f)).toList();
  }

  Future<void> _scanDirectory(Directory dir, String rootPath, List<Finding> findings) async {
    final excludedDirs = {
      '.venv',
      'env',
      'venv',
      'virtualenv',
      '__pycache__',
      '.git',
      'build',
      'dist',
      'reports'
    };

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: rootPath);
        final pathSegments = p.split(relativePath);
        if (pathSegments.any((seg) => excludedDirs.contains(seg))) continue;

        final ext = p.extension(entity.path).toLowerCase();
        final name = p.basename(entity.path);

        if (ext == '.py' || name == '.env' || name == '.env.example') {
          await _scanFile(entity, relativePath, findings);
        }
      }
    }
  }

  Future<void> _scanFile(File file, String relativePath, List<Finding> findings) async {
    final lines = await file.readAsLines();
    final name = p.basename(file.path);

    // 1. File Size Check (Code Quality)
    if (lines.length > 500) {
      findings.add(Finding(
        id: 'CQ-PY-001',
        category: 'CODE_QUALITY',
        severity: 'MEDIUM',
        confidence: 'HIGH',
        title: 'Large Python Module',
        file: relativePath,
        line: lines.length,
        evidence: 'Total lines: ${lines.length}',
        description: 'Module exceeds recommended limit of 500 lines.',
        risk: 'Large modules violate single responsibility guidelines and increase refactoring costs.',
        recommendation: 'Break down the script into multiple submodule files or classes.',
      ));
    }

    final secretRegex = RegExp(
      r"""[a-zA-Z0-9_-]*(key|secret|password|passwd|token|auth|credential|jwt)[a-zA-Z0-9_-]*\s*=\s*['"]([A-Za-z0-9\-_+=/]{16,})['"]""",
      caseSensitive: false,
    );
    final evalRegex = RegExp(r'\b(eval|exec)\s*\(');
    final subprocessShellRegex = RegExp(r'\bsubprocess\.(Popen|run|call|check_output)\s*\([^)]*shell\s*=\s*True\b');
    final osSystemRegex = RegExp(r'\bos\.system\s*\(');
    final insecureYamlRegex = RegExp(r'\byaml\.load\s*\(\s*[^,)]+\s*\)(?!\s*[^)]*Loader\s*=\s*yaml\.SafeLoader)');
    final pickleRegex = RegExp(r'\bpickle\.loads\s*\(');
    final printLogRegex = RegExp(r'\bprint\s*\(');
    final debugTrueRegex = RegExp(r'\b(DEBUG|debug)\s*=\s*True\b');

    for (int i = 0; i < lines.length; i++) {
      final lineText = lines[i];
      final lineNum = i + 1;

      // 2. Secrets Scan
      if (secretRegex.hasMatch(lineText)) {
        final match = secretRegex.firstMatch(lineText)!;
        findings.add(Finding(
          id: 'SEC-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Secret Exposure',
          file: relativePath,
          line: lineNum,
          evidence: lineText.replaceAll(match.group(2)!, '[REDACTED]'),
          description: 'A hardcoded secret key assignment was exposed in code.',
          risk: 'Exposed API tokens and database keys allow attackers to intercept backend data and perform privilege escalation.',
          recommendation: 'Use os.getenv() to load credentials from environment configurations.',
        ));
      }

      // 3. Dynamic Execution (Security)
      if (evalRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-PY-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Unsafe Dynamic Execution (eval/exec)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Usage of eval() or exec() dynamic interpreter functions.',
          risk: 'Dynamic interpreters execute strings directly inside current thread context, permitting remote code injection if variables are untrusted.',
          recommendation: 'Refactor code to parse structured data (json module) instead of executing raw script strings.',
        ));
      }

      // 4. Command Injection in shell subprocesses (Security)
      if (subprocessShellRegex.hasMatch(lineText) || osSystemRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-PY-002',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Command Injection Risk in Subprocess Shell',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Executing shell commands with shell=True or using os.system().',
          risk: 'Enabling shell parsing allows shell syntax injection. Attackers can append command chains (e.g. "; rm -rf /").',
          recommendation: 'Pass shell=False and provide command arguments as a list: subprocess.run(["ls", "-l"]).',
        ));
      }

      // 5. Unsafe Deserialization (Security)
      if (insecureYamlRegex.hasMatch(lineText) || pickleRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-PY-003',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Insecure Object Deserialization (pickle/yaml)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Using pickle.loads() or unsafely parsing YAML without SafeLoader.',
          risk: 'Deserializing untrusted streams allows arbitrary payload instantiation and instant Remote Code Execution (RCE).',
          recommendation: 'Use yaml.safe_load() and exchange structured formats (like JSON) instead of binary serialized objects.',
        ));
      }

      // 6. Active debug mode (Security)
      if (debugTrueRegex.hasMatch(lineText) && name.endsWith('.py')) {
        findings.add(Finding(
          id: 'SEC-PY-004',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Python Server Debug Mode Active',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Server debug flag is configured to True.',
          risk: 'Active debug mode outputs stack traces and console access to anonymous web clients, leading to database and system takeover.',
          recommendation: 'Disable debug mode (set DEBUG = False) in staging and production.',
        ));
      }

      // 7. Leftover Console Prints (Code Quality)
      if (printLogRegex.hasMatch(lineText) && !lineText.contains('logger.') && name.endsWith('.py')) {
        findings.add(Finding(
          id: 'CQ-PY-002',
          category: 'CODE_QUALITY',
          severity: 'LOW',
          confidence: 'HIGH',
          title: 'Leftover Debug Print Statement',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Raw print() statement found in production module.',
          risk: 'Raw print statements slow down standard I/O streams and populate log servers with unstructured telemetry.',
          recommendation: 'Replace raw prints with standard Python logging module (logging.getLogger).',
        ));
      }
    }
  }

  Future<void> _scanDependencies(String projectPath, List<Finding> findings) async {
    final reqsFile = File(p.join(projectPath, 'requirements.txt'));
    if (!reqsFile.existsSync()) return;

    try {
      final lines = await reqsFile.readAsLines();
      final vulnerablePkgs = {
        'requests': '2.25.0',
        'django': '3.2.0',
        'flask': '1.1.0',
        'jinja2': '2.11.0',
      };

      for (final line in lines) {
        final cleanLine = line.trim().replaceAll(' ', '');
        final parts = cleanLine.split('==');
        if (parts.length == 2) {
          final pkg = parts[0].toLowerCase();
          final ver = parts[1];
          if (vulnerablePkgs.containsKey(pkg)) {
            findings.add(Finding(
              id: 'DEP-001',
              category: 'DEPENDENCY',
              severity: 'HIGH',
              confidence: 'MEDIUM',
              title: 'Vulnerable Python Dependency ($pkg)',
              file: 'requirements.txt',
              line: 1,
              evidence: line.trim(),
              description: 'Exposed package version ($ver) is configured in requirements.',
              risk: 'Running vulnerable package editions exposes the server hosting environment to public exploits.',
              recommendation: 'Upgrade package $pkg to its latest secure version.',
            ));
          }
        }
      }
    } catch (_) {}
  }

  @override
  Future<ProjectMetadata> getMetadata(String projectPath) async {
    final reqsFile = File(p.join(projectPath, 'requirements.txt'));
    String projectName = p.basename(projectPath);
    final Map<String, String> dependencies = {};

    if (reqsFile.existsSync()) {
      try {
        final lines = reqsFile.readAsLinesSync();
        for (final line in lines) {
          final clean = line.trim().replaceAll(' ', '');
          final parts = clean.split('==');
          if (parts.length == 2) {
            dependencies[parts[0]] = parts[1];
          } else {
            dependencies[clean] = 'latest';
          }
        }
      } catch (_) {}
    }

    String framework = 'Standard Python script / module';
    if (dependencies.containsKey('django') || dependencies.containsKey('Django')) {
      framework = 'Django';
    } else if (dependencies.containsKey('flask') || dependencies.containsKey('Flask')) {
      framework = 'Flask';
    } else if (dependencies.containsKey('fastapi') || dependencies.containsKey('FastAPI')) {
      framework = 'FastAPI';
    }

    String database = 'None (Standard SQLite fallback)';
    if (dependencies.containsKey('mysqlclient') || dependencies.containsKey('pymysql')) {
      database = 'MySQL';
    } else if (dependencies.containsKey('psycopg2') || dependencies.containsKey('psycopg2-binary')) {
      database = 'PostgreSQL';
    } else if (dependencies.containsKey('pymongo')) {
      database = 'MongoDB';
    }

    return ProjectMetadata(
      projectName: projectName,
      flutterVersion: 'N/A (Python)',
      dartVersion: 'Python Runtime',
      dependencies: dependencies,
      devDependencies: {},
      detectedArchitecture: 'Python Backend ($framework)',
      detectedStateManagement: 'N/A',
      detectedRouter: '$framework routing',
      detectedNetwork: 'requests / urllib3',
      detectedDatabase: database,
      hasFirebase: dependencies.containsKey('firebase-admin') || dependencies.containsKey('firebase'),
      hasAuthentication: dependencies.containsKey('pyjwt') || dependencies.containsKey('cryptography') || dependencies.containsKey('passlib'),
      targetPlatforms: ['Server Host', 'Container (Docker)'],
    );
  }
}
