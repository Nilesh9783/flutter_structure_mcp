import 'package:flutter_architect_mcp/core/models/finding.dart';

class SolutionGenerator {
  /// Generates a tailored, accurate code solution and a copy-pasteable Claude fix prompt for a given finding.
  static Finding attachSolutionAndPrompt(Finding finding) {
    final fix = generateSuggestedFix(finding);
    final prompt = generateClaudePrompt(finding, suggestedFix: fix);

    return finding.copyWith(
      suggestedFix: fix,
      claudePrompt: prompt,
    );
  }

  /// Generates a tailored code solution for the finding based on its ID, file, and exact evidence.
  static String generateSuggestedFix(Finding finding) {
    final id = finding.id;
    final evidence = finding.evidence.trim();
    final file = finding.file;

    switch (id) {
      // 1. Secrets / Credentials (All Platforms)
      case 'SEC-001':
      case 'SEC-SEC-001':
      case 'SEC-ATH-001':
        return _generateSecretFix(finding);

      case 'SEC-004':
        return '''// In $file (Line ${finding.line}):
// Remove private key/certificate from source code.
// Inject via environment variable or secret manager at runtime:
const privateKey = process.env.PRIVATE_KEY || '';''';

      // 2. Storage
      case 'SEC-STR-001':
      case 'SEC-005':
        return _generateStorageFix(finding);

      // 3. Network & Cleartext
      case 'SEC-NET-001':
      case 'SEC-007':
        return '''// In $file (Line ${finding.line}):
// Remove bypass or restrict strictly to local debug mode:
if (kDebugMode) {
  client.badCertificateCallback = (cert, host, port) => host == '10.0.2.2' || host == 'localhost';
} else {
  // Use default platform certificate trust validation in production
}''';

      case 'SEC-NET-002':
      case 'SEC-006':
      case 'SEC-NODE-003':
      case 'SEC-VUE-002':
      case 'SEC-LAR-005':
        final secureUrl = evidence.replaceAll('http://', 'https://');
        return '''// In $file (Line ${finding.line}):
// Replace unencrypted HTTP endpoint with HTTPS:
// Before: $evidence
// After:  $secureUrl''';

      // 4. Memory Leaks (Flutter/Dart)
      case 'MEM-001':
        return '''// In $file (Line ${finding.line}):
// 1. Declare subscription variable in the class/State:
StreamSubscription? _subscription;

// 2. Assign when listening (e.g. in initState):
_subscription = $evidence;

// 3. Clean up in dispose() or onClose():
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}''';

      case 'MEM-002':
        return '''// In $file (Line ${finding.line}):
// 1. Declare Timer variable in the class/State:
Timer? _timer;

// 2. Assign when creating:
_timer = $evidence;

// 3. Cancel inside dispose() or onClose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}''';

      case 'MEM-003':
        final type = _extractControllerType(finding.title, evidence);
        final varName = _suggestVariableName(type);
        return '''// In $file (Line ${finding.line}):
// 1. Declare as a state field:
late final $type $varName;

// 2. Initialize in initState():
@override
void initState() {
  super.initState();
  $varName = $type();
}

// 3. Always dispose in dispose():
@override
void dispose() {
  $varName.dispose();
  super.dispose();
}''';

      case 'MEM-GETX-001':
        return '''// In $file (Line ${finding.line}):
// Override onClose() to cancel subscriptions and timers:
@override
void onClose() {
  // Cancel any active subscriptions/timers here
  super.onClose();
}''';

      // 5. Performance (Flutter/Dart)
      case 'PERF-001':
        return '''// In $file (Line ${finding.line}):
// Convert widget to a StatefulWidget State<YourWidget> and move controller creation out of build():
// 1. Initialize inside initState():
@override
void initState() {
  super.initState();
  // Initialize controller here once
}

// 2. Dispose in dispose():
@override
void dispose() {
  // Dispose controller here
  super.dispose();
}''';

      case 'PERF-002':
        return '''// In $file (Line ${finding.line}):
// Do not trigger API/Database calls directly inside build().
// Option A: Call in initState() and cache the Future in a state variable for FutureBuilder.
// Option B: Fetch via a ViewModel / BLoC / Riverpod provider outside the build lifecycle.''';

      case 'PERF-003':
        return '''// In $file (Line ${finding.line}):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ...; // Render single item
  },
)''';

      // 6. Code Quality & Architecture (Flutter/Dart)
      case 'QAL-001':
      case 'CQ-001':
        return '''// In $file:
// Break down this large file into modular components:
// 1. Extract reusable sub-widgets into separate widget files.
// 2. Move business logic, state handlers, or helpers into dedicated service or controller classes.''';

      case 'QAL-002':
        return '''// In $file (Line ${finding.line}):
// Complete or track pending note: "$evidence"
// Either implement the required logic or convert it to an issue tracker ticket.''';

      case 'QAL-ARC-001':
        return '''// In $file (Line ${finding.line}):
// Move database operations out of the UI layer:
// 1. Create a Repository or DAO class (e.g. UserRepository).
// 2. Call the repository from your state manager (BLoC / ViewModel / Controller).
// 3. UI should only observe state and invoke controller methods.''';

      case 'QAL-ARC-002':
        return '''// In $file (Line ${finding.line}):
// Move direct network calls out of UI widgets:
// 1. Delegate HTTP/Dio requests to an ApiClient / Repository class.
// 2. Trigger requests through your state manager and bind UI to the resulting state.''';

      // 7. Android Platform Security
      case 'SEC-AND-001':
      case 'SEC-011':
        return '''<!-- In $file (Line ${finding.line}) -->
<!-- Disable automated ADB data backups to prevent sandbox data extraction -->
<application
    android:allowBackup="false"
    ... >''';

      case 'SEC-AND-002':
        return '''<!-- In $file (Line ${finding.line}) -->
<!-- Disable cleartext HTTP traffic or use network_security_config -->
<application
    android:usesCleartextTraffic="false"
    ... >''';

      case 'SEC-AND-003':
        return '''<!-- In $file (Line ${finding.line}) -->
<!-- Set exported="false" for internal activities or protect with permissions -->
<activity
    android:name="..."
    android:exported="false">
</activity>''';

      // 8. iOS Platform Security
      case 'SEC-IOS-001':
      case 'SEC-012':
        return '''<!-- In $file (Line ${finding.line}) -->
<!-- Disable global ATS bypass and configure domain-specific exceptions if needed -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>''';

      case 'SEC-IOS-002':
        return '''<!-- In $file (Line ${finding.line}) -->
<!-- Validate all incoming deep links and query parameters strictly, or prefer Universal Links (HTTPS). -->''';

      // 9. Firebase Security
      case 'SEC-FB-001':
        return '''// In firestore.rules:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}''';

      case 'SEC-FB-002':
      case 'SEC-013':
        return '''// In $file (Line ${finding.line}):
// Replace wildcard allow rules with authenticated access checks:
// Before: allow read, write: if true;
// After:  allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;''';

      // 10. WebViews
      case 'SEC-WV-001':
      case 'SEC-WV-002':
      case 'SEC-008':
        return '''// In $file (Line ${finding.line}):
// Restrict JavaScript and validate loaded URLs with navigationDelegate:
NavigationDelegate(
  onNavigationRequest: (NavigationRequest request) {
    final uri = Uri.parse(request.url);
    if (uri.scheme == 'https' && uri.host.endsWith('yourdomain.com')) {
      return NavigationDecision.navigate;
    }
    return NavigationDecision.prevent;
  },
)''';

      // 11. Dependencies
      case 'SEC-DEP-001':
      case 'DEP-001':
      case 'DEP-LAR-001':
        return '''# In package dependency configuration:
# Update package to secure version:
${finding.recommendation}

# Then install dependencies in terminal.''';

      case 'SEC-DEP-002':
      case 'DEP-002':
        return '''# Generate and commit the lockfile to ensure reproducible and auditable builds:
flutter pub get   # or npm install / composer install / pip freeze > requirements.txt''';

      // 12. Node.js Specific Rules
      case 'SEC-NODE-001':
        return '''// In $file (Line ${finding.line}):
// Avoid eval(). Use JSON.parse() or strict mapping functions instead:
const data = JSON.parse(untrustedInput);''';

      case 'CQ-NODE-001':
        return '''// In $file (Line ${finding.line}):
// Replace console.log with a production logger (e.g. winston, pino):
logger.info("Application event", { detail: data });''';

      case 'CQ-NODE-002':
        return '''// In $file:
// Refactor this large module into smaller focused files and helper services.''';

      case 'CQ-NODE-003':
        return '''// In $file (Line ${finding.line}):
// Properly handle or re-throw caught exceptions:
try {
  // operation
} catch (err) {
  logger.error("Operation failed", err);
  throw err;
}''';

      case 'SEC-NODE-002':
        return '''// In $file (Line ${finding.line}):
// Avoid child_process.exec() which spawns a shell and introduces command injection risks.
// Use execFile() or spawn() which pass arguments directly:
const { execFile } = require('child_process');
execFile(pathToExecutable, [arg1, arg2], (err, stdout) => {
  if (err) throw err;
});''';

      case 'PERF-NODE-001':
        return '''// In $file (Line ${finding.line}):
// Replace synchronous file system call (fs.*Sync) with non-blocking async method:
const fs = require('fs').promises;
const data = await fs.readFile(filePath, 'utf8');''';

      // 13. Vue.js Specific Rules
      case 'SEC-VUE-001':
        return '''<!-- In $file (Line ${finding.line}): -->
<!-- Avoid v-html with untrusted input to prevent XSS. Use text interpolation {{ }} or sanitize with DOMPurify: -->
<div v-html="DOMPurify.sanitize(content)"></div>''';

      case 'CQ-VUE-001':
        return '''<!-- In $file: -->
<!-- Refactor large Vue component into smaller reusable child components and composables. -->''';

      case 'CQ-VUE-002':
        return '''<!-- In $file (Line ${finding.line}): -->
<!-- Avoid direct DOM manipulation (document.getElementById). Use Vue template refs: -->
<script setup>
import { useTemplateRef } from 'vue';
const elementRef = useTemplateRef('myElement');
</script>
<template>
  <div ref="myElement"></div>
</template>''';

      case 'CQ-VUE-003':
        return '''<!-- In $file (Line ${finding.line}): -->
<!-- Do not mutate props directly. Emit an update event to the parent component: -->
<script setup>
const props = defineProps(['modelValue']);
const emit = defineEmits(['update:modelValue']);
const onInput = (val) => emit('update:modelValue', val);
</script>''';

      case 'CQ-VUE-004':
        return '''// In $file (Line ${finding.line}):
// Remove console.log calls before production build.''';

      case 'PERF-VUE-001':
        return '''<!-- In $file (Line ${finding.line}): -->
<!-- Provide unique :key binding in v-for loops for optimal Virtual DOM reconciliation: -->
<div v-for="item in items" :key="item.id">
  {{ item.name }}
</div>''';

      // 14. Laravel Specific Rules
      case 'CQ-LAR-001':
        return '''// In $file:
// Refactor large class into Single-Responsibility Services, Actions, or Form Requests.''';

      case 'SEC-LAR-001':
        return '''# In .env:
# Ensure APP_DEBUG is set to false in production:
APP_DEBUG=false''';

      case 'SEC-LAR-002':
        return '''// In $file (Line ${finding.line}):
// Prevent SQL Injection by using Eloquent query bindings instead of raw string interpolation:
\$users = DB::table('users')->where('email', \$email)->get();''';

      case 'SEC-LAR-003':
        return '''// In $file (Line ${finding.line}):
// Avoid empty \$guarded = [] which allows mass assignment vulnerabilities.
// Explicitly declare \$fillable:
protected \$fillable = ['name', 'email', 'status'];''';

      case 'SEC-LAR-004':
        return '''{{-- In $file (Line ${finding.line}): --}}
{{-- Avoid unescaped {!! !!} with untrusted content to prevent XSS. Use standard escaped {{ }}: --}}
{{ \$userContent }}''';

      case 'ARC-LAR-001':
        return '''// Move database queries out of Blade templates into Controller / ViewModel:
// Controller:
public function index() {
    \$posts = Post::published()->paginate(20);
    return view('posts.index', compact('posts'));
}''';

      // 15. Python Specific Rules
      case 'CQ-PY-001':
        return '''# In $file:
# Refactor large Python module into separate focused sub-modules or packages.''';

      case 'SEC-PY-001':
        return '''# In $file (Line ${finding.line}):
# Avoid dynamic eval() / exec(). Use ast.literal_eval() or explicit parsers:
import ast
data = ast.literal_eval(untrusted_string)''';

      case 'SEC-PY-002':
        return '''# In $file (Line ${finding.line}):
# Avoid unsafe pickle.loads() on untrusted data which permits arbitrary code execution.
# Use secure serialization formats like JSON, msgpack, or Protocol Buffers:
import json
data = json.loads(payload)''';

      case 'SEC-PY-003':
        return '''# In $file (Line ${finding.line}):
# Avoid subprocess execution with shell=True to prevent command injection:
import subprocess
result = subprocess.run(["command", arg1, arg2], capture_output=True, check=True)''';

      case 'SEC-PY-004':
        return '''# In settings / config:
# Set DEBUG to False in production environments:
DEBUG = False''';

      case 'CQ-PY-002':
        return '''# In $file (Line ${finding.line}):
# Avoid bare except: clauses. Always catch specific exceptions:
try:
    execute_operation()
except (ValueError, KeyError) as err:
    logger.error("Operation failed: %s", err)''';

      // 16. Runtime Performance & Memory Rules
      case 'RT-001':
        return '''// Runtime Memory Heap Growth:
// 1. Check for unclosed StreamSubscriptions or active Timers across navigation transitions.
// 2. Clear image cache if dealing with large asset lists:
PaintingBinding.instance.imageCache.clear();''';

      case 'RT-002':
        return '''// Object Retention After Disposal:
// Ensure State classes remove all listeners from ChangeNotifiers / ValueNotifiers in dispose():
@override
void dispose() {
  notifier.removeListener(_onChanged);
  super.dispose();
}''';

      case 'RT-003':
        return '''// Frame Jank / Raster Latency (> 16.67ms):
// 1. Offload heavy computational loops or JSON decoding to Isolate.run() or compute().
// 2. Wrap complex static subtrees in RepaintBoundary() widgets.
// 3. Mark immutable widgets as const.''';

      case 'RT-004':
        return '''// Excessive Widget Rebuilds:
// Narrow rebuild scopes using Selector / BlocSelector / Consumer widgets so only changed properties rebuild.''';

      case 'RT-006':
        return '''// High Network API Latency:
// 1. Implement client-side caching with dio_cache_interceptor.
// 2. Request paginated endpoints and compress payload bodies.''';

      // Fallback
      default:
        return finding.recommendation.isNotEmpty
            ? finding.recommendation
            : 'Review ${finding.file} around line ${finding.line} and apply the recommended fix.';
    }
  }

