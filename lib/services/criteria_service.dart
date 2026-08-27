import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'yaml_service.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';

class CriteriaService {
  static final CriteriaService _instance = CriteriaService._internal();
  factory CriteriaService() => _instance;
  CriteriaService._internal();

  final YamlService _yamlService = YamlService();
  Map<String, dynamic> _defaultCriteria = {};
  List<Map<String, String>> _sheetCriteria = [];
  bool _initialized = false;

  static const Map<String, String> idMapping = {
    'QAL-001': 'CQ-001',
    'QAL-002': 'CQ-004',
    'QAL-ARC-001': 'ARC-001',
    'QAL-ARC-002': 'ARC-003',
    'SEC-SEC-001': 'SEC-001',
    'SEC-STR-001': 'SEC-005',
    'SEC-NET-002': 'SEC-006',
    'SEC-NET-001': 'SEC-007',
    'SEC-WV-001': 'SEC-008',
    'SEC-WV-002': 'SEC-008',
    'SEC-FB-001': 'SEC-013',
    'SEC-FB-002': 'SEC-013',
    'SEC-AND-001': 'SEC-011',
    'SEC-AND-002': 'SEC-011',
    'SEC-AND-003': 'SEC-011',
    'SEC-IOS-001': 'SEC-012',
    'SEC-IOS-002': 'SEC-012',
    'MEM-001': 'MEM-001',
    'MEM-002': 'MEM-002',
    'MEM-003': 'MEM-003',
    'SEC-DEP-001': 'DEP-001',
    'SEC-DEP-002': 'DEP-002',
  };

  static const Map<String, String> ruleNameDisambiguation = {
    'QAL-001': 'Large File LOC',
  };

  static const String sheetUrl =
      'https://docs.google.com/spreadsheets/d/1Fy70spio6cM_JPVxPoSN8FRp4GXK7EdDOBO44pqKyVI/export?format=csv';

  Map<String, dynamic> get defaultCriteria => _defaultCriteria;
  List<Map<String, String>> get sheetCriteria => _sheetCriteria;

  double? getRuleThreshold(String ruleId) {
    final resolvedId = idMapping[ruleId] ?? ruleId;
    final row = _sheetCriteria.firstWhere(
      (r) => r['Rule ID'] == resolvedId && _containsNumericThreshold(r['Threshold / Configuration'] ?? ''),
      orElse: () => _sheetCriteria.firstWhere(
        (r) => r['Rule ID'] == resolvedId,
        orElse: () => {},
      ),
    );
    if (row.isEmpty) return null;
    final thresholdStr = row['Threshold / Configuration'] ?? '';
    final regex = RegExp(r'\d+(\.\d+)?');
    final match = regex.firstMatch(thresholdStr);
    if (match != null) {
      return double.tryParse(match.group(0)!);
    }
    return null;
  }

  bool _containsNumericThreshold(String val) {
    return RegExp(r'[><]\s*\d+').hasMatch(val);
  }

  Finding enrichFindingWithSheet(Finding f) {
    final resolvedId = idMapping[f.id] ?? f.id;
    final expectedName = ruleNameDisambiguation[f.id];
    final row = _sheetCriteria.firstWhere(
      (r) => r['Rule ID'] == resolvedId && (expectedName == null || r['Rule Name'] == expectedName),
      orElse: () => _sheetCriteria.firstWhere(
        (r) => r['Rule ID'] == resolvedId,
        orElse: () => {},
      ),
    );
    if (row.isEmpty) return f;

    final sheetSeverity = (row['Severity'] ?? f.severity).toString().toUpperCase();
    final sheetConfidence = (row['Confidence'] ?? f.confidence).toString().toUpperCase();
    final sheetTitle = row['Rule Name'] ?? f.title;
    final sheetDesc = row['What to Check / Trigger Condition'] ?? f.description;
    final sheetRec = row['Recommendation'] ?? f.recommendation;

    return Finding(
      id: f.id,
      category: f.category,
      severity: _validateSeverity(sheetSeverity) ? sheetSeverity : f.severity,
      confidence: _validateConfidence(sheetConfidence) ? sheetConfidence : f.confidence,
      title: sheetTitle.isNotEmpty ? sheetTitle : f.title,
      file: f.file,
      line: f.line,
      evidence: f.evidence,
      description: sheetDesc.isNotEmpty ? sheetDesc : f.description,
      risk: f.risk,
      recommendation: sheetRec.isNotEmpty ? sheetRec : f.recommendation,
      fixAvailable: f.fixAvailable,
    );
  }

