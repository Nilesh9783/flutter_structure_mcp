import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';

class IosScanner {
  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    final iosDir = Directory(p.join(projectDir.path, 'ios'));
    if (!iosDir.existsSync()) {
      return findings;
    }

    // Find Info.plist files
    final plistFiles = <File>[];
    try {
      await for (final entity in iosDir.list(recursive: true, followLinks: false)) {
        if (entity is File && p.basename(entity.path) == 'Info.plist') {
          plistFiles.add(entity);
        }
      }
    } catch (_) {}

    for (final plistFile in plistFiles) {
      final relativePath = p.relative(plistFile.path, from: projectDir.path);
      // Skip build/pods plists
      if (relativePath.contains('Pods/') || relativePath.contains('.symlinks/')) {
        continue;
      }

      final plistContent = await plistFile.readAsString();

      // Check NSAllowsArbitraryLoads
      if (plistContent.contains('<key>NSAllowsArbitraryLoads</key>') &&
          plistContent.contains('<true/>')) {
        findings.add(Finding(
          id: 'SEC-IOS-001',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'iOS App Transport Security (ATS) Bypassed',
          file: relativePath,
          line: 1,
          evidence: 'NSAllowsArbitraryLoads = true',
          description: 'The Info.plist contains NSAllowsArbitraryLoads configured to true.',
          risk: 'Enabling arbitrary loads disables Apple App Transport Security (ATS) checks globally for the app, permitting unencrypted connections (HTTP) to any server.',
          recommendation: 'Remove NSAllowsArbitraryLoads = true and declare secure connection exceptions only for specific external domains if necessary.',
          fixAvailable: false,
        ));
      }

      // Check custom URL schemes
      if (plistContent.contains('<key>CFBundleURLSchemes</key>')) {
        findings.add(Finding(
          id: 'SEC-IOS-002',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'MEDIUM',
          title: 'Custom iOS URL Schemes Configured',
          file: relativePath,
          line: 1,
          evidence: 'CFBundleURLSchemes',
          description: 'Custom URL schemes are registered in Info.plist.',
          risk: 'Custom URL schemes are susceptible to hijacking since any application can register any URL scheme. If the app accepts sensitive parameters or actions via URL links, it can cause vulnerabilities.',
          recommendation: 'Ensure all parameters passed through custom URL schemes are validated. Prefer Universal Links (HTTPS-based) which are secure.',
          fixAvailable: false,
        ));
      }
    }

    return findings;
  }
}
