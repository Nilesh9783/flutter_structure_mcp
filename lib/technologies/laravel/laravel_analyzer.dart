import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

class LaravelAnalyzer implements BaseAnalyzer {
  @override
  String get technologyId => 'laravel';

  @override
  String get technologyName => 'Laravel';

  @override
  bool canAnalyze(String projectPath) {
    // Check artisan script in root
    final artisan = File(p.join(projectPath, 'artisan'));
    if (artisan.existsSync()) return true;

    // Check composer.json for laravel framework
    final composerJson = File(p.join(projectPath, 'composer.json'));
    if (composerJson.existsSync()) {
      try {
        final content = composerJson.readAsStringSync();
        final parsed = jsonDecode(content);
        if (parsed is Map) {
          final require = parsed['require'];
          if (require is Map && require.containsKey('laravel/framework')) {
            return true;
          }
        }
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
    await _scanComposerJson(projectPath, findings);
    return findings;
  }

  Future<void> _scanDirectory(Directory dir, String rootPath, List<Finding> findings) async {
    final excludedDirs = {'vendor', 'node_modules', 'storage', 'bootstrap/cache', '.git', 'tests', 'reports'};

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: rootPath);
        final pathSegments = p.split(relativePath);
        if (pathSegments.any((seg) => excludedDirs.contains(seg))) continue;

        final ext = p.extension(entity.path).toLowerCase();
        final name = p.basename(entity.path);

        if (ext == '.php' || ext == '.blade.php' || name == '.env' || name == '.env.example') {
          await _scanFile(entity, relativePath, findings);
        }
      }
    }
  }

  Future<void> _scanFile(File file, String relativePath, List<Finding> findings) async {
    final lines = await file.readAsLines();
    final name = p.basename(file.path);

    // 1. Controller Size Check
    if (name.contains('Controller') && lines.length > 300) {
      findings.add(Finding(
        id: 'CQ-LAR-001',
        category: 'CODE_QUALITY',
        severity: 'MEDIUM',
        confidence: 'HIGH',
        title: 'Bloated Laravel Controller',
        file: relativePath,
        line: lines.length,
        evidence: 'Total lines: ${lines.length}',
        description: 'Controller exceeds recommended limit of 300 lines.',
        risk: 'Fat controllers violate separation of concerns, holding business rules inside HTTP entry points and hurting testability.',
        recommendation: 'Move business/database logic to Service classes, Form Requests, or Action components.',
      ));
    }

    final sqlInjectionRegex = RegExp(r'''\b(DB::raw|whereRaw|selectRaw|havingRaw|orderByRaw)\s*\(\s*(['"][^'"]*\$[a-zA-Z_]|[^,)]*\.\s*\$[a-zA-Z_])''');
    final csrfExemptionsRegex = RegExp(r'\$except\s*=\s*\[[^\]]+\]');
    final unprotectedModelRegex = RegExp(r'protected\s+\$guarded\s*=\s*\[\s*\]');
    final dbInViewRegex = RegExp(r'\b(DB::|App\\Models\\[a-zA-Z0-9_]+::(all|where|query|find|first|get)\b)');

    for (int i = 0; i < lines.length; i++) {
      final lineText = lines[i];
      final lineNum = i + 1;

      // 2. Env Config Auditing (.env files)
      if (name == '.env') {
        if (lineText.contains('APP_DEBUG=true')) {
          findings.add(Finding(
            id: 'SEC-LAR-001',
            category: 'SECURITY',
            severity: 'HIGH',
            confidence: 'HIGH',
            title: 'Laravel Debug Mode Active',
            file: relativePath,
            line: lineNum,
            evidence: lineText.trim(),
            description: 'Application Debug mode (APP_DEBUG=true) is active in .env.',
            risk: 'Active debug mode prints detailed SQL queries, environment credentials, and stack traces on errors, leading to extreme information disclosure.',
            recommendation: 'Ensure APP_DEBUG=false is set in staging and production environments.',
          ));
        }

        if (lineText.contains('APP_KEY=') && lineText.trim() == 'APP_KEY=') {
          findings.add(Finding(
            id: 'SEC-LAR-002',
            category: 'SECURITY',
            severity: 'CRITICAL',
            confidence: 'HIGH',
            title: 'Missing Application Encryption Key (APP_KEY)',
            file: relativePath,
            line: lineNum,
            evidence: lineText.trim(),
            description: 'APP_KEY is blank or missing in the active environment configuration.',
            risk: 'Cookie encryption, password hashes, and user sessions are insecure or non-functional without a unique encryption key.',
            recommendation: 'Run "php artisan key:generate" to establish a cryptographically secure key.',
          ));
        }
      }

      // 3. SQL Injection Risk in raw queries (Security)
      if (sqlInjectionRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-LAR-003',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'MEDIUM',
          title: 'Vulnerable Raw SQL Query Bindings',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Usage of DB raw query functions with dynamic variable interpolation.',
          risk: 'Direct string interpolation inside database query operations bypasses parameter sanitization, allowing arbitrary SQL execution (SQL Injection).',
          recommendation: 'Pass variables as binding parameters: DB::raw("SELECT * FROM users WHERE id = :id", ["id" => \$userId]).',
        ));
      }

      // 4. Loose Mass Assignment on Models (Security)
      if (unprotectedModelRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-LAR-004',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Unprotected Model Mass Assignment (Empty \$guarded)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'A Eloquent Model declares "\$guarded = []", exposing it to mass assignment.',
          risk: 'HTTP client updates can alter unexpected model properties (e.g. setting "is_admin = true" via POST request parameters).',
          recommendation: 'Use a defined "\$fillable" array containing safe parameters, or strictly validate input before filling.',
        ));
      }

      // 5. MVC Layer violation: DB Query inside Blade template (Architecture)
      if (relativePath.endsWith('.blade.php') && dbInViewRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'ARC-LAR-001',
          category: 'ARCHITECTURE',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Database Queries Executed in Blade Template',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Eloquent/DB query calls inside Laravel Blade view file.',
          risk: 'Violates MVC layer design, slows rendering, and creates N+1 query loops that are difficult to optimize.',
          recommendation: 'Retrieve and resolve dataset records in the Controller or Repository, and pass static models/collections to Blade.',
        ));
      }
    }

    // 6. Loose CSRF Exemptions Check
    if (name == 'VerifyCsrfToken.php') {
      final content = lines.join('\n');
      if (csrfExemptionsRegex.hasMatch(content)) {
        final match = csrfExemptionsRegex.firstMatch(content)!.group(0)!;
        if (match.contains("'*'") || match.contains("'api/*'") || match.split(',').length > 5) {
          findings.add(Finding(
            id: 'SEC-LAR-005',
            category: 'SECURITY',
            severity: 'HIGH',
            confidence: 'MEDIUM',
            title: 'Broad CSRF Exemption Rules',
            file: relativePath,
            line: 1,
            evidence: match,
            description: 'VerifyCsrfToken declares wildcard exceptions or too many exempted URLs.',
            risk: 'Exempted routes bypass Cross-Site Request Forgery protections, allowing malicious third parties to execute POST actions on behalf of authenticated clients.',
            recommendation: 'Keep exceptions to a minimum. Move API routes to api.php routes, which naturally operate without session state and CSRF.',
          ));
        }
      }
    }
  }

  Future<void> _scanComposerJson(String projectPath, List<Finding> findings) async {
    final composerJsonFile = File(p.join(projectPath, 'composer.json'));
    if (!composerJsonFile.existsSync()) return;

    try {
      final doc = jsonDecode(composerJsonFile.readAsStringSync());
      if (doc is! Map) return;

      final require = doc['require'] as Map? ?? {};
      
      // Known old versions checks
      if (require.containsKey('laravel/framework')) {
        final version = require['laravel/framework'].toString();
        if (version.startsWith('^5.') || version.startsWith('^6.') || version.startsWith('^7.')) {
          findings.add(Finding(
            id: 'DEP-LAR-001',
            category: 'DEPENDENCY',
            severity: 'HIGH',
            confidence: 'HIGH',
            title: 'Legacy Laravel Framework Version',
            file: 'composer.json',
            line: 1,
            evidence: '"laravel/framework": "$version"',
            description: 'Project uses a legacy Laravel release (<= 7.x) which is end-of-life.',
            risk: 'Unsupported framework releases do not receive security hotfixes or PHP version compatibility patches.',
            recommendation: 'Upgrade laravel/framework to a currently supported release (>= 10.x).',
          ));
        }
      }
    } catch (_) {}
  }

  @override
  Future<ProjectMetadata> getMetadata(String projectPath) async {
    final composerJsonFile = File(p.join(projectPath, 'composer.json'));
    String projectName = p.basename(projectPath);
    String laravelVersion = 'unknown';
    String phpVersion = 'unknown';
    final Map<String, String> dependencies = {};
    final Map<String, String> devDependencies = {};

    if (composerJsonFile.existsSync()) {
      try {
        final content = composerJsonFile.readAsStringSync();
        final doc = jsonDecode(content);
        if (doc is Map) {
          projectName = doc['name']?.toString() ?? projectName;
          final req = doc['require'];
          if (req is Map) {
            req.forEach((k, v) => dependencies[k.toString()] = v.toString());
          }
          final reqDev = doc['require-dev'];
          if (reqDev is Map) {
            reqDev.forEach((k, v) => devDependencies[k.toString()] = v.toString());
          }
        }
      } catch (_) {}
    }

    if (dependencies.containsKey('laravel/framework')) {
      laravelVersion = dependencies['laravel/framework']!.replaceAll(RegExp(r'[^0-9\.]'), '');
    }
    if (dependencies.containsKey('php')) {
      phpVersion = dependencies['php']!;
    }

    // Attempt to parse DB from .env if available
    String database = 'MySQL / PostgreSQL (Laravel default)';
    final envFile = File(p.join(projectPath, '.env'));
    if (envFile.existsSync()) {
      try {
        final envContent = envFile.readAsStringSync();
        final match = RegExp(r'DB_CONNECTION=([^\s]+)').firstMatch(envContent);
        if (match != null) {
          database = match.group(1)!.trim();
        }
      } catch (_) {}
    }

    return ProjectMetadata(
      projectName: projectName,
      flutterVersion: 'N/A (Laravel)',
      dartVersion: 'PHP $phpVersion',
      dependencies: dependencies,
      devDependencies: devDependencies,
      detectedArchitecture: 'Laravel $laravelVersion (MVC)',
      detectedStateManagement: 'N/A',
      detectedRouter: 'Laravel Route Engine',
      detectedNetwork: 'GuzzleHttp / Http Client',
      detectedDatabase: database,
      hasFirebase: dependencies.containsKey('kreait/laravel-firebase'),
      hasAuthentication: true, // Laravel has built-in Auth
      targetPlatforms: ['Server Host', 'Apache / Nginx'],
    );
  }
}
