import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

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
      if (relativePath.contains('Pods/') || relativePath.contains('.symlinks/')) {
        continue;
      }

      final plistContent = await plistFile.readAsString();
      final lines = plistContent.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];

        // Check NSAllowsArbitraryLoads
        if (line.contains('<key>NSAllowsArbitraryLoads</key>') || (line.contains('NSAllowsArbitraryLoads') && plistContent.contains('<true/>'))) {
          final finding = Finding(
            id: 'SEC-IOS-001',
            category: 'SECURITY',
            severity: 'HIGH',
            confidence: 'HIGH',
            title: 'iOS App Transport Security (ATS) Bypassed',
            file: relativePath,
            line: i + 1,
            evidence: line.trim(),
            description: 'The Info.plist contains NSAllowsArbitraryLoads configured at line ${i + 1}.',
            risk: 'Enabling arbitrary loads disables Apple App Transport Security (ATS) checks globally for the app, permitting unencrypted connections (HTTP) to any server.',
            recommendation: 'Remove NSAllowsArbitraryLoads = true and declare secure connection exceptions only for specific external domains if necessary.',
            fixAvailable: false,
          );
          findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
        }

        // Check custom URL schemes
        if (line.contains('<key>CFBundleURLSchemes</key>')) {
          final finding = Finding(
            id: 'SEC-IOS-002',
            category: 'SECURITY',
            severity: 'MEDIUM',
            confidence: 'MEDIUM',
            title: 'Custom iOS URL Schemes Configured',
            file: relativePath,
            line: i + 1,
            evidence: line.trim(),
            description: 'Custom URL schemes are registered in Info.plist at line ${i + 1}.',
            risk: 'Custom URL schemes are susceptible to hijacking since any application can register any URL scheme. If the app accepts sensitive parameters or actions via URL links, it can cause vulnerabilities.',
            recommendation: 'Ensure all parameters passed through custom URL schemes are validated. Prefer Universal Links (HTTPS-based) which are secure.',
            fixAvailable: false,
          );
          findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
        }
      }
    }

    return findings;
  }
}