  bool _validateSeverity(String sev) {
    return const ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'].contains(sev);
  }

  bool _validateConfidence(String conf) {
    return const ['HIGH', 'MEDIUM', 'LOW'].contains(conf);
  }

  // Retrieve max lines of code from yaml configuration with safe fallback
  int get maxLinesOfCode {
    final codeQuality = _defaultCriteria['code_quality'];
    if (codeQuality is Map) {
      final value = codeQuality['max_lines_of_code'];
      if (value is num) return value.toInt();
    }
    return 500; // Default fallback
  }

  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Resolve project root and load local criteria.yaml
    final scriptUri = Platform.script;
    final scriptPath = scriptUri.isScheme('file') ? scriptUri.toFilePath() : '.';
    String projectRoot = p.dirname(p.dirname(scriptPath));
    if (!Directory(p.join(projectRoot, 'config')).existsSync()) {
      projectRoot = Directory.current.path;
    }

    final criteriaYamlPath = p.join(projectRoot, 'config', 'criteria.yaml');
    _defaultCriteria = _yamlService.loadYamlFile(criteriaYamlPath);

    // 2. Resolve cache path for Google Sheets criteria
    final cacheCsvPath = p.join(projectRoot, 'config', 'cached_criteria.csv');

    // 3. Fetch remote criteria with offline caching
    try {
      final fetchedCsv = await _fetchRemoteCsv();
      if (fetchedCsv.isNotEmpty) {
        _sheetCriteria = _parseCsv(fetchedCsv);
        // Save to cache
        final cacheFile = File(cacheCsvPath);
        await cacheFile.writeAsString(fetchedCsv);
      }
    } catch (e) {
      stderr.writeln('⚠️ Warning: Failed to fetch online criteria: $e');
    }

    // 4. Fallback to cache if remote failed
    if (_sheetCriteria.isEmpty) {
      final cacheFile = File(cacheCsvPath);
      if (cacheFile.existsSync()) {
        try {
          final cachedContent = await cacheFile.readAsString();
          _sheetCriteria = _parseCsv(cachedContent);
        } catch (_) {}
      }
    }

    // 5. Fallback to hardcoded backup if all else fails
    if (_sheetCriteria.isEmpty) {
      _sheetCriteria = _parseCsv(_hardcodedCsvBackup);
    }

