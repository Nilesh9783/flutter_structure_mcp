# Flutter Engineering MCP Analysis Report

## Project Overview
- **Project Name:** flutter_structure_mcp
- **Flutter SDK:** Flutter >=3.19.0
- **Dart SDK / Runtime:** Dart >=3.3.0
- **State Management:** Bloc
- **Database:** Hive / SecureStorage
- **Router:** GoRouter
- **Network Client:** Dio

## Security Score: **0/100**
```
Calculated codebase score: 0/100 based on 256 findings evaluated (0 Critical, 12 High, 0 Medium, 0 Low).
```

## Summary of Findings
- **Critical:** 0
- **High:** 12
- **Medium:** 0
- **Low:** 0

## 🤖 Master Fix Command for Claude (Fix All Issues)
Pass this master instruction to Claude to fix all issues in one operation:
```markdown
# 🛠️ Master Fix Command for Claude

Please review and resolve the following 256 audit finding(s) in the project.
CRITICAL: Preserve all existing functionality, imports, styles, and public APIs while applying these fixes.

## 📁 File: `lib/fixes/fix_engine.dart` (8 issues)

### 1. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 52)
- **Evidence:** `if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 52):
// Replace insecure HTTP endpoint with HTTPS:
// Before: if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {
// After:  if (f.id == 'SEC-NET-002' && targetLine.contains('https://')) {
```

### 2. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 53)
- **Evidence:** `final updatedLine = targetLine.replaceAll('http://', 'https://');`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 53):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final updatedLine = targetLine.replaceAll('http://', 'https://');
// After:  final updatedLine = targetLine.replaceAll('https://', 'https://');
```

### 3. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 40)
- **Evidence:** `if (!file.existsSync()) continue;`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 4. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 103)
- **Evidence:** `if (origFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 5. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 118)
- **Evidence:** `if (!file.existsSync()) continue;`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 118):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 6. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 131)
- **Evidence:** `if (pubspec.existsSync()) {`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 131):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 7. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 156)
- **Evidence:** `if (backupFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 156):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 8. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 168)
- **Evidence:** `if (backupFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/fixes/fix_engine.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/services/criteria_service.dart` (3 issues)

### 9. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 321)
- **Evidence:** `SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh`
- **Fix Instruction:**
```
// In lib/services/criteria_service.dart (Line 321):
// Replace insecure HTTP endpoint with HTTPS:
// Before: SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
// After:  SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,https:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
```

### 10. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 167)
- **Evidence:** `if (cacheFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/criteria_service.dart (Line 167):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 11. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 287)
- **Evidence:** `buffer.writeln('  - Allow TODO comments: ${codeQuality['allow_todo_comments'] ?? false}');`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `lib/technologies/flutter/security/scanners/network_scanner.dart` (4 issues)

### 12. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 19)
- **Evidence:** `// Pattern to detect http:// connections (excluding localhost)`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 19):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Pattern to detect http:// connections (excluding localhost)
// After:  // Pattern to detect https:// connections (excluding localhost)
```

### 13. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 21)
- **Evidence:** `r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 21):
// Replace insecure HTTP endpoint with HTTPS:
// Before: r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
// After:  r'https://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
```

### 14. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 75)
- **Evidence:** `// Look for http:// cleartext endpoints`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 75):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Look for http:// cleartext endpoints
// After:  // Look for https:// cleartext endpoints
```

### 15. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 92)
- **Evidence:** `recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 92):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',
// After:  recommendation: 'Replace all "https://" endpoints with secure "https://" channels.',
```
---
## 📁 File: `lib/technologies/node/node_analyzer.dart` (5 issues)

### 16. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 107)
- **Evidence:** `final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');`
- **Fix Instruction:**
```
// In lib/technologies/node/node_analyzer.dart (Line 107):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');
// After:  final httpRegex = RegExp(r'https://[a-zA-Z0-9\-\.]+');
```

### 17. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 19)
- **Evidence:** `if (!packageJson.existsSync()) return false;`
- **Fix Instruction:**
```
// In lib/technologies/node/node_analyzer.dart (Line 19):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 18. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 40)
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Fix Instruction:**
```
// In lib/technologies/node/node_analyzer.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 19. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 257)
- **Evidence:** `if (!packageJsonFile.existsSync()) return;`
- **Fix Instruction:**
```
// In lib/technologies/node/node_analyzer.dart (Line 257):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 20. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 299)
- **Evidence:** `if (!packageJsonFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/node/node_analyzer.dart (Line 299):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (5 issues)

### 21. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 501)
- **Evidence:** `<li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 501):
// Replace insecure HTTP endpoint with HTTPS:
// Before: <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>
// After:  <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>https://&lt;your-computer-ip&gt;:8080/api/record</code></li>
```

### 22. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 587)
- **Evidence:** `Timer.periodic(Duration(seconds: 4), (timer) async {`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 587):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(Duration(seconds: 4), (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

### 23. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 614)
- **Evidence:** `timerInterval = setInterval(() => {`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 614):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = timerInterval = setInterval(() => {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

### 24. [CODE_QUALITY - LOW] File Exceeds 500 Lines (815 lines) (Line 1)
- **Evidence:** `Total lines: 815`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```

### 25. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 628)
- **Evidence:** `console.log('Connected to metrics streaming server.');`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 628):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/utils/solution_generator.dart` (2 issues)

### 26. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 55)
- **Evidence:** `final secureUrl = evidence.replaceAll('http://', 'https://');`
- **Fix Instruction:**
```
// In lib/utils/solution_generator.dart (Line 55):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final secureUrl = evidence.replaceAll('http://', 'https://');
// After:  final secureUrl = evidence.replaceAll('https://', 'https://');
```

### 27. [CODE_QUALITY - LOW] File Exceeds 500 Lines (609 lines) (Line 1)
- **Evidence:** `Total lines: 609`
- **Fix Instruction:**
```
// In lib/utils/solution_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
---
## 📁 File: `mcphub_plugin/src/index.ts` (49 issues)

### 28. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 120)
- **Evidence:** `{ id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 120):
// Replace insecure HTTP endpoint with HTTPS:
// Before: { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },
// After:  { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "https:// / usesCleartextTraffic", severity: "HIGH" },
```

### 29. [SECURITY - HIGH] Plaintext HTTP URL Endpoint Detected (Line 441)
- **Evidence:** `recommendation: "Replace unencrypted http:// with secure https:// endpoints.",`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 441):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: "Replace unencrypted http:// with secure https:// endpoints.",
// After:  recommendation: "Replace unencrypted https:// with secure https:// endpoints.",
```

### 30. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 235)
- **Evidence:** `_timer = ${evidence || "Timer.periodic(...)"};`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 235):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = _timer = ${evidence || "Timer.periodic(...)"};;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

### 31. [PERFORMANCE - MEDIUM] ListView(children: [...]) Used Instead of ListView.builder (Line 130)
- **Evidence:** `{ id: "PERF-003", category: "Performance", name: "Eager ListView Constructor", check: "ListView(children: [...]) used instead of ListView.builder()", type: "Static", threshold: "Eager Child Allocation", severity: "MEDIUM" },`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 130):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)
```

### 32. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 400)
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 400):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 33. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 461)
- **Evidence:** `if (!fs.existsSync(manifestPath)) continue;`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 461):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 34. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 464)
- **Evidence:** `const content = fs.readFileSync(manifestPath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 464):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 35. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 518)
- **Evidence:** `if (!fs.existsSync(plistPath)) continue;`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 518):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 36. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 521)
- **Evidence:** `const content = fs.readFileSync(plistPath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 521):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 37. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 552)
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 552):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 38. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 610)
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 610):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 39. [PERFORMANCE - MEDIUM] ListView(children: [...]) Used Instead of ListView.builder (Line 622)
- **Evidence:** `title: "ListView(children: [...]) Used Instead of ListView.builder",`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 622):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)
```

### 40. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 633)
- **Evidence:** `if (/readFileSync|existsSync|writeFileSync|File\([^)]+\)\.readAsBytesSync/g.test(line)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 633):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 41. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 664)
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 664):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 42. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 744)
- **Evidence:** `if (fs.existsSync(pubspecPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 43. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 748)
- **Evidence:** `const content = fs.readFileSync(pubspecPath, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 748):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 44. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 778)
- **Evidence:** `if (fs.existsSync(packageJsonPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 778):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 45. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 784)
- **Evidence:** `const pkg = JSON.parse(fs.readFileSync(packageJsonPath, "utf-8"));`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 784):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 46. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 871)
- **Evidence:** `if (!fs.existsSync(techDir)) fs.mkdirSync(techDir, { recursive: true });`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 871):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 47. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 872)
- **Evidence:** `if (!fs.existsSync(baseReportsDir)) fs.mkdirSync(baseReportsDir, { recursive: true });`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 872):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 48. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 886)
- **Evidence:** `fs.writeFileSync(jsonPathTech, jsonStr, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 886):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 49. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 887)
- **Evidence:** `fs.writeFileSync(jsonPathBase, jsonStr, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 887):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 50. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 893)
- **Evidence:** `fs.writeFileSync(mdPathTech, mdContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 893):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 51. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 894)
- **Evidence:** `fs.writeFileSync(mdPathBase, mdContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 894):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 52. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 900)
- **Evidence:** `fs.writeFileSync(htmlPathTech, htmlContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 900):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 53. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 901)
- **Evidence:** `fs.writeFileSync(htmlPathBase, htmlContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 901):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 54. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 907)
- **Evidence:** `fs.writeFileSync(pdfHtmlPathTech, pdfHtmlContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 907):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 55. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 908)
- **Evidence:** `fs.writeFileSync(pdfHtmlPathBase, pdfHtmlContent, "utf-8");`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 908):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 56. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 1492)
- **Evidence:** `<li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Main Thread I/O:</strong> Synchronous disk operations (readFileSync/Sync)</li>`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 1492):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 57. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2279)
- **Evidence:** `if (!fs.existsSync(dir)) return results;`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 58. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2309)
- **Evidence:** `if (!fs.existsSync(dir)) return [];`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2309):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 59. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2677)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2677):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 60. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2727)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2727):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 61. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2744)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 62. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2757)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2757):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 63. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2770)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2770):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 64. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2783)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2783):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 65. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2796)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2796):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 66. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2809)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2809):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 67. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 2822)
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts (Line 2822):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 68. [CODE_QUALITY - LOW] File Exceeds 500 Lines (2878 lines) (Line 1)
- **Evidence:** `Total lines: 2878`
- **Fix Instruction:**
```
// In mcphub_plugin/src/index.ts:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```

### 69. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 132)
- **Evidence:** `{ id: "CQ-004", category: "Code Quality", name: "Unresolved TODO Comments", check: "Found uncompleted production TODO notes or developer comments", type: "Static", threshold: "TODO Match", severity: "INFO" },`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 70. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 703)
- **Evidence:** `if (/TODO|FIXME/i.test(line)) {`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 71. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 709)
- **Evidence:** `title: "Unresolved TODO / Development Note",`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 72. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 714)
- **Evidence:** `risk: "Unresolved TODOs in production indicate unfinished features or missing validations.",`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 73. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 1818)
- **Evidence:** `const todoFindings = findings.filter(f => f.id === "QAL-002" || /TODO/i.test(f.title));`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 74. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 1870)
- **Evidence:** `const todoRows = todoFindings.length === 0`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 75. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 1871)
- **Evidence:** `? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 76. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 1872)
- **Evidence:** `: todoFindings.map(f => ``
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `lib/technologies/flutter/memory/memory_engine.dart` (2 issues)

### 77. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 76)
- **Evidence:** `if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/memory/memory_engine.dart (Line 76):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

### 78. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 127)
- **Evidence:** `final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/memory/memory_engine.dart (Line 127):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
---
## 📁 File: `lib/tools/runtime_perf_check/client_integration.dart` (1 issue)

### 79. [MEMORY - MEDIUM] Periodic Timer / Interval Declared (Line 122)
- **Evidence:** `Timer.periodic(interval, (timer) async {`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/client_integration.dart (Line 122):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(interval, (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
---
## 📁 File: `templates/shared/common/reusable_component/dialogs/dispute_dialog.dart` (1 issue)

### 80. [MEMORY - HIGH] Controller / Stream Created Without dispose() Method (Line 1)
- **Evidence:** `Missing @override void dispose() or unmount hook`
- **Fix Instruction:**
```
// In templates/shared/common/reusable_component/dialogs/dispute_dialog.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```
---
## 📁 File: `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (5 issues)

### 81. [MEMORY - HIGH] Controller / Stream Created Without dispose() Method (Line 1)
- **Evidence:** `Missing @override void dispose() or unmount hook`
- **Fix Instruction:**
```
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 82. [CODE_QUALITY - LOW] File Exceeds 500 Lines (766 lines) (Line 1)
- **Evidence:** `Total lines: 766`
- **Fix Instruction:**
```
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```

### 83. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 64)
- **Evidence:** `// TODO: implement initState`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 84. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 523)
- **Evidence:** `// TODO remove +/- symbol removed`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 85. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 570)
- **Evidence:** `//TODO: Sprint 2`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `lib/rag/retriever.dart` (1 issue)

### 86. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 30)
- **Evidence:** `if (knowledgeDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/rag/retriever.dart (Line 30):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/services/email_service.dart` (19 issues)

### 87. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 18)
- **Evidence:** `if (!File(chromePath).existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 18):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 88. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 28)
- **Evidence:** `return result.exitCode == 0 && File(pdfPath).existsSync();`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 89. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 92)
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 90. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 95)
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 95):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 91. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 98)
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 92. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 113)
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 113):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 93. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 162)
- **Evidence:** `if (smtpTempFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 162):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 94. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 165)
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 165):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 95. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 168)
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 96. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 187)
- **Evidence:** `if (!simulatedDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 187):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 97. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 227)
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 227):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 98. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 230)
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 230):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 99. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 71)
- **Evidence:** `print('⚠️ PDF conversion failed: $e. Reverting to original HTML file.');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 71):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 100. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 111)
- **Evidence:** `print('⚠️ Mailman CLI not available or failed: $e. Falling back to SMTP/Simulation...');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 111):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 101. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 172)
- **Evidence:** `print('✉️ [Email Sent] Successfully sent audit report to $to via SMTP.');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 172):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 102. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 179)
- **Evidence:** `print('❌ [SMTP Error] Failed to send email via SMTP: $e. Falling back to simulation mode...');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 179):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 103. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 235)
- **Evidence:** `print('✉️ [Simulated Email Sent] To: $to, Subject: $subject');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 235):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 104. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 236)
- **Evidence:** `print('   -> Saved simulated email log to: $htmlLogPath');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 236):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 105. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 237)
- **Evidence:** `print('   -> Saved attachment PDF to: $pdfAttachmentPath');`
- **Fix Instruction:**
```
// In lib/services/email_service.dart (Line 237):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/services/flutter_service.dart` (5 issues)