  /// Generates a precise, copy-pasteable prompt for Claude to fix a single finding without breaking functionality.
  static String generateClaudePrompt(Finding finding, {String? suggestedFix}) {
    final fix = suggestedFix ?? generateSuggestedFix(finding);
    final buffer = StringBuffer();

    buffer.writeln('Please fix the following issue in my project without breaking existing functionality:');
    buffer.writeln();
    buffer.writeln('- **File:** `${finding.file}` (Line ${finding.line})');
    buffer.writeln('- **Category:** ${finding.category} | **Severity:** ${finding.severity}');
    buffer.writeln('- **Issue:** ${finding.title}');
    buffer.writeln('- **Evidence:** `${finding.evidence}`');
    buffer.writeln();
    buffer.writeln('### Required Solution:');
    buffer.writeln(fix);
    buffer.writeln();
    buffer.writeln('Please inspect `${finding.file}`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.');

    return buffer.toString().trim();
  }

  /// Generates a Master Claude Prompt to fix all detected issues in one consolidated instruction.
  static String generateMasterClaudePrompt(List<Finding> findings) {
    if (findings.isEmpty) {
      return 'No issues detected! No fixes needed.';
    }

    final buffer = StringBuffer();
    buffer.writeln('# 🛠️ Master Fix Command for Claude');
    buffer.writeln();
    buffer.writeln('Please review and resolve the following ${findings.length} audit finding(s) in the project.');
    buffer.writeln('CRITICAL: Preserve all existing functionality, imports, styles, and public APIs while applying these fixes.');
    buffer.writeln();

    // Group findings by file
    final byFile = <String, List<Finding>>{};
    for (final f in findings) {
      byFile.putIfAbsent(f.file, () => []).add(f);
    }

    int index = 1;
    for (final entry in byFile.entries) {
      final file = entry.key;
      final fileFindings = entry.value;

      buffer.writeln('## 📁 File: `$file` (${fileFindings.length} issue${fileFindings.length > 1 ? 's' : ''})');
      for (final f in fileFindings) {
        final fix = f.suggestedFix.isNotEmpty ? f.suggestedFix : generateSuggestedFix(f);
        buffer.writeln();
        buffer.writeln('### $index. [${f.category} - ${f.severity}] ${f.title} (Line ${f.line})');
        buffer.writeln('- **Evidence:** `${f.evidence}`');
        buffer.writeln('- **Fix Instruction:**');
        buffer.writeln('```');
        buffer.writeln(fix);
        buffer.writeln('```');
        index++;
      }
      buffer.writeln('---');
    }

    buffer.writeln();
    buffer.writeln('### Fix Rules & Constraints:');
    buffer.writeln('1. DO NOT break existing functionality, imports, styles, or public APIs.');
    buffer.writeln('2. If packages are required (e.g. `flutter_secure_storage` or `flutter_dotenv`), add them to `pubspec.yaml` / `package.json` appropriately.');
    buffer.writeln('3. Ensure no regressions or compilation errors are introduced.');

    return buffer.toString().trim();
  }