    _initialized = true;
  }

  Future<String> _fetchRemoteCsv() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client.getUrl(Uri.parse(sheetUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        final content = await response.transform(utf8.decoder).join();
        return content;
      }
    } finally {
      client.close();
    }
    return '';
  }

  List<Map<String, String>> _parseCsv(String csvContent) {
    final result = <Map<String, String>>[];
    final rows = <List<String>>[];
    var currentRow = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < csvContent.length; i++) {
      final char = csvContent[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        currentRow.add(buffer.toString().trim());
        buffer.clear();
      } else if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i + 1 < csvContent.length && csvContent[i + 1] == '\n') {
          i++;
        }
        currentRow.add(buffer.toString().trim());
        buffer.clear();
        if (currentRow.isNotEmpty && currentRow.any((cell) => cell.isNotEmpty)) {
          rows.add(currentRow);
        }
        currentRow = [];
      } else {
        buffer.write(char);
      }
    }
    if (buffer.isNotEmpty || currentRow.isNotEmpty) {
      currentRow.add(buffer.toString().trim());
      rows.add(currentRow);
    }

    if (rows.isEmpty) return [];

    final headerRow = rows.first;
    for (int i = 1; i < rows.length; i++) {
      final values = rows[i];
      final entry = <String, String>{};
      for (int j = 0; j < headerRow.length; j++) {
        if (j < values.length) {
          entry[headerRow[j]] = values[j];
        } else {
          entry[headerRow[j]] = '';
        }
      }
      if (entry.containsKey('Category') && entry['Category']!.trim().isNotEmpty) {
        result.add(entry);
      }
    }
    return result;
  }

  String getCriteriaObservationMessage() {
    final buffer = StringBuffer();
    buffer.writeln('📋 ANALYSIS CRITERIA OBSERVED FOR YOUR PROJECT:');
    buffer.writeln(
        'We observe the following default and dynamically retrieved sheet criteria to audit your project:');
    buffer.writeln('Source: $sheetUrl');
    buffer.writeln();

    // Group sheet criteria by category
    final grouped = <String, List<Map<String, String>>>{};
    for (final criteria in _sheetCriteria) {
      final category = criteria['Category'] ?? 'General';
      grouped.putIfAbsent(category, () => []).add(criteria);
    }

    for (final category in grouped.keys) {
      buffer.writeln('🔹 $category');
      for (final criteria in grouped[category]!) {
        final subcategory = criteria['Subcategory'] ?? '';
        final name = criteria['Rule Name'] ?? criteria['Analysis Criteria'] ?? '';
        final check = criteria['What to Check / Trigger Condition'] ?? criteria['What to Check'] ?? '';
        final type = criteria['Analysis Type'] ?? 'Static';
        final threshold = criteria['Threshold / Configuration'] ?? '';
        final thresholdStr = threshold.isNotEmpty ? ' [Threshold: $threshold]' : '';
        buffer.writeln('  - **$name** ($subcategory - $type): $check$thresholdStr');
      }
      buffer.writeln();
    }

    // Add local parameters
    buffer.writeln('⚙️ Local Threshold Parameters (from config/criteria.yaml):');
    buffer.writeln('  - Max Lines of Code per file: $maxLinesOfCode');
    final codeQuality = _defaultCriteria['code_quality'];
    if (codeQuality is Map) {
      buffer.writeln('  - Max lines per function: ${codeQuality['max_function_lines'] ?? 50}');
      buffer.writeln('  - Allow TODO comments: ${codeQuality['allow_todo_comments'] ?? false}');
      buffer.writeln('  - Enforce class prefixes: ${codeQuality['enforce_class_prefixes'] ?? true}');
    }
    final naming = _defaultCriteria['naming_conventions'];
    if (naming is Map) {
      buffer.writeln('  - Model naming suffix required: ${naming['models']?['require_suffix'] ?? true} ("${naming['models']?['suffix'] ?? 'Model'}")');
      buffer.writeln('  - Service naming suffix required: ${naming['services']?['require_suffix'] ?? true} ("${naming['services']?['suffix'] ?? 'Service'}")');
    }
    return buffer.toString();
  }

  // Resilient backup of the Google Sheet data if offline or unreachable
  static const String _hardcodedCsvBackup = '''Rule ID,Category,Subcategory,Rule Name,Analysis Criteria,What to Check / Trigger Condition,Analysis Type,Suggested Detection,Threshold / Configuration,Severity,Confidence,Recommendation,Evidence Required,Suggested By
CQ-001,Code Quality,Complexity,Large File LOC,Lines of Code,"Trigger when a file has more than 500 non-empty, non-comment code lines",Static,AST + line count,file_code_loc > 500,Medium,High,Split large files into smaller focused units,File path + LOC + threshold,Nilesh
CQ-002,Code Quality,Complexity,Large Class LOC,Lines of Code,Trigger when a class exceeds configured LOC threshold,Static,AST + line count,class_code_loc > 300,Medium,High,Split class responsibilities,Class name + LOC,Nilesh
CQ-003,Code Quality,Complexity,Large Function LOC,Lines of Code,Trigger when a function/method exceeds configured LOC threshold,Static,AST + line count,function_code_loc > 80,High,High,Break function into smaller methods,Function + line range + LOC,Nilesh
CQ-004,Code Quality,Dead Code,Unused Widgets/Classes/Functions,Unused declarations,Declared widget/class/function has no references,Static,AST + reference graph,reference_count == 0,Medium,High,Remove unused code or document intentional public APIs,Declaration + references,Nilesh
CQ-005,Code Quality,Dead Code,Unused Imports,Unused imports,Imported symbol is never referenced,Static,Dart analyzer + AST,import_reference_count == 0,Low,High,Remove unused imports,Import line,Nilesh
CQ-006,Code Quality,Dead Code,Unreachable Branch,Dead/unreachable branches,Branch can never execute based on static control-flow analysis,Static,AST + control-flow analysis,unreachable == true,Medium,High,Remove or simplify unreachable logic,Branch line + condition,Nilesh
CQ-007,Code Quality,Maintainability,High Cyclomatic Complexity,Function complexity,Function exceeds complexity threshold,Static,Control-flow graph,complexity > 10,High,High,Refactor complex logic,Function + complexity score,Nilesh
CQ-008,Code Quality,Duplication,Duplicate Code,Repeated code blocks,Similar code block exceeds configured similarity threshold,Static,Token/AST similarity,similarity >= 0.85,Medium,Medium,Extract reusable functions/widgets/services,Matching locations,Nilesh
CQ-009,Code Quality,Flutter,Large Build Method,Widget structure,Build method exceeds configured size,Static,AST/widget-tree heuristics,build_loc > 80,High,High,Extract widgets and separate UI/business logic,Widget + build LOC,Nilesh
CQ-010,Code Quality,Flutter,Deep Widget Nesting,Widget structure,Widget tree nesting exceeds threshold,Static,AST/widget-tree analysis,depth > 8,Medium,High,Extract nested widgets,Widget + depth,Nilesh
CQ-011,Code Quality,Flutter,Broad State Rebuild,Unnecessary rebuilds,State update potentially rebuilds unnecessarily large widget subtree,Static,AST + state-management patterns,Configurable,Medium,Medium,Narrow rebuild scope,State call + widget location,Nilesh
CQ-012,Code Quality,Flutter,Missing Const Opportunity,Const usage,Constructor/widget can safely be const but is not,Static,Dart analyzer + AST,const_possible == true,Low,High,Use const constructors/instances,Source location,Nilesh
CQ-013,Code Quality,Flutter,Improper final Usage,Variable mutability,Local variable never reassigned and can be final,Static,AST + flow analysis,assignment_count == 1,Low,High,Prefer final,Variable location,Nilesh
CQ-014,Code Quality,Flutter,Unsafe Late Usage,Late initialization,late variable may be accessed before initialization or is unnecessary,Static,AST + flow analysis,Configurable,Medium,Medium,Avoid unnecessary late and initialize safely,Variable + access path,Nilesh
CQ-015,Code Quality,Naming,Naming Convention Violation,Dart naming,"Classes, variables, methods/files violate Dart naming conventions",Static,AST + lint rules,Dart convention,Low,High,Apply Dart naming conventions,Symbol + expected name,Nilesh
CQ-016,Code Quality,Error Handling,Empty Catch Block,Error handling,Catch block has no meaningful handling/logging/rethrow,Static,AST pattern scan,catch_body_effective_statements == 0,Medium,High,"Handle, propagate, or intentionally document errors",Catch location,Nilesh
SEC-001,Security,Secrets,Hardcoded API Key,Secret exposure,API key pattern detected in source/config,Static,Secret-pattern scan + entropy,Pattern + entropy score,Critical,High,Remove secret and rotate credential,File + line + redacted evidence,Nilesh
SEC-002,Security,Secrets,Payment Gateway Credential,Secret exposure,Payment provider private/secret credential detected,Static,Provider-specific patterns + secret scan,Provider pattern,Critical,High,Never ship private payment credentials in client,File + line + redacted evidence,Nilesh
SEC-003,Security,Secrets,Firebase Service Account,Secret exposure,Firebase service-account JSON/private key detected,Static,Pattern/file scan,Credential pattern,Critical,High,"Remove, rotate and keep credentials server-side",File + line,Nilesh
SEC-004,Security,Secrets,Private Key/Certificate,Secret exposure,PEM/private key/signing material detected,Static,Secret scanner,private_key_detected == true,Critical,High,Remove and rotate exposed credentials,File + line,Nilesh
SEC-005,Security,Authentication,Insecure Token Storage,Token storage,Access/refresh tokens stored in SharedPreferences/plain files,Static,Storage API pattern scan,Sensitive token + insecure storage,High,High,Use platform secure storage,Storage call + variable,Nilesh
SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
SEC-007,Security,Network,Certificate Validation Bypass,TLS validation,Client bypasses certificate validation,Static,API/client configuration scan,Trust-all callback/API,Critical,High,Use platform certificate validation,Client config + line,Nilesh
SEC-008,Security,WebView,Unsafe WebView Configuration,WebView security,JavaScript/file access/untrusted navigation enabled without controls,Static,WebView API scan,Risk pattern,High,Medium,"Restrict navigation, sources and JS capabilities",WebView config,Nilesh
SEC-009,Security,Input,Unsafe Dynamic Data Handling,Dynamic execution,Unsafe eval-like/dynamic deserialization or execution pattern detected,Static,AST/API pattern scan,Risk API pattern,High,Medium,Validate and constrain untrusted input,API + data flow,Nilesh
SEC-010,Security,Logging,Sensitive Data in Logs,Logging security,Token/password/payment/PII passed to logging APIs,Static,Log-call + secret pattern scan,Sensitive variable/pattern,High,High,Remove sensitive logs or redact values,Log statement + variable,Nilesh
SEC-011,Security,Platform,Android Insecure Configuration,Android security,"Debuggable release config, exported components or permissive network settings",Static,Android manifest/Gradle scan,Risk configuration,High,High,Harden release configuration,Manifest/Gradle location,Nilesh
SEC-012,Security,Platform,iOS Insecure Configuration,iOS security,"ATS exceptions, insecure entitlements or overly permissive settings",Static,Info.plist/entitlement scan,Risk configuration,High,High,Minimize exceptions and harden release settings,Config key + value,Nilesh
SEC-013,Security,Firebase,Overly Permissive Firebase Rules,Firebase security,Firestore/Realtime Database allows broad unauthenticated read/write,Static,Rules parser/pattern scan,Broad read/write access,Critical,High,Apply least-privilege authenticated access,Rule path + rule,Nilesh
MEM-001,Memory Leak,Lifecycle,Unclosed StreamSubscription,Resource lifecycle,StreamSubscription created without matching cancellation/disposal,Static,AST lifecycle pairing,cancel_missing == true,High,High,Cancel subscriptions in dispose/close,Creation + lifecycle location,Nilesh
MEM-002,Memory Leak,Lifecycle,Unclosed Timer,Resource lifecycle,Timer created without cancellation,Static,AST lifecycle pairing,cancel_missing == true,High,High,Cancel timers in dispose/close,Timer creation + lifecycle,Nilesh
MEM-003,Memory Leak,Lifecycle,AnimationController Not Disposed,Resource lifecycle,AnimationController created in State without dispose,Static,AST lifecycle analysis,dispose_missing == true,High,High,Dispose controller in State.dispose,Controller + dispose,Nilesh
MEM-004,Memory Leak,Lifecycle,TextEditingController Not Disposed,Resource lifecycle,TextEditingController retained without disposal,Static,AST lifecycle analysis,dispose_missing == true,High,High,Dispose controller in State.dispose,Controller + dispose,Nilesh
MEM-005,Memory Leak,Lifecycle,Scroll/Page Controller Not Disposed,Resource lifecycle,ScrollController/PageController created without disposal,Static,AST lifecycle analysis,dispose_missing == true,High,High,Dispose controller,Controller + dispose,Nilesh
MEM-006,Memory Leak,State,Listener Not Removed,Listener lifecycle,addListener/addObserver without matching remove,Static,AST pair matching,remove_missing == true,High,High,Remove listeners during disposal,Add/remove locations,Nilesh
MEM-007,Memory Leak,Flutter,Unnecessary StatefulWidget,Widget lifecycle,StatefulWidget has no mutable state or lifecycle requirement,Static,AST heuristic,stateful_need == false,Low,High,Prefer StatelessWidget,Widget + reason,Nilesh
MEM-008,Memory Leak,Flutter,Missing Const StatelessWidget,Widget optimization,Immutable widget does not use const constructor,Static,AST + analyzer,const_possible == true,Low,High,Use const constructors,Widget location,Nilesh
MEM-009,Memory Leak,Closures,Long-Lived Closure Captures State/Context,Closure retention,Long-lived callback captures State/BuildContext,Static,Reference/lifetime heuristic,Risk pattern,High,Medium,Avoid retaining State/BuildContext beyond lifecycle,Closure + captured references,Nilesh
MEM-010,Memory Leak,Collections,Unbounded In-Memory Collection,Collection growth,List/map/cache grows without size/eviction control,Static,Data-flow heuristics,Configurable size/eviction rule,Medium,Medium,Bound cache size and implement eviction,Collection + growth path,Nilesh
RT-001,Runtime Analysis,Memory,Heap Growth Over Time,Memory behavior,Heap increases across repeated flows and does not return toward baseline,Runtime,Dart VM/service heap snapshots,Configurable growth %,High,High,Identify retained objects and lifecycle leaks,Heap snapshots + trend,Nilesh
RT-002,Runtime Analysis,Memory,Widget/Object Retention,Object retention,Objects remain retained after route/widget disposal,Runtime,Heap snapshot/dominator analysis,Retained after disposal,High,High,Find retaining references and dispose/remove listeners,Object + retaining path,Nilesh
RT-003,Runtime Analysis,Performance,Frame Rendering/Jank,Rendering performance,Frame build/raster time exceeds threshold or dropped frames detected,Runtime,Flutter performance timeline,frame_time > 16.67ms,High,High,Reduce rebuilds and expensive UI/raster work,Frame timeline,Nilesh
RT-004,Runtime Analysis,Performance,Excessive Widget Rebuilds,Rebuild performance,Widget rebuild count significantly exceeds expected baseline,Runtime,Timeline + rebuild counters,Configurable multiplier,Medium,Medium,Localize state and use selectors/builders,Widget + rebuild count,Nilesh
RT-005,Runtime Analysis,Performance,Slow Startup,Startup performance,Cold-start time exceeds configured threshold,Runtime,Startup timeline,startup_ms > 3000,High,High,Defer non-critical initialization,Startup trace,Nilesh
RT-006,Runtime Analysis,Network,Slow API Request,Network performance,API request exceeds latency threshold,Runtime,HTTP instrumentation,latency_ms > 2000,Medium,High,"Cache, batch, debounce or optimize API calls",Request + latency,Nilesh
RT-007,Runtime Analysis,Network,Excessive Network Traffic,Network usage,Unexpected request frequency or payload volume,Runtime,HTTP metrics,Configurable request/payload threshold,Medium,Medium,Reduce polling and duplicate calls,Request metrics,Nilesh
RT-008,Runtime Analysis,Crash,Unhandled Exception,Runtime stability,Unhandled Dart/Flutter exception during test flow,Runtime,Error hooks/log collection,unhandled_exception == true,Critical,High,Handle expected failures and improve error boundaries,Exception + stack trace,Nilesh
RT-009,Runtime Analysis,Lifecycle,Resource Retained After Screen Exit,Lifecycle runtime,Subscription/timer remains active after navigation away,Runtime,Lifecycle instrumentation,Active resource after dispose,High,High,Cancel/dispose resources on screen exit,Screen + resource,Nilesh
RT-010,Runtime Analysis,Storage,Sensitive Runtime Storage,Runtime security,Token/payment/PII written to logs or insecure storage,Runtime,Storage/log interception,Sensitive data detected,Critical,High,Use secure storage and redact telemetry,Storage/log event,Nilesh
DEP-001,Dependencies,Vulnerability,Vulnerable Package Version,Dependency security,Direct/transitive dependency has known security advisory,Static,pubspec.lock + advisory database,Known CVE/advisory,Critical,High,"Upgrade, replace or pin to safe version",Package + advisory,Nilesh
DEP-002,Dependencies,Hygiene,Unused Dependency,Dependency hygiene,Declared package has no project references,Static,Dependency/reference analysis,reference_count == 0,Low,High,Remove unused dependency,Package + references,Nilesh
DEP-003,Dependencies,Risk,Unmaintained Package,Dependency risk,Package has stale releases or weak maintenance signals,Static,Package metadata analysis,Configurable inactivity period,Medium,Medium,Replace or review dependency risk,Package + metadata,Nilesh
ARC-001,Architecture,Structure,Layer Violation,Architecture boundaries,UI directly accesses infrastructure/data layer against selected architecture,Static,Import/dependency graph,Forbidden dependency,High,High,Enforce layer boundaries,Import + layers,Nilesh
ARC-002,Architecture,State Management,Mixed State Management,State architecture,Conflicting state-management patterns used across modules,Static,AST/import pattern analysis,Configured allowed patterns,Medium,High,Standardize state-management approach,Module + patterns,Nilesh
ARC-003,Architecture,Testability,Business Logic Inside Widget,Separation of concerns,Networking/business rules embedded in build/UI classes,Static,AST heuristics,Configurable complexity/API count,High,Medium,Move logic to controller/view-model/use-case/service,Widget + logic evidence,Nilesh
REP-001,Reporting,Evidence,File/Line/Code Evidence,Finding evidence,Every finding must include exact source location and evidence snippet,Both,Scanner metadata,Required fields,High,High,Make findings actionable and reviewable,File + line + snippet,Nilesh
REP-002,Reporting,Severity,Severity/Confidence Scoring,Finding scoring,Every finding receives severity and confidence,Both,Rule engine,Required fields,High,High,Use consistent scoring across categories,Severity + confidence,Nilesh
REP-003,Reporting,False Positives,Suppression/Ignore Support,Finding suppression,Approved findings can be suppressed with a reason,Both,Config file / annotations,Suppression requires reason,Medium,High,Support project-level exclusions with audit trail,Rule + reason + owner,Nilesh''';
}