### 106. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 16)
- **Evidence:** `File(envFlutter).existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/flutter_service.dart (Line 16):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 107. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 22)
- **Evidence:** `if (File(path).existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/flutter_service.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 108. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 32)
- **Evidence:** `if (path.isNotEmpty && File(path).existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/flutter_service.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 109. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 51)
- **Evidence:** `if (envRoot != null && envRoot.isNotEmpty && Directory(envRoot).existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/flutter_service.dart (Line 51):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 110. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 105)
- **Evidence:** `stderr.writeln("Executable Exists  : ${File(executable).existsSync()}");`
- **Fix Instruction:**
```
// In lib/services/flutter_service.dart (Line 105):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/services/pubspec_service.dart` (1 issue)

### 111. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 10)
- **Evidence:** `if (!file.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/pubspec_service.dart (Line 10):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/services/yaml_service.dart` (1 issue)

### 112. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 7)
- **Evidence:** `if (!file.existsSync()) {`
- **Fix Instruction:**
```
// In lib/services/yaml_service.dart (Line 7):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/analyzer/project_detector.dart` (20 issues)

### 113. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 63)
- **Evidence:** `if (dir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 63):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 114. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 65)
- **Evidence:** `if (pubspec.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 65):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 115. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 92)
- **Evidence:** `if (!root.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 116. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 97)
- **Evidence:** `'pubspec.yaml': File(p.join(projectPath, 'pubspec.yaml')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 97):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 117. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 98)
- **Evidence:** `'lib': Directory(p.join(projectPath, 'lib')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 118. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 99)
- **Evidence:** `'android': Directory(p.join(projectPath, 'android')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 99):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 119. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 100)
- **Evidence:** `'ios': Directory(p.join(projectPath, 'ios')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 100):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 120. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 101)
- **Evidence:** `'test': Directory(p.join(projectPath, 'test')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 101):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 121. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 102)
- **Evidence:** `'assets': Directory(p.join(projectPath, 'assets')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 102):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 122. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 103)
- **Evidence:** `'analysis_options.yaml': File(p.join(projectPath, 'analysis_options.yaml')).existsSync(),`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 123. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 110)
- **Evidence:** `if (!pubspecFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 110):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 124. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 154)
- **Evidence:** `if (metadataFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 154):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 125. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 175)
- **Evidence:** `if (versionFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 175):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 126. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 189)
- **Evidence:** `if (versionFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 189):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 127. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 265)
- **Evidence:** `if (Directory(p.join(projectPath, 'android')).existsSync()) targetPlatforms.add('android');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 265):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 128. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 266)
- **Evidence:** `if (Directory(p.join(projectPath, 'ios')).existsSync()) targetPlatforms.add('ios');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 266):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 129. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 267)
- **Evidence:** `if (Directory(p.join(projectPath, 'web')).existsSync()) targetPlatforms.add('web');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 267):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 130. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 268)
- **Evidence:** `if (Directory(p.join(projectPath, 'macos')).existsSync()) targetPlatforms.add('macos');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 268):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 131. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 269)
- **Evidence:** `if (Directory(p.join(projectPath, 'windows')).existsSync()) targetPlatforms.add('windows');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 269):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 132. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 270)
- **Evidence:** `if (Directory(p.join(projectPath, 'linux')).existsSync()) targetPlatforms.add('linux');`
- **Fix Instruction:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 270):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/architecture_analysis/architecture_scanner.dart` (1 issue)

### 133. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 32)
- **Evidence:** `if (!libDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/architecture_analysis/architecture_scanner.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/flutter_analyzer.dart` (2 issues)

### 134. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 22)
- **Evidence:** `return pubspec.existsSync();`
- **Fix Instruction:**
```
// In lib/technologies/flutter/flutter_analyzer.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 135. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 28)
- **Evidence:** `if (!dir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/flutter_analyzer.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/security/scanners/android_scanner.dart` (1 issue)

### 136. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 11)
- **Evidence:** `if (!androidDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/android_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (3 issues)

### 137. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 48)
- **Evidence:** `if (!pubspecFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 48):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 138. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 74)
- **Evidence:** `if (lockFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 74):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 139. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 125)
- **Evidence:** `if (!lockFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 125):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/flutter/security/scanners/ios_scanner.dart` (1 issue)

### 140. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 11)
- **Evidence:** `if (!iosDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/flutter/security/scanners/ios_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/laravel/laravel_analyzer.dart` (6 issues)

### 141. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 20)
- **Evidence:** `if (artisan.existsSync()) return true;`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 142. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 24)
- **Evidence:** `if (composerJson.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 24):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 143. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 43)
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 43):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 144. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 212)
- **Evidence:** `if (!composerJsonFile.existsSync()) return;`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 212):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 145. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 251)
- **Evidence:** `if (composerJsonFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 251):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 146. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 279)
- **Evidence:** `if (envFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/python/python_analyzer.dart` (5 issues)

### 147. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 21)
- **Evidence:** `if (reqs.existsSync() || setup.existsSync() || pyproj.existsSync()) return true;`
- **Fix Instruction:**
```
// In lib/technologies/python/python_analyzer.dart (Line 21):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 148. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 25)
- **Evidence:** `if (dir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/python/python_analyzer.dart (Line 25):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 149. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 38)
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Fix Instruction:**
```
// In lib/technologies/python/python_analyzer.dart (Line 38):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 150. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 219)
- **Evidence:** `if (!reqsFile.existsSync()) return;`
- **Fix Instruction:**
```
// In lib/technologies/python/python_analyzer.dart (Line 219):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 151. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 262)
- **Evidence:** `if (reqsFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/python/python_analyzer.dart (Line 262):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/technologies/vue/vue_analyzer.dart` (4 issues)

### 152. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 20)
- **Evidence:** `if (packageJson.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 153. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 36)
- **Evidence:** `if (dir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 36):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 154. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 49)
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Fix Instruction:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 49):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 155. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 238)
- **Evidence:** `if (packageJsonFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 238):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `lib/tools/mcp_server_router.dart` (9 issues)

### 156. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 559)
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 559):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 157. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 1134)
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1134):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 158. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 1221)
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1221):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 159. [CODE_QUALITY - LOW] File Exceeds 500 Lines (1384 lines) (Line 1)
- **Evidence:** `Total lines: 1384`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```

### 160. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 331)
- **Evidence:** `'Checks class sizing, method complexity, TODO comments, and UI-layer separation violations.',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 161. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 1155)
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1155):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 162. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 1157)
- **Evidence:** `print('❌ Background email delivery failed: $err');`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1157):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 163. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 1243)
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1243):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 164. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 1245)
- **Evidence:** `print('❌ Background email delivery failed: $err');`
- **Fix Instruction:**
```
// In lib/tools/mcp_server_router.dart (Line 1245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/tools/runtime_perf_check/perf_server.dart` (7 issues)

### 165. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 195)
- **Evidence:** `if (!reportsDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 195):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 166. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 44)
- **Evidence:** `print('🚀 Runtime Performance Server running at http://localhost:$port');`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 167. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 67)
- **Evidence:** `print('🔌 Dashboard client connected to WebSocket stream.');`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 168. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 123)
- **Evidence:** `final double ram = (data['ram'] as num?)?.toDouble() ?? 0.0;`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 169. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 124)
- **Evidence:** `final double storage = (data['storage'] as num?)?.toDouble() ?? 0.0;`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 170. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 201)
- **Evidence:** `print('💾 Runtime performance HTML report saved to: ${reportFile.path}');`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 201):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 171. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 245)
- **Evidence:** `print('🛑 Runtime Performance Server stopped.');`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/utils/path_utils.dart` (5 issues)

### 172. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 12)
- **Evidence:** `if (Directory(p.join(root, 'templates')).existsSync() || Directory(p.join(root, 'config')).existsSync()) {`
- **Fix Instruction:**
```
// In lib/utils/path_utils.dart (Line 12):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 173. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 22)
- **Evidence:** `if (hostedDir.existsSync()) {`
- **Fix Instruction:**
```
// In lib/utils/path_utils.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 174. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 34)
- **Evidence:** `if (Directory(p.join(latestDir, 'templates')).existsSync() || Directory(p.join(latestDir, 'config')).existsSync()) {`
- **Fix Instruction:**
```
// In lib/utils/path_utils.dart (Line 34):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 175. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 45)
- **Evidence:** `if (Directory(p.join(currentDir, 'templates')).existsSync() || Directory(p.join(currentDir, 'config')).existsSync()) {`
- **Fix Instruction:**
```
// In lib/utils/path_utils.dart (Line 45):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 176. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 86)
- **Evidence:** `if (file.existsSync()) {`
- **Fix Instruction:**
```
// In lib/utils/path_utils.dart (Line 86):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
---
## 📁 File: `scratch/query_mailman.dart` (4 issues)

### 177. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 6)
- **Evidence:** `if (!file.existsSync()) {`
- **Fix Instruction:**
```
// In scratch/query_mailman.dart (Line 6):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 178. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 7)
- **Evidence:** `print('Error: tools_list.json does not exist');`
- **Fix Instruction:**
```
// In scratch/query_mailman.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 179. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 19)
- **Evidence:** `print('=== TOOL: $name ===');`
- **Fix Instruction:**
```
// In scratch/query_mailman.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 180. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 20)
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(tool));`
- **Fix Instruction:**
```
// In scratch/query_mailman.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `scratch/test_mcp_email.dart` (7 issues)

### 181. [PERFORMANCE - MEDIUM] Synchronous File / Disk I/O Operation Detected (Line 39)
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 39):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```

### 182. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 15)
- **Evidence:** `print('Starting simulated MCP Full Flutter Audit with email...');`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 183. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 35)
- **Evidence:** `print('PDF HTML Report generated at: $reportPdfHtmlPath');`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 35):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 184. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 52)
- **Evidence:** `print('Sending report to $recipientEmail via EmailService...');`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 52):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 185. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 62)
- **Evidence:** `print('=== EMAIL DELIVERY RESULT ===');`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 62):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 186. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 63)
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(emailRes));`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 187. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 67)
- **Evidence:** `print('Error: $e\n$stack');`
- **Fix Instruction:**
```
// In scratch/test_mcp_email.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `bin/flutter_architect_mcp.dart` (2 issues)

### 188. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 7)
- **Evidence:** `print('Running test project generation...');`
- **Fix Instruction:**
```
// In bin/flutter_architect_mcp.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 189. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 22)
- **Evidence:** `print("✅ Project generated successfully.");`
- **Fix Instruction:**
```
// In bin/flutter_architect_mcp.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (12 issues)

### 190. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 9)
- **Evidence:** `// Pattern to detect TODO/FIXME comments`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 191. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 10)
- **Evidence:** `static final RegExp _todoPattern = RegExp(`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 192. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 11)
- **Evidence:** `r'//\s*(?:TODO|FIXME)\s*[:\s](.*)',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 193. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 33)
- **Evidence:** `final allowTodo = codeQualityConf is Map ? (codeQualityConf['allow_todo_comments'] ?? false) : false;`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 194. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 77)
- **Evidence:** `// 2. Check for TODO / FIXME comments`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 195. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 78)
- **Evidence:** `if (!allowTodo) {`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 196. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 81)
- **Evidence:** `final match = _todoPattern.firstMatch(lineContent);`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 197. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 83)
- **Evidence:** `final todoText = match.group(1)?.trim() ?? '';`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 198. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 89)
- **Evidence:** `title: 'Pending TODO / FIXME Comment',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 199. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 93)
- **Evidence:** `description: 'Found unresolved developer note in $relativePath at line ${i + 1}: "$todoText"',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 200. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 94)
- **Evidence:** `risk: 'Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 201. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 95)
- **Evidence:** `recommendation: 'Address the TODO item or track it in your team\'s issue management system.',`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `lib/tools/architectures_create/create_project.dart` (13 issues)

### 202. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 7)
- **Evidence:** `print('Usage: dart run lib/tools/architectures_create/create_project.dart [options]');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 203. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 8)
- **Evidence:** `print('Options:');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 204. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 9)
- **Evidence:** `print('  --name <project_name>       Name of the project (required)');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 205. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 10)
- **Evidence:** `print('  --arch <architecture>       Architecture: clean, mvc, mvvm (required)');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 10):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 206. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 11)
- **Evidence:** `print('  --state <state>             State management: bloc, getx, provider, riverpod, rxdart');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 11):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 207. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 12)
- **Evidence:** `print('  --backend <backend>         Backend: firebase, supabase');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 208. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 13)
- **Evidence:** `print('  --db <database>             Database: hive, isar, drift');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 13):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 209. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 14)
- **Evidence:** `print('  --network <network>         Network: dio, retrofit');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 14):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 210. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 15)
- **Evidence:** `print('  --router <router>           Router: go_router, auto_route, own_extensions');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 211. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 16)
- **Evidence:** `print('  --target <dir>              Target directory (default: current directory)');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 212. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 59)
- **Evidence:** `print('❌ Error: Project name is required (--name <project_name>).');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 59):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 213. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 63)
- **Evidence:** `print('❌ Error: Architecture is required (--arch <architecture>).');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 214. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 81)
- **Evidence:** `print('❌ Project generation failed: $e');`
- **Fix Instruction:**
```
// In lib/tools/architectures_create/create_project.dart (Line 81):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/tools/runtime_perf_check/perf_pdf_generator.dart` (2 issues)

