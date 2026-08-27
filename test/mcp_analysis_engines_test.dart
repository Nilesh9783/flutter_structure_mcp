import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/secret_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/storage_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/network_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/auth_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/scanners/webview_scanner.dart';
import 'package:flutter_architect_mcp/technologies/flutter/memory/memory_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/performance/performance_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/code_quality/code_quality_scanner.dart';
import 'package:flutter_architect_mcp/rag/retriever.dart';
import 'package:flutter_architect_mcp/fixes/fix_engine.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory(Directory.systemTemp.createTempSync('mcp_test_project').resolveSymbolicLinksSync());
    
    // Create a mock pubspec.yaml
    File(p.join(tempDir.path, 'pubspec.yaml')).writeAsStringSync('''
name: mock_flutter_project
description: Mock project for testing security and memory scans.
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  shared_preferences: ^2.0.15
  dio: ^5.0.0
''');

    // Create a mock code file with multiple issues
    final libDir = Directory(p.join(tempDir.path, 'lib'))..createSync();
    final viewsDir = Directory(p.join(libDir.path, 'views'))..createSync();

    File(p.join(viewsDir.path, 'login_page.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Secret Scanner Target
  final String _awsKey = "AKIA1234567890123456";

  // 2. Auth Scanner Target
  final String _secretPass = "mySuperSecretPassword123";

  @override
  void initState() {
    super.initState();
    // 3. Memory Leak Target
    myStream.listen((data) {
      print(data);
    });
  }

  // 4. Performance Bottleneck Target
  @override
  Widget build(BuildContext context) {
    // 5. Controller creation inside build
    final controller = TextEditingController();

    // 6. Direct HTTP cleartext connection
    final String url = "http://my-unsecured-api.com/login";

    // 7. Storage Scanner Target
    final prefs = SharedPreferences.getInstance();
    prefs.then((p) => p.setString('access_token', 'my-token'));

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Text("Login Screen"),
          ],
        ),
      ),
    );
  }
}
''');

    // Create a WebView file with issues
    File(p.join(libDir.path, 'web_view_widget.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://flutter.dev',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
''');
  });

  tearDownAll(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  group('Security Scanners', () {
    test('SecretScanner should find hardcoded AWS key', () async {
      final scanner = SecretScanner();
      final findings = await scanner.scan(tempDir);
      final awsFinding = findings.firstWhere((f) => f.id == 'SEC-SEC-001');
      expect(awsFinding, isNotNull);
      expect(awsFinding.severity, equals('HIGH'));
    });

    test('StorageScanner should find unencrypted sensitive keys', () async {
      final scanner = StorageScanner();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.evidence.toLowerCase().contains('access_token')), isTrue);
    });

    test('NetworkScanner should find cleartext HTTP link', () async {
      final scanner = NetworkScanner();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.evidence.contains('http://my-unsecured-api.com')), isTrue);
    });

    test('AuthScanner should flag hardcoded passwords', () async {
      final scanner = AuthScanner();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.evidence.contains('mySuperSecretPassword123')), isTrue);
    });

    test('WebViewScanner should flag unrestricted JS mode', () async {
      final scanner = WebViewScanner();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.evidence.toLowerCase().contains('javascriptmode.unrestricted')), isTrue);
    });
  });

  group('Memory & Performance Scanners', () {
    test('MemoryEngine should find un-cancelled StreamSubscription', () async {
      final scanner = MemoryEngine();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.title.contains('StreamSubscription')), isTrue);
    });

    test('PerformanceEngine should find controller instantiation in build()', () async {
      final scanner = PerformanceEngine();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.title.contains('Controller Instantiation Inside Widget build()')), isTrue);
    });
  });

  group('Code Quality & RAG Retriever', () {
    test('CodeQualityScanner should flag pending TODO comments or architectural breach', () async {
      // Mock code with a TODO comment
      final file = File(p.join(tempDir.path, 'lib', 'todo_file.dart'));
      file.writeAsStringSync('// TODO: Implement checkout workflow');

      final scanner = CodeQualityScanner();
      final findings = await scanner.scan(tempDir);
      expect(findings.any((f) => f.title.contains('TODO')), isTrue);
    });

    test('Retriever should find matching knowledge rules from base', () {
      final retriever = Retriever();
      final doc = retriever.retrieve('StreamSubscription cancel leak');
      expect(doc, isNotNull);
      expect(doc!.title, equals('MEM-001'));
    });
  });

  group('Fix Engine', () {
    test('FixEngine should suggest rewriting http:// to https://', () {
      final finder = Finding(
        id: 'SEC-NET-002',
        category: 'SECURITY',
        severity: 'HIGH',
        confidence: 'HIGH',
        title: 'Cleartext HTTP Traffic',
        file: 'lib/views/login_page.dart',
        line: 33,
        evidence: 'http://my-unsecured-api.com/login',
        description: 'http connection',
        risk: 'MITM',
        recommendation: 'Use https',
        fixAvailable: true,
      );

      final fixer = FixEngine(tempDir.path);
      final suggestions = fixer.suggestFixes([finder]);
      expect(suggestions.length, equals(1));
      expect(suggestions.first.newContent.contains('https://'), isTrue);
    });
  });
}
