import 'package:test/test.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';
import 'package:flutter_architect_mcp/reports/report_generator.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

void main() {
  group('SolutionGenerator Tests', () {
    test('generateSuggestedFix creates accurate non-generic solutions for hardcoded secrets', () {
      final customSecretFinding = Finding(
        id: 'SEC-001',
        category: 'SECURITY',
        severity: 'CRITICAL',
        confidence: 'HIGH',
        title: 'Hardcoded Secret Exposure (customApiKey)',
        file: 'lib/services/api_service.dart',
        line: 14,
        evidence: 'final customApiKey = "ai_sec_9948271038472910";',
        description: 'Hardcoded credentials found at line 14.',
        risk: 'Secret exposure',
        recommendation: 'Use secure storage or .env',
      );

      final fix = SolutionGenerator.generateSuggestedFix(customSecretFinding);

      // Verify that NO dummy stripe key sk_live_... is returned
      expect(fix.contains('sk_live_51H'), isFalse);
      // Verify tailored .env / flutter_secure_storage solution
      expect(fix.contains('.env'), isTrue);
      expect(fix.contains('flutter_secure_storage'), isTrue);
    });

    test('generateSuggestedFix creates accurate lifecycle solutions for memory leaks', () {
      final streamLeak = Finding(
        id: 'MEM-001',
        category: 'MEMORY',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'Unclosed StreamSubscription Lifecycle Leak',
        file: 'lib/screens/chat_screen.dart',
        line: 45,
        evidence: 'chatStream.listen((event) { ... });',
        description: 'StreamSubscription not cancelled.',
        risk: 'Memory leak and continued background execution.',
        recommendation: 'Cancel subscription in dispose().',
      );

      final fix = SolutionGenerator.generateSuggestedFix(streamLeak);
      expect(fix.contains('StreamSubscription'), isTrue);
      expect(fix.contains('cancel()'), isTrue);
      expect(fix.contains('dispose()'), isTrue);

      final timerLeak = Finding(
        id: 'MEM-002',
        category: 'MEMORY',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'Unclosed Timer Lifecycle Leak',
        file: 'lib/screens/countdown_screen.dart',
        line: 22,
        evidence: 'Timer.periodic(Duration(seconds: 1), (timer) { ... });',
        description: 'Timer never cancelled.',
        risk: 'Memory leak',
        recommendation: 'Cancel timer in dispose().',
      );

      final timerFix = SolutionGenerator.generateSuggestedFix(timerLeak);
      expect(timerFix.contains('Timer? _timer'), isTrue);
      expect(timerFix.contains('_timer?.cancel()'), isTrue);
      expect(timerFix.contains('dispose()'), isTrue);
    });

    test('generateSuggestedFix creates solutions for build() method bottlenecks', () {
      final buildController = Finding(
        id: 'PERF-001',
        category: 'PERFORMANCE',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'Controller Instantiation Inside build() Method',
        file: 'lib/screens/login_view.dart',
        line: 30,
        evidence: 'final emailController = TextEditingController();',
        description: 'Instantiating controllers inside build() causes re-allocation on every frame.',
        risk: 'UI jank and loss of text input state.',
        recommendation: 'Move controller to State class and dispose it.',
      );

      final fix = SolutionGenerator.generateSuggestedFix(buildController);
      expect(fix.contains('State<'), isTrue);
      expect(fix.contains('initState()'), isTrue);
      expect(fix.contains('dispose()'), isTrue);
    });

    test('generateSuggestedFix creates accurate solutions for Node, Vue, Laravel, and Python', () {
      // Node eval
      final nodeEval = Finding(
        id: 'SEC-NODE-002',
        category: 'SECURITY',
        severity: 'HIGH',
        confidence: 'MEDIUM',
        title: 'Child Process Exec Command Injection',
        file: 'server/app.js',
        line: 42,
        evidence: 'cp.exec(cmd)',
        description: 'Command injection risk',
        risk: 'Injection',
        recommendation: 'Use execFile',
      );
      expect(SolutionGenerator.generateSuggestedFix(nodeEval).contains('execFile'), isTrue);

      // Vue v-html
      final vueHtml = Finding(
        id: 'SEC-VUE-001',
        category: 'SECURITY',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'v-html XSS Risk',
        file: 'src/components/Post.vue',
        line: 15,
        evidence: 'v-html="rawHtml"',
        description: 'XSS risk',
        risk: 'XSS',
        recommendation: 'Sanitize with DOMPurify',
      );
      expect(SolutionGenerator.generateSuggestedFix(vueHtml).contains('DOMPurify'), isTrue);

      // Laravel SQL injection
      final laravelSql = Finding(
        id: 'SEC-LAR-002',
        category: 'SECURITY',
        severity: 'CRITICAL',
        confidence: 'HIGH',
        title: 'Raw SQL Query with String Interpolation',
        file: 'app/Http/Controllers/UserController.php',
        line: 55,
        evidence: "DB::select('SELECT * FROM users WHERE email = ' . \$email)",
        description: 'SQL Injection',
        risk: 'Database exploit',
        recommendation: 'Use query bindings',
      );
      expect(SolutionGenerator.generateSuggestedFix(laravelSql).contains('where('), isTrue);

      // Python pickle
      final pyPickle = Finding(
        id: 'SEC-PY-002',
        category: 'SECURITY',
        severity: 'CRITICAL',
        confidence: 'HIGH',
        title: 'Insecure Deserialization via pickle',
        file: 'backend/loader.py',
        line: 18,
        evidence: 'pickle.loads(payload)',
        description: 'RCE risk',
        risk: 'Remote code execution',
        recommendation: 'Use JSON',
      );
      expect(SolutionGenerator.generateSuggestedFix(pyPickle).contains('json.loads'), isTrue);

      // Runtime frame jank
      final runtimeJank = Finding(
        id: 'RT-003',
        category: 'PERFORMANCE',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'Frame Jank Detected (> 16.67ms)',
        file: 'lib/views/feed_view.dart',
        line: 1,
        evidence: 'Average frame raster time: 24.5ms',
        description: 'UI stuttering',
        risk: 'Dropped frames',
        recommendation: 'Offload work to isolates',
      );
      expect(SolutionGenerator.generateSuggestedFix(runtimeJank).contains('Isolate.run'), isTrue);
    });

    test('generateClaudePrompt formats accurate single-issue command', () {
      final finding = Finding(
        id: 'SEC-001',
        category: 'SECURITY',
        severity: 'CRITICAL',
        confidence: 'HIGH',
        title: 'Hardcoded Secret Exposure (geminiApiKey)',
        file: 'lib/services/ai_service.dart',
        line: 8,
        evidence: 'const geminiApiKey = "AIzaSyD-sample-gemini-key";',
        description: 'Exposed API key at line 8.',
        risk: 'Unauthorized API quota consumption.',
        recommendation: 'Store key in .env or secure vault.',
      );

      final prompt = SolutionGenerator.generateClaudePrompt(finding);
      expect(prompt.contains('lib/services/ai_service.dart'), isTrue);
      expect(prompt.contains('Line 8'), isTrue);
      expect(prompt.contains('geminiApiKey'), isTrue);
      expect(prompt.contains('preserving all existing behavior'), isTrue);
    });

    test('generateMasterClaudePrompt groups issues by file and provides master instructions', () {
      final findings = [
        Finding(
          id: 'SEC-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Secret',
          file: 'lib/network/api_client.dart',
          line: 12,
          evidence: 'final apiKey = "secret_1234567890123456";',
          description: 'Exposed secret at line 12.',
          risk: 'Credential leak',
          recommendation: 'Move to .env',
        ),
        Finding(
          id: 'MEM-001',
          category: 'MEMORY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Unclosed StreamSubscription',
          file: 'lib/screens/live_tracker.dart',
          line: 40,
          evidence: 'locationStream.listen((loc) {});',
          description: 'Stream leak at line 40.',
          risk: 'Memory leak',
          recommendation: 'Cancel in dispose()',
        ),
      ];

      final masterPrompt = SolutionGenerator.generateMasterClaudePrompt(findings);

      expect(masterPrompt.contains('lib/network/api_client.dart'), isTrue);
      expect(masterPrompt.contains('lib/screens/live_tracker.dart'), isTrue);
      expect(masterPrompt.contains('Fix Rules & Constraints:'), isTrue);
      expect(masterPrompt.contains('DO NOT break existing functionality'), isTrue);
    });

    test('ReportGenerator embeds masterClaudePrompt and tailored solutions in outputs', () async {
      final findings = [
        Finding(
          id: 'SEC-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Secret Exposure (authKey)',
          file: 'lib/core/auth.dart',
          line: 5,
          evidence: 'const authKey = "my_private_auth_token_9999";',
          description: 'Hardcoded secret at line 5.',
          risk: 'Token exposure',
          recommendation: 'Migrate to .env',
        ),
      ];

      final metadata = ProjectMetadata(
        projectName: 'TestApp',
        flutterVersion: '3.24.0',
        dartVersion: '3.5.0',
        dependencies: {},
        devDependencies: {},
        detectedArchitecture: 'Clean',
        detectedStateManagement: 'Bloc',
        detectedRouter: 'GoRouter',
        detectedNetwork: 'Dio',
        detectedDatabase: 'Hive',
        hasFirebase: false,
        hasAuthentication: true,
        targetPlatforms: ['android', 'ios'],
      );

      final reporter = ReportGenerator(
        projectPath: '.',
        findings: findings,
        metadata: metadata,
      );

      final paths = await reporter.generateAllReports();
      expect(paths['json'], isNotNull);
      expect(paths['markdown'], isNotNull);
      expect(paths['html'], isNotNull);
      expect(paths['pdfHtml'], isNotNull);
    });
  });
}