### 215. [CODE_QUALITY - LOW] File Exceeds 500 Lines (584 lines) (Line 1)
- **Evidence:** `Total lines: 584`
- **Fix Instruction:**
```
// In lib/tools/runtime_perf_check/perf_pdf_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```

### 216. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 565)
- **Evidence:** `if (params.get('autodownload') === 'true') {`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `lib/tools/scanners_and_audit_reports/run_audit.dart` (16 issues)

### 217. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 12)
- **Evidence:** `print('Auditing project at: $projectPath...');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 218. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 16)
- **Evidence:** `print('-------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 219. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 17)
- **Evidence:** `print('Project Name: ${meta.projectName}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 17):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 220. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 18)
- **Evidence:** `print('Flutter SDK:  ${meta.flutterVersion}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 221. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 19)
- **Evidence:** `print('Dart SDK:     ${meta.dartVersion}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 222. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 20)
- **Evidence:** `print('-------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 223. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 22)
- **Evidence:** `print('Running scanners...');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 224. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 36)
- **Evidence:** `print('-------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 225. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 37)
- **Evidence:** `print('✅ Audit completed successfully!');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 37):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 226. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 38)
- **Evidence:** `print('- Findings detected: ${findings.length}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 38):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 227. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 39)
- **Evidence:** `print('- JSON Report:       ${paths['json']}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 228. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 40)
- **Evidence:** `print('- Markdown Report:   ${paths['markdown']}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 40):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 229. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 41)
- **Evidence:** `print('- HTML Report:       ${paths['html']}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 41):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 230. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 42)
- **Evidence:** `print('- PDF HTML View:     ${paths['pdfHtml']}');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 42):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 231. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 43)
- **Evidence:** `print('-------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 43):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 232. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 45)
- **Evidence:** `print('❌ Error running audit: $e');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 45):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (9 issues)

### 233. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 6)
- **Evidence:** `print('Usage: dart run lib/tools/scanners_and_audit_reports/run_runtime_perf.dart [options]');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 6):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 234. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 7)
- **Evidence:** `print('Options:');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 235. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 8)
- **Evidence:** `print('  --port <port>   Port to run the dashboard server on (default: 8080)');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 236. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 22)
- **Evidence:** `print('----------------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 237. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 23)
- **Evidence:** `print('📊 RUNTIME PERFORMANCE MONITOR STARTED');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 23):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 238. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 24)
- **Evidence:** `print('👉 Open in browser: http://localhost:$port');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 24):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 239. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 25)
- **Evidence:** `print('👉 Feed API Logs to: http://localhost:$port/api/record');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 25):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 240. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 26)
- **Evidence:** `print('Press Ctrl+C to terminate the server.');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 26):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 241. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 27)
- **Evidence:** `print('----------------------------------------------------');`
- **Fix Instruction:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 27):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `scratch/test_draft.dart` (8 issues)

### 242. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 5)
- **Evidence:** `print('Starting mailman process...');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 5):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 243. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 9)
- **Evidence:** `print('SERVER OUT: $line');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 244. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 18)
- **Evidence:** `print('Extracted draftId: $draftId');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 245. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 33)
- **Evidence:** `print('Sending confirm_send request...');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 33):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 246. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 36)
- **Evidence:** `print('=== CONFIRM SEND RESPONSE RECEIVED ===');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 247. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 39)
- **Evidence:** `print('Parse error: $e');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 248. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 44)
- **Evidence:** `print('SERVER ERR: $data');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```

### 249. [CODE_QUALITY - INFO] Debug Print Statement Left in Code (Line 84)
- **Evidence:** `print('Sending draft_email request...');`
- **Fix Instruction:**
```
// In scratch/test_draft.dart (Line 84):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
---
## 📁 File: `templates/shared/common/reusable_component/toast/flushbar.dart` (1 issue)

### 250. [CODE_QUALITY - LOW] File Exceeds 500 Lines (791 lines) (Line 1)
- **Evidence:** `Total lines: 791`
- **Fix Instruction:**
```
// In templates/shared/common/reusable_component/toast/flushbar.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
---
## 📁 File: `templates/shared/common/reusable_component/widgets/common_debit_card.dart` (1 issue)

### 251. [CODE_QUALITY - LOW] File Exceeds 500 Lines (532 lines) (Line 1)
- **Evidence:** `Total lines: 532`
- **Fix Instruction:**
```
// In templates/shared/common/reusable_component/widgets/common_debit_card.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
---
## 📁 File: `templates/shared/common/reusable_component/widgets/keyboard_config.dart` (1 issue)

### 252. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 3)
- **Evidence:** `// TODO in future remove`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart` (1 issue)

### 253. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 8)
- **Evidence:** `// TODO: implement dispose`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `templates/shared/common/reusable_component/widgets/web_view.dart` (1 issue)

### 254. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 23)
- **Evidence:** `// TODO: implement initState`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---
## 📁 File: `templates/shared/utils/helper/notification_sender_helper.dart` (2 issues)

### 255. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 83)
- **Evidence:** `// TODO`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```

### 256. [CODE_QUALITY - INFO] Unresolved TODO / Development Note (Line 266)
- **Evidence:** `// TODO`
- **Fix Instruction:**
```
Address or track the pending task in the issue management system.
```
---

### Fix Rules & Constraints:
1. DO NOT break existing functionality, imports, styles, or public APIs.
2. If packages are required (e.g. `flutter_secure_storage` or `flutter_dotenv`), add them to `pubspec.yaml` / `package.json` appropriately.
3. Ensure no regressions or compilation errors are introduced.
```

## Detailed Findings List

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 52)
- **Confidence:** HIGH
- **Evidence:** `if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/fixes/fix_engine.dart at line 52.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 52):
// Replace insecure HTTP endpoint with HTTPS:
// Before: if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {
// After:  if (f.id == 'SEC-NET-002' && targetLine.contains('https://')) {
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 52)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 52):
// Replace insecure HTTP endpoint with HTTPS:
// Before: if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {
// After:  if (f.id == 'SEC-NET-002' && targetLine.contains('https://')) {

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 53)
- **Confidence:** HIGH
- **Evidence:** `final updatedLine = targetLine.replaceAll('http://', 'https://');`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/fixes/fix_engine.dart at line 53.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 53):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final updatedLine = targetLine.replaceAll('http://', 'https://');
// After:  final updatedLine = targetLine.replaceAll('https://', 'https://');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 53)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `final updatedLine = targetLine.replaceAll('http://', 'https://');`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 53):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final updatedLine = targetLine.replaceAll('http://', 'https://');
// After:  final updatedLine = targetLine.replaceAll('https://', 'https://');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/services/criteria_service.dart` (Line 321)
- **Confidence:** HIGH
- **Evidence:** `SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/services/criteria_service.dart at line 321.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/services/criteria_service.dart (Line 321):
// Replace insecure HTTP endpoint with HTTPS:
// Before: SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
// After:  SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,https:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/criteria_service.dart` (Line 321)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh`

### Required Solution:
// In lib/services/criteria_service.dart (Line 321):
// Replace insecure HTTP endpoint with HTTPS:
// Before: SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,http:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh
// After:  SEC-006,Security,Network,HTTP/Cleartext Traffic,Network security,Non-TLS HTTP endpoint or cleartext platform configuration detected,Static,URL + platform config scan,https:// / cleartext enabled,High,High,Use HTTPS and disable cleartext traffic,URL/config location,Nilesh

Please inspect `lib/services/criteria_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 19)
- **Confidence:** HIGH
- **Evidence:** `// Pattern to detect http:// connections (excluding localhost)`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/technologies/flutter/security/scanners/network_scanner.dart at line 19.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 19):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Pattern to detect http:// connections (excluding localhost)
// After:  // Pattern to detect https:// connections (excluding localhost)
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 19)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `// Pattern to detect http:// connections (excluding localhost)`

### Required Solution:
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 19):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Pattern to detect http:// connections (excluding localhost)
// After:  // Pattern to detect https:// connections (excluding localhost)

Please inspect `lib/technologies/flutter/security/scanners/network_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 21)
- **Confidence:** HIGH
- **Evidence:** `r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/technologies/flutter/security/scanners/network_scanner.dart at line 21.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 21):
// Replace insecure HTTP endpoint with HTTPS:
// Before: r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
// After:  r'https://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 21)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',`

### Required Solution:
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 21):
// Replace insecure HTTP endpoint with HTTPS:
// Before: r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
// After:  r'https://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',

Please inspect `lib/technologies/flutter/security/scanners/network_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 75)
- **Confidence:** HIGH
- **Evidence:** `// Look for http:// cleartext endpoints`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/technologies/flutter/security/scanners/network_scanner.dart at line 75.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 75):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Look for http:// cleartext endpoints
// After:  // Look for https:// cleartext endpoints
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 75)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `// Look for http:// cleartext endpoints`

### Required Solution:
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 75):
// Replace insecure HTTP endpoint with HTTPS:
// Before: // Look for http:// cleartext endpoints
// After:  // Look for https:// cleartext endpoints

Please inspect `lib/technologies/flutter/security/scanners/network_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 92)
- **Confidence:** HIGH
- **Evidence:** `recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/technologies/flutter/security/scanners/network_scanner.dart at line 92.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 92):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',
// After:  recommendation: 'Replace all "https://" endpoints with secure "https://" channels.',
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/network_scanner.dart` (Line 92)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',`

### Required Solution:
// In lib/technologies/flutter/security/scanners/network_scanner.dart (Line 92):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',
// After:  recommendation: 'Replace all "https://" endpoints with secure "https://" channels.',

Please inspect `lib/technologies/flutter/security/scanners/network_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/technologies/node/node_analyzer.dart` (Line 107)
- **Confidence:** HIGH
- **Evidence:** `final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/technologies/node/node_analyzer.dart at line 107.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/technologies/node/node_analyzer.dart (Line 107):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');
// After:  final httpRegex = RegExp(r'https://[a-zA-Z0-9\-\.]+');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/node/node_analyzer.dart` (Line 107)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');`

### Required Solution:
// In lib/technologies/node/node_analyzer.dart (Line 107):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');
// After:  final httpRegex = RegExp(r'https://[a-zA-Z0-9\-\.]+');

Please inspect `lib/technologies/node/node_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 501)
- **Confidence:** HIGH
- **Evidence:** `<li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/tools/runtime_perf_check/perf_dashboard_html.dart at line 501.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 501):
// Replace insecure HTTP endpoint with HTTPS:
// Before: <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>
// After:  <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>https://&lt;your-computer-ip&gt;:8080/api/record</code></li>
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 501)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `<li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 501):
// Replace insecure HTTP endpoint with HTTPS:
// Before: <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>
// After:  <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>https://&lt;your-computer-ip&gt;:8080/api/record</code></li>

Please inspect `lib/tools/runtime_perf_check/perf_dashboard_html.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `lib/utils/solution_generator.dart` (Line 55)
- **Confidence:** HIGH
- **Evidence:** `final secureUrl = evidence.replaceAll('http://', 'https://');`
- **Description:** Unencrypted HTTP URL endpoint detected in lib/utils/solution_generator.dart at line 55.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In lib/utils/solution_generator.dart (Line 55):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final secureUrl = evidence.replaceAll('http://', 'https://');
// After:  final secureUrl = evidence.replaceAll('https://', 'https://');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/solution_generator.dart` (Line 55)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `final secureUrl = evidence.replaceAll('http://', 'https://');`

