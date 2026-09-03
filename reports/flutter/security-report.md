# Flutter Engineering MCP Analysis Report

## Project Overview
- **Project Name:** TestApp
- **Flutter SDK:** 3.24.0
- **Dart SDK:** 3.5.0
- **State Management:** Bloc
- **Database:** Hive
- **Router:** GoRouter
- **Network Client:** Dio

## Security Score: **75/100**
```
Calculated from security/dependency findings:
- Initial Base Score: 100
- Critical Findings: 1 (Penalty: -25 points each => -25)
- High Findings: 0 (Penalty: -15 points each => 0)
- Medium Findings: 0 (Penalty: -7 points each => 0)
- Low Findings: 0 (Penalty: -2 points each => 0)
- Total Deductions: 25
- Final Score: 75
```

## Summary of Findings
- **Critical:** 1
- **High:** 0
- **Medium:** 0
- **Low:** 0

## Analysis Criteria Observed
The analysis was performed based on the following dynamic sheet and local configuration criteria:

### Code Quality
- **Proper use of const and final** (Maintainability - Static): If widget not updated once declear and vaeriable value will never change once declear then use const and final with decration [Threshold: const_possible == true
assignment_count == 1]
- **Large File LOC** (Complexity - Static): Trigger when a file has more than 500 non-empty, non-comment code lines [Threshold: file_code_loc > 500]
- **Large Class LOC** (Complexity - Static): Trigger when a class exceeds configured LOC threshold [Threshold: class_code_loc > 300]
- **Large Function LOC** (Complexity - Static): Trigger when a function/method exceeds configured LOC threshold [Threshold: function_code_loc > 80]
- **Unused Widgets/Classes/Functions** (Dead Code - Static): Declared widget/class/function has no references [Threshold: reference_count == 0]
- **Unused Imports** (Dead Code - Static): Imported symbol is never referenced [Threshold: import_reference_count == 0]
- **Unreachable Branch** (Dead Code - Static): Branch can never execute based on static control-flow analysis [Threshold: unreachable == true]
- **High Cyclomatic Complexity** (Maintainability - Static): Function exceeds complexity threshold [Threshold: complexity > 10]
- **Duplicate Code** (Duplication - Static): Similar code block exceeds configured similarity threshold [Threshold: similarity >= 0.85]
- **Large Build Method** (Flutter - Static): Build method exceeds configured size [Threshold: build_loc > 80]
- **Deep Widget Nesting** (Flutter - Static): Widget tree nesting exceeds threshold [Threshold: depth > 8]
- **Broad State Rebuild** (Flutter - Static): State update potentially rebuilds unnecessarily large widget subtree [Threshold: Configurable]
- **Missing Const Opportunity** (Flutter - Static): Constructor/widget can safely be const but is not [Threshold: const_possible == true]
- **Improper final Usage** (Flutter - Static): Local variable never reassigned and can be final [Threshold: assignment_count == 1]
- **Unsafe Late Usage** (Flutter - Static): late variable may be accessed before initialization or is unnecessary [Threshold: Configurable]
- **Naming Convention Violation** (Naming - Static): Classes, variables, methods/files violate Dart naming conventions [Threshold: Dart convention]
- **Empty Catch Block** (Error Handling - Static): Catch block has no meaningful handling/logging/rethrow [Threshold: catch_body_effective_statements == 0]

