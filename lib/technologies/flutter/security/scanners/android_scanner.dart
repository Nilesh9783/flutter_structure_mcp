import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class AndroidScanner {
  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    final androidDir = Directory(p.join(projectDir.path, 'android'));
    if (!androidDir.existsSync()) {
      return findings;
    }

    // 1. Scan AndroidManifest.xml
    final manifestFiles = <File>[];
    try {
      await for (final entity in androidDir.list(recursive: true, followLinks: false)) {
        if (entity is File && p.basename(entity.path) == 'AndroidManifest.xml') {
          manifestFiles.add(entity);
        }
      }
    } catch (_) {}

    for (final manifestFile in manifestFiles) {
      final relativePath = p.relative(manifestFile.path, from: projectDir.path);
      final isDebugManifest = manifestFile.path.contains('/debug/');
      final manifestContent = await manifestFile.readAsString();
      final lines = manifestContent.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];

        // Check allowBackup
        if (line.contains('android:allowBackup="true"') && !isDebugManifest) {
          final finding = Finding(
            id: 'SEC-AND-001',
            category: 'SECURITY',
            severity: 'MEDIUM',
            confidence: 'HIGH',
            title: 'Android Application Backups Enabled',
            file: relativePath,
            line: i + 1,
            evidence: line.trim(),
            description: 'The app Manifest configures backups to be enabled at line ${i + 1}.',
            risk: 'When backups are enabled, anyone with USB debugging access can use "adb backup" to extract the private sandbox directories and databases of this application.',
            recommendation: 'Set android:allowBackup="false" in AndroidManifest.xml unless backup of sensitive application data is specifically handled and secured.',
            fixAvailable: true,
          );
          findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
        }

        // Check usesCleartextTraffic
        if (line.contains('android:usesCleartextTraffic="true"')) {
          final finding = Finding(
            id: 'SEC-AND-002',
            category: 'SECURITY',
            severity: 'HIGH',
            confidence: 'HIGH',
            title: 'Android Cleartext Traffic Allowed',
            file: relativePath,
            line: i + 1,
            evidence: line.trim(),
            description: 'The Android Manifest configures the application to allow cleartext HTTP traffic at line ${i + 1}.',
            risk: 'Cleartext traffic is vulnerable to interception and modification via Man-In-The-Middle attacks.',
            recommendation: 'Remove usesCleartextTraffic="true" or use a network security configuration file to allow cleartext traffic only for specific API domains or debugging endpoints.',
            fixAvailable: true,
          );
          findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
        }

        // Check exported components
        if (line.contains('android:exported="true"')) {
          final finding = Finding(
            id: 'SEC-AND-003',
            category: 'SECURITY',
            severity: 'MEDIUM',
            confidence: 'MEDIUM',
            title: 'Exported Android Component without Custom Permissions',
            file: relativePath,
            line: i + 1,
            evidence: line.trim(),
            description: 'An Android component is marked exported="true" at line ${i + 1} in $relativePath.',
            risk: 'Exported activities can be started by any other application on the device. If they accept arguments or intents without validation, it could lead to intent injection or unauthorized privilege access.',
            recommendation: 'Ensure exported components validate all received intent extras, or set android:exported="false" if they only need to be accessed internally.',
            fixAvailable: false,
          );
          findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
        }
      }
    }

    return findings;
  }
}