### Required Solution:
// In lib/utils/solution_generator.dart (Line 55):
// Replace insecure HTTP endpoint with HTTPS:
// Before: final secureUrl = evidence.replaceAll('http://', 'https://');
// After:  final secureUrl = evidence.replaceAll('https://', 'https://');

Please inspect `lib/utils/solution_generator.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 120)
- **Confidence:** HIGH
- **Evidence:** `{ id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },`
- **Description:** Unencrypted HTTP URL endpoint detected in mcphub_plugin/src/index.ts at line 120.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 120):
// Replace insecure HTTP endpoint with HTTPS:
// Before: { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },
// After:  { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "https:// / usesCleartextTraffic", severity: "HIGH" },
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 120)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `{ id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 120):
// Replace insecure HTTP endpoint with HTTPS:
// Before: { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },
// After:  { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "https:// / usesCleartextTraffic", severity: "HIGH" },

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [SECURITY] [HIGH] Plaintext HTTP URL Endpoint Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 441)
- **Confidence:** HIGH
- **Evidence:** `recommendation: "Replace unencrypted http:// with secure https:// endpoints.",`
- **Description:** Unencrypted HTTP URL endpoint detected in mcphub_plugin/src/index.ts at line 441.
- **Risk:** Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).
- **Recommendation:** Replace unencrypted http:// with secure https:// endpoints.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 441):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: "Replace unencrypted http:// with secure https:// endpoints.",
// After:  recommendation: "Replace unencrypted https:// with secure https:// endpoints.",
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 441)
- **Category:** SECURITY | **Severity:** HIGH
- **Issue:** Plaintext HTTP URL Endpoint Detected
- **Evidence:** `recommendation: "Replace unencrypted http:// with secure https:// endpoints.",`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 441):
// Replace insecure HTTP endpoint with HTTPS:
// Before: recommendation: "Replace unencrypted http:// with secure https:// endpoints.",
// After:  recommendation: "Replace unencrypted https:// with secure https:// endpoints.",

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** Yes
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `lib/technologies/flutter/memory/memory_engine.dart` (Line 76)
- **Confidence:** MEDIUM
- **Evidence:** `if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {`
- **Description:** Periodic timer declared in lib/technologies/flutter/memory/memory_engine.dart at line 76.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/memory/memory_engine.dart (Line 76):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/memory/memory_engine.dart` (Line 76)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {`

### Required Solution:
// In lib/technologies/flutter/memory/memory_engine.dart (Line 76):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `lib/technologies/flutter/memory/memory_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `lib/technologies/flutter/memory/memory_engine.dart` (Line 127)
- **Confidence:** MEDIUM
- **Evidence:** `final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');`
- **Description:** Periodic timer declared in lib/technologies/flutter/memory/memory_engine.dart at line 127.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/memory/memory_engine.dart (Line 127):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/memory/memory_engine.dart` (Line 127)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');`

### Required Solution:
// In lib/technologies/flutter/memory/memory_engine.dart (Line 127):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `lib/technologies/flutter/memory/memory_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `lib/tools/runtime_perf_check/client_integration.dart` (Line 122)
- **Confidence:** MEDIUM
- **Evidence:** `Timer.periodic(interval, (timer) async {`
- **Description:** Periodic timer declared in lib/tools/runtime_perf_check/client_integration.dart at line 122.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/client_integration.dart (Line 122):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(interval, (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/client_integration.dart` (Line 122)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `Timer.periodic(interval, (timer) async {`

### Required Solution:
// In lib/tools/runtime_perf_check/client_integration.dart (Line 122):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(interval, (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `lib/tools/runtime_perf_check/client_integration.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 587)
- **Confidence:** MEDIUM
- **Evidence:** `Timer.periodic(Duration(seconds: 4), (timer) async {`
- **Description:** Periodic timer declared in lib/tools/runtime_perf_check/perf_dashboard_html.dart at line 587.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 587):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(Duration(seconds: 4), (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 587)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `Timer.periodic(Duration(seconds: 4), (timer) async {`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 587):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = Timer.periodic(Duration(seconds: 4), (timer) async {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `lib/tools/runtime_perf_check/perf_dashboard_html.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 614)
- **Confidence:** MEDIUM
- **Evidence:** `timerInterval = setInterval(() => {`
- **Description:** Periodic timer declared in lib/tools/runtime_perf_check/perf_dashboard_html.dart at line 614.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 614):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = timerInterval = setInterval(() => {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 614)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `timerInterval = setInterval(() => {`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 614):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = timerInterval = setInterval(() => {;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `lib/tools/runtime_perf_check/perf_dashboard_html.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [MEDIUM] Periodic Timer / Interval Declared
- **File:** `mcphub_plugin/src/index.ts` (Line 235)
- **Confidence:** MEDIUM
- **Evidence:** `_timer = ${evidence || "Timer.periodic(...)"};`
- **Description:** Periodic timer declared in mcphub_plugin/src/index.ts at line 235.
- **Risk:** Active timers that are not cancelled continue executing in background, draining battery and leaking memory.
- **Recommendation:** Store the Timer instance and call timer.cancel() inside dispose() or unmount.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 235):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = _timer = ${evidence || "Timer.periodic(...)"};;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 235)
- **Category:** MEMORY | **Severity:** MEDIUM
- **Issue:** Periodic Timer / Interval Declared
- **Evidence:** `_timer = ${evidence || "Timer.periodic(...)"};`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 235):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = _timer = ${evidence || "Timer.periodic(...)"};;

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [HIGH] Controller / Stream Created Without dispose() Method
- **File:** `templates/shared/common/reusable_component/dialogs/dispute_dialog.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Missing @override void dispose() or unmount hook`
- **Description:** Stateful resource or controller declared in templates/shared/common/reusable_component/dialogs/dispute_dialog.dart but no dispose lifecycle method was found.
- **Risk:** Leaked controllers retain listeners and memory allocations indefinitely, leading to app lag and OOM crashes.
- **Recommendation:** Implement dispose() and invoke .dispose() or .close() on all controllers and streams.
- **Tailored Code Solution:**
```
// In templates/shared/common/reusable_component/dialogs/dispute_dialog.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/dialogs/dispute_dialog.dart` (Line 1)
- **Category:** MEMORY | **Severity:** HIGH
- **Issue:** Controller / Stream Created Without dispose() Method
- **Evidence:** `Missing @override void dispose() or unmount hook`

### Required Solution:
// In templates/shared/common/reusable_component/dialogs/dispute_dialog.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

Please inspect `templates/shared/common/reusable_component/dialogs/dispute_dialog.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [MEMORY] [HIGH] Controller / Stream Created Without dispose() Method
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Missing @override void dispose() or unmount hook`
- **Description:** Stateful resource or controller declared in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart but no dispose lifecycle method was found.
- **Risk:** Leaked controllers retain listeners and memory allocations indefinitely, leading to app lag and OOM crashes.
- **Recommendation:** Implement dispose() and invoke .dispose() or .close() on all controllers and streams.
- **Tailored Code Solution:**
```
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 1)
- **Category:** MEMORY | **Severity:** HIGH
- **Issue:** Controller / Stream Created Without dispose() Method
- **Evidence:** `Missing @override void dispose() or unmount hook`

### Required Solution:
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart (Line 1):
// 1. Declare controller as late final state field:
late final TextEditingController _controller;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 40)
- **Confidence:** HIGH
- **Evidence:** `if (!file.existsSync()) continue;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 40)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!file.existsSync()) continue;`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 103)
- **Confidence:** HIGH
- **Evidence:** `if (origFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 103)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (origFile.existsSync()) {`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 118)
- **Confidence:** HIGH
- **Evidence:** `if (!file.existsSync()) continue;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 118):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 118)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!file.existsSync()) continue;`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 118):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 131)
- **Confidence:** HIGH
- **Evidence:** `if (pubspec.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 131):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 131)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pubspec.existsSync()) {`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 131):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 156)
- **Confidence:** HIGH
- **Evidence:** `if (backupFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 156):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 156)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (backupFile.existsSync()) {`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 156):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/fixes/fix_engine.dart` (Line 168)
- **Confidence:** HIGH
- **Evidence:** `if (backupFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/fixes/fix_engine.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/fixes/fix_engine.dart` (Line 168)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (backupFile.existsSync()) {`

### Required Solution:
// In lib/fixes/fix_engine.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/fixes/fix_engine.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/rag/retriever.dart` (Line 30)
- **Confidence:** HIGH
- **Evidence:** `if (knowledgeDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/rag/retriever.dart (Line 30):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/rag/retriever.dart` (Line 30)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (knowledgeDir.existsSync()) {`

### Required Solution:
// In lib/rag/retriever.dart (Line 30):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/rag/retriever.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/criteria_service.dart` (Line 167)
- **Confidence:** HIGH
- **Evidence:** `if (cacheFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/criteria_service.dart (Line 167):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/criteria_service.dart` (Line 167)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (cacheFile.existsSync()) {`

### Required Solution:
// In lib/services/criteria_service.dart (Line 167):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/criteria_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 18)
- **Confidence:** HIGH
- **Evidence:** `if (!File(chromePath).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 18):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 18)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!File(chromePath).existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 18):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 28)
- **Confidence:** HIGH
- **Evidence:** `return result.exitCode == 0 && File(pdfPath).existsSync();`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 28)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `return result.exitCode == 0 && File(pdfPath).existsSync();`

### Required Solution:
// In lib/services/email_service.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 92)
- **Confidence:** HIGH
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 92)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 95)
- **Confidence:** HIGH
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 95):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 95)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 95):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 98)
- **Confidence:** HIGH
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 98)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 113)
- **Confidence:** HIGH
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 113):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 113)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempAttachmentFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 113):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 162)
- **Confidence:** HIGH
- **Evidence:** `if (smtpTempFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 162):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 162)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (smtpTempFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 162):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 165)
- **Confidence:** HIGH
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 165):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 165)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 165):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 168)
- **Confidence:** HIGH
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 168)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 168):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 187)
- **Confidence:** HIGH
- **Evidence:** `if (!simulatedDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 187):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 187)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!simulatedDir.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 187):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 227)
- **Confidence:** HIGH
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 227):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 227)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempHtmlFile != null && tempHtmlFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 227):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/email_service.dart` (Line 230)
- **Confidence:** HIGH
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 230):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 230)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (tempPdfFile != null && tempPdfFile.existsSync()) {`

### Required Solution:
// In lib/services/email_service.dart (Line 230):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/flutter_service.dart` (Line 16)
- **Confidence:** HIGH
- **Evidence:** `File(envFlutter).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/flutter_service.dart (Line 16):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/flutter_service.dart` (Line 16)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `File(envFlutter).existsSync()) {`

### Required Solution:
// In lib/services/flutter_service.dart (Line 16):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/flutter_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/flutter_service.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `if (File(path).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/flutter_service.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/flutter_service.dart` (Line 22)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (File(path).existsSync()) {`

