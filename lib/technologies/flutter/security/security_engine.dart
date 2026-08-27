import 'dart:io';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'scanners/secret_scanner.dart';
import 'scanners/storage_scanner.dart';
import 'scanners/network_scanner.dart';
import 'scanners/auth_scanner.dart';
import 'scanners/firebase_scanner.dart';
import 'scanners/webview_scanner.dart';
import 'scanners/android_scanner.dart';
import 'scanners/ios_scanner.dart';
import 'scanners/dependency_scanner.dart';

class SecurityScoreDetails {
  final int rawScore;
  final int finalScore;
  final int criticalCount;
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final String explanation;

  SecurityScoreDetails({
    required this.rawScore,
    required this.finalScore,
    required this.criticalCount,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.explanation,
  });
}

class SecurityEngine {
  final SecretScanner _secretScanner = SecretScanner();
  final StorageScanner _storageScanner = StorageScanner();
  final NetworkScanner _networkScanner = NetworkScanner();
  final AuthScanner _authScanner = AuthScanner();
  final FirebaseScanner _firebaseScanner = FirebaseScanner();
  final WebViewScanner _webViewScanner = WebViewScanner();
  final AndroidScanner _androidScanner = AndroidScanner();
  final IosScanner _iosScanner = IosScanner();
  final DependencyScanner _dependencyScanner = DependencyScanner();

  // Configurable penalties
  static int penaltyCritical = -25;
  static int penaltyHigh = -15;
  static int penaltyMedium = -7;
  static int penaltyLow = -2;

  Future<List<Finding>> runAllScans(Directory projectDir, {bool hasFirebase = false}) async {
    final findings = <Finding>[];

    findings.addAll(await _secretScanner.scan(projectDir));
    findings.addAll(await _storageScanner.scan(projectDir));
    findings.addAll(await _networkScanner.scan(projectDir));
    findings.addAll(await _authScanner.scan(projectDir));
    findings.addAll(await _firebaseScanner.scan(projectDir, hasFirebase: hasFirebase));
    findings.addAll(await _webViewScanner.scan(projectDir));
    findings.addAll(await _androidScanner.scan(projectDir));
    findings.addAll(await _iosScanner.scan(projectDir));
    findings.addAll(await _dependencyScanner.scan(projectDir));

    return findings;
  }

  /// Calculates the security score based on structured findings.
  static SecurityScoreDetails calculateScore(List<Finding> findings) {
    int critical = 0;
    int high = 0;
    int medium = 0;
    int low = 0;

    for (final f in findings) {
      if (f.category != 'SECURITY' && f.category != 'DEPENDENCY') continue;
      
      switch (f.severity.toUpperCase()) {
        case 'CRITICAL':
          critical++;
          break;
        case 'HIGH':
          high++;
          break;
        case 'MEDIUM':
          medium++;
          break;
        case 'LOW':
          low++;
          break;
      }
    }

    final deductions = (critical * penaltyCritical) +
                       (high * penaltyHigh) +
                       (medium * penaltyMedium) +
                       (low * penaltyLow);

    final rawScore = 100 + deductions;
    final finalScore = rawScore.clamp(0, 100);

    final explanation = 'Calculated from security/dependency findings:\n'
        '- Initial Base Score: 100\n'
        '- Critical Findings: $critical (Penalty: ${penaltyCritical} points each => ${critical * penaltyCritical})\n'
        '- High Findings: $high (Penalty: ${penaltyHigh} points each => ${high * penaltyHigh})\n'
        '- Medium Findings: $medium (Penalty: ${penaltyMedium} points each => ${medium * penaltyMedium})\n'
        '- Low Findings: $low (Penalty: ${penaltyLow} points each => ${low * penaltyLow})\n'
        '- Total Deductions: ${deductions.abs()}\n'
        '- Final Score: $finalScore';

    return SecurityScoreDetails(
      rawScore: rawScore,
      finalScore: finalScore,
      criticalCount: critical,
      highCount: high,
      mediumCount: medium,
      lowCount: low,
      explanation: explanation,
    );
  }
}
