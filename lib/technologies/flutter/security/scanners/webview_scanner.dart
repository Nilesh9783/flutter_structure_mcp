import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class WebViewScanner {
  // Pattern to find unrestricted JavaScript Mode
  static final RegExp _jsUnrestrictedPattern = RegExp(
    r'javascriptMode\s*:\s*JavascriptMode\.unrestricted',
    caseSensitive: false,
  );

  static final RegExp _webViewControllerJsPattern = RegExp(
    r'\.\.setJavaScriptMode\s*\(\s*JavaScriptMode\.unrestricted\s*\)',
    caseSensitive: false,
  );

  // Pattern to find WebView without navigation delegate checking URLs
  static final RegExp _webViewCreationPattern = RegExp(
    r'WebView\s*\(\s*',
    caseSensitive: false,
  );

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    await for (final entity in projectDir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is! File) continue;

      final relativePath = p.relative(entity.path, from: projectDir.path);
      if (relativePath.startsWith('.git/') ||
          relativePath.startsWith('.dart_tool/') ||
          relativePath.startsWith('build/') ||
          relativePath.startsWith('reports/') ||
          relativePath.startsWith('test/') ||
          relativePath.contains('/reports/') ||
          relativePath.contains('/test/') ||
          p.extension(entity.path) != '.dart') {
        continue;
      }

      if (FileCache.isCached(entity)) {
        findings.addAll(
          FileCache.getFindings(
            entity,
          ).where((f) => f.id.startsWith('SEC-WV-')),
        );
        continue;
      }

      try {
        final content = await entity.readAsString();

        // Check for unrestricted JS Mode
        final hasUnrestrictedJs =
            _jsUnrestrictedPattern.hasMatch(content) ||
            _webViewControllerJsPattern.hasMatch(content);
        if (hasUnrestrictedJs) {
          findings.add(
            Finding(
              id: 'SEC-WV-001',
              category: 'SECURITY',
              severity: 'MEDIUM',
              confidence: 'HIGH',
              title: 'WebView JavaScript Execution Enabled Unrestrictedly',
              file: relativePath,
              line: 1,
              evidence: 'JavaScriptMode.unrestricted',
              description:
                  'Detected a WebView instantiated with unrestricted JavaScript execution enabled.',
              risk:
                  'Enabling JavaScript in WebViews allows loaded pages to execute code. If untrusted remote content is displayed, it could lead to Cross-Site Scripting (XSS) attacks compromising local app data or bridge APIs.',
              recommendation:
                  'Only enable JavaScript if strictly required. Ensure that navigation is restricted to HTTPS and approved domains using navigation delegates.',
              fixAvailable: false,
            ),
          );
        }

        // Check navigation delegate on WebViews
        if (_webViewCreationPattern.hasMatch(content) &&
            !content.contains('navigationDelegate')) {
          findings.add(
            Finding(
              id: 'SEC-WV-002',
              category: 'SECURITY',
              severity: 'MEDIUM',
              confidence: 'MEDIUM',
              title: 'WebView Lacks Navigation Validation Delegate',
              file: relativePath,
              line: 1,
              evidence: 'WebView(...) without navigationDelegate',
              description:
                  'A WebView was instantiated without defining a navigationDelegate to filter loaded URLs.',
              risk:
                  'Without URL checking, users or malicious links can navigate the WebView to arbitrary external domains, which might steal tokens or impersonate interfaces.',
              recommendation:
                  'Implement navigationDelegate / setNavigationDelegate and reject navigation requests to unknown or non-allowlisted domains.',
              fixAvailable: false,
            ),
          );
        }
      } catch (_) {}
    }
    return findings;
  }
}