### Required Solution:
// In lib/services/flutter_service.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/flutter_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/flutter_service.dart` (Line 32)
- **Confidence:** HIGH
- **Evidence:** `if (path.isNotEmpty && File(path).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/flutter_service.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/flutter_service.dart` (Line 32)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (path.isNotEmpty && File(path).existsSync()) {`

### Required Solution:
// In lib/services/flutter_service.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/flutter_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/flutter_service.dart` (Line 51)
- **Confidence:** HIGH
- **Evidence:** `if (envRoot != null && envRoot.isNotEmpty && Directory(envRoot).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/flutter_service.dart (Line 51):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/flutter_service.dart` (Line 51)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (envRoot != null && envRoot.isNotEmpty && Directory(envRoot).existsSync()) {`

### Required Solution:
// In lib/services/flutter_service.dart (Line 51):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/flutter_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/flutter_service.dart` (Line 105)
- **Confidence:** HIGH
- **Evidence:** `stderr.writeln("Executable Exists  : ${File(executable).existsSync()}");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/flutter_service.dart (Line 105):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/flutter_service.dart` (Line 105)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `stderr.writeln("Executable Exists  : ${File(executable).existsSync()}");`

### Required Solution:
// In lib/services/flutter_service.dart (Line 105):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/flutter_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/pubspec_service.dart` (Line 10)
- **Confidence:** HIGH
- **Evidence:** `if (!file.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/pubspec_service.dart (Line 10):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/pubspec_service.dart` (Line 10)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!file.existsSync()) {`

### Required Solution:
// In lib/services/pubspec_service.dart (Line 10):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/pubspec_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/services/yaml_service.dart` (Line 7)
- **Confidence:** HIGH
- **Evidence:** `if (!file.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/services/yaml_service.dart (Line 7):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/yaml_service.dart` (Line 7)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!file.existsSync()) {`

### Required Solution:
// In lib/services/yaml_service.dart (Line 7):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/services/yaml_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 63)
- **Confidence:** HIGH
- **Evidence:** `if (dir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 63):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 63)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (dir.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 63):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 65)
- **Confidence:** HIGH
- **Evidence:** `if (pubspec.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 65):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 65)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pubspec.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 65):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 92)
- **Confidence:** HIGH
- **Evidence:** `if (!root.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 92)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!root.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 92):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 97)
- **Confidence:** HIGH
- **Evidence:** `'pubspec.yaml': File(p.join(projectPath, 'pubspec.yaml')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 97):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 97)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'pubspec.yaml': File(p.join(projectPath, 'pubspec.yaml')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 97):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 98)
- **Confidence:** HIGH
- **Evidence:** `'lib': Directory(p.join(projectPath, 'lib')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 98)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'lib': Directory(p.join(projectPath, 'lib')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 98):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 99)
- **Confidence:** HIGH
- **Evidence:** `'android': Directory(p.join(projectPath, 'android')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 99):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 99)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'android': Directory(p.join(projectPath, 'android')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 99):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 100)
- **Confidence:** HIGH
- **Evidence:** `'ios': Directory(p.join(projectPath, 'ios')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 100):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 100)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'ios': Directory(p.join(projectPath, 'ios')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 100):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 101)
- **Confidence:** HIGH
- **Evidence:** `'test': Directory(p.join(projectPath, 'test')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 101):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 101)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'test': Directory(p.join(projectPath, 'test')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 101):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 102)
- **Confidence:** HIGH
- **Evidence:** `'assets': Directory(p.join(projectPath, 'assets')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 102):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 102)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'assets': Directory(p.join(projectPath, 'assets')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 102):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 103)
- **Confidence:** HIGH
- **Evidence:** `'analysis_options.yaml': File(p.join(projectPath, 'analysis_options.yaml')).existsSync(),`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 103)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `'analysis_options.yaml': File(p.join(projectPath, 'analysis_options.yaml')).existsSync(),`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 103):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 110)
- **Confidence:** HIGH
- **Evidence:** `if (!pubspecFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 110):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 110)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!pubspecFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 110):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 154)
- **Confidence:** HIGH
- **Evidence:** `if (metadataFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 154):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 154)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (metadataFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 154):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 175)
- **Confidence:** HIGH
- **Evidence:** `if (versionFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 175):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 175)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (versionFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 175):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 189)
- **Confidence:** HIGH
- **Evidence:** `if (versionFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 189):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 189)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (versionFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 189):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 265)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'android')).existsSync()) targetPlatforms.add('android');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 265):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 265)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'android')).existsSync()) targetPlatforms.add('android');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 265):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 266)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'ios')).existsSync()) targetPlatforms.add('ios');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 266):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 266)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'ios')).existsSync()) targetPlatforms.add('ios');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 266):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 267)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'web')).existsSync()) targetPlatforms.add('web');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 267):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 267)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'web')).existsSync()) targetPlatforms.add('web');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 267):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 268)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'macos')).existsSync()) targetPlatforms.add('macos');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 268):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 268)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'macos')).existsSync()) targetPlatforms.add('macos');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 268):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 269)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'windows')).existsSync()) targetPlatforms.add('windows');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 269):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 269)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'windows')).existsSync()) targetPlatforms.add('windows');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 269):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 270)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(projectPath, 'linux')).existsSync()) targetPlatforms.add('linux');`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 270):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/analyzer/project_detector.dart` (Line 270)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(projectPath, 'linux')).existsSync()) targetPlatforms.add('linux');`

### Required Solution:
// In lib/technologies/flutter/analyzer/project_detector.dart (Line 270):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/analyzer/project_detector.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/architecture_analysis/architecture_scanner.dart` (Line 32)
- **Confidence:** HIGH
- **Evidence:** `if (!libDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/architecture_analysis/architecture_scanner.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/architecture_analysis/architecture_scanner.dart` (Line 32)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!libDir.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/architecture_analysis/architecture_scanner.dart (Line 32):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/architecture_analysis/architecture_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/flutter_analyzer.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `return pubspec.existsSync();`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/flutter_analyzer.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/flutter_analyzer.dart` (Line 22)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `return pubspec.existsSync();`

### Required Solution:
// In lib/technologies/flutter/flutter_analyzer.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/flutter_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/flutter_analyzer.dart` (Line 28)
- **Confidence:** HIGH
- **Evidence:** `if (!dir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/flutter_analyzer.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/flutter_analyzer.dart` (Line 28)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!dir.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/flutter_analyzer.dart (Line 28):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/flutter_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/security/scanners/android_scanner.dart` (Line 11)
- **Confidence:** HIGH
- **Evidence:** `if (!androidDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/android_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/android_scanner.dart` (Line 11)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!androidDir.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/security/scanners/android_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/security/scanners/android_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 48)
- **Confidence:** HIGH
- **Evidence:** `if (!pubspecFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 48):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 48)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!pubspecFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 48):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/security/scanners/dependency_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 74)
- **Confidence:** HIGH
- **Evidence:** `if (lockFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 74):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 74)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (lockFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 74):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/security/scanners/dependency_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 125)
- **Confidence:** HIGH
- **Evidence:** `if (!lockFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 125):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/dependency_scanner.dart` (Line 125)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!lockFile.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/security/scanners/dependency_scanner.dart (Line 125):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/security/scanners/dependency_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/flutter/security/scanners/ios_scanner.dart` (Line 11)
- **Confidence:** HIGH
- **Evidence:** `if (!iosDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/flutter/security/scanners/ios_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/security/scanners/ios_scanner.dart` (Line 11)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!iosDir.existsSync()) {`

### Required Solution:
// In lib/technologies/flutter/security/scanners/ios_scanner.dart (Line 11):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/flutter/security/scanners/ios_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 20)
- **Confidence:** HIGH
- **Evidence:** `if (artisan.existsSync()) return true;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 20)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (artisan.existsSync()) return true;`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 24)
- **Confidence:** HIGH
- **Evidence:** `if (composerJson.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 24):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 24)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (composerJson.existsSync()) {`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 24):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 43)
- **Confidence:** HIGH
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 43):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 43)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!dir.existsSync()) return findings;`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 43):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 212)
- **Confidence:** HIGH
- **Evidence:** `if (!composerJsonFile.existsSync()) return;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 212):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 212)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!composerJsonFile.existsSync()) return;`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 212):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 251)
- **Confidence:** HIGH
- **Evidence:** `if (composerJsonFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 251):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 251)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (composerJsonFile.existsSync()) {`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 251):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 279)
- **Confidence:** HIGH
- **Evidence:** `if (envFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/laravel/laravel_analyzer.dart (Line 279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/laravel/laravel_analyzer.dart` (Line 279)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (envFile.existsSync()) {`

### Required Solution:
// In lib/technologies/laravel/laravel_analyzer.dart (Line 279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/laravel/laravel_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/node/node_analyzer.dart` (Line 19)
- **Confidence:** HIGH
- **Evidence:** `if (!packageJson.existsSync()) return false;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/node/node_analyzer.dart (Line 19):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/node/node_analyzer.dart` (Line 19)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!packageJson.existsSync()) return false;`

### Required Solution:
// In lib/technologies/node/node_analyzer.dart (Line 19):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/node/node_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/node/node_analyzer.dart` (Line 40)
- **Confidence:** HIGH
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/node/node_analyzer.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/node/node_analyzer.dart` (Line 40)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!dir.existsSync()) return findings;`

