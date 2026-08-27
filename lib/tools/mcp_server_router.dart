import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_mcp/server.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_architect_mcp/technologies/flutter/models/project_config.dart';
import 'package:flutter_architect_mcp/technologies/flutter/generators/project_generator.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/security_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/secret_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/android_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/ios_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/dependency_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/memory/memory_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/performance/performance_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/code_quality/code_quality_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/architecture_analysis/architecture_scanner.dart';
import 'package:flutter_architect_mcp/rag/rag_service.dart';
import 'package:flutter_architect_mcp/fixes/fix_engine.dart';
import 'package:flutter_architect_mcp/reports/report_generator.dart';
import 'package:flutter_architect_mcp/tools/runtime_perf_check/perf_server.dart';
import 'package:flutter_architect_mcp/services/criteria_service.dart';
import 'package:flutter_architect_mcp/services/email_service.dart';
import 'package:flutter_architect_mcp/core/constants/report_constants.dart';
import 'package:flutter_architect_mcp/technologies/analyzer_hub.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';

base class McpServerRouter extends MCPServer with ToolsSupport {
  McpServerRouter(super.channel)
      : super.fromStreamChannel(
          implementation: Implementation(
            name: 'multi-tech-architect-mcp',
            version: '3.0.0',
            description:
                'Multi-Technology Architecture, Security, Memory, and Performance Analysis MCP Server.',
          ),
        ) {
    _registerTools();
  }

  void _registerTools() {
    // 0. New Generalized tool: analyze_project
    registerTool(
      Tool(
        name: 'analyze_project',
        description:
            'Audits any codebase (Flutter/Dart, Node.js, Vue.js, Laravel PHP, Python, or auto-detect) for quality, security, and performance.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the project to analyze.',
            ),
            'technology': Schema.string(
              description: 'Target technology type: flutter, node, vue, laravel, python, or auto.',
            ),
            'scanLevel': Schema.string(
              description: 'Audit depth: quick, standard, full, deep.',
            ),
            'generateReport': Schema.bool(
              description: 'Set true to output reports to files.',
            ),
            'email': Schema.string(
              description: 'Optional email address to send the generated report automatically.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleAnalyzeProjectGeneral,
    );

    // 1. Existing tool: create_project
    registerTool(
      Tool(
        name: 'create_project',
        description:
            'Creates a new Flutter project configured with architecture, state management, router, database, and backend.',
        inputSchema: ObjectSchema(
          properties: {
            'projectName': Schema.string(
              description:
                  'The name of the Flutter project to create (lowercase snake_case).',
            ),
            'architecture': Schema.string(
              description:
                  'Architecture pattern: clean, mvvm, mvc, feature-first, layered.',
            ),
            'stateManagement': Schema.string(
              description:
                  'State management: bloc, getx, provider, riverpod, rxdart.',
            ),
            'database': Schema.string(
              description: 'Database: hive, isar, drift.',
            ),
            'backend': Schema.string(
              description: 'Backend: firebase, supabase.',
            ),
            'network': Schema.string(
              description: 'Network client: dio, retrofit.',
            ),
            'router': Schema.string(
              description: 'Router: go_router, auto_route, own_extensions.',
            ),
            'targetDirectory': Schema.string(
              description: 'Absolute path to target directory.',
            ),
          },
          required: ['projectName', 'architecture'],
        ),
      ),
      _handleCreateProject,
    );

    // 2. Existing Tool: create_flutter_project
    registerTool(
      Tool(
        name: 'create_flutter_project',
        description:
            'Creates a new Flutter project from configuration details and runs an optional post-creation audit.',
        inputSchema: ObjectSchema(
          properties: {
            'projectName': Schema.string(
              description: 'The name of the project in lowercase snake_case.',
            ),
            'projectPath': Schema.string(
              description: 'Optional path where the project should be created.',
            ),
            'architecture': Schema.string(
              description: 'clean, mvvm, mvc, feature-first, layered.',
            ),
            'stateManagement': Schema.string(
              description: 'bloc, getx, provider, riverpod, rxdart.',
            ),
            'backend': Schema.string(description: 'firebase, supabase.'),
            'database': Schema.string(description: 'hive, isar, drift.'),
            'routing': Schema.string(
              description: 'go_router, auto_route, own_extensions.',
            ),
            'authentication': Schema.string(
              description: 'Authentication integration choice.',
            ),
            'platforms': Schema.list(
              items: Schema.string(),
              description:
                  'Target platforms (android, ios, web, macos, windows, linux).',
            ),
            'runAudit': Schema.bool(
              description:
                  'Set to true to run security, memory, and performance audits post creation.',
            ),
          },
          required: ['projectName', 'architecture'],
        ),
      ),
      _handleCreateFlutterProject,
    );

    // 3. Existing Tool: analyze_flutter_project
    registerTool(
      Tool(
        name: 'analyze_flutter_project',
        description:
            'Analyzes an existing Flutter project at a given path to extract configuration, dependencies, and state managers.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
            'scanLevel': Schema.string(
              description: 'Scan depth: quick, standard, full, deep.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleAnalyzeProject,
    );

    // 4. Existing Tool: detect_flutter_architecture
    registerTool(
      Tool(
        name: 'detect_flutter_architecture',
        description:
            'Analyzes the project source files and structure to detect architectural patterns and confidence score.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleDetectArchitecture,
    );

    // 5. Existing Tool: architecture_scan
    registerTool(
      Tool(
        name: 'architecture_scan',
        description:
            'Analyzes directory layout and class definitions to determine code modularity and layers.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleDetectArchitecture,
    );

    // 6. Existing Tool: security_scan
    registerTool(
      Tool(
        name: 'security_scan',
        description:
            'Performs a complete security check including secrets, network, storage, webviews, and platform configurations.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleSecurityScan,
    );

    // 7. Existing Tool: secret_scan
    registerTool(
      Tool(
        name: 'secret_scan',
        description:
            'Scans source files for hardcoded API keys, private keys, JWTs, and cloud credentials.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleSecretScan,
    );

    // 8. Existing Tool: dependency_scan
    registerTool(
      Tool(
        name: 'dependency_scan',
        description:
            'Audits direct and transitive dependencies in pubspec.yaml/lock for known vulnerable versions.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleDependencyScan,
    );

    // 9. Existing Tool: memory_scan
    registerTool(
      Tool(
        name: 'memory_scan',
        description:
            'Performs static lifecycle analysis to discover unclosed streams, timers, and un-disposed widgets/controllers.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleMemoryScan,
    );

    // 10. Existing Tool: runtime_memory_scan
    registerTool(
      Tool(
        name: 'runtime_memory_scan',
        description:
            'Collects runtime memory snapshots of the running application (Requires instrumented emulator/device).',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleRuntimeMemoryScan,
    );

    // 11. Existing Tool: performance_scan
    registerTool(
      Tool(
        name: 'performance_scan',
        description:
            'Statically inspects build methods, observer models, and list views for rendering and cpu bottlenecks.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handlePerformanceScan,
    );

    // 12. Existing Tool: code_quality_scan
    registerTool(
      Tool(
        name: 'code_quality_scan',
        description:
            'Checks class sizing, method complexity, TODO comments, and UI-layer separation violations.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleCodeQualityScan,
    );

    // 13. Existing Tool: android_security_scan
    registerTool(
      Tool(
        name: 'android_security_scan',
        description:
            'Inspects AndroidManifest.xml, networks configurations, and debug flag overrides.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleAndroidSecurityScan,
    );

    // 14. Existing Tool: ios_security_scan
    registerTool(
      Tool(
        name: 'ios_security_scan',
        description:
            'Inspects Info.plist, custom URL schemes, and App Transport Security exception permissions.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleIosSecurityScan,
    );

    // 15. Existing Tool: full_flutter_audit
    registerTool(
      Tool(
        name: 'full_flutter_audit',
        description:
            'Runs all available static analyzers (security, memory, performance, quality, dependencies) and generates full reports.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
            'scanLevel': Schema.string(
              description: 'Audit depth: quick, standard, full, deep.',
            ),
            'includeRuntime': Schema.bool(
              description: 'Set true to run device profiling if active.',
            ),
            'generateReport': Schema.bool(
              description: 'Set true to output reports to files.',
            ),
            'email': Schema.string(
              description: 'Optional email address to send the generated report automatically.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleFullFlutterAudit,
    );

    // 16. Existing Tool: generate_security_report
    registerTool(
      Tool(
        name: 'generate_security_report',
        description:
            'Generates report documents in HTML, Markdown, and JSON using findings and metadata.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
            'email': Schema.string(
              description: 'Optional email address to send the generated report automatically.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleGenerateSecurityReport,
    );

    // 17. Existing Tool: suggest_fixes
    registerTool(
      Tool(
        name: 'suggest_fixes',
        description:
            'Analyzes code quality and security findings to show proposed safe edits (diff format) without writing.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleSuggestFixes,
    );

    // 18. Existing Tool: apply_safe_fixes
    registerTool(
      Tool(
        name: 'apply_safe_fixes',
        description:
            'Applies safe edits to source files, verifying build/test pass and automatically rolling back on error.',
        inputSchema: ObjectSchema(
          properties: {
            'projectPath': Schema.string(
              description: 'Absolute path to the Flutter project.',
            ),
          },
          required: ['projectPath'],
        ),
      ),
      _handleApplySafeFixes,
    );

    // 19. Existing Tool: start_runtime_perf_check
    registerTool(
      Tool(
        name: 'start_runtime_perf_check',
        description:
            'Starts a runtime performance check server with a web dashboard to profile memory, APIs, and navigation.',
        inputSchema: ObjectSchema(
          properties: {
            'port': Schema.int(
              description: 'The port to bind the server to (default is 8080).',
            ),
          },
        ),
      ),
      _handleStartRuntimePerfCheck,
    );
  }

  // MARK: - General Handler

  Future<CallToolResult> _handleAnalyzeProjectGeneral(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    final techInput = args['technology'] as String? ?? 'auto';
    final scanLevel = args['scanLevel'] as String? ?? 'standard';
    final generateReport = args['generateReport'] as bool? ?? true;
    final email = args['email'] as String?;

    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final hub = AnalyzerHub();
      BaseAnalyzer? analyzer;

      if (techInput.toLowerCase() == 'auto') {
        analyzer = hub.detectTechnology(projectPath);
        if (analyzer == null) {
          return CallToolResult(
            isError: true,
            content: [
              Content.text(
                text: 'Error: Could not auto-detect project technology at "$projectPath". '
                    'Supported technologies are: flutter, node, vue, laravel, python.',
              ),
            ],
          );
        }
      } else {
        analyzer = hub.getAnalyzerById(techInput);
        if (analyzer == null) {
          return CallToolResult(
            isError: true,
            content: [
              Content.text(
                text: 'Error: Unsupported technology "$techInput". '
                    'Supported technologies: flutter, node, vue, laravel, python.',
              ),
            ],
          );
        }
      }

      final findings = await analyzer.analyze(projectPath, scanLevel: scanLevel);
      final rawMeta = await analyzer.getMetadata(projectPath);

      final rag = RagService();
      final enrichedFindings = rag.enrichFindings(findings);
      final score = SecurityEngine.calculateScore(enrichedFindings);

      String reportHtmlPath = '';
      String reportPdfHtmlPath = '';

      if (generateReport) {
        final reporter = ReportGenerator(
          projectPath: projectPath,
          findings: enrichedFindings,
          metadata: rawMeta,
          technologyId: analyzer.technologyId,
        );
        final paths = await reporter.generateAllReports();
        reportHtmlPath = paths['html'] ?? '';
        reportPdfHtmlPath = paths['pdfHtml'] ?? '';
      }

      String emailStatus = '';
      if (email != null && email.isNotEmpty && reportPdfHtmlPath.isNotEmpty) {
        final pdfHtmlFile = File(reportPdfHtmlPath);
        if (pdfHtmlFile.existsSync()) {
          try {
            final htmlBytes = pdfHtmlFile.readAsBytesSync();
            final base64Html = base64Encode(htmlBytes);

            final emailSubject = ReportConstants.emailSubjectTemplate.replaceAll('{projectName}', rawMeta.projectName);
            final emailBody = ReportConstants.emailBodyTemplate
                .replaceAll('{projectName}', rawMeta.projectName)
                .replaceAll('{score}', score.finalScore.toString())
                .replaceAll('{findingsCount}', enrichedFindings.length.toString())
                .replaceAll('{architecture}', rawMeta.detectedArchitecture)
                .replaceAll('{stateManagement}', rawMeta.detectedStateManagement);

            final emailService = EmailService();
            await emailService.sendReport(
              to: email,
              subject: emailSubject,
              body: emailBody,
              pdfBase64: base64Html,
              filename: 'security-report-${rawMeta.projectName}.html',
            );
            emailStatus = 'Email report delivery initiated.';
          } catch (e) {
            emailStatus = 'Error sending email: $e';
          }
        }
      }

      final criteriaMsg = await _getCriteriaMessage();
      final Map<String, dynamic> result = {
        'technology': analyzer.technologyName,
        'metadata': rawMeta.toJson(),
        'score': score.finalScore,
        'explanation': score.explanation,
        'findings': enrichedFindings.map((Finding f) => f.toJson()).toList(),
        'htmlReportPath': reportHtmlPath,
        'pdfHtmlReportPath': reportPdfHtmlPath,
        'emailStatus': emailStatus,
      };

      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n${jsonEncode(result)}')],
      );
    } catch (e, stack) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error during general audit: $e\n$stack')],
      );
    }
  }

  // MARK: - Flutter Specific Handlers (Delegated)

  Future<CallToolResult> _handleCreateProject(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectName = args['projectName'] as String?;
    final architecture = args['architecture'] as String?;
    final stateManagement = args['stateManagement'] as String? ?? '';
    final database = args['database'] as String? ?? '';
    final backend = args['backend'] as String? ?? '';
    final network = args['network'] as String? ?? '';
    final router = args['router'] as String? ?? '';
    final targetDirectory =
        args['targetDirectory'] as String? ?? Directory.current.path;

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
      await generator.generate(config, targetDirectory: targetDirectory);
      return CallToolResult(
        content: [
          Content.text(
            text: 'Success: Flutter project "$projectName" created at $targetDirectory with $architecture.',
          ),
        ],
      );
    } catch (e, stackTrace) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e\n$stackTrace')],
      );
    }
  }

  Future<CallToolResult> _handleCreateFlutterProject(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectName = args['projectName'] as String?;
    final projectPath = args['projectPath'] as String? ?? Directory.current.path;
    final architecture = args['architecture'] as String?;
    final stateManagement = args['stateManagement'] as String? ?? '';
    final backend = args['backend'] as String? ?? '';
    final database = args['database'] as String? ?? '';
    final router = args['routing'] as String? ?? '';
    final runAudit = args['runAudit'] as bool? ?? false;

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
    );

    try {
      final generator = ProjectGenerator();
      await generator.generate(config, targetDirectory: projectPath);
      final fullCreatedPath = p.join(projectPath, projectName);

      if (runAudit) {
        final detector = ProjectDetector.detectMetadata(fullCreatedPath);
        final secEngine = SecurityEngine();
        var findings = await secEngine.runAllScans(
          Directory(fullCreatedPath),
          hasFirebase: detector.hasFirebase,
        );

        findings.addAll(await MemoryEngine().scan(Directory(fullCreatedPath)));
        findings.addAll(await PerformanceEngine().scan(Directory(fullCreatedPath)));
        findings.addAll(await CodeQualityScanner().scan(Directory(fullCreatedPath)));

        final rag = RagService();
        findings = rag.enrichFindings(findings);

        final reporter = ReportGenerator(
          projectPath: fullCreatedPath,
          findings: findings,
          metadata: detector,
          technologyId: 'flutter',
        );
        final paths = await reporter.generateAllReports();

        return CallToolResult(
          content: [
            Content.text(
              text: 'Success: Generated project "$projectName" at $projectPath.\n'
                  'Post-creation audit complete.\n'
                  'HTML report generated at: ${paths['html']}\n'
                  'PDF Download View generated at: ${paths['pdfHtml']}\n'
                  'Findings Count: ${findings.length}\n'
                  'Security Score: ${SecurityEngine.calculateScore(findings).finalScore}/100',
            ),
          ],
        );
      }

      return CallToolResult(
        content: [
          Content.text(
            text: 'Success: Generated project "$projectName" at $projectPath with $architecture architecture.',
          ),
        ],
      );
    } catch (e, stack) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error during project generation: $e\n$stack')],
      );
    }
  }

  Future<CallToolResult> _handleAnalyzeProject(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final stat = ProjectDetector.validateStructure(projectPath);
      final meta = ProjectDetector.detectMetadata(projectPath);
      final resultText = 'Project validation: ${jsonEncode(stat)}\n\nMetadata: ${jsonEncode(meta.toJson())}';
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error analyzing project: $e')],
      );
    }
  }

  Future<CallToolResult> _handleDetectArchitecture(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final meta = ProjectDetector.detectMetadata(projectPath);
      final scanner = ArchitectureScanner();
      final result = await scanner.scanProject(Directory(projectPath), meta);
      return CallToolResult(
        content: [Content.text(text: jsonEncode(result.toJson()))],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleSecurityScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final meta = ProjectDetector.detectMetadata(projectPath);
      final engine = SecurityEngine();
      final findings = await engine.runAllScans(
        Directory(projectPath),
        hasFirebase: meta.hasFirebase,
      );
      final score = SecurityEngine.calculateScore(findings);
      final resultText =
          'Security Score: ${score.finalScore}/100\n\nFindings: ${jsonEncode(findings.map((Finding f) => f.toJson()).toList())}';
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleSecretScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = SecretScanner();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleDependencyScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = DependencyScanner();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleMemoryScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = MemoryEngine();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleRuntimeMemoryScan(CallToolRequest request) async {
    return CallToolResult(
      content: [
        Content.text(
          text: '{\n  "status": "NOT_AVAILABLE",\n  "message": "Runtime memory analysis unavailable."\n}',
        ),
      ],
    );
  }

  Future<CallToolResult> _handlePerformanceScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = PerformanceEngine();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleCodeQualityScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = CodeQualityScanner();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleAndroidSecurityScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = AndroidScanner();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleIosSecurityScan(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final criteriaMsg = await _getCriteriaMessage();
      final scanner = IosScanner();
      final findings = await scanner.scan(Directory(projectPath));
      final resultText = jsonEncode(findings.map((f) => f.toJson()).toList());
      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n$resultText')],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleFullFlutterAudit(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    final generateReport = args['generateReport'] as bool? ?? true;
    final email = args['email'] as String?;

    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final meta = ProjectDetector.detectMetadata(projectPath);
      final findings = <Finding>[];

      findings.addAll(await SecurityEngine().runAllScans(Directory(projectPath), hasFirebase: meta.hasFirebase));
      findings.addAll(await MemoryEngine().scan(Directory(projectPath)));
      findings.addAll(await PerformanceEngine().scan(Directory(projectPath)));
      findings.addAll(await CodeQualityScanner().scan(Directory(projectPath)));

      final archScanner = ArchitectureScanner();
      final archResult = await archScanner.scanProject(Directory(projectPath), meta);

      final enrichedMeta = ProjectMetadata(
        projectName: meta.projectName,
        flutterVersion: meta.flutterVersion,
        dartVersion: meta.dartVersion,
        dependencies: meta.dependencies,
        devDependencies: meta.devDependencies,
        detectedArchitecture: archResult.architecture,
        detectedStateManagement: archResult.stateManagement,
        detectedRouter: meta.detectedRouter,
        detectedNetwork: meta.detectedNetwork,
        detectedDatabase: meta.detectedDatabase,
        hasFirebase: meta.hasFirebase,
        hasAuthentication: meta.hasAuthentication,
        targetPlatforms: meta.targetPlatforms,
      );

      final rag = RagService();
      final enrichedFindings = rag.enrichFindings(findings);
      final score = SecurityEngine.calculateScore(enrichedFindings);

      String reportHtmlPath = '';
      String reportPdfHtmlPath = '';
      if (generateReport) {
        final reporter = ReportGenerator(
          projectPath: projectPath,
          findings: enrichedFindings,
          metadata: enrichedMeta,
          technologyId: 'flutter',
        );
        final paths = await reporter.generateAllReports();
        reportHtmlPath = paths['html'] ?? '';
        reportPdfHtmlPath = paths['pdfHtml'] ?? '';
      }

      String emailStatus = '';
      if (email != null && email.isNotEmpty && reportPdfHtmlPath.isNotEmpty) {
        final pdfHtmlFile = File(reportPdfHtmlPath);
        if (pdfHtmlFile.existsSync()) {
          try {
            final htmlBytes = pdfHtmlFile.readAsBytesSync();
            final base64Html = base64Encode(htmlBytes);

            final emailSubject = ReportConstants.emailSubjectTemplate.replaceAll('{projectName}', enrichedMeta.projectName);
            final emailBody = ReportConstants.emailBodyTemplate
                .replaceAll('{projectName}', enrichedMeta.projectName)
                .replaceAll('{score}', score.finalScore.toString())
                .replaceAll('{findingsCount}', enrichedFindings.length.toString())
                .replaceAll('{architecture}', enrichedMeta.detectedArchitecture)
                .replaceAll('{stateManagement}', enrichedMeta.detectedStateManagement);

            final emailService = EmailService();
            emailService.sendReport(
              to: email,
              subject: emailSubject,
              body: emailBody,
              pdfBase64: base64Html,
              filename: 'security-report-${enrichedMeta.projectName}.html',
            ).then((res) {
              print('✉️ Background email delivery status: ${res['message']}');
            }).catchError((err) {
              print('❌ Background email delivery failed: $err');
            });
            emailStatus = 'Email report delivery initiated in the background.';
          } catch (e) {
            emailStatus = 'Error sending email: $e';
          }
        }
      }

      final criteriaMsg = await _getCriteriaMessage();
      final Map<String, dynamic> result = {
        'metadata': enrichedMeta.toJson(),
        'score': score.finalScore,
        'explanation': score.explanation,
        'findings': enrichedFindings.map((Finding f) => f.toJson()).toList(),
        'htmlReportPath': reportHtmlPath,
        'pdfHtmlReportPath': reportPdfHtmlPath,
        'emailStatus': emailStatus,
      };

      return CallToolResult(
        content: [Content.text(text: '$criteriaMsg\n\n${jsonEncode(result)}')],
      );
    } catch (e, stack) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error during audit: $e\n$stack')],
      );
    }
  }

  Future<CallToolResult> _handleGenerateSecurityReport(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    final email = args['email'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final meta = ProjectDetector.detectMetadata(projectPath);
      final findings = <Finding>[];

      findings.addAll(await SecurityEngine().runAllScans(Directory(projectPath), hasFirebase: meta.hasFirebase));
      findings.addAll(await MemoryEngine().scan(Directory(projectPath)));
      findings.addAll(await PerformanceEngine().scan(Directory(projectPath)));
      findings.addAll(await CodeQualityScanner().scan(Directory(projectPath)));

      final reporter = ReportGenerator(
        projectPath: projectPath,
        findings: findings,
        metadata: meta,
        technologyId: 'flutter',
      );
      final paths = await reporter.generateAllReports();
      final reportPdfHtmlPath = paths['pdfHtml'] ?? '';

      String emailStatus = '';
      if (email != null && email.isNotEmpty && reportPdfHtmlPath.isNotEmpty) {
        final pdfHtmlFile = File(reportPdfHtmlPath);
        if (pdfHtmlFile.existsSync()) {
          try {
            final htmlBytes = pdfHtmlFile.readAsBytesSync();
            final base64Html = base64Encode(htmlBytes);

            final score = SecurityEngine.calculateScore(findings);
            final emailSubject = ReportConstants.emailSubjectTemplate.replaceAll('{projectName}', meta.projectName);
            final emailBody = ReportConstants.emailBodyTemplate
                .replaceAll('{projectName}', meta.projectName)
                .replaceAll('{score}', score.finalScore.toString())
                .replaceAll('{findingsCount}', findings.length.toString())
                .replaceAll('{architecture}', 'Detected')
                .replaceAll('{stateManagement}', 'Analyzed');

            final emailService = EmailService();
            emailService.sendReport(
              to: email,
              subject: emailSubject,
              body: emailBody,
              pdfBase64: base64Html,
              filename: 'security-report-${meta.projectName}.html',
            ).then((res) {
              print('✉️ Background email delivery status: ${res['message']}');
            }).catchError((err) {
              print('❌ Background email delivery failed: $err');
            });
            emailStatus = 'Email report delivery initiated in the background.';
          } catch (e) {
            emailStatus = 'Error sending email: $e';
          }
        }
      }

      final Map<String, dynamic> result = Map<String, dynamic>.from(paths);
      if (emailStatus.isNotEmpty) {
        result['emailStatus'] = emailStatus;
      }

      return CallToolResult(content: [Content.text(text: jsonEncode(result))]);
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleSuggestFixes(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final meta = ProjectDetector.detectMetadata(projectPath);
      final findings = <Finding>[];
      findings.addAll(await SecurityEngine().runAllScans(Directory(projectPath), hasFirebase: meta.hasFirebase));

      final fixer = FixEngine(projectPath);
      final diffs = fixer.suggestFixes(findings);
      return CallToolResult(
        content: [
          Content.text(text: jsonEncode(diffs.map((d) => d.toJson()).toList())),
        ],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleApplySafeFixes(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final projectPath = args['projectPath'] as String?;
    if (projectPath == null || projectPath.trim().isEmpty) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: projectPath is required.')],
      );
    }

    try {
      final meta = ProjectDetector.detectMetadata(projectPath);
      final findings = <Finding>[];
      findings.addAll(await SecurityEngine().runAllScans(Directory(projectPath), hasFirebase: meta.hasFirebase));

      final fixer = FixEngine(projectPath);
      final applied = await fixer.applySafeFixes(findings);
      return CallToolResult(
        content: [
          Content.text(
            text: '{\n  "status": "SUCCESS",\n  "appliedFiles": ${jsonEncode(applied)}\n}',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error: $e')],
      );
    }
  }

  Future<CallToolResult> _handleStartRuntimePerfCheck(CallToolRequest request) async {
    final args = request.arguments ?? {};
    final port = (args['port'] as num?)?.toInt() ?? 8080;

    try {
      final server = PerfServer();
      await server.start(port: port);

      return CallToolResult(
        content: [
          Content.text(
            text: '📊 Runtime Performance Server successfully started!\n'
                '👉 Open in browser: http://localhost:$port\n'
                '👉 Send metrics to: http://localhost:$port/api/record\n\n'
                'Integrate the helper codes displayed on the dashboard Integration Guide tab into your Flutter app to begin profiling.',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        isError: true,
        content: [Content.text(text: 'Error starting server: $e')],
      );
    }
  }

  Future<String> _getCriteriaMessage() async {
    final criteriaService = CriteriaService();
    await criteriaService.initialize();
    return criteriaService.getCriteriaObservationMessage();
  }
}