### Security
- **Hardcoded API Key** (Secrets - Static): API key pattern detected in source/config [Threshold: Pattern + entropy score]
- **Payment Gateway Credential** (Secrets - Static): Payment provider private/secret credential detected [Threshold: Provider pattern]
- **Firebase Service Account** (Secrets - Static): Firebase service-account JSON/private key detected [Threshold: Credential pattern]
- **Private Key/Certificate** (Secrets - Static): PEM/private key/signing material detected [Threshold: private_key_detected == true]
- **Insecure Token Storage** (Authentication - Static): Access/refresh tokens stored in SharedPreferences/plain files [Threshold: Sensitive token + insecure storage]
- **HTTP/Cleartext Traffic** (Network - Static): Non-TLS HTTP endpoint or cleartext platform configuration detected [Threshold: http:// / cleartext enabled]
- **Certificate Validation Bypass** (Network - Static): Client bypasses certificate validation [Threshold: Trust-all callback/API]
- **Unsafe WebView Configuration** (WebView - Static): JavaScript/file access/untrusted navigation enabled without controls [Threshold: Risk pattern]
- **Unsafe Dynamic Data Handling** (Input - Static): Unsafe eval-like/dynamic deserialization or execution pattern detected [Threshold: Risk API pattern]
- **Sensitive Data in Logs** (Logging - Static): Token/password/payment/PII passed to logging APIs [Threshold: Sensitive variable/pattern]
- **Android Insecure Configuration** (Platform - Static): Debuggable release config, exported components or permissive network settings [Threshold: Risk configuration]
- **iOS Insecure Configuration** (Platform - Static): ATS exceptions, insecure entitlements or overly permissive settings [Threshold: Risk configuration]
- **Overly Permissive Firebase Rules** (Firebase - Static): Firestore/Realtime Database allows broad unauthenticated read/write [Threshold: Broad read/write access]

### Memory Leak
- **Unclosed StreamSubscription** (Lifecycle - Static): StreamSubscription created without matching cancellation/disposal [Threshold: cancel_missing == true]
- **Unclosed Timer** (Lifecycle - Static): Timer created without cancellation [Threshold: cancel_missing == true]
- **AnimationController Not Disposed** (Lifecycle - Static): AnimationController created in State without dispose [Threshold: dispose_missing == true]
- **TextEditingController Not Disposed** (Lifecycle - Static): TextEditingController retained without disposal [Threshold: dispose_missing == true]
- **Scroll/Page Controller Not Disposed** (Lifecycle - Static): ScrollController/PageController created without disposal [Threshold: dispose_missing == true]
- **Listener Not Removed** (State - Static): addListener/addObserver without matching remove [Threshold: remove_missing == true]
- **Unnecessary StatefulWidget** (Flutter - Static): StatefulWidget has no mutable state or lifecycle requirement [Threshold: stateful_need == false]
- **Missing Const StatelessWidget** (Flutter - Static): Immutable widget does not use const constructor [Threshold: const_possible == true]
- **Long-Lived Closure Captures State/Context** (Closures - Static): Long-lived callback captures State/BuildContext [Threshold: Risk pattern]
- **Unbounded In-Memory Collection** (Collections - Static): List/map/cache grows without size/eviction control [Threshold: Configurable size/eviction rule]

### Runtime Analysis
- **Heap Growth Over Time** (Memory - Runtime): Heap increases across repeated flows and does not return toward baseline [Threshold: Configurable growth %]
- **Widget/Object Retention** (Memory - Runtime): Objects remain retained after route/widget disposal [Threshold: Retained after disposal]
- **Frame Rendering/Jank** (Performance - Runtime): Frame build/raster time exceeds threshold or dropped frames detected [Threshold: frame_time > 16.67ms]
- **Excessive Widget Rebuilds** (Performance - Runtime): Widget rebuild count significantly exceeds expected baseline [Threshold: Configurable multiplier]
- **Slow Startup** (Performance - Runtime): Cold-start time exceeds configured threshold [Threshold: startup_ms > 3000]
- **Slow API Request** (Network - Runtime): API request exceeds latency threshold [Threshold: latency_ms > 2000]
- **Excessive Network Traffic** (Network - Runtime): Unexpected request frequency or payload volume [Threshold: Configurable request/payload threshold]
- **Unhandled Exception** (Crash - Runtime): Unhandled Dart/Flutter exception during test flow [Threshold: unhandled_exception == true]
- **Resource Retained After Screen Exit** (Lifecycle - Runtime): Subscription/timer remains active after navigation away [Threshold: Active resource after dispose]
- **Sensitive Runtime Storage** (Storage - Runtime): Token/payment/PII written to logs or insecure storage [Threshold: Sensitive data detected]

### Dependencies
- **Vulnerable Package Version** (Vulnerability - Static): Direct/transitive dependency has known security advisory [Threshold: Known CVE/advisory]
- **Unused Dependency** (Hygiene - Static): Declared package has no project references [Threshold: reference_count == 0]
- **Unmaintained Package** (Risk - Static): Package has stale releases or weak maintenance signals [Threshold: Configurable inactivity period]

### Architecture
- **Layer Violation** (Structure - Static): UI directly accesses infrastructure/data layer against selected architecture [Threshold: Forbidden dependency]
- **Mixed State Management** (State Management - Static): Conflicting state-management patterns used across modules [Threshold: Configured allowed patterns]
- **Business Logic Inside Widget** (Testability - Static): Networking/business rules embedded in build/UI classes [Threshold: Configurable complexity/API count]

### Reporting
- **File/Line/Code Evidence** (Evidence - Both): Every finding must include exact source location and evidence snippet [Threshold: Required fields]
- **Severity/Confidence Scoring** (Severity - Both): Every finding receives severity and confidence [Threshold: Required fields]
- **Suppression/Ignore Support** (False Positives - Both): Approved findings can be suppressed with a reason [Threshold: Suppression requires reason]

### Local Threshold Parameters
- **Max Lines of Code per file:** 500
- **Max lines per function:** 50
- **Allow TODO comments:** false
- **Enforce class prefixes:** true


## 🤖 Master Fix Command for Claude (Fix All Issues)
Pass this master instruction to Claude to fix all issues in one operation preserving functionality:
```markdown
# 🛠️ Master Fix Command for Claude

Please review and resolve the following 1 audit finding(s) in the project.
CRITICAL: Preserve all existing functionality, imports, styles, and public APIs while applying these fixes.

## 📁 File: `lib/core/auth.dart` (1 issue)

### 1. [SECURITY - CRITICAL] Hardcoded Secret Exposure (authKey) (Line 5)
- **Evidence:** `const authKey = "my_private_auth_token_9999";`
- **Fix Instruction:**
```
// In lib/core/auth.dart (Line 5):
// Step 1: Remove hardcoded credential and store it in environment config or secure storage.
// Step 2: Use flutter_dotenv or flutter_secure_storage:

// Option A: Using flutter_dotenv (.env file):
// Add key to .env: API_SECRET_KEY=your_value_here
import 'package:flutter_dotenv/flutter_dotenv.dart';
final apiKey = dotenv.env['API_SECRET_KEY'] ?? '';

// Option B: Using flutter_secure_storage (for runtime sensitive tokens):
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = const FlutterSecureStorage();
final apiKey = await storage.read(key: 'api_secret_key');
```
---

### Fix Rules & Constraints:
1. DO NOT break existing functionality, imports, styles, or public APIs.
2. If packages are required (e.g. `flutter_secure_storage` or `flutter_dotenv`), add them to `pubspec.yaml` / `package.json` appropriately.
3. Ensure no regressions or compilation errors are introduced.
```


## Detailed Findings List

### [SECURITY] [CRITICAL] Hardcoded Secret Exposure (authKey)
- **File:** `lib/core/auth.dart` (Line 5)
- **Confidence:** HIGH
- **Evidence:** `const authKey = "my_private_auth_token_9999";`
- **Description:** Hardcoded secret at line 5.
- **Risk:** Token exposure
- **Recommendation:** Migrate to .env
- **Tailored Code Solution:**
```
// In lib/core/auth.dart (Line 5):
// Step 1: Remove hardcoded credential and store it in environment config or secure storage.
// Step 2: Use flutter_dotenv or flutter_secure_storage:

// Option A: Using flutter_dotenv (.env file):
// Add key to .env: API_SECRET_KEY=your_value_here
import 'package:flutter_dotenv/flutter_dotenv.dart';
final apiKey = dotenv.env['API_SECRET_KEY'] ?? '';

// Option B: Using flutter_secure_storage (for runtime sensitive tokens):
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = const FlutterSecureStorage();
final apiKey = await storage.read(key: 'api_secret_key');
```
- **Claude AI Fix Prompt:**
```
Please fix the following issue in my project without breaking existing functionality:

- **File:** `lib/core/auth.dart` (Line 5)
- **Category:** SECURITY | **Severity:** CRITICAL
- **Issue:** Hardcoded Secret Exposure (authKey)
- **Evidence:** `const authKey = "my_private_auth_token_9999";`

### Required Solution:
// In lib/core/auth.dart (Line 5):
// Step 1: Remove hardcoded credential and store it in environment config or secure storage.
// Step 2: Use flutter_dotenv or flutter_secure_storage:

// Option A: Using flutter_dotenv (.env file):
// Add key to .env: API_SECRET_KEY=your_value_here
import 'package:flutter_dotenv/flutter_dotenv.dart';
final apiKey = dotenv.env['API_SECRET_KEY'] ?? '';

// Option B: Using flutter_secure_storage (for runtime sensitive tokens):
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = const FlutterSecureStorage();
final apiKey = await storage.read(key: 'api_secret_key');

Please inspect `lib/core/auth.dart`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.
```
- **Auto-Fix Available:** No
---