### Required Solution:
// In lib/technologies/node/node_analyzer.dart (Line 40):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/node/node_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/node/node_analyzer.dart` (Line 257)
- **Confidence:** HIGH
- **Evidence:** `if (!packageJsonFile.existsSync()) return;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/node/node_analyzer.dart (Line 257):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/node/node_analyzer.dart` (Line 257)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!packageJsonFile.existsSync()) return;`

### Required Solution:
// In lib/technologies/node/node_analyzer.dart (Line 257):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/node/node_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/node/node_analyzer.dart` (Line 299)
- **Confidence:** HIGH
- **Evidence:** `if (!packageJsonFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/node/node_analyzer.dart (Line 299):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/node/node_analyzer.dart` (Line 299)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!packageJsonFile.existsSync()) {`

### Required Solution:
// In lib/technologies/node/node_analyzer.dart (Line 299):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/node/node_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/python/python_analyzer.dart` (Line 21)
- **Confidence:** HIGH
- **Evidence:** `if (reqs.existsSync() || setup.existsSync() || pyproj.existsSync()) return true;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/python/python_analyzer.dart (Line 21):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/python/python_analyzer.dart` (Line 21)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (reqs.existsSync() || setup.existsSync() || pyproj.existsSync()) return true;`

### Required Solution:
// In lib/technologies/python/python_analyzer.dart (Line 21):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/python/python_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/python/python_analyzer.dart` (Line 25)
- **Confidence:** HIGH
- **Evidence:** `if (dir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/python/python_analyzer.dart (Line 25):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/python/python_analyzer.dart` (Line 25)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (dir.existsSync()) {`

### Required Solution:
// In lib/technologies/python/python_analyzer.dart (Line 25):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/python/python_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/python/python_analyzer.dart` (Line 38)
- **Confidence:** HIGH
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/python/python_analyzer.dart (Line 38):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/python/python_analyzer.dart` (Line 38)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!dir.existsSync()) return findings;`

### Required Solution:
// In lib/technologies/python/python_analyzer.dart (Line 38):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/python/python_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/python/python_analyzer.dart` (Line 219)
- **Confidence:** HIGH
- **Evidence:** `if (!reqsFile.existsSync()) return;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/python/python_analyzer.dart (Line 219):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/python/python_analyzer.dart` (Line 219)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!reqsFile.existsSync()) return;`

### Required Solution:
// In lib/technologies/python/python_analyzer.dart (Line 219):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/python/python_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/python/python_analyzer.dart` (Line 262)
- **Confidence:** HIGH
- **Evidence:** `if (reqsFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/python/python_analyzer.dart (Line 262):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/python/python_analyzer.dart` (Line 262)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (reqsFile.existsSync()) {`

### Required Solution:
// In lib/technologies/python/python_analyzer.dart (Line 262):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/python/python_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 20)
- **Confidence:** HIGH
- **Evidence:** `if (packageJson.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 20)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (packageJson.existsSync()) {`

### Required Solution:
// In lib/technologies/vue/vue_analyzer.dart (Line 20):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/vue/vue_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 36)
- **Confidence:** HIGH
- **Evidence:** `if (dir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 36):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 36)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (dir.existsSync()) {`

### Required Solution:
// In lib/technologies/vue/vue_analyzer.dart (Line 36):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/vue/vue_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 49)
- **Confidence:** HIGH
- **Evidence:** `if (!dir.existsSync()) return findings;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 49):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 49)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!dir.existsSync()) return findings;`

### Required Solution:
// In lib/technologies/vue/vue_analyzer.dart (Line 49):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/vue/vue_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 238)
- **Confidence:** HIGH
- **Evidence:** `if (packageJsonFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/technologies/vue/vue_analyzer.dart (Line 238):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/vue/vue_analyzer.dart` (Line 238)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (packageJsonFile.existsSync()) {`

### Required Solution:
// In lib/technologies/vue/vue_analyzer.dart (Line 238):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/technologies/vue/vue_analyzer.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/tools/mcp_server_router.dart` (Line 559)
- **Confidence:** HIGH
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 559):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 559)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 559):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/tools/mcp_server_router.dart` (Line 1134)
- **Confidence:** HIGH
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1134):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1134)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1134):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/tools/mcp_server_router.dart` (Line 1221)
- **Confidence:** HIGH
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1221):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1221)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1221):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 195)
- **Confidence:** HIGH
- **Evidence:** `if (!reportsDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 195):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 195)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!reportsDir.existsSync()) {`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_server.dart (Line 195):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/utils/path_utils.dart` (Line 12)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(root, 'templates')).existsSync() || Directory(p.join(root, 'config')).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/utils/path_utils.dart (Line 12):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/path_utils.dart` (Line 12)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(root, 'templates')).existsSync() || Directory(p.join(root, 'config')).existsSync()) {`

### Required Solution:
// In lib/utils/path_utils.dart (Line 12):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/utils/path_utils.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/utils/path_utils.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `if (hostedDir.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/utils/path_utils.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/path_utils.dart` (Line 22)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (hostedDir.existsSync()) {`

### Required Solution:
// In lib/utils/path_utils.dart (Line 22):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/utils/path_utils.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/utils/path_utils.dart` (Line 34)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(latestDir, 'templates')).existsSync() || Directory(p.join(latestDir, 'config')).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/utils/path_utils.dart (Line 34):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/path_utils.dart` (Line 34)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(latestDir, 'templates')).existsSync() || Directory(p.join(latestDir, 'config')).existsSync()) {`

### Required Solution:
// In lib/utils/path_utils.dart (Line 34):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/utils/path_utils.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/utils/path_utils.dart` (Line 45)
- **Confidence:** HIGH
- **Evidence:** `if (Directory(p.join(currentDir, 'templates')).existsSync() || Directory(p.join(currentDir, 'config')).existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/utils/path_utils.dart (Line 45):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/path_utils.dart` (Line 45)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (Directory(p.join(currentDir, 'templates')).existsSync() || Directory(p.join(currentDir, 'config')).existsSync()) {`

### Required Solution:
// In lib/utils/path_utils.dart (Line 45):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/utils/path_utils.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `lib/utils/path_utils.dart` (Line 86)
- **Confidence:** HIGH
- **Evidence:** `if (file.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In lib/utils/path_utils.dart (Line 86):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/path_utils.dart` (Line 86)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (file.existsSync()) {`

### Required Solution:
// In lib/utils/path_utils.dart (Line 86):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `lib/utils/path_utils.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] ListView(children: [...]) Used Instead of ListView.builder
- **File:** `mcphub_plugin/src/index.ts` (Line 130)
- **Confidence:** HIGH
- **Evidence:** `{ id: "PERF-003", category: "Performance", name: "Eager ListView Constructor", check: "ListView(children: [...]) used instead of ListView.builder()", type: "Static", threshold: "Eager Child Allocation", severity: "MEDIUM" },`
- **Description:** Using standard ListView constructor eagerly constructs all children at once.
- **Risk:** Causes rendering jank, frame drops, and high memory consumption for lists with dynamic or large element counts.
- **Recommendation:** Switch to ListView.builder() to lazily instantiate only visible on-screen items.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 130):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 130)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** ListView(children: [...]) Used Instead of ListView.builder
- **Evidence:** `{ id: "PERF-003", category: "Performance", name: "Eager ListView Constructor", check: "ListView(children: [...]) used instead of ListView.builder()", type: "Static", threshold: "Eager Child Allocation", severity: "MEDIUM" },`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 130):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 400)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 400):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 400)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 400):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 461)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(manifestPath)) continue;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 461):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 461)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(manifestPath)) continue;`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 461):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 464)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(manifestPath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 464):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 464)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(manifestPath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 464):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 518)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(plistPath)) continue;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 518):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 518)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(plistPath)) continue;`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 518):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 521)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(plistPath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 521):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 521)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(plistPath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 521):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 552)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 552):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 552)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 552):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 610)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 610):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 610)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 610):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] ListView(children: [...]) Used Instead of ListView.builder
- **File:** `mcphub_plugin/src/index.ts` (Line 622)
- **Confidence:** HIGH
- **Evidence:** `title: "ListView(children: [...]) Used Instead of ListView.builder",`
- **Description:** Using standard ListView constructor eagerly constructs all children at once.
- **Risk:** Causes rendering jank, frame drops, and high memory consumption for lists with dynamic or large element counts.
- **Recommendation:** Switch to ListView.builder() to lazily instantiate only visible on-screen items.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 622):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 622)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** ListView(children: [...]) Used Instead of ListView.builder
- **Evidence:** `title: "ListView(children: [...]) Used Instead of ListView.builder",`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 622):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 633)
- **Confidence:** HIGH
- **Evidence:** `if (/readFileSync|existsSync|writeFileSync|File\([^)]+\)\.readAsBytesSync/g.test(line)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 633):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 633)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (/readFileSync|existsSync|writeFileSync|File\([^)]+\)\.readAsBytesSync/g.test(line)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 633):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 664)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 664):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 664)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(filePath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 664):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 744)
- **Confidence:** HIGH
- **Evidence:** `if (fs.existsSync(pubspecPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 744)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (fs.existsSync(pubspecPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 748)
- **Confidence:** HIGH
- **Evidence:** `const content = fs.readFileSync(pubspecPath, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 748):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 748)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const content = fs.readFileSync(pubspecPath, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 748):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 778)
- **Confidence:** HIGH
- **Evidence:** `if (fs.existsSync(packageJsonPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 778):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 778)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (fs.existsSync(packageJsonPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 778):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 784)
- **Confidence:** HIGH
- **Evidence:** `const pkg = JSON.parse(fs.readFileSync(packageJsonPath, "utf-8"));`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 784):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 784)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `const pkg = JSON.parse(fs.readFileSync(packageJsonPath, "utf-8"));`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 784):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 871)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(techDir)) fs.mkdirSync(techDir, { recursive: true });`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 871):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 871)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(techDir)) fs.mkdirSync(techDir, { recursive: true });`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 871):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 872)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(baseReportsDir)) fs.mkdirSync(baseReportsDir, { recursive: true });`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 872):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 872)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(baseReportsDir)) fs.mkdirSync(baseReportsDir, { recursive: true });`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 872):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 886)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(jsonPathTech, jsonStr, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 886):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 886)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(jsonPathTech, jsonStr, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 886):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 887)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(jsonPathBase, jsonStr, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 887):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 887)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(jsonPathBase, jsonStr, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 887):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 893)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(mdPathTech, mdContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 893):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 893)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(mdPathTech, mdContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 893):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 894)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(mdPathBase, mdContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 894):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 894)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(mdPathBase, mdContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 894):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 900)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(htmlPathTech, htmlContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 900):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 900)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(htmlPathTech, htmlContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 900):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 901)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(htmlPathBase, htmlContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 901):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 901)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(htmlPathBase, htmlContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 901):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 907)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(pdfHtmlPathTech, pdfHtmlContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 907):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 907)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(pdfHtmlPathTech, pdfHtmlContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 907):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 908)
- **Confidence:** HIGH
- **Evidence:** `fs.writeFileSync(pdfHtmlPathBase, pdfHtmlContent, "utf-8");`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 908):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 908)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `fs.writeFileSync(pdfHtmlPathBase, pdfHtmlContent, "utf-8");`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 908):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 1492)
- **Confidence:** HIGH
- **Evidence:** `<li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Main Thread I/O:</strong> Synchronous disk operations (readFileSync/Sync)</li>`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 1492):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1492)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `<li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Main Thread I/O:</strong> Synchronous disk operations (readFileSync/Sync)</li>`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 1492):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2279)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(dir)) return results;`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2279)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(dir)) return results;`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2279):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2309)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(dir)) return [];`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2309):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2309)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(dir)) return [];`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2309):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2677)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2677):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2677)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2677):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2727)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2727):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2727)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2727):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2744)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2744)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2744):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2757)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2757):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2757)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2757):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2770)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2770):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2770)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2770):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2783)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2783):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2783)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2783):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2796)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2796):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2796)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2796):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2809)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2809):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2809)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2809):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `mcphub_plugin/src/index.ts` (Line 2822)
- **Confidence:** HIGH
- **Evidence:** `if (!fs.existsSync(projectPath)) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts (Line 2822):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 2822)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!fs.existsSync(projectPath)) {`

