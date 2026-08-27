import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';

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
      // Skip debug manifest if there are multiple manifests, but scan the main one.
      final isDebugManifest = manifestFile.path.contains('/debug/');
      final manifestContent = await manifestFile.readAsString();

      // Check allowBackup
      if (manifestContent.contains('android:allowBackup="true"') && !isDebugManifest) {
        findings.add(Finding(
          id: 'SEC-AND-001',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Android Application Backups Enabled',
          file: relativePath,
          line: 1,
          evidence: 'android:allowBackup="true"',
          description: 'The app Manifest configures backups to be enabled.',
          risk: 'When backups are enabled, anyone with USB debugging access can use "adb backup" to extract the private sandbox directories and databases of this application.',
          recommendation: 'Set android:allowBackup="false" in AndroidManifest.xml unless backup of sensitive application data is specifically handled and secured.',
          fixAvailable: false,
        ));
      }

      // Check usesCleartextTraffic
      if (manifestContent.contains('android:usesCleartextTraffic="true"')) {
        findings.add(Finding(
          id: 'SEC-AND-002',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Android Cleartext Traffic Allowed',
          file: relativePath,
          line: 1,
          evidence: 'android:usesCleartextTraffic="true"',
          description: 'The Android Manifest configures the application to allow cleartext HTTP traffic.',
          risk: 'Cleartext traffic is vulnerable to interception and modification via Man-In-The-Middle attacks.',
          recommendation: 'Remove usesCleartextTraffic="true" or use a network security configuration file to allow cleartext traffic only for specific API domains or debugging endpoints.',
          fixAvailable: false,
        ));
      }

      // Check exported components
      final exportedMatches = RegExp(r'<activity[^>]+android:exported="true"[^>]*>').allMatches(manifestContent);
      if (exportedMatches.isNotEmpty) {
        findings.add(Finding(
          id: 'SEC-AND-003',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'MEDIUM',
          title: 'Exported Android Component without Custom Permissions',
          file: relativePath,
          line: 1,
          evidence: 'android:exported="true"',
          description: 'One or more Android Activities are marked exported=true in the Manifest.',
          risk: 'Exported activities can be started by any other application on the device. If they accept arguments or intents without validation, it could lead to intent injection or unauthorized privilege access.',
          recommendation: 'Ensure exported components validate all received intent extras, or set android:exported="false" if they only need to be accessed internally.',
          fixAvailable: false,
        ));
      }
    }

    return findings;
  }
}