  // --- Helpers ---

  static String _generateSecretFix(Finding finding) {
    final file = finding.file;
    final ext = file.split('.').last.toLowerCase();

    if (ext == 'dart') {
      return '''// In $file (Line ${finding.line}):
// Step 1: Remove hardcoded credential and store it in environment config or secure storage.
// Step 2: Use flutter_dotenv or flutter_secure_storage:

// Option A: Using flutter_dotenv (.env file):
// Add key to .env: API_SECRET_KEY=your_value_here
import 'package:flutter_dotenv/flutter_dotenv.dart';
final apiKey = dotenv.env['API_SECRET_KEY'] ?? '';

// Option B: Using flutter_secure_storage (for runtime sensitive tokens):
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = const FlutterSecureStorage();
final apiKey = await storage.read(key: 'api_secret_key');''';
    } else if (ext == 'js' || ext == 'ts' || ext == 'jsx' || ext == 'tsx' || ext == 'vue') {
      return '''// In $file (Line ${finding.line}):
// 1. Move secret to .env file:
// API_KEY=your_key_here

// 2. Access via environment variables:
const apiKey = process.env.API_KEY || import.meta.env.VITE_API_KEY;''';
    } else if (ext == 'php') {
      return '''// In $file (Line ${finding.line}):
// Move secret to .env and access via config() or env():
// In .env: SERVICE_API_KEY=your_key_here
\$apiKey = config('services.custom.key', env('SERVICE_API_KEY'));''';
    } else if (ext == 'py') {
      return '''# In $file (Line ${finding.line}):
# Move secret to environment variable (.env) and access with os.environ:
import os
api_key = os.environ.get('API_SECRET_KEY', '')''';
    }

    return '''// In $file (Line ${finding.line}):
// Move hardcoded credential into environment variables or secret store.''';
  }

  static String _generateStorageFix(Finding finding) {
    final file = finding.file;
    final line = finding.line;
    return '''// In $file (Line $line):
// Replace plaintext SharedPreferences / unencrypted storage with FlutterSecureStorage:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = const FlutterSecureStorage();
// Write: await secureStorage.write(key: 'auth_token', value: token);
// Read:  final token = await secureStorage.read(key: 'auth_token');''';
  }

  static String _extractControllerType(String title, String evidence) {
    if (evidence.contains('TextEditingController') || title.contains('TextEditingController')) {
      return 'TextEditingController';
    } else if (evidence.contains('AnimationController') || title.contains('AnimationController')) {
      return 'AnimationController';
    } else if (evidence.contains('ScrollController') || title.contains('ScrollController')) {
      return 'ScrollController';
    } else if (evidence.contains('PageController') || title.contains('PageController')) {
      return 'PageController';
    }
    return 'TextEditingController';
  }

  static String _suggestVariableName(String type) {
    switch (type) {
      case 'TextEditingController': return '_textController';
      case 'AnimationController': return '_animController';
      case 'ScrollController': return '_scrollController';
      case 'PageController': return '_pageController';
      default: return '_controller';
    }
  }
}