### Required Solution:
// In mcphub_plugin/src/index.ts (Line 2822):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `scratch/query_mailman.dart` (Line 6)
- **Confidence:** HIGH
- **Evidence:** `if (!file.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In scratch/query_mailman.dart (Line 6):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/query_mailman.dart` (Line 6)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (!file.existsSync()) {`

### Required Solution:
// In scratch/query_mailman.dart (Line 6):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `scratch/query_mailman.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Synchronous File / Disk I/O Operation Detected
- **File:** `scratch/test_mcp_email.dart` (Line 39)
- **Confidence:** HIGH
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`
- **Description:** Synchronous file system call executed in application thread.
- **Risk:** Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.
- **Recommendation:** Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 39):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 39)
- **Category:** PERFORMANCE | **Severity:** MEDIUM
- **Issue:** Synchronous File / Disk I/O Operation Detected
- **Evidence:** `if (pdfHtmlFile.existsSync()) {`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 39):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `bin/flutter_architect_mcp.dart` (Line 7)
- **Confidence:** HIGH
- **Evidence:** `print('Running test project generation...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in bin/flutter_architect_mcp.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In bin/flutter_architect_mcp.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `bin/flutter_architect_mcp.dart` (Line 7)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Running test project generation...');`

### Required Solution:
// In bin/flutter_architect_mcp.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `bin/flutter_architect_mcp.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `bin/flutter_architect_mcp.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `print("✅ Project generated successfully.");`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in bin/flutter_architect_mcp.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In bin/flutter_architect_mcp.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `bin/flutter_architect_mcp.dart` (Line 22)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print("✅ Project generated successfully.");`

### Required Solution:
// In bin/flutter_architect_mcp.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `bin/flutter_architect_mcp.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/services/criteria_service.dart` (Line 287)
- **Confidence:** HIGH
- **Evidence:** `buffer.writeln('  - Allow TODO comments: ${codeQuality['allow_todo_comments'] ?? false}');`
- **Description:** Found a developer note: "buffer.writeln('  - Allow TODO comments: ${codeQuality['allow_todo_comments'] ?? false}');" in lib/services/criteria_service.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/criteria_service.dart` (Line 287)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `buffer.writeln('  - Allow TODO comments: ${codeQuality['allow_todo_comments'] ?? false}');`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/services/criteria_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 71)
- **Confidence:** HIGH
- **Evidence:** `print('⚠️ PDF conversion failed: $e. Reverting to original HTML file.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 71):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 71)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('⚠️ PDF conversion failed: $e. Reverting to original HTML file.');`

### Required Solution:
// In lib/services/email_service.dart (Line 71):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 111)
- **Confidence:** HIGH
- **Evidence:** `print('⚠️ Mailman CLI not available or failed: $e. Falling back to SMTP/Simulation...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 111):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 111)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('⚠️ Mailman CLI not available or failed: $e. Falling back to SMTP/Simulation...');`

### Required Solution:
// In lib/services/email_service.dart (Line 111):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 172)
- **Confidence:** HIGH
- **Evidence:** `print('✉️ [Email Sent] Successfully sent audit report to $to via SMTP.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 172):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 172)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('✉️ [Email Sent] Successfully sent audit report to $to via SMTP.');`

### Required Solution:
// In lib/services/email_service.dart (Line 172):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 179)
- **Confidence:** HIGH
- **Evidence:** `print('❌ [SMTP Error] Failed to send email via SMTP: $e. Falling back to simulation mode...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 179):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 179)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ [SMTP Error] Failed to send email via SMTP: $e. Falling back to simulation mode...');`

### Required Solution:
// In lib/services/email_service.dart (Line 179):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 235)
- **Confidence:** HIGH
- **Evidence:** `print('✉️ [Simulated Email Sent] To: $to, Subject: $subject');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 235):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 235)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('✉️ [Simulated Email Sent] To: $to, Subject: $subject');`

### Required Solution:
// In lib/services/email_service.dart (Line 235):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 236)
- **Confidence:** HIGH
- **Evidence:** `print('   -> Saved simulated email log to: $htmlLogPath');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 236):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 236)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('   -> Saved simulated email log to: $htmlLogPath');`

### Required Solution:
// In lib/services/email_service.dart (Line 236):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/services/email_service.dart` (Line 237)
- **Confidence:** HIGH
- **Evidence:** `print('   -> Saved attachment PDF to: $pdfAttachmentPath');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/services/email_service.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/services/email_service.dart (Line 237):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/services/email_service.dart` (Line 237)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('   -> Saved attachment PDF to: $pdfAttachmentPath');`

### Required Solution:
// In lib/services/email_service.dart (Line 237):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/services/email_service.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 9)
- **Confidence:** HIGH
- **Evidence:** `// Pattern to detect TODO/FIXME comments`
- **Description:** Found a developer note: "// Pattern to detect TODO/FIXME comments" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 9)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// Pattern to detect TODO/FIXME comments`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 10)
- **Confidence:** HIGH
- **Evidence:** `static final RegExp _todoPattern = RegExp(`
- **Description:** Found a developer note: "static final RegExp _todoPattern = RegExp(" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 10)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `static final RegExp _todoPattern = RegExp(`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 11)
- **Confidence:** HIGH
- **Evidence:** `r'//\s*(?:TODO|FIXME)\s*[:\s](.*)',`
- **Description:** Found a developer note: "r'//\s*(?:TODO|FIXME)\s*[:\s](.*)'," in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 11)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `r'//\s*(?:TODO|FIXME)\s*[:\s](.*)',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 33)
- **Confidence:** HIGH
- **Evidence:** `final allowTodo = codeQualityConf is Map ? (codeQualityConf['allow_todo_comments'] ?? false) : false;`
- **Description:** Found a developer note: "final allowTodo = codeQualityConf is Map ? (codeQualityConf['allow_todo_comments'] ?? false) : false;" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 33)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `final allowTodo = codeQualityConf is Map ? (codeQualityConf['allow_todo_comments'] ?? false) : false;`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 77)
- **Confidence:** HIGH
- **Evidence:** `// 2. Check for TODO / FIXME comments`
- **Description:** Found a developer note: "// 2. Check for TODO / FIXME comments" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 77)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// 2. Check for TODO / FIXME comments`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 78)
- **Confidence:** HIGH
- **Evidence:** `if (!allowTodo) {`
- **Description:** Found a developer note: "if (!allowTodo) {" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 78)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `if (!allowTodo) {`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 81)
- **Confidence:** HIGH
- **Evidence:** `final match = _todoPattern.firstMatch(lineContent);`
- **Description:** Found a developer note: "final match = _todoPattern.firstMatch(lineContent);" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 81)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `final match = _todoPattern.firstMatch(lineContent);`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 83)
- **Confidence:** HIGH
- **Evidence:** `final todoText = match.group(1)?.trim() ?? '';`
- **Description:** Found a developer note: "final todoText = match.group(1)?.trim() ?? '';" in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 83)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `final todoText = match.group(1)?.trim() ?? '';`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 89)
- **Confidence:** HIGH
- **Evidence:** `title: 'Pending TODO / FIXME Comment',`
- **Description:** Found a developer note: "title: 'Pending TODO / FIXME Comment'," in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 89)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `title: 'Pending TODO / FIXME Comment',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 93)
- **Confidence:** HIGH
- **Evidence:** `description: 'Found unresolved developer note in $relativePath at line ${i + 1}: "$todoText"',`
- **Description:** Found a developer note: "description: 'Found unresolved developer note in $relativePath at line ${i + 1}: "$todoText"'," in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 93)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `description: 'Found unresolved developer note in $relativePath at line ${i + 1}: "$todoText"',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 94)
- **Confidence:** HIGH
- **Evidence:** `risk: 'Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.',`
- **Description:** Found a developer note: "risk: 'Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.'," in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 94)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `risk: 'Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 95)
- **Confidence:** HIGH
- **Evidence:** `recommendation: 'Address the TODO item or track it in your team\'s issue management system.',`
- **Description:** Found a developer note: "recommendation: 'Address the TODO item or track it in your team\'s issue management system.'," in lib/technologies/flutter/code_quality/code_quality_scanner.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/technologies/flutter/code_quality/code_quality_scanner.dart` (Line 95)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `recommendation: 'Address the TODO item or track it in your team\'s issue management system.',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/technologies/flutter/code_quality/code_quality_scanner.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 7)
- **Confidence:** HIGH
- **Evidence:** `print('Usage: dart run lib/tools/architectures_create/create_project.dart [options]');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 7)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Usage: dart run lib/tools/architectures_create/create_project.dart [options]');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 8)
- **Confidence:** HIGH
- **Evidence:** `print('Options:');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 8)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Options:');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 9)
- **Confidence:** HIGH
- **Evidence:** `print('  --name <project_name>       Name of the project (required)');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 9)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --name <project_name>       Name of the project (required)');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 10)
- **Confidence:** HIGH
- **Evidence:** `print('  --arch <architecture>       Architecture: clean, mvc, mvvm (required)');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 10):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 10)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --arch <architecture>       Architecture: clean, mvc, mvvm (required)');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 10):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 11)
- **Confidence:** HIGH
- **Evidence:** `print('  --state <state>             State management: bloc, getx, provider, riverpod, rxdart');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 11):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 11)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --state <state>             State management: bloc, getx, provider, riverpod, rxdart');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 11):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 12)
- **Confidence:** HIGH
- **Evidence:** `print('  --backend <backend>         Backend: firebase, supabase');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 12)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --backend <backend>         Backend: firebase, supabase');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 13)
- **Confidence:** HIGH
- **Evidence:** `print('  --db <database>             Database: hive, isar, drift');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 13):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 13)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --db <database>             Database: hive, isar, drift');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 13):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 14)
- **Confidence:** HIGH
- **Evidence:** `print('  --network <network>         Network: dio, retrofit');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 14):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 14)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --network <network>         Network: dio, retrofit');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 14):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 15)
- **Confidence:** HIGH
- **Evidence:** `print('  --router <router>           Router: go_router, auto_route, own_extensions');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 15)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --router <router>           Router: go_router, auto_route, own_extensions');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 16)
- **Confidence:** HIGH
- **Evidence:** `print('  --target <dir>              Target directory (default: current directory)');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 16)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --target <dir>              Target directory (default: current directory)');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 59)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Error: Project name is required (--name <project_name>).');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 59):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 59)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Error: Project name is required (--name <project_name>).');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 59):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 63)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Error: Architecture is required (--arch <architecture>).');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 63)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Error: Architecture is required (--arch <architecture>).');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/architectures_create/create_project.dart` (Line 81)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Project generation failed: $e');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/architectures_create/create_project.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/architectures_create/create_project.dart (Line 81):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/architectures_create/create_project.dart` (Line 81)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Project generation failed: $e');`

### Required Solution:
// In lib/tools/architectures_create/create_project.dart (Line 81):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/architectures_create/create_project.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (1384 lines)
- **File:** `lib/tools/mcp_server_router.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 1384`
- **Description:** File lib/tools/mcp_server_router.dart contains 1384 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (1384 lines)
- **Evidence:** `Total lines: 1384`

### Required Solution:
// In lib/tools/mcp_server_router.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/tools/mcp_server_router.dart` (Line 331)
- **Confidence:** HIGH
- **Evidence:** `'Checks class sizing, method complexity, TODO comments, and UI-layer separation violations.',`
- **Description:** Found a developer note: "'Checks class sizing, method complexity, TODO comments, and UI-layer separation violations.'," in lib/tools/mcp_server_router.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 331)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `'Checks class sizing, method complexity, TODO comments, and UI-layer separation violations.',`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/mcp_server_router.dart` (Line 1155)
- **Confidence:** HIGH
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/mcp_server_router.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1155):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1155)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1155):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/mcp_server_router.dart` (Line 1157)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Background email delivery failed: $err');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/mcp_server_router.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1157):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1157)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Background email delivery failed: $err');`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1157):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/mcp_server_router.dart` (Line 1243)
- **Confidence:** HIGH
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/mcp_server_router.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1243):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1243)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('✉️ Background email delivery status: ${res['message']}');`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1243):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/mcp_server_router.dart` (Line 1245)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Background email delivery failed: $err');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/mcp_server_router.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/mcp_server_router.dart (Line 1245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/mcp_server_router.dart` (Line 1245)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Background email delivery failed: $err');`

### Required Solution:
// In lib/tools/mcp_server_router.dart (Line 1245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/mcp_server_router.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (815 lines)
- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 815`
- **Description:** File lib/tools/runtime_perf_check/perf_dashboard_html.dart contains 815 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (815 lines)
- **Evidence:** `Total lines: 815`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `lib/tools/runtime_perf_check/perf_dashboard_html.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 628)
- **Confidence:** HIGH
- **Evidence:** `console.log('Connected to metrics streaming server.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/runtime_perf_check/perf_dashboard_html.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 628):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_dashboard_html.dart` (Line 628)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `console.log('Connected to metrics streaming server.');`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_dashboard_html.dart (Line 628):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/runtime_perf_check/perf_dashboard_html.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (584 lines)
- **File:** `lib/tools/runtime_perf_check/perf_pdf_generator.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 584`
- **Description:** File lib/tools/runtime_perf_check/perf_pdf_generator.dart contains 584 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_pdf_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_pdf_generator.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (584 lines)
- **Evidence:** `Total lines: 584`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_pdf_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `lib/tools/runtime_perf_check/perf_pdf_generator.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/tools/runtime_perf_check/perf_pdf_generator.dart` (Line 565)
- **Confidence:** HIGH
- **Evidence:** `if (params.get('autodownload') === 'true') {`
- **Description:** Found a developer note: "if (params.get('autodownload') === 'true') {" in lib/tools/runtime_perf_check/perf_pdf_generator.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_pdf_generator.dart` (Line 565)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `if (params.get('autodownload') === 'true') {`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/tools/runtime_perf_check/perf_pdf_generator.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 44)
- **Confidence:** HIGH
- **Evidence:** `print('🚀 Runtime Performance Server running at http://localhost:$port');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 44)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('🚀 Runtime Performance Server running at http://localhost:$port');`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_server.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 67)
- **Confidence:** HIGH
- **Evidence:** `print('🔌 Dashboard client connected to WebSocket stream.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 67)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('🔌 Dashboard client connected to WebSocket stream.');`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_server.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 123)
- **Confidence:** HIGH
- **Evidence:** `final double ram = (data['ram'] as num?)?.toDouble() ?? 0.0;`
- **Description:** Found a developer note: "final double ram = (data['ram'] as num?)?.toDouble() ?? 0.0;" in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 123)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `final double ram = (data['ram'] as num?)?.toDouble() ?? 0.0;`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 124)
- **Confidence:** HIGH
- **Evidence:** `final double storage = (data['storage'] as num?)?.toDouble() ?? 0.0;`
- **Description:** Found a developer note: "final double storage = (data['storage'] as num?)?.toDouble() ?? 0.0;" in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 124)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `final double storage = (data['storage'] as num?)?.toDouble() ?? 0.0;`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 201)
- **Confidence:** HIGH
- **Evidence:** `print('💾 Runtime performance HTML report saved to: ${reportFile.path}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 201):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 201)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('💾 Runtime performance HTML report saved to: ${reportFile.path}');`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_server.dart (Line 201):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 245)
- **Confidence:** HIGH
- **Evidence:** `print('🛑 Runtime Performance Server stopped.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/runtime_perf_check/perf_server.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/runtime_perf_check/perf_server.dart (Line 245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/runtime_perf_check/perf_server.dart` (Line 245)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('🛑 Runtime Performance Server stopped.');`

### Required Solution:
// In lib/tools/runtime_perf_check/perf_server.dart (Line 245):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/runtime_perf_check/perf_server.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 12)
- **Confidence:** HIGH
- **Evidence:** `print('Auditing project at: $projectPath...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 12)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Auditing project at: $projectPath...');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 12):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 16)
- **Confidence:** HIGH
- **Evidence:** `print('-------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 16)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('-------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 16):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 17)
- **Confidence:** HIGH
- **Evidence:** `print('Project Name: ${meta.projectName}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 17):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 17)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Project Name: ${meta.projectName}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 17):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 18)
- **Confidence:** HIGH
- **Evidence:** `print('Flutter SDK:  ${meta.flutterVersion}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 18)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Flutter SDK:  ${meta.flutterVersion}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 19)
- **Confidence:** HIGH
- **Evidence:** `print('Dart SDK:     ${meta.dartVersion}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 19)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Dart SDK:     ${meta.dartVersion}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 20)
- **Confidence:** HIGH
- **Evidence:** `print('-------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 20)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('-------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `print('Running scanners...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 22)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Running scanners...');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 36)
- **Confidence:** HIGH
- **Evidence:** `print('-------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 36)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('-------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 37)
- **Confidence:** HIGH
- **Evidence:** `print('✅ Audit completed successfully!');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 37):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 37)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('✅ Audit completed successfully!');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 37):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 38)
- **Confidence:** HIGH
- **Evidence:** `print('- Findings detected: ${findings.length}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 38):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 38)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('- Findings detected: ${findings.length}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 38):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 39)
- **Confidence:** HIGH
- **Evidence:** `print('- JSON Report:       ${paths['json']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 39)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('- JSON Report:       ${paths['json']}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 40)
- **Confidence:** HIGH
- **Evidence:** `print('- Markdown Report:   ${paths['markdown']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 40):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 40)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('- Markdown Report:   ${paths['markdown']}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 40):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 41)
- **Confidence:** HIGH
- **Evidence:** `print('- HTML Report:       ${paths['html']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 41):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 41)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('- HTML Report:       ${paths['html']}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 41):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 42)
- **Confidence:** HIGH
- **Evidence:** `print('- PDF HTML View:     ${paths['pdfHtml']}');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 42):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 42)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('- PDF HTML View:     ${paths['pdfHtml']}');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 42):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 43)
- **Confidence:** HIGH
- **Evidence:** `print('-------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 43):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 43)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('-------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 43):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 45)
- **Confidence:** HIGH
- **Evidence:** `print('❌ Error running audit: $e');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_audit.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 45):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_audit.dart` (Line 45)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('❌ Error running audit: $e');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_audit.dart (Line 45):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_audit.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 6)
- **Confidence:** HIGH
- **Evidence:** `print('Usage: dart run lib/tools/scanners_and_audit_reports/run_runtime_perf.dart [options]');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 6):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 6)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Usage: dart run lib/tools/scanners_and_audit_reports/run_runtime_perf.dart [options]');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 6):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 7)
- **Confidence:** HIGH
- **Evidence:** `print('Options:');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 7)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Options:');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 8)
- **Confidence:** HIGH
- **Evidence:** `print('  --port <port>   Port to run the dashboard server on (default: 8080)');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 8)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('  --port <port>   Port to run the dashboard server on (default: 8080)');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 8):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 22)
- **Confidence:** HIGH
- **Evidence:** `print('----------------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 22)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('----------------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 22):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 23)
- **Confidence:** HIGH
- **Evidence:** `print('📊 RUNTIME PERFORMANCE MONITOR STARTED');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 23):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 23)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('📊 RUNTIME PERFORMANCE MONITOR STARTED');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 23):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 24)
- **Confidence:** HIGH
- **Evidence:** `print('👉 Open in browser: http://localhost:$port');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 24):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 24)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('👉 Open in browser: http://localhost:$port');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 24):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 25)
- **Confidence:** HIGH
- **Evidence:** `print('👉 Feed API Logs to: http://localhost:$port/api/record');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 25):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 25)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('👉 Feed API Logs to: http://localhost:$port/api/record');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 25):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 26)
- **Confidence:** HIGH
- **Evidence:** `print('Press Ctrl+C to terminate the server.');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 26):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 26)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Press Ctrl+C to terminate the server.');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 26):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 27)
- **Confidence:** HIGH
- **Evidence:** `print('----------------------------------------------------');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 27):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart` (Line 27)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('----------------------------------------------------');`

### Required Solution:
// In lib/tools/scanners_and_audit_reports/run_runtime_perf.dart (Line 27):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `lib/tools/scanners_and_audit_reports/run_runtime_perf.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (609 lines)
- **File:** `lib/utils/solution_generator.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 609`
- **Description:** File lib/utils/solution_generator.dart contains 609 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In lib/utils/solution_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/utils/solution_generator.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (609 lines)
- **Evidence:** `Total lines: 609`

### Required Solution:
// In lib/utils/solution_generator.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `lib/utils/solution_generator.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (2878 lines)
- **File:** `mcphub_plugin/src/index.ts` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 2878`
- **Description:** File mcphub_plugin/src/index.ts contains 2878 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In mcphub_plugin/src/index.ts:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (2878 lines)
- **Evidence:** `Total lines: 2878`

### Required Solution:
// In mcphub_plugin/src/index.ts:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 132)
- **Confidence:** HIGH
- **Evidence:** `{ id: "CQ-004", category: "Code Quality", name: "Unresolved TODO Comments", check: "Found uncompleted production TODO notes or developer comments", type: "Static", threshold: "TODO Match", severity: "INFO" },`
- **Description:** Found a developer note: "{ id: "CQ-004", category: "Code Quality", name: "Unresolved TODO Comments", check: "Found uncompleted production TODO notes or developer comments", type: "Static", threshold: "TODO Match", severity: "INFO" }," in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 132)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `{ id: "CQ-004", category: "Code Quality", name: "Unresolved TODO Comments", check: "Found uncompleted production TODO notes or developer comments", type: "Static", threshold: "TODO Match", severity: "INFO" },`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 703)
- **Confidence:** HIGH
- **Evidence:** `if (/TODO|FIXME/i.test(line)) {`
- **Description:** Found a developer note: "if (/TODO|FIXME/i.test(line)) {" in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 703)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `if (/TODO|FIXME/i.test(line)) {`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 709)
- **Confidence:** HIGH
- **Evidence:** `title: "Unresolved TODO / Development Note",`
- **Description:** Found a developer note: "title: "Unresolved TODO / Development Note"," in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 709)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `title: "Unresolved TODO / Development Note",`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 714)
- **Confidence:** HIGH
- **Evidence:** `risk: "Unresolved TODOs in production indicate unfinished features or missing validations.",`
- **Description:** Found a developer note: "risk: "Unresolved TODOs in production indicate unfinished features or missing validations."," in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 714)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `risk: "Unresolved TODOs in production indicate unfinished features or missing validations.",`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 1818)
- **Confidence:** HIGH
- **Evidence:** `const todoFindings = findings.filter(f => f.id === "QAL-002" || /TODO/i.test(f.title));`
- **Description:** Found a developer note: "const todoFindings = findings.filter(f => f.id === "QAL-002" || /TODO/i.test(f.title));" in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1818)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `const todoFindings = findings.filter(f => f.id === "QAL-002" || /TODO/i.test(f.title));`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 1870)
- **Confidence:** HIGH
- **Evidence:** `const todoRows = todoFindings.length === 0`
- **Description:** Found a developer note: "const todoRows = todoFindings.length === 0" in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1870)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `const todoRows = todoFindings.length === 0`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 1871)
- **Confidence:** HIGH
- **Evidence:** `? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'`
- **Description:** Found a developer note: "? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'" in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1871)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `mcphub_plugin/src/index.ts` (Line 1872)
- **Confidence:** HIGH
- **Evidence:** `: todoFindings.map(f => ``
- **Description:** Found a developer note: ": todoFindings.map(f => `" in mcphub_plugin/src/index.ts.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `mcphub_plugin/src/index.ts` (Line 1872)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `: todoFindings.map(f => ``

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `mcphub_plugin/src/index.ts`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/query_mailman.dart` (Line 7)
- **Confidence:** HIGH
- **Evidence:** `print('Error: tools_list.json does not exist');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/query_mailman.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/query_mailman.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/query_mailman.dart` (Line 7)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Error: tools_list.json does not exist');`

### Required Solution:
// In scratch/query_mailman.dart (Line 7):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/query_mailman.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/query_mailman.dart` (Line 19)
- **Confidence:** HIGH
- **Evidence:** `print('=== TOOL: $name ===');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/query_mailman.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/query_mailman.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/query_mailman.dart` (Line 19)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('=== TOOL: $name ===');`

### Required Solution:
// In scratch/query_mailman.dart (Line 19):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/query_mailman.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/query_mailman.dart` (Line 20)
- **Confidence:** HIGH
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(tool));`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/query_mailman.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/query_mailman.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/query_mailman.dart` (Line 20)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(tool));`

### Required Solution:
// In scratch/query_mailman.dart (Line 20):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/query_mailman.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 5)
- **Confidence:** HIGH
- **Evidence:** `print('Starting mailman process...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 5):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 5)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Starting mailman process...');`

### Required Solution:
// In scratch/test_draft.dart (Line 5):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 9)
- **Confidence:** HIGH
- **Evidence:** `print('SERVER OUT: $line');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 9)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('SERVER OUT: $line');`

### Required Solution:
// In scratch/test_draft.dart (Line 9):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 18)
- **Confidence:** HIGH
- **Evidence:** `print('Extracted draftId: $draftId');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 18)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Extracted draftId: $draftId');`

### Required Solution:
// In scratch/test_draft.dart (Line 18):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 33)
- **Confidence:** HIGH
- **Evidence:** `print('Sending confirm_send request...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 33):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 33)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Sending confirm_send request...');`

### Required Solution:
// In scratch/test_draft.dart (Line 33):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 36)
- **Confidence:** HIGH
- **Evidence:** `print('=== CONFIRM SEND RESPONSE RECEIVED ===');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 36)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('=== CONFIRM SEND RESPONSE RECEIVED ===');`

### Required Solution:
// In scratch/test_draft.dart (Line 36):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 39)
- **Confidence:** HIGH
- **Evidence:** `print('Parse error: $e');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 39)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Parse error: $e');`

### Required Solution:
// In scratch/test_draft.dart (Line 39):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 44)
- **Confidence:** HIGH
- **Evidence:** `print('SERVER ERR: $data');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 44)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('SERVER ERR: $data');`

### Required Solution:
// In scratch/test_draft.dart (Line 44):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_draft.dart` (Line 84)
- **Confidence:** HIGH
- **Evidence:** `print('Sending draft_email request...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_draft.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_draft.dart (Line 84):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_draft.dart` (Line 84)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Sending draft_email request...');`

### Required Solution:
// In scratch/test_draft.dart (Line 84):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_draft.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 15)
- **Confidence:** HIGH
- **Evidence:** `print('Starting simulated MCP Full Flutter Audit with email...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 15)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Starting simulated MCP Full Flutter Audit with email...');`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 15):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 35)
- **Confidence:** HIGH
- **Evidence:** `print('PDF HTML Report generated at: $reportPdfHtmlPath');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 35):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 35)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('PDF HTML Report generated at: $reportPdfHtmlPath');`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 35):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 52)
- **Confidence:** HIGH
- **Evidence:** `print('Sending report to $recipientEmail via EmailService...');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 52):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 52)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Sending report to $recipientEmail via EmailService...');`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 52):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 62)
- **Confidence:** HIGH
- **Evidence:** `print('=== EMAIL DELIVERY RESULT ===');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 62):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 62)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('=== EMAIL DELIVERY RESULT ===');`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 62):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 63)
- **Confidence:** HIGH
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(emailRes));`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 63)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print(JsonEncoder.withIndent('  ').convert(emailRes));`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 63):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Debug Print Statement Left in Code
- **File:** `scratch/test_mcp_email.dart` (Line 67)
- **Confidence:** HIGH
- **Evidence:** `print('Error: $e\n$stack');`
- **Description:** Production logging should use a structured logger rather than raw print/console.log in scratch/test_mcp_email.dart.
- **Risk:** Exposes internal runtime variables in console and pollutes release logs.
- **Recommendation:** Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.
- **Tailored Code Solution:**
```
// In scratch/test_mcp_email.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `scratch/test_mcp_email.dart` (Line 67)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Debug Print Statement Left in Code
- **Evidence:** `print('Error: $e\n$stack');`

### Required Solution:
// In scratch/test_mcp_email.dart (Line 67):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");

Please inspect `scratch/test_mcp_email.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (791 lines)
- **File:** `templates/shared/common/reusable_component/toast/flushbar.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 791`
- **Description:** File templates/shared/common/reusable_component/toast/flushbar.dart contains 791 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In templates/shared/common/reusable_component/toast/flushbar.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/toast/flushbar.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (791 lines)
- **Evidence:** `Total lines: 791`

### Required Solution:
// In templates/shared/common/reusable_component/toast/flushbar.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `templates/shared/common/reusable_component/toast/flushbar.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (532 lines)
- **File:** `templates/shared/common/reusable_component/widgets/common_debit_card.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 532`
- **Description:** File templates/shared/common/reusable_component/widgets/common_debit_card.dart contains 532 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In templates/shared/common/reusable_component/widgets/common_debit_card.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/common_debit_card.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (532 lines)
- **Evidence:** `Total lines: 532`

### Required Solution:
// In templates/shared/common/reusable_component/widgets/common_debit_card.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `templates/shared/common/reusable_component/widgets/common_debit_card.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/keyboard_config.dart` (Line 3)
- **Confidence:** HIGH
- **Evidence:** `// TODO in future remove`
- **Description:** Found a developer note: "// TODO in future remove" in templates/shared/common/reusable_component/widgets/keyboard_config.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/keyboard_config.dart` (Line 3)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO in future remove`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/keyboard_config.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [LOW] File Exceeds 500 Lines (766 lines)
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 1)
- **Confidence:** HIGH
- **Evidence:** `Total lines: 766`
- **Description:** File templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart contains 766 lines of code.
- **Risk:** Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.
- **Recommendation:** Refactor into smaller modular widgets, services, or domain components.
- **Tailored Code Solution:**
```
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 1)
- **Category:** CODE_QUALITY | **Severity:** LOW
- **Issue:** File Exceeds 500 Lines (766 lines)
- **Evidence:** `Total lines: 766`

### Required Solution:
// In templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 64)
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement initState`
- **Description:** Found a developer note: "// TODO: implement initState" in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 64)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO: implement initState`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 523)
- **Confidence:** HIGH
- **Evidence:** `// TODO remove +/- symbol removed`
- **Description:** Found a developer note: "// TODO remove +/- symbol removed" in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 523)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO remove +/- symbol removed`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 570)
- **Confidence:** HIGH
- **Evidence:** `//TODO: Sprint 2`
- **Description:** Found a developer note: "//TODO: Sprint 2" in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart` (Line 570)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `//TODO: Sprint 2`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart` (Line 8)
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement dispose`
- **Description:** Found a developer note: "// TODO: implement dispose" in templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart` (Line 8)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO: implement dispose`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/common/reusable_component/widgets/web_view.dart` (Line 23)
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement initState`
- **Description:** Found a developer note: "// TODO: implement initState" in templates/shared/common/reusable_component/widgets/web_view.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/common/reusable_component/widgets/web_view.dart` (Line 23)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO: implement initState`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/common/reusable_component/widgets/web_view.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/utils/helper/notification_sender_helper.dart` (Line 83)
- **Confidence:** HIGH
- **Evidence:** `// TODO`
- **Description:** Found a developer note: "// TODO" in templates/shared/utils/helper/notification_sender_helper.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/utils/helper/notification_sender_helper.dart` (Line 83)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/utils/helper/notification_sender_helper.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---

### [CODE_QUALITY] [INFO] Unresolved TODO / Development Note
- **File:** `templates/shared/utils/helper/notification_sender_helper.dart` (Line 266)
- **Confidence:** HIGH
- **Evidence:** `// TODO`
- **Description:** Found a developer note: "// TODO" in templates/shared/utils/helper/notification_sender_helper.dart.
- **Risk:** Unresolved TODOs in production indicate unfinished features or missing validations.
- **Recommendation:** Address or track the pending task in the issue management system.
- **Tailored Code Solution:**
```
Address or track the pending task in the issue management system.
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `templates/shared/utils/helper/notification_sender_helper.dart` (Line 266)
- **Category:** CODE_QUALITY | **Severity:** INFO
- **Issue:** Unresolved TODO / Development Note
- **Evidence:** `// TODO`

### Required Solution:
Address or track the pending task in the issue management system.

Please inspect `templates/shared/utils/helper/notification_sender_helper.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---
