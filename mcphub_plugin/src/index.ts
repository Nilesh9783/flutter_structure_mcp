import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool as McpTool,
} from "@modelcontextprotocol/sdk/types.js";
import { z } from "zod";
import * as fs from "fs";
import * as path from "path";
import * as os from "os";

// ============================================================================
// Types and Interfaces
// ============================================================================

export interface Tool {
  name: string;
  description: string;
  inputSchema: {
    type: "object";
    properties?: Record<string, any>;
    required?: string[];
  };
}

export interface Finding {
  id: string;
  category: "SECURITY" | "MEMORY" | "PERFORMANCE" | "CODE_QUALITY" | "ARCHITECTURE" | "DEPENDENCY";
  severity: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "INFO";
  confidence: "HIGH" | "MEDIUM" | "LOW";
  title: string;
  file: string;
  line: number;
  evidence: string;
  description: string;
  risk: string;
  recommendation: string;
  fixAvailable: boolean;
  suggestedFix?: string;
  claudePrompt?: string;
}

export interface SecurityScoreDetails {
  rawScore: number;
  finalScore: number;
  criticalCount: number;
  highCount: number;
  mediumCount: number;
  lowCount: number;
  riskLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "EXCELLENT";
  explanation: string;
}

export interface ProjectMetadata {
  projectName: string;
  technology: string;
  technologyId: string;
  flutterVersion: string;
  dartVersion: string;
  detectedArchitecture: string;
  detectedStateManagement: string;
  detectedDatabase: string;
  detectedRouter: string;
  detectedNetwork: string;
  targetPlatforms: string[];
  hasFirebase: boolean;
  hasSupabase: boolean;
  packageCount: number;
}

// ============================================================================
// Path Utility & Sanitization
// ============================================================================

export class PathUtils {
  static resolveSafePath(rawPath?: string): string {
    if (!rawPath || typeof rawPath !== "string") {
      return process.cwd();
    }

    let cleaned = rawPath.trim();
    // Remove surrounding single or double quotes
    cleaned = cleaned.replace(/^['"]|['"]$/g, "").trim();

    // Expand ~ to user home directory
    if (cleaned.startsWith("~")) {
      cleaned = path.join(os.homedir(), cleaned.slice(1));
    }

    // On macOS / Linux, fix missing leading slash for absolute-looking user paths
    if (process.platform !== "win32") {
      if (cleaned.startsWith("Users/") || cleaned.startsWith("home/")) {
        cleaned = "/" + cleaned;
      }
    }

    return path.resolve(cleaned);
  }
}

// ============================================================================
// Criteria Data (Google Sheet / Standard Criteria Mirror)
// ============================================================================

export const AUDIT_CRITERIA: Array<{
  id: string;
  category: string;
  name: string;
  check: string;
  type: string;
  threshold: string;
  severity: string;
}> = [
  { id: "SEC-001", category: "Security", name: "Hardcoded API Key", check: "API key or token pattern detected in source/config", type: "Static", threshold: "Pattern Match", severity: "CRITICAL" },
  { id: "SEC-002", category: "Security", name: "Payment Gateway Credential", check: "Payment provider private/secret credential detected", type: "Static", threshold: "Provider Pattern", severity: "CRITICAL" },
  { id: "SEC-003", category: "Security", name: "Firebase Service Account", check: "Firebase service-account JSON/private key detected", type: "Static", threshold: "Credential File", severity: "CRITICAL" },
  { id: "SEC-004", category: "Security", name: "Private Key/Certificate", check: "PEM/private key/signing material detected", type: "Static", threshold: "private_key_detected == true", severity: "CRITICAL" },
  { id: "SEC-005", category: "Security", name: "Insecure Token Storage", check: "Access/refresh tokens stored in plaintext storage", type: "Static", threshold: "Plain Storage Match", severity: "HIGH" },
  { id: "SEC-006", category: "Security", name: "HTTP/Cleartext Traffic", check: "Non-TLS HTTP endpoint or cleartext platform configuration", type: "Static", threshold: "http:// / usesCleartextTraffic", severity: "HIGH" },
  { id: "SEC-007", category: "Security", name: "Certificate Validation Bypass", check: "Client bypasses certificate validation callback", type: "Static", threshold: "Trust-all callback", severity: "CRITICAL" },
  { id: "SEC-011", category: "Security", name: "Android Insecure Configuration", check: "allowBackup=true, cleartext traffic or exported components", type: "Static", threshold: "Manifest Risk Pattern", severity: "HIGH" },
  { id: "SEC-012", category: "Security", name: "iOS Insecure Configuration", check: "NSAllowsArbitraryLoads or ATS exceptions enabled", type: "Static", threshold: "Info.plist ATS", severity: "HIGH" },
  { id: "SEC-013", category: "Security", name: "Overly Permissive Firebase Rules", check: "Firestore/Realtime Database allows unauthenticated access", type: "Static", threshold: "allow read, write: if true", severity: "CRITICAL" },
  { id: "MEM-001", category: "Memory Leak", name: "Unclosed StreamSubscription", check: "StreamSubscription created without matching disposal/cancel", type: "Static", threshold: "Missing .cancel()", severity: "HIGH" },
  { id: "MEM-002", category: "Memory Leak", name: "Unclosed Timer", check: "Periodic or delayed Timer created without cancellation", type: "Static", threshold: "Missing .cancel()", severity: "HIGH" },
  { id: "MEM-003", category: "Memory Leak", name: "Controller Not Disposed", check: "TextEditing, Animation, or Scroll Controller created without dispose()", type: "Static", threshold: "Missing .dispose()", severity: "HIGH" },
  { id: "PERF-001", category: "Performance", name: "Controller Instantiated in build()", check: "Instantiating controllers inside build() method causing jank", type: "Static", threshold: "Controller in build()", severity: "HIGH" },
  { id: "PERF-002", category: "Performance", name: "Synchronous File / Disk I/O", check: "Synchronous file system call executed in application thread", type: "Static", threshold: "Sync I/O in main thread", severity: "MEDIUM" },
  { id: "PERF-003", category: "Performance", name: "Eager ListView Constructor", check: "ListView(children: [...]) used instead of ListView.builder()", type: "Static", threshold: "Eager Child Allocation", severity: "MEDIUM" },
  { id: "CQ-001", category: "Code Quality", name: "Large File LOC", check: "Trigger when a file has more than 500 lines of code", type: "Static", threshold: "LOC > 500", severity: "LOW" },
  { id: "CQ-004", category: "Code Quality", name: "Unresolved TODO Comments", check: "Found uncompleted production TODO notes or developer comments", type: "Static", threshold: "TODO Match", severity: "INFO" },
  { id: "CQ-015", category: "Code Quality", name: "Debug Print Left in Code", check: "Production logging using raw print() or console.log() statements", type: "Static", threshold: "print() / console.log()", severity: "INFO" },
  { id: "ARC-001", category: "Architecture", name: "UI Direct Database Access", check: "Database/Repository queries invoked directly inside UI widgets", type: "Static", threshold: "Layer Boundary Violation", severity: "HIGH" },
  { id: "DEP-001", category: "Dependencies", name: "Vulnerable Dependency Version", check: "Package dependency has known security advisory or missing lockfile", type: "Static", threshold: "Lockfile Missing / CVE", severity: "HIGH" }
];

// ============================================================================
// Solution & Claude Fix Prompt Generator
// ============================================================================

export class SolutionGenerator {
  static attachSolutionAndPrompt(finding: Finding): Finding {
    const fix = this.generateSuggestedFix(finding);
    const prompt = this.generateClaudePrompt(finding, fix);
    return {
      ...finding,
      suggestedFix: fix,
      claudePrompt: prompt,
    };
  }

  static generateSuggestedFix(finding: Finding): string {
    const id = finding.id;
    const file = finding.file;
    const evidence = finding.evidence ? finding.evidence.trim() : "";

    switch (id) {
      case "SEC-001":
      case "SEC-SEC-001":
      case "SEC-ATH-001":
        return `// In ${file} (Line ${finding.line}):
// Remove hardcoded credential from source code.
// Option A: Use flutter_dotenv / .env:
import 'package:flutter_dotenv/flutter_dotenv.dart';
final apiKey = dotenv.env['API_SECRET_KEY'] ?? '';

// Option B: Use flutter_secure_storage for runtime tokens:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final secureStorage = const FlutterSecureStorage();
final apiKey = await secureStorage.read(key: 'api_secret_key');`;

      case "SEC-STR-001":
      case "SEC-005":
        return `// In ${file} (Line ${finding.line}):
// Replace plaintext SharedPreferences with FlutterSecureStorage:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final secureStorage = const FlutterSecureStorage();
// Write: await secureStorage.write(key: 'auth_token', value: token);
// Read:  final token = await secureStorage.read(key: 'auth_token');`;

      case "SEC-NET-002":
      case "SEC-006":
        return `// In ${file} (Line ${finding.line}):
// Replace insecure HTTP endpoint with HTTPS:
// Before: ${evidence}
// After:  ${evidence.replace(/http:\/\//g, "https://")}`;

      case "SEC-AND-001":
      case "SEC-011":
        return `<!-- In ${file} (Line ${finding.line}) -->
<!-- Disable cleartext HTTP network traffic in AndroidManifest.xml: -->
<application
    android:usesCleartextTraffic="false"
    ... >`;

      case "SEC-AND-002":
        return `<!-- In ${file} (Line ${finding.line}) -->
<!-- Disable automated ADB data backups to prevent sandbox extraction: -->
<application
    android:allowBackup="false"
    ... >`;

      case "SEC-IOS-001":
      case "SEC-012":
        return `<!-- In ${file} (Line ${finding.line}) -->
<!-- Disable global ATS bypass and configure HTTPS in Info.plist: -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>`;

      case "MEM-001":
        return `// In ${file} (Line ${finding.line}):
// 1. Declare StreamSubscription / listener variable in State:
StreamSubscription? _subscription;

// 2. Assign on initialization:
_subscription = ${evidence || "stream.listen(...)"};

// 3. Cancel inside dispose():
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}`;

      case "MEM-002":
        return `// In ${file} (Line ${finding.line}):
// 1. Declare Timer variable in State:
Timer? _timer;

// 2. Assign when starting:
_timer = ${evidence || "Timer.periodic(...)"};

// 3. Cancel in dispose():
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}`;

      case "MEM-003":
        return `// In ${file} (Line ${finding.line}):
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
}`;

      case "PERF-001":
        return `// In ${file} (Line ${finding.line}):
// Convert to StatefulWidget and move controller instantiation out of build():
class _SafeWidgetState extends State<SafeWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Allocated once
  }

  @override
  void dispose() {
    _controller.dispose(); // Safely freed from memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(controller: _controller);
}`;

      case "PERF-002":
        return `// In ${file} (Line ${finding.line}):
// Replace synchronous file system call with asynchronous non-blocking method:
// Dart: await File(filePath).readAsString();
// Node: const data = await fs.promises.readFile(filePath, 'utf-8');`;

      case "PERF-003":
        return `// In ${file} (Line ${finding.line}):
// Replace static ListView with lazy-loading ListView.builder:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItemWidget(item: items[index]);
  },
)`;

      case "QUAL-001":
      case "CQ-001":
        return `// In ${file}:
// Refactor this large monolithic file into smaller modular widgets and helper services.
// 1. Extract sub-views into dedicated components in /widgets.
// 2. Move business logic into a controller / ViewModel / BLoC.`;

      case "QUAL-002":
      case "CQ-015":
        return `// In ${file} (Line ${finding.line}):
// Replace raw debug print with a structured production logger:
// Dart:   logger.d("Debug message");
// Node:   logger.info("Application event");`;

      default:
        return finding.recommendation || `Review ${file} around line ${finding.line} and apply the recommended fix.`;
    }
  }

  static generateClaudePrompt(finding: Finding, suggestedFix?: string): string {
    const fix = suggestedFix || this.generateSuggestedFix(finding);
    return `Please fix the following issue in my project without breaking existing functionality:

- **File:** \`${finding.file}\` (Line ${finding.line})
- **Category:** ${finding.category} | **Severity:** ${finding.severity}
- **Issue:** ${finding.title}
- **Evidence:** \`${finding.evidence}\`

### Required Solution:
${fix}

Please inspect \`${finding.file}\`, apply the necessary changes preserving all existing behavior and APIs, and ensure the code compiles cleanly.`.trim();
  }

  static generateMasterClaudePrompt(findings: Finding[]): string {
    if (findings.length === 0) {
      return "No issues detected! No fixes needed.";
    }

    const byFile: Record<string, Finding[]> = {};
    for (const f of findings) {
      if (!byFile[f.file]) byFile[f.file] = [];
      byFile[f.file].push(f);
    }

    let buffer = `# 🛠️ Master Fix Command for Claude\n\n`;
    buffer += `Please review and resolve the following ${findings.length} audit finding(s) in the project.\n`;
    buffer += `CRITICAL: Preserve all existing functionality, imports, styles, and public APIs while applying these fixes.\n\n`;

    let index = 1;
    for (const [file, fileFindings] of Object.entries(byFile)) {
      buffer += `## 📁 File: \`${file}\` (${fileFindings.length} issue${fileFindings.length > 1 ? "s" : ""})\n`;
      for (const f of fileFindings) {
        const fix = f.suggestedFix || this.generateSuggestedFix(f);
        buffer += `\n### ${index}. [${f.category} - ${f.severity}] ${f.title} (Line ${f.line})\n`;
        buffer += `- **Evidence:** \`${f.evidence}\`\n`;
        buffer += `- **Fix Instruction:**\n\`\`\`\n${fix}\n\`\`\`\n`;
        index++;
      }
      buffer += `---\n`;
    }

    buffer += `\n### Fix Rules & Constraints:\n`;
    buffer += `1. DO NOT break existing functionality, imports, styles, or public APIs.\n`;
    buffer += `2. If packages are required (e.g. \`flutter_secure_storage\` or \`flutter_dotenv\`), add them to \`pubspec.yaml\` / \`package.json\` appropriately.\n`;
    buffer += `3. Ensure no regressions or compilation errors are introduced.\n`;

    return buffer.trim();
  }
}

// ============================================================================
// Core Analyzers & Scanners
// ============================================================================

export class SecretScanner {
  private static patterns = [
    { name: "AWS Access Key", regex: /(?:^|[^A-Z0-9_-])(AKIA[0-9A-Z]{16})(?:[^A-Z0-9_-]|$)/g },
    { name: "Private Key Header", regex: /-----BEGIN (?:RSA |EC |DSA |GPG |)?PRIVATE KEY-----/g },
    { name: "Google API Key", regex: /AIza[0-9A-Za-z-_]{35}/g },
    { name: "Firebase Service Key", regex: /"private_key"\s*:\s*"[^"]+"/g },
    { name: "GitHub Token", regex: /gh[opr]_[0-9a-zA-Z]{36,255}/g },
    { name: "Slack Token", regex: /xox[bapr]-[0-9a-zA-Z]{10,200}/g },
    { name: "JWT Token", regex: /eyJhbGciOi[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*/g },
    { name: "Generic Secret / Password", regex: /(?:api_key|apikey|secret_key|secretkey|access_token|oauth_token|aws_secret|db_password)\s*[:=]\s*["']([^"']{8,})["']/gi },
  ];

  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const files = listFilesRecursively(projectPath, [
      ".dart", ".js", ".ts", ".vue", ".php", ".py", ".yaml", ".yml", ".json", ".xml", ".properties", ".gradle", ".plist", ".env"
    ]);

    for (const filePath of files) {
      const relPath = path.relative(projectPath, filePath);
      const fileName = path.basename(filePath).toLowerCase();
      const isClientConfig = fileName === "google-services.json" || fileName === "googleservice-info.plist" || fileName === "firebase_options.dart";

      try {
        const content = fs.readFileSync(filePath, "utf-8");
        const lines = content.split("\n");

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];
          for (const pat of this.patterns) {
            if (isClientConfig && pat.name === "Google API Key") continue;
            pat.regex.lastIndex = 0;
            const match = pat.regex.exec(line);
            if (match) {
              const rawSecret = match[0];
              const masked = maskSecret(rawSecret);
              findings.push(SolutionGenerator.attachSolutionAndPrompt({
                id: "SEC-SEC-001",
                category: "SECURITY",
                severity: "HIGH",
                confidence: "HIGH",
                title: `Potential Hardcoded Secret / ${pat.name} Detected`,
                file: relPath,
                line: i + 1,
                evidence: line.replace(rawSecret, masked).trim(),
                description: `Hardcoded credential or API secret pattern (${pat.name}) detected in ${relPath} at line ${i + 1}.`,
                risk: "Storing cleartext credentials in code repositories leads to unauthorized access and credential leakage.",
                recommendation: "Extract credentials to environment variables (.env) or secure vault storage. Never commit secrets to source control.",
                fixAvailable: false,
              }));
            }
          }

          if (line.includes("http://") && !line.includes("http://localhost") && !line.includes("http://10.0.2.2") && !line.includes("http://127.0.0.1") && !line.includes("http://schemas.android.com") && !line.includes("http://www.w3.org")) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "SEC-NET-002",
              category: "SECURITY",
              severity: "HIGH",
              confidence: "HIGH",
              title: "Plaintext HTTP URL Endpoint Detected",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: `Unencrypted HTTP URL endpoint detected in ${relPath} at line ${i + 1}.`,
              risk: "Allows network adversaries to intercept and modify API payloads via Man-in-the-Middle (MitM).",
              recommendation: "Replace unencrypted http:// with secure https:// endpoints.",
              fixAvailable: true,
            }));
          }
        }
      } catch { }
    }
    return findings;
  }
}

export class AndroidScanner {
  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const manifestFiles = [
      path.join(projectPath, "android/app/src/main/AndroidManifest.xml"),
      path.join(projectPath, "AndroidManifest.xml"),
    ];

    for (const manifestPath of manifestFiles) {
      if (!fs.existsSync(manifestPath)) continue;
      const relPath = path.relative(projectPath, manifestPath);
      try {
        const content = fs.readFileSync(manifestPath, "utf-8");
        const lines = content.split("\n");

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];
          if (/android:usesCleartextTraffic\s*=\s*["']true["']/i.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "SEC-AND-001",
              category: "SECURITY",
              severity: "HIGH",
              confidence: "HIGH",
              title: "Cleartext HTTP Traffic Permitted (usesCleartextTraffic=true)",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: "The application explicitly permits cleartext HTTP network traffic in AndroidManifest.xml.",
              risk: "Allows Man-in-the-Middle (MitM) attacks where network traffic can be intercepted and modified.",
              recommendation: 'Disable cleartext traffic by setting android:usesCleartextTraffic="false" or configure a Network Security Config.',
              fixAvailable: true,
            }));
          }

          if (/android:allowBackup\s*=\s*["']true["']/i.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "SEC-AND-002",
              category: "SECURITY",
              severity: "MEDIUM",
              confidence: "HIGH",
              title: "ADB Application Backup Enabled (allowBackup=true)",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: "Android application backup is enabled by default in AndroidManifest.xml.",
              risk: "Attackers with physical or ADB access can extract private app storage and databases via adb backup.",
              recommendation: 'Set android:allowBackup="false" if application data contains sensitive user credentials.',
              fixAvailable: true,
            }));
          }
        }
      } catch { }
    }
    return findings;
  }
}

export class IosScanner {
  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const plistFiles = [
      path.join(projectPath, "ios/Runner/Info.plist"),
      path.join(projectPath, "Info.plist"),
    ];

    for (const plistPath of plistFiles) {
      if (!fs.existsSync(plistPath)) continue;
      const relPath = path.relative(projectPath, plistPath);
      try {
        const content = fs.readFileSync(plistPath, "utf-8");
        if (content.includes("NSAllowsArbitraryLoads") && /<key>NSAllowsArbitraryLoads<\/key>\s*<true\/>/i.test(content)) {
          findings.push(SolutionGenerator.attachSolutionAndPrompt({
            id: "SEC-IOS-001",
            category: "SECURITY",
            severity: "HIGH",
            confidence: "HIGH",
            title: "App Transport Security (ATS) Disabled (NSAllowsArbitraryLoads=true)",
            file: relPath,
            line: 1,
            evidence: "<key>NSAllowsArbitraryLoads</key><true/>",
            description: "iOS App Transport Security is globally disabled, allowing insecure plaintext HTTP network requests.",
            risk: "Insecure transmission allows attackers on the same network to intercept or manipulate data payloads.",
            recommendation: "Remove NSAllowsArbitraryLoads or configure domain-specific ATS exceptions only for verified endpoints.",
            fixAvailable: true,
          }));
        }
      } catch { }
    }
    return findings;
  }
}

export class MemoryScanner {
  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const files = listFilesRecursively(projectPath, [".dart", ".vue", ".js", ".ts"]);

    for (const filePath of files) {
      const relPath = path.relative(projectPath, filePath);
      try {
        const content = fs.readFileSync(filePath, "utf-8");
        const lines = content.split("\n");

        const hasStreamController = /StreamController\s*<.*?>\s*\(/g.test(content) || /new StreamController/g.test(content);
        const hasAnimationController = /AnimationController\s*\(/g.test(content);
        const hasTextController = /TextEditingController\s*\(/g.test(content);
        const hasScrollController = /ScrollController\s*\(/g.test(content);
        const hasDispose = /dispose\s*\(\s*\)/.test(content) || /onUnmounted\s*\(/.test(content);

        if ((hasStreamController || hasAnimationController || hasTextController || hasScrollController) && !hasDispose) {
          findings.push(SolutionGenerator.attachSolutionAndPrompt({
            id: "MEM-003",
            category: "MEMORY",
            severity: "HIGH",
            confidence: "HIGH",
            title: "Controller / Stream Created Without dispose() Method",
            file: relPath,
            line: 1,
            evidence: "Missing @override void dispose() or unmount hook",
            description: `Stateful resource or controller declared in ${relPath} but no dispose lifecycle method was found.`,
            risk: "Leaked controllers retain listeners and memory allocations indefinitely, leading to app lag and OOM crashes.",
            recommendation: "Implement dispose() and invoke .dispose() or .close() on all controllers and streams.",
            fixAvailable: false,
          }));
        }

        for (let i = 0; i < lines.length; i++) {
          if (/Timer\.periodic\s*\(/.test(lines[i]) || /setInterval\s*\(/.test(lines[i])) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "MEM-002",
              category: "MEMORY",
              severity: "MEDIUM",
              confidence: "MEDIUM",
              title: "Periodic Timer / Interval Declared",
              file: relPath,
              line: i + 1,
              evidence: lines[i].trim(),
              description: `Periodic timer declared in ${relPath} at line ${i + 1}.`,
              risk: "Active timers that are not cancelled continue executing in background, draining battery and leaking memory.",
              recommendation: "Store the Timer instance and call timer.cancel() inside dispose() or unmount.",
              fixAvailable: false,
            }));
          }
        }
      } catch { }
    }
    return findings;
  }
}

export class PerformanceScanner {
  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const files = listFilesRecursively(projectPath, [".dart", ".vue", ".js", ".ts"]);

    for (const filePath of files) {
      const relPath = path.relative(projectPath, filePath);
      try {
        const content = fs.readFileSync(filePath, "utf-8");
        const lines = content.split("\n");

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];

          if (/ListView\s*\(\s*children:\s*\[/.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "PERF-003",
              category: "PERFORMANCE",
              severity: "MEDIUM",
              confidence: "HIGH",
              title: "ListView(children: [...]) Used Instead of ListView.builder",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: "Using standard ListView constructor eagerly constructs all children at once.",
              risk: "Causes rendering jank, frame drops, and high memory consumption for lists with dynamic or large element counts.",
              recommendation: "Switch to ListView.builder() to lazily instantiate only visible on-screen items.",
              fixAvailable: false,
            }));
          }

          if (/readFileSync|existsSync|writeFileSync|File\([^)]+\)\.readAsBytesSync/g.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "PERF-002",
              category: "PERFORMANCE",
              severity: "MEDIUM",
              confidence: "HIGH",
              title: "Synchronous File / Disk I/O Operation Detected",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: "Synchronous file system call executed in application thread.",
              risk: "Blocks the main UI event loop during disk reads/writes, causing noticeable UI freezes.",
              recommendation: "Use asynchronous I/O methods (e.g. readAsString() or fs.promises) to avoid blocking the main thread.",
              fixAvailable: false,
            }));
          }
        }
      } catch { }
    }
    return findings;
  }
}

export class CodeQualityScanner {
  static scan(projectPath: string): Finding[] {
    const findings: Finding[] = [];
    const files = listFilesRecursively(projectPath, [".dart", ".vue", ".js", ".ts", ".php", ".py"]);

    for (const filePath of files) {
      const relPath = path.relative(projectPath, filePath);
      try {
        const content = fs.readFileSync(filePath, "utf-8");
        const lines = content.split("\n");

        if (lines.length > 500) {
          findings.push(SolutionGenerator.attachSolutionAndPrompt({
            id: "QUAL-001",
            category: "CODE_QUALITY",
            severity: "LOW",
            confidence: "HIGH",
            title: `File Exceeds 500 Lines (${lines.length} lines)`,
            file: relPath,
            line: 1,
            evidence: `Total lines: ${lines.length}`,
            description: `File ${relPath} contains ${lines.length} lines of code.`,
            risk: "Monolithic files increase cognitive load, make unit testing difficult, and violate single-responsibility principle.",
            recommendation: "Refactor into smaller modular widgets, services, or domain components.",
            fixAvailable: false,
          }));
        }

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];
          if (/^\s*print\s*\(|^\s*console\.log\s*\(|^\s*dd\s*\(|^\s*var_dump\s*\(/g.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "QUAL-002",
              category: "CODE_QUALITY",
              severity: "INFO",
              confidence: "HIGH",
              title: "Debug Print Statement Left in Code",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: `Production logging should use a structured logger rather than raw print/console.log in ${relPath}.`,
              risk: "Exposes internal runtime variables in console and pollutes release logs.",
              recommendation: "Replace with structured logger (e.g. logger package or winston) and disable debug output in release builds.",
              fixAvailable: false,
            }));
          }

          if (/TODO|FIXME/i.test(line)) {
            findings.push(SolutionGenerator.attachSolutionAndPrompt({
              id: "QAL-002",
              category: "CODE_QUALITY",
              severity: "INFO",
              confidence: "HIGH",
              title: "Unresolved TODO / Development Note",
              file: relPath,
              line: i + 1,
              evidence: line.trim(),
              description: `Found a developer note: "${line.trim()}" in ${relPath}.`,
              risk: "Unresolved TODOs in production indicate unfinished features or missing validations.",
              recommendation: "Address or track the pending task in the issue management system.",
              fixAvailable: false,
            }));
          }
        }
      } catch { }
    }
    return findings;
  }
}

export class ProjectDetector {
  static detect(projectPath: string): ProjectMetadata {
    const projectName = path.basename(path.resolve(projectPath));
    let technology = "Flutter";
    let technologyId = "flutter";
    let detectedArchitecture = "Clean Architecture";
    let detectedStateManagement = "Bloc";
    let detectedDatabase = "Hive / SecureStorage";
    let detectedRouter = "GoRouter";
    let detectedNetwork = "Dio";
    let targetPlatforms = ["Android", "iOS"];
    let flutterVersion = "Flutter >=3.19.0";
    let dartVersion = "Dart >=3.3.0";
    let hasFirebase = false;
    let hasSupabase = false;
    let packageCount = 0;

    const pubspecPath = path.join(projectPath, "pubspec.yaml");
    if (fs.existsSync(pubspecPath)) {
      technology = "Flutter";
      technologyId = "flutter";
      try {
        const content = fs.readFileSync(pubspecPath, "utf-8");
        hasFirebase = content.includes("firebase_core");
        hasSupabase = content.includes("supabase_flutter");

        if (content.includes("flutter_bloc") || content.includes("bloc:")) detectedStateManagement = "Bloc";
        else if (content.includes("get:")) detectedStateManagement = "GetX";
        else if (content.includes("provider:")) detectedStateManagement = "Provider";
        else if (content.includes("flutter_riverpod") || content.includes("riverpod:")) detectedStateManagement = "Riverpod";

        if (content.includes("go_router")) detectedRouter = "GoRouter";
        else if (content.includes("auto_route")) detectedRouter = "AutoRoute";

        if (content.includes("dio")) detectedNetwork = "Dio";
        else if (content.includes("http:")) detectedNetwork = "http";

        if (content.includes("hive")) detectedDatabase = "Hive";
        else if (content.includes("isar")) detectedDatabase = "Isar";
        else if (content.includes("sqflite")) detectedDatabase = "Sqflite";

        const libDirs = listDirs(path.join(projectPath, "lib"));
        if (libDirs.includes("domain") && libDirs.includes("data") && libDirs.includes("presentation")) {
          detectedArchitecture = "Clean Architecture";
        } else if (libDirs.includes("views") && libDirs.includes("viewmodels")) {
          detectedArchitecture = "MVVM";
        } else if (libDirs.includes("features")) {
          detectedArchitecture = "Feature-First";
        }
      } catch { }
    } else {
      const packageJsonPath = path.join(projectPath, "package.json");
      if (fs.existsSync(packageJsonPath)) {
        technology = "Node.js";
        technologyId = "node";
        flutterVersion = "N/A";
        dartVersion = "Node.js >=18.0.0";
        try {
          const pkg = JSON.parse(fs.readFileSync(packageJsonPath, "utf-8"));
          packageCount = Object.keys(pkg.dependencies || {}).length + Object.keys(pkg.devDependencies || {}).length;
          if (pkg.dependencies?.vue || pkg.devDependencies?.vue) {
            technology = "Vue.js";
            technologyId = "vue";
          }
        } catch { }
      }
    }

    return {
      projectName,
      technology,
      technologyId,
      flutterVersion,
      dartVersion,
      detectedArchitecture,
      detectedStateManagement,
      detectedDatabase,
      detectedRouter,
      detectedNetwork,
      targetPlatforms,
      hasFirebase,
      hasSupabase,
      packageCount,
    };
  }
}

// ============================================================================
// Scoring Engine
// ============================================================================

export function calculateScore(findings: Finding[]): SecurityScoreDetails {
  let criticalCount = 0;
  let highCount = 0;
  let mediumCount = 0;
  let lowCount = 0;

  for (const f of findings) {
    if (f.category !== "SECURITY" && f.category !== "DEPENDENCY") continue;
    switch (f.severity) {
      case "CRITICAL": criticalCount++; break;
      case "HIGH": highCount++; break;
      case "MEDIUM": mediumCount++; break;
      case "LOW": lowCount++; break;
    }
  }

  const deductions = (criticalCount * 25) + (highCount * 15) + (mediumCount * 7) + (lowCount * 2);
  const rawScore = 100 - deductions;
  const finalScore = Math.max(0, Math.min(100, rawScore));

  let riskLevel: SecurityScoreDetails["riskLevel"] = "EXCELLENT";
  if (finalScore < 40) riskLevel = "CRITICAL";
  else if (finalScore < 60) riskLevel = "HIGH";
  else if (finalScore < 80) riskLevel = "MEDIUM";
  else if (finalScore < 95) riskLevel = "LOW";

  const explanation = `Calculated codebase score: ${finalScore}/100 based on ${findings.length} findings evaluated (${criticalCount} Critical, ${highCount} High, ${mediumCount} Medium, ${lowCount} Low).`;

  return {
    rawScore,
    finalScore,
    criticalCount,
    highCount,
    mediumCount,
    lowCount,
    riskLevel,
    explanation,
  };
}

// ============================================================================
// Report Generators (Interactive HTML, Print-Ready PDF HTML, Markdown, JSON)
// ============================================================================

export class FullReportGenerator {
  static async generateAllReports(
    projectPath: string,
    meta: ProjectMetadata,
    findings: Finding[],
    score: SecurityScoreDetails
  ): Promise<{ html: string; pdfHtml: string; json: string; markdown: string }> {
    const techDir = path.join(projectPath, "reports", meta.technologyId || "flutter");
    const baseReportsDir = path.join(projectPath, "reports");

    if (!fs.existsSync(techDir)) fs.mkdirSync(techDir, { recursive: true });
    if (!fs.existsSync(baseReportsDir)) fs.mkdirSync(baseReportsDir, { recursive: true });

    // 1. JSON Report
    const jsonMap = {
      projectPath,
      metadata: meta,
      score: score.finalScore,
      scoreDetails: score,
      masterClaudePrompt: SolutionGenerator.generateMasterClaudePrompt(findings),
      findings: findings,
    };
    const jsonStr = JSON.stringify(jsonMap, null, 2);
    const jsonPathTech = path.join(techDir, "security-report.json");
    const jsonPathBase = path.join(baseReportsDir, "security-report.json");
    fs.writeFileSync(jsonPathTech, jsonStr, "utf-8");
    fs.writeFileSync(jsonPathBase, jsonStr, "utf-8");

    // 2. Markdown Report
    const mdContent = this.generateMarkdown(meta, findings, score);
    const mdPathTech = path.join(techDir, "security-report.md");
    const mdPathBase = path.join(baseReportsDir, "security-report.md");
    fs.writeFileSync(mdPathTech, mdContent, "utf-8");
    fs.writeFileSync(mdPathBase, mdContent, "utf-8");

    // 3. Interactive HTML Report (With Category Tabs & Dark UI)
    const htmlContent = this.generateInteractiveHtml(meta, findings, score);
    const htmlPathTech = path.join(techDir, "security-report.html");
    const htmlPathBase = path.join(baseReportsDir, "security-report.html");
    fs.writeFileSync(htmlPathTech, htmlContent, "utf-8");
    fs.writeFileSync(htmlPathBase, htmlContent, "utf-8");

    // 4. Print-Ready PDF HTML View
    const pdfHtmlContent = this.generatePdfHtml(meta, findings, score);
    const pdfHtmlPathTech = path.join(techDir, "security-report-pdf.html");
    const pdfHtmlPathBase = path.join(baseReportsDir, "security-report-pdf.html");
    fs.writeFileSync(pdfHtmlPathTech, pdfHtmlContent, "utf-8");
    fs.writeFileSync(pdfHtmlPathBase, pdfHtmlContent, "utf-8");

    return {
      html: htmlPathTech,
      pdfHtml: pdfHtmlPathTech,
      json: jsonPathTech,
      markdown: mdPathTech,
    };
  }

  static generateMarkdown(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string {
    let md = `# ${meta.technology} Engineering MCP Analysis Report\n\n`;
    md += `## Project Overview\n`;
    md += `- **Project Name:** ${meta.projectName}\n`;
    md += `- **Flutter SDK:** ${meta.flutterVersion}\n`;
    md += `- **Dart SDK / Runtime:** ${meta.dartVersion}\n`;
    md += `- **State Management:** ${meta.detectedStateManagement}\n`;
    md += `- **Database:** ${meta.detectedDatabase}\n`;
    md += `- **Router:** ${meta.detectedRouter}\n`;
    md += `- **Network Client:** ${meta.detectedNetwork}\n\n`;

    md += `## Security Score: **${score.finalScore}/100**\n`;
    md += `\`\`\`\n${score.explanation}\n\`\`\`\n\n`;

    md += `## Summary of Findings\n`;
    md += `- **Critical:** ${score.criticalCount}\n`;
    md += `- **High:** ${score.highCount}\n`;
    md += `- **Medium:** ${score.mediumCount}\n`;
    md += `- **Low:** ${score.lowCount}\n\n`;

    if (findings.length > 0) {
      md += `## 🤖 Master Fix Command for Claude (Fix All Issues)\n`;
      md += `Pass this master instruction to Claude to fix all issues in one operation:\n`;
      md += `\`\`\`markdown\n${SolutionGenerator.generateMasterClaudePrompt(findings)}\n\`\`\`\n\n`;
    }

    md += `## Detailed Findings List\n`;
    if (findings.length === 0) {
      md += `_No findings detected! Your project passes all architectural, performance, and security checks._\n`;
    } else {
      for (const f of findings) {
        md += `\n### [${f.category}] [${f.severity}] ${f.title}\n`;
        md += `- **File:** \`${f.file}\` (Line ${f.line})\n`;
        md += `- **Confidence:** ${f.confidence}\n`;
        md += `- **Evidence:** \`${f.evidence}\`\n`;
        md += `- **Description:** ${f.description}\n`;
        md += `- **Risk:** ${f.risk}\n`;
        md += `- **Recommendation:** ${f.recommendation}\n`;
        if (f.suggestedFix) {
          md += `- **Tailored Code Solution:**\n\`\`\`\n${f.suggestedFix}\n\`\`\`\n`;
        }
        if (f.claudePrompt) {
          md += `- **Claude AI Fix Prompt:**\n\`\`\`\n${f.claudePrompt}\n\`\`\`\n`;
        }
        md += `- **Auto-Fix Available:** ${f.fixAvailable ? "Yes" : "No"}\n---\n`;
      }
    }
    return md;
  }

  static generateInteractiveHtml(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string {
    const findingsJson = JSON.stringify(findings).replace(/</g, "\\u003c").replace(/>/g, "\\u003e");
    const masterPrompt = SolutionGenerator.generateMasterClaudePrompt(findings)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");

    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${meta.technology} Advanced Audit Report - ${meta.projectName}</title>
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: #151d30;
            --text-color: #e2e8f0;
            --text-muted: #94a3b8;
            --primary: #38bdf8;
            --primary-glow: rgba(56, 189, 248, 0.15);
            --border: #222e4a;
            
            --critical: #ef4444;
            --high: #f97316;
            --medium: #eab308;
            --low: #22c55e;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            line-height: 1.6;
            padding: 2rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        h1 {
            font-size: 2rem;
            background: linear-gradient(135deg, #38bdf8 0%, #818cf8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .metadata-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .meta-card {
            flex: 1;
            min-width: 220px;
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .meta-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 0.25rem;
        }

        .meta-value {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .dashboard {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .score-card {
            flex: 1;
            min-width: 250px;
            background: radial-gradient(circle at top left, var(--card-bg) 40%, rgba(56, 189, 248, 0.08) 100%);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .score-circle {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 8px solid var(--primary);
            box-shadow: 0 0 20px var(--primary-glow);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .stats-card {
            flex: 2;
            min-width: 300px;
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2rem;
        }

        .stats-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 1.2rem;
            border-left: 4px solid var(--primary);
            padding-left: 0.75rem;
        }

        .stats-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .stat-box {
            flex: 1;
            min-width: 100px;
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
            font-weight: bold;
        }

        .stat-box.critical { background-color: rgba(239, 68, 68, 0.15); border: 1px solid var(--critical); color: #fca5a5; }
        .stat-box.high { background-color: rgba(249, 115, 22, 0.15); border: 1px solid var(--high); color: #fed7aa; }
        .stat-box.medium { background-color: rgba(234, 179, 8, 0.15); border: 1px solid var(--medium); color: #fef08a; }
        .stat-box.low { background-color: rgba(34, 197, 94, 0.15); border: 1px solid var(--low); color: #bbf7d0; }

        .stat-num { font-size: 2rem; margin-bottom: 0.25rem; }
        .stat-lbl { font-size: 0.8rem; text-transform: uppercase; }

        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            background-color: var(--card-bg);
            padding: 1rem;
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        .filter-btn {
            background-color: #1e293b;
            color: var(--text-color);
            border: 1px solid var(--border);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s ease;
        }

        .filter-btn.active, .filter-btn:hover {
            background-color: var(--primary);
            color: #0b0f19;
            font-weight: 600;
        }

        .findings-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .finding-item {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .finding-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
        }

        .finding-item.critical::before { background-color: var(--critical); }
        .finding-item.high::before { background-color: var(--high); }
        .finding-item.medium::before { background-color: var(--medium); }
        .finding-item.low::before { background-color: var(--low); }
        .finding-item.info::before { background-color: #64748b; }

        .finding-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .finding-title-group {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .finding-title {
            font-size: 1.15rem;
            font-weight: 700;
        }

        .badge {
            font-size: 0.7rem;
            text-transform: uppercase;
            padding: 0.2rem 0.6rem;
            border-radius: 6px;
            font-weight: 700;
        }

        .badge.critical { background-color: var(--critical); color: white; }
        .badge.high { background-color: var(--high); color: white; }
        .badge.medium { background-color: var(--medium); color: #0b0f19; }
        .badge.low { background-color: var(--low); color: white; }
        .badge.info { background-color: #64748b; color: white; }
        .badge.category { background-color: #334155; color: #cbd5e1; }

        .finding-meta {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
        }

        .finding-meta span {
            margin-right: 1rem;
        }

        .finding-section {
            background-color: rgba(15, 23, 42, 0.4);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.75rem;
            border: 1px solid rgba(255,255,255,0.02);
        }

        .section-title {
            font-size: 0.8rem;
            text-transform: uppercase;
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        pre {
            background-color: #020617;
            padding: 0.75rem;
            border-radius: 6px;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: #38bdf8;
            margin-top: 0.25rem;
        }

        .solution-box {
            background: rgba(34, 197, 94, 0.08);
            border: 1px solid rgba(34, 197, 94, 0.25);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.75rem;
        }

        .solution-title {
            font-size: 0.8rem;
            text-transform: uppercase;
            color: #4ade80;
            font-weight: 700;
            margin-bottom: 0.35rem;
        }

        .prompt-box {
            background: rgba(129, 140, 248, 0.08);
            border: 1px solid rgba(129, 140, 248, 0.25);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.75rem;
        }

        .prompt-title {
            font-size: 0.8rem;
            text-transform: uppercase;
            color: #818cf8;
            font-weight: 700;
            margin-bottom: 0.35rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .copy-btn {
            background: #1e293b;
            border: 1px solid var(--border);
            color: var(--text-color);
            padding: 0.35rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .copy-btn:hover {
            background: var(--primary);
            color: #0b0f19;
        }

        .toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #22c55e;
            color: #0b0f19;
            padding: 0.75rem 1.25rem;
            border-radius: 8px;
            font-weight: bold;
            font-size: 0.9rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.4);
            z-index: 100000;
            display: none;
            animation: toastFadeIn 0.3s ease-out;
        }

        @keyframes toastFadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px dashed var(--border);
            color: var(--text-muted);
        }

        /* Modal Styles */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 10000; 
            left: 0; 
            top: 0; 
            width: 100%; 
            height: 100%; 
            overflow: auto; 
            background-color: rgba(11, 15, 25, 0.85); 
            backdrop-filter: blur(5px); 
            align-items: center; 
            justify-content: center;
        }
        .modal-content {
            background-color: var(--card-bg); 
            border: 1px solid var(--border); 
            padding: 2rem; 
            border-radius: 12px; 
            max-width: 650px; 
            width: 90%; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.5); 
            position: relative;
            animation: modalFadeIn 0.3s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-close {
            position: absolute; 
            right: 1.25rem; 
            top: 1rem; 
            font-size: 1.5rem; 
            color: var(--text-muted); 
            cursor: pointer;
            transition: color 0.2s;
        }
        .modal-close:hover {
            color: var(--primary);
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block; 
            font-size: 0.8rem; 
            color: var(--text-muted); 
            margin-bottom: 0.5rem; 
            text-transform: uppercase;
        }
        .form-control {
            width: 100%; 
            padding: 0.75rem; 
            border-radius: 8px; 
            border: 1px solid var(--border); 
            background-color: #0b0f19; 
            color: var(--text-color); 
            font-size: 0.9rem;
            outline: none;
        }
    </style>
</head>
<body>
    <div id="toast" class="toast">📋 Copied to clipboard!</div>

    <div class="container">
        <!-- Top File Role & Navigation Demarcation Banner -->
        <div style="background: linear-gradient(135deg, rgba(56, 189, 248, 0.12) 0%, rgba(129, 140, 248, 0.12) 100%); border: 1px solid rgba(56, 189, 248, 0.35); border-radius: 12px; padding: 1rem 1.25rem; margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                    <span style="background: #38bdf8; color: #0b0f19; font-size: 0.7rem; font-weight: 800; padding: 0.2rem 0.5rem; border-radius: 4px; text-transform: uppercase;">File 1 of 2</span>
                    <span style="font-weight: 700; color: #38bdf8; font-size: 1rem;">📊 Interactive Audit Dashboard (security-report.html)</span>
                </div>
                <p style="font-size: 0.825rem; color: var(--text-muted); line-height: 1.4;">
                    <strong>What this file includes:</strong> Live interactive severity/category tabs, detailed vulnerability &amp; memory leak cards, 1-click Claude fix prompts, and Master &quot;Fix All with AI&quot; batch prompt modal.
                </p>
            </div>
            <div style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                <a href="security-report-pdf.html" style="display: inline-flex; align-items: center; gap: 0.35rem; background: #1e293b; border: 1px solid var(--border); color: #cbd5e1; text-decoration: none; font-size: 0.8rem; font-weight: 600; padding: 0.5rem 1rem; border-radius: 6px; transition: all 0.2s;">
                    📄 Open Print-Ready Document View (security-report-pdf.html) &rarr;
                </a>
            </div>
        </div>

        <header>
            <div>
                <h1>${meta.technology} Advanced Engineering Audit</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">Automated security, architectural, and lifecycle audit report</p>
            </div>
            <div style="text-align: right;">
                <p style="font-weight: bold;">Date: ${new Date().toLocaleString()}</p>
                <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 0.5rem;">Project Name: ${meta.projectName}</p>
                <div style="display: flex; gap: 0.5rem; justify-content: flex-end; align-items: center; flex-wrap: wrap;">
                    <button onclick="openMasterPromptModal()" style="display: inline-block; background: linear-gradient(135deg, #818cf8 0%, #38bdf8 100%); color: #0b0f19; font-weight: bold; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; border: none; cursor: pointer;">🤖 Fix All with Claude</button>
                    <button onclick="window.print()" style="display: inline-block; background-color: var(--primary); color: #0b0f19; font-weight: 700; border: none; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; cursor: pointer;">🖨️ Download / Print PDF</button>
                    <a href="security-report-pdf.html" style="display: inline-block; background: #1e293b; border: 1px solid var(--border); color: #cbd5e1; font-weight: 600; text-decoration: none; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px;">📄 Print-Ready View</a>
                </div>
            </div>
        </header>

        <section class="metadata-grid">
            <div class="meta-card">
                <div class="meta-label">Environment SDK</div>
                <div class="meta-value">${meta.flutterVersion}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">Runtime</div>
                <div class="meta-value">${meta.dartVersion}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">State Management</div>
                <div class="meta-value">${meta.detectedStateManagement}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">Router</div>
                <div class="meta-value">${meta.detectedRouter}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">Network &amp; Database</div>
                <div class="meta-value">${meta.detectedNetwork} / ${meta.detectedDatabase}</div>
            </div>
        </section>

        <!-- Analysis Criteria Section -->
        <section class="meta-card" style="margin-bottom: 2rem; max-height: 380px; overflow-y: auto;">
            <h2 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 0.5rem;">Analysis Criteria Observed</h2>
            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">This report is based on established mobile &amp; cloud engineering quality criteria:</p>
            <div style="display: flex; flex-wrap: wrap; gap: 1rem;">
                <div style="flex: 1; min-width: 280px; background: rgba(255,255,255,0.01); padding: 1rem; border-radius: 8px; border: 1px solid var(--border);">
                    <h3 style="font-size: 0.95rem; color: var(--text-color); border-bottom: 1px solid var(--border); padding-bottom: 0.25rem; margin-bottom: 0.5rem;">Security &amp; Secrets</h3>
                    <ul style="list-style-type: none; font-size: 0.8rem; color: var(--text-muted); padding-left: 0;">
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Hardcoded Secrets:</strong> API keys, private keys, JWTs in source code</li>
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Network Security:</strong> Cleartext HTTP traffic &amp; ATS bypasses</li>
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Platform Storage:</strong> Android allowBackup &amp; insecure shared preferences</li>
                    </ul>
                </div>
                <div style="flex: 1; min-width: 280px; background: rgba(255,255,255,0.01); padding: 1rem; border-radius: 8px; border: 1px solid var(--border);">
                    <h3 style="font-size: 0.95rem; color: var(--text-color); border-bottom: 1px solid var(--border); padding-bottom: 0.25rem; margin-bottom: 0.5rem;">Memory &amp; Performance</h3>
                    <ul style="list-style-type: none; font-size: 0.8rem; color: var(--text-muted); padding-left: 0;">
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Lifecycle Leaks:</strong> Undisposed StreamControllers, Timers, AnimationControllers</li>
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">UI Rendering Jank:</strong> Eager ListView vs ListView.builder</li>
                        <li style="margin-bottom: 0.4rem;"><strong style="color: var(--text-color);">Main Thread I/O:</strong> Synchronous disk operations (readFileSync/Sync)</li>
                    </ul>
                </div>
            </div>
        </section>

        <section class="dashboard">
            <div class="score-card">
                <div class="score-circle">${score.finalScore}</div>
                <h3 style="font-size: 1.25rem; margin-bottom: 0.25rem;">Overall Audit Score</h3>
                <p style="color: var(--text-muted); font-size: 0.85rem;">Capped 0 - 100 scale (${score.riskLevel})</p>
            </div>
            <div class="stats-card">
                <h3 class="stats-title">Audit Findings Summary</h3>
                <div class="stats-grid">
                    <div class="stat-box critical">
                        <div class="stat-num">${score.criticalCount}</div>
                        <div class="stat-lbl">Critical</div>
                    </div>
                    <div class="stat-box high">
                        <div class="stat-num">${score.highCount}</div>
                        <div class="stat-lbl">High</div>
                    </div>
                    <div class="stat-box medium">
                        <div class="stat-num">${score.mediumCount}</div>
                        <div class="stat-lbl">Medium</div>
                    </div>
                    <div class="stat-box low">
                        <div class="stat-num">${score.lowCount}</div>
                        <div class="stat-lbl">Low</div>
                    </div>
                </div>
                <div style="margin-top: 1.5rem; font-size: 0.85rem; color: var(--text-muted); background: rgba(0,0,0,0.2); padding: 1rem; border-radius: 8px;">
                    <strong>Scoring Rationale:</strong><br>
                    ${score.explanation}
                </div>
            </div>
        </section>

        <section style="margin-bottom: 2rem;">
            <h3 style="font-size: 1.25rem; margin-bottom: 1rem; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.5rem;">
                <span>Detailed Findings</span>
                <button onclick="openMasterPromptModal()" class="copy-btn" style="background: rgba(129, 140, 248, 0.2); color: #818cf8; border-color: rgba(129, 140, 248, 0.4);">📋 Copy Master Prompt for All Issues</button>
            </h3>
            
            <div class="filters">
                <button class="filter-btn active" onclick="filterSeverity('ALL')">All Severity</button>
                <button class="filter-btn" onclick="filterSeverity('CRITICAL')">Critical</button>
                <button class="filter-btn" onclick="filterSeverity('HIGH')">High</button>
                <button class="filter-btn" onclick="filterSeverity('MEDIUM')">Medium</button>
                <button class="filter-btn" onclick="filterSeverity('LOW')">Low</button>
                
                <span style="border-left: 1px solid var(--border); margin: 0 0.5rem;"></span>
                
                <button class="filter-btn active" onclick="filterCategory('ALL')">All Categories</button>
                <button class="filter-btn" onclick="filterCategory('SECURITY')">Security</button>
                <button class="filter-btn" onclick="filterCategory('MEMORY')">Memory</button>
                <button class="filter-btn" onclick="filterCategory('PERFORMANCE')">Performance</button>
                <button class="filter-btn" onclick="filterCategory('CODE_QUALITY')">Code Quality</button>
                <button class="filter-btn" onclick="filterCategory('DEPENDENCY')">Dependencies</button>
            </div>

            <div class="findings-list" id="findingsContainer">
                <!-- Injected via JavaScript -->
            </div>
        </section>
    </div>

    <script>
        const findings = ${findingsJson};
        let currentSeverity = 'ALL';
        let currentCategory = 'ALL';

        function showToast(msg) {
            const toast = document.getElementById('toast');
            if (!toast) return;
            toast.innerText = msg || '📋 Copied to clipboard!';
            toast.style.display = 'block';
            clearTimeout(window._toastTimer);
            window._toastTimer = setTimeout(() => {
                toast.style.display = 'none';
            }, 2500);
        }

        function triggerButtonSuccess(btn) {
            if (!btn) return;
            const origHtml = btn.innerHTML;
            btn.innerHTML = '✅ Copied!';
            btn.style.background = '#22c55e';
            btn.style.color = '#0b0f19';
            btn.style.borderColor = '#22c55e';
            btn.disabled = true;
            setTimeout(() => {
                btn.innerHTML = origHtml;
                btn.style.background = '';
                btn.style.color = '';
                btn.style.borderColor = '';
                btn.disabled = false;
            }, 2000);
        }

        function copyText(text, btn) {
            if (!text || text.trim().length === 0) {
                showToast('⚠️ Nothing to copy');
                return;
            }

            let copied = false;
            try {
                const ta = document.createElement('textarea');
                ta.value = text;
                ta.style.position = 'fixed';
                ta.style.top = '10px';
                ta.style.left = '10px';
                ta.style.width = '100px';
                ta.style.height = '40px';
                ta.style.opacity = '0.01';
                ta.style.zIndex = '999999';
                document.body.appendChild(ta);
                ta.focus();
                ta.select();
                ta.setSelectionRange(0, 999999);
                copied = document.execCommand('copy');
                document.body.removeChild(ta);
            } catch (e) {
                copied = false;
            }

            if (!copied && navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(() => {
                    showToast('📋 Prompt copied to clipboard!');
                    if (btn) triggerButtonSuccess(btn);
                }).catch(() => {
                    showToast('⚠️ Please select text and copy manually.');
                });
                return;
            }

            if (copied) {
                showToast('📋 Prompt copied to clipboard!');
                if (btn) triggerButtonSuccess(btn);
            } else {
                showToast('⚠️ Please select text and copy manually.');
            }
        }

        function copyFindingPrompt(index, btn) {
            if (findings && findings[index] && findings[index].claudePrompt) {
                copyText(findings[index].claudePrompt, btn);
            }
        }

        function openMasterPromptModal() {
            document.getElementById('masterPromptModal').style.display = 'flex';
        }

        function closeMasterPromptModal() {
            document.getElementById('masterPromptModal').style.display = 'none';
        }

        function copyMasterPrompt(btn) {
            const el = document.getElementById('masterPromptText');
            if (el) {
                copyText(el.value, btn);
            }
        }

        function renderFindings() {
            const container = document.getElementById('findingsContainer');
            container.innerHTML = '';

            const filtered = findings.filter(f => {
                const matchSev = currentSeverity === 'ALL' || f.severity.toUpperCase() === currentSeverity;
                const matchCat = currentCategory === 'ALL' || f.category.toUpperCase() === currentCategory;
                return matchSev && matchCat;
            });

            if (filtered.length === 0) {
                container.innerHTML = \`
                    <div class="empty-state">
                        <h4>No findings match the current filter selection.</h4>
                        <p style="margin-top: 0.5rem; font-size: 0.9rem;">Great job! No unresolved issues found in this view.</p>
                    </div>
                \`;
                return;
            }

            filtered.forEach((f, idx) => {
                const originalIdx = findings.indexOf(f);
                const item = document.createElement('div');
                item.className = 'finding-item ' + f.severity.toLowerCase();

                let solutionHtml = '';
                if (f.suggestedFix && f.suggestedFix.trim().length > 0) {
                    solutionHtml = \`
                        <div class="solution-box">
                            <div class="solution-title">💡 Tailored Code Solution</div>
                            <pre style="color: #4ade80;"><code>\${escapeHtml(f.suggestedFix)}</code></pre>
                        </div>
                    \`;
                }

                let promptHtml = '';
                if (f.claudePrompt && f.claudePrompt.trim().length > 0) {
                    promptHtml = \`
                        <div class="prompt-box">
                            <div class="prompt-title">
                                <span>🤖 Claude AI Fix Prompt</span>
                                <button class="copy-btn" onclick="copyFindingPrompt(\${originalIdx}, this)">📋 Copy Prompt</button>
                            </div>
                            <pre style="color: #cbd5e1; max-height: 180px; overflow-y: auto;"><code>\${escapeHtml(f.claudePrompt)}</code></pre>
                        </div>
                    \`;
                }

                item.innerHTML = \`
                    <div class="finding-header">
                        <div class="finding-title-group">
                            <span class="badge \${f.severity.toLowerCase()}">\${f.severity}</span>
                            <span class="badge category">\${f.category}</span>
                            <h4 class="finding-title">\${f.title}</h4>
                        </div>
                        <span style="font-size: 0.85rem; font-weight: bold; color: var(--text-muted)">ID: \${f.id}</span>
                    </div>

                    <div class="finding-meta">
                        <span><strong>File:</strong> \${f.file} (Line \${f.line})</span>
                        <span><strong>Confidence:</strong> \${f.confidence}</span>
                        \${f.fixAvailable ? '<span style="color: var(--low); font-weight: bold;">(Auto-Fix Available)</span>' : ''}
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Evidence</div>
                        <pre><code>\${escapeHtml(f.evidence)}</code></pre>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Description</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem;">\${f.description.replace(/\\n/g, '<br>')}</p>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Risk Analysis</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem;">\${f.risk}</p>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Recommendation</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem; white-space: pre-line;">\${f.recommendation}</p>
                    </div>

                    \${solutionHtml}
                    \${promptHtml}
                \`;
                container.appendChild(item);
            });
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function filterSeverity(sev) {
            currentSeverity = sev;
            updateButtonState('filter-btn', sev, ['ALL', 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW']);
            renderFindings();
        }

        function filterCategory(cat) {
            currentCategory = cat;
            updateButtonState('filter-btn', cat, ['ALL', 'SECURITY', 'MEMORY', 'PERFORMANCE', 'CODE_QUALITY', 'DEPENDENCY']);
            renderFindings();
        }

        function updateButtonState(btnClass, activeVal, valuesList) {
            const buttons = document.querySelectorAll('.' + btnClass);
            buttons.forEach(btn => {
                const text = btn.innerText.toUpperCase();
                const matches = text.includes(activeVal) || (activeVal === 'ALL' && text.includes('ALL'));
                if (matches) {
                    btn.classList.add('active');
                } else {
                    const isOther = valuesList.some(v => v !== activeVal && text.includes(v));
                    if (isOther) {
                        btn.classList.remove('active');
                    }
                }
            });
        }

        // Initial render
        renderFindings();
    </script>

    <!-- Master Claude Prompt Modal HTML -->
    <div id="masterPromptModal" class="modal">
        <div class="modal-content" style="max-width: 800px;">
            <span onclick="closeMasterPromptModal()" class="modal-close">&times;</span>
            <h2 style="font-size: 1.25rem; color: var(--text-color); margin-bottom: 0.5rem; border-bottom: 1px solid var(--border); padding-bottom: 0.5rem;">🤖 Master Fix Command for Claude</h2>
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1rem;">
                Pass this instruction directly to Claude to resolve all ${findings.length} audit finding(s) preserving existing code functionality.
            </p>
            <div class="form-group">
                <textarea id="masterPromptText" class="form-control" rows="14" style="font-family: 'Courier New', monospace; font-size: 0.8rem; resize: vertical;" readonly>${masterPrompt}</textarea>
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem;">
                <button onclick="closeMasterPromptModal()" class="copy-btn" style="padding: 0.55rem 1.25rem;">Close</button>
                <button onclick="copyMasterPrompt(this)" style="padding: 0.55rem 1.5rem; border-radius: 8px; border: none; background: linear-gradient(135deg, #818cf8 0%, #38bdf8 100%); color: #0b0f19; font-weight: bold; font-size: 0.85rem; cursor: pointer;">📋 Copy Master Prompt</button>
            </div>
        </div>
    </div>
</body>
</html>`;
  }

  static generatePdfHtml(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string {
    const securityFindings = findings.filter(f => f.category === "SECURITY" || f.category === "DEPENDENCY");
    const performanceFindings = findings.filter(f => f.category === "PERFORMANCE");
    const memoryFindings = findings.filter(f => f.category === "MEMORY");
    const debtFindings = findings.filter(f => (f.category === "CODE_QUALITY" || f.category === "ARCHITECTURE") && f.id !== "QAL-002");
    const todoFindings = findings.filter(f => f.id === "QAL-002" || /TODO/i.test(f.title));

    const totalHigh = findings.filter(f => f.severity === "CRITICAL" || f.severity === "HIGH").length;
    const totalMedium = findings.filter(f => f.severity === "MEDIUM").length;
    const totalLow = findings.filter(f => f.severity === "LOW" || f.severity === "INFO").length;
    const totalIssues = findings.length;

    const securityRows = securityFindings.length === 0
      ? '<tr><td colspan="5" style="text-align: center; color: #64748b; padding: 16px;">No security issues detected.</td></tr>'
      : securityFindings.map(f => `
        <tr>
          <td><code>${f.id}</code></td>
          <td><span class="badge badge-${f.severity.toLowerCase()}">&nbsp;${f.severity}&nbsp;</span></td>
          <td><code>${f.file}</code></td>
          <td style="text-align: center;">${f.line}</td>
          <td><strong>${f.title}</strong>: ${f.description}<br/><em style="font-size: 11px; color: #64748b; display: block; margin-top: 4px;">Risk: ${f.risk}</em></td>
        </tr>
      `).join("\n");

    const performanceRows = performanceFindings.length === 0
      ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No performance issues detected.</td></tr>'
      : performanceFindings.map(f => `
        <tr>
          <td>${path.basename(f.file, path.extname(f.file))}</td>
          <td><code>${f.file}</code></td>
          <td style="text-align: center;">${f.line}</td>
          <td>${f.title}</td>
        </tr>
      `).join("\n");

    const memoryRows = memoryFindings.length === 0
      ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No memory leaks detected.</td></tr>'
      : memoryFindings.map(f => `
        <tr>
          <td><code>${f.id} (${f.severity})</code></td>
          <td><code>${f.file}</code></td>
          <td style="text-align: center;">${f.line}</td>
          <td>${f.title}</td>
        </tr>
      `).join("\n");

    const debtRows = debtFindings.length === 0
      ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No structural debt issues detected.</td></tr>'
      : debtFindings.map(f => `
        <tr>
          <td><code>${f.file}</code></td>
          <td style="text-align: center;">${f.line}</td>
          <td>General Maintenance</td>
          <td>${f.recommendation}</td>
        </tr>
      `).join("\n");

    const todoRows = todoFindings.length === 0
      ? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'
      : todoFindings.map(f => `
        <tr>
          <td><code>${f.file}</code></td>
          <td style="text-align: center;">${f.line}</td>
          <td>${f.evidence}</td>
        </tr>
      `).join("\n");

    const masterPrompt = SolutionGenerator.generateMasterClaudePrompt(findings)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");

    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PDF Download View - Code Quality &amp; Security Audit Report</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #ffffff;
            color: #1e293b;
            line-height: 1.5;
            padding: 40px;
            margin: 0 auto;
            max-width: 900px;
        }

        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px 24px;
            margin-bottom: 30px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 6px;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-primary {
            background-color: #2563eb;
            color: #ffffff;
        }

        .btn-secondary {
            background-color: #ffffff;
            border-color: #cbd5e1;
            color: #334155;
        }

        .header-card {
            background-color: #081121;
            border-radius: 8px;
            color: #ffffff;
            padding: 30px 24px;
            margin-bottom: 30px;
        }

        .header-card h1 {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            color: #ffffff;
        }

        .header-card p {
            font-size: 13px;
            color: #94a3b8;
            margin: 6px 0 0 0;
        }

        .meta-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 15px;
        }

        .meta-col {
            flex: 1;
            min-width: 120px;
            display: flex;
            flex-direction: column;
        }

        .meta-label {
            font-size: 10px;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }

        .meta-val {
            font-size: 13px;
            color: #f1f5f9;
            font-weight: 600;
        }

        h2 {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            margin-top: 30px;
            margin-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 6px;
            page-break-after: avoid;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
            font-size: 12px;
        }

        th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 10px;
            letter-spacing: 0.03em;
            text-align: left;
            padding: 10px 12px;
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 10px 12px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: top;
        }

        tr:nth-child(even) td {
            background-color: #f8fafc;
        }

        code {
            font-family: Menlo, Monaco, Consolas, monospace;
            background-color: #f1f5f9;
            padding: 2px 4px;
            border-radius: 4px;
            font-size: 11px;
            color: #0f172a;
        }

        .badge {
            display: inline-block;
            font-weight: 700;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 4px;
            text-transform: uppercase;
        }

        .badge-critical, .badge-high {
            background-color: #fee2e2;
            color: #b91c1c;
        }

        .badge-medium {
            background-color: #fef3c7;
            color: #b45309;
        }

        .badge-low {
            background-color: #dcfce7;
            color: #15803d;
        }

        .action-box {
            background-color: #eff6ff;
            border-left: 4px solid #3b82f6;
            border-radius: 0 4px 4px 0;
            padding: 14px 18px;
            margin-bottom: 24px;
        }

        .action-box-title {
            font-size: 12px;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 8px;
        }

        .action-box ul {
            margin: 0;
            padding-left: 20px;
            font-size: 12px;
            color: #1e40af;
        }

        .code-box {
            background-color: #0f172a;
            border-radius: 6px;
            padding: 16px;
            margin-top: 10px;
            margin-bottom: 24px;
            overflow-x: auto;
        }

        .code-box pre {
            margin: 0;
            font-family: Menlo, Monaco, Consolas, monospace;
            font-size: 11px;
            color: #cbd5e1;
            line-height: 1.5;
        }

        @media print {
            .action-bar { display: none !important; }
            body { padding: 0; max-width: 100%; }
        }
    </style>
</head>
<body>
    <div class="action-bar">
        <div>
            <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.2rem;">
                <span style="background: #0f172a; color: white; font-size: 0.7rem; font-weight: 800; padding: 0.2rem 0.5rem; border-radius: 4px; text-transform: uppercase;">File 2 of 2</span>
                <span style="font-weight: 700; color: #0f172a; font-size: 1rem;">📄 Print-Ready Audit Document (security-report-pdf.html)</span>
            </div>
            <p style="font-size: 0.8rem; color: #64748b; margin: 0;">Formatted A4 layout with Executive Summary tables &amp; 3-Phase Action Plan.</p>
        </div>
        <div style="display: flex; gap: 0.5rem; align-items: center;">
            <a class="btn btn-secondary" href="security-report.html">📊 Interactive Dashboard</a>
            <button class="btn btn-primary" onclick="window.print()">🖨️ Save as PDF / Print</button>
        </div>
    </div>

    <div id="report-content">
        <div class="header-card">
            <h1>Code Quality &amp; Security Audit Report</h1>
            <p>Comprehensive Static Code &amp; Dependency Analysis</p>
            <div class="meta-grid">
                <div class="meta-col">
                    <span class="meta-label">Project</span>
                    <span class="meta-val">${meta.projectName}</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">Score</span>
                    <span class="meta-val">${score.finalScore}/100 (${score.riskLevel})</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">Architecture</span>
                    <span class="meta-val">${meta.detectedArchitecture}</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">State / Network</span>
                    <span class="meta-val">${meta.detectedStateManagement} / ${meta.detectedNetwork}</span>
                </div>
            </div>
        </div>

        <h2>1. Executive Summary &amp; Category Breakdown</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 40%;">Category</th>
                    <th style="text-align: center; width: 20%;">High Severity</th>
                    <th style="text-align: center; width: 20%;">Medium Severity</th>
                    <th style="text-align: center; width: 20%;">Total Issues</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Security &amp; Secrets</td>
                    <td style="text-align: center; color: #b91c1c; font-weight: bold;">${securityFindings.filter(f => f.severity === 'HIGH' || f.severity === 'CRITICAL').length}</td>
                    <td style="text-align: center; color: #b45309;">${securityFindings.filter(f => f.severity === 'MEDIUM').length}</td>
                    <td style="text-align: center; font-weight: bold;">${securityFindings.length}</td>
                </tr>
                <tr>
                    <td>Performance &amp; UI Rendering</td>
                    <td style="text-align: center; color: #b91c1c;">${performanceFindings.filter(f => f.severity === 'HIGH' || f.severity === 'CRITICAL').length}</td>
                    <td style="text-align: center; color: #b45309;">${performanceFindings.filter(f => f.severity === 'MEDIUM').length}</td>
                    <td style="text-align: center; font-weight: bold;">${performanceFindings.length}</td>
                </tr>
                <tr>
                    <td>Memory &amp; Lifecycle Leaks</td>
                    <td style="text-align: center; color: #b91c1c;">${memoryFindings.filter(f => f.severity === 'HIGH' || f.severity === 'CRITICAL').length}</td>
                    <td style="text-align: center; color: #b45309;">${memoryFindings.filter(f => f.severity === 'MEDIUM').length}</td>
                    <td style="text-align: center; font-weight: bold;">${memoryFindings.length}</td>
                </tr>
                <tr style="font-weight: bold; background-color: #f1f5f9 !important;">
                    <td>Total Detected Issues</td>
                    <td style="text-align: center; color: #b91c1c;">${totalHigh}</td>
                    <td style="text-align: center; color: #b45309;">${totalMedium}</td>
                    <td style="text-align: center; color: #2563eb;">${totalIssues}</td>
                </tr>
            </tbody>
        </table>

        <h2>2. Critical Security Findings</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 15%;">Rule ID</th>
                    <th style="width: 12%;">Severity</th>
                    <th style="width: 30%;">File Location</th>
                    <th style="text-align: center; width: 8%;">Line</th>
                    <th style="width: 35%;">Finding Details</th>
                </tr>
            </thead>
            <tbody>
                ${securityRows}
            </tbody>
        </table>

        <h2>3. Memory &amp; Resource Leaks</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 25%;">Issue Type</th>
                    <th style="width: 45%;">File Path</th>
                    <th style="text-align: center; width: 10%;">Line</th>
                    <th style="width: 20%;">Hazard</th>
                </tr>
            </thead>
            <tbody>
                ${memoryRows}
            </tbody>
        </table>

        <h2>4. High-Priority Performance Flaws</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 25%;">Component</th>
                    <th style="width: 45%;">File Path</th>
                    <th style="text-align: center; width: 10%;">Line</th>
                    <th style="width: 20%;">Issue Description</th>
                </tr>
            </thead>
            <tbody>
                ${performanceRows}
            </tbody>
        </table>

        <h2>5. Class Bloat &amp; Technical Debt (LOC > 500)</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 45%;">File Location</th>
                    <th style="text-align: center; width: 10%;">Line</th>
                    <th style="width: 20%;">Focus Area</th>
                    <th style="width: 25%;">Recommendation</th>
                </tr>
            </thead>
            <tbody>
                ${debtRows}
            </tbody>
        </table>

        <h2>6. Recommended 3-Phase Action Plan</h2>
        <div style="font-size: 12px; margin-bottom: 16px;">
            <strong>Phase 1 — Hotfix (Days 1–2):</strong>
            <ul style="margin: 4px 0 12px 0; padding-left: 20px;">
                <li>Migrate hardcoded credentials and cleartext HTTP endpoints to HTTPS and secure storage.</li>
                <li>Disable android:usesCleartextTraffic and iOS ATS arbitrary load exceptions in production.</li>
            </ul>
            <strong>Phase 2 — Performance &amp; Memory (Days 3–5):</strong>
            <ul style="margin: 4px 0 12px 0; padding-left: 20px;">
                <li>Add dispose() lifecycle methods to cancel active StreamSubscriptions, Timers, and TextEditingControllers.</li>
                <li>Convert eager ListView widgets to ListView.builder() to reduce memory allocations during scroll.</li>
            </ul>
            <strong>Phase 3 — Refactoring &amp; Technical Debt (Week 2):</strong>
            <ul style="margin: 4px 0 0 0; padding-left: 20px;">
                <li>Split files exceeding 500 lines into focused sub-widgets and dedicated controller services.</li>
            </ul>
        </div>

        <h2>7. Master Claude AI Batch Fix Command</h2>
        <div class="code-box">
            <pre><code>${masterPrompt}</code></pre>
        </div>
    </div>
</body>
</html>`;
  }
}

// ============================================================================
// Helper Utilities
// ============================================================================

function listFilesRecursively(dir: string, allowedExtensions: string[]): string[] {
  const results: string[] = [];
  if (!fs.existsSync(dir)) return results;

  const ignoreDirs = new Set([
    "node_modules", ".git", ".dart_tool", "build", "dist", ".gradle", ".idea", "reports", "test", "coverage"
  ]);

  function traverse(current: string) {
    try {
      const entries = fs.readdirSync(current, { withFileTypes: true });
      for (const entry of entries) {
        const fullPath = path.join(current, entry.name);
        if (entry.isDirectory()) {
          if (!ignoreDirs.has(entry.name)) {
            traverse(fullPath);
          }
        } else if (entry.isFile()) {
          const ext = path.extname(entry.name).toLowerCase();
          if (allowedExtensions.includes(ext) || entry.name.startsWith(".env")) {
            results.push(fullPath);
          }
        }
      }
    } catch { }
  }

  traverse(dir);
  return results;
}

function listDirs(dir: string): string[] {
  if (!fs.existsSync(dir)) return [];
  try {
    return fs.readdirSync(dir, { withFileTypes: true })
      .filter(e => e.isDirectory())
      .map(e => e.name);
  } catch {
    return [];
  }
}

function maskSecret(secret: string): string {
  if (secret.length <= 8) return "[MASKED]";
  return `${secret.substring(0, 4)}...[MASKED]...${secret.substring(secret.length - 4)}`;
}

// ============================================================================
// Tool Definitions (All share unified prefix: nic_architect_)
// ============================================================================

export const ALL_TOOLS: Tool[] = [
  // 5 Exact Required MCPHub Settings Tools
  {
    name: "nic_architect_configure",
    description: "Configures settings, parameters, and credentials for the nic-architect plugin.",
    inputSchema: {
      type: "object",
      properties: {
        scanLevel: { type: "string", description: "Default scan level (quick, standard, full, deep)." },
        generateReport: { type: "boolean", description: "Whether to generate report artifacts." },
        defaultProjectPath: { type: "string", description: "Default project directory path." },
        apiKey: { type: "string", description: "Optional API Key or access token." },
      },
    },
  },
  {
    name: "nic_architect_status",
    description: "Returns the operational status, version, and active settings of the nic-architect plugin.",
    inputSchema: {
      type: "object",
      properties: {},
    },
  },
  {
    name: "nic_architect_remove",
    description: "Removes saved configuration and resets the nic-architect plugin.",
    inputSchema: {
      type: "object",
      properties: {},
    },
  },
  {
    name: "nic_architect_health_check",
    description: "Performs a health check on the nic-architect plugin.",
    inputSchema: {
      type: "object",
      properties: {},
    },
  },
  {
    name: "nic_architect_get_logs",
    description: "Retrieves recent execution and audit logs from the nic-architect plugin.",
    inputSchema: {
      type: "object",
      properties: {
        lines: { type: "number", description: "Number of log lines to retrieve (default: 50)." },
      },
    },
  },

  // Audit & Scanner Tools
  {
    name: "nic_architect_analyze_project",
    description: "Audits any codebase (Flutter/Dart, Node.js, Vue.js, Laravel PHP, Python, or auto-detect) for quality, security, memory, and performance.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to analyze." },
        technology: { type: "string", description: "Target technology: flutter, node, vue, laravel, python, or auto." },
        scanLevel: { type: "string", description: "Audit depth: quick, standard, full, deep." },
        generateReport: { type: "boolean", description: "Set true to generate interactive HTML report artifact." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_security_scan",
    description: "Performs complete security checks including secrets, network configs, cleartext traffic, and platform files.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to scan." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_secret_scan",
    description: "Scans source files for hardcoded API keys, private keys, JWTs, and cloud credentials.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to scan." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_memory_scan",
    description: "Performs static lifecycle analysis to discover unclosed streams, timers, and undisposed controllers.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to scan." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_performance_scan",
    description: "Statically inspects build methods, observer models, and list views for rendering and CPU bottlenecks.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to scan." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_code_quality_scan",
    description: "Checks class sizing, method complexity, debug print statements, and architectural violations.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to scan." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_detect_architecture",
    description: "Analyzes project source files and structure to detect architectural patterns and confidence score.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the Flutter project." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_android_security_scan",
    description: "Inspects AndroidManifest.xml, network security configurations, and debug flag overrides.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_ios_security_scan",
    description: "Inspects Info.plist, custom URL schemes, and App Transport Security exception permissions.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project." },
      },
      required: ["projectPath"],
    },
  },
  {
    name: "nic_architect_full_audit",
    description: "Runs all static analyzers (security, memory, performance, quality) and generates comprehensive reports with category tabs.",
    inputSchema: {
      type: "object",
      properties: {
        projectPath: { type: "string", description: "Absolute path to the project to audit." },
        generateReport: { type: "boolean", description: "Generate rich HTML audit reports." },
      },
      required: ["projectPath"],
    },
  },
];

// ============================================================================
// MCPHub Plugin Class (Self-Contained Class with all MCPHub contract methods)
// ============================================================================

export default class NicFlutterStructureArchitect {
  readonly name = "nic-flutter-structure-architect";
  readonly displayName = "NIC Flutter & Multi-Tech Architect";
  readonly display_name = "NIC Flutter & Multi-Tech Architect";
  readonly title = "NIC Flutter & Multi-Tech Architect";
  readonly version = "1.0.8";
  readonly description = "Multi-technology codebase auditor for Flutter, Vue projects with interactive tabbed HTML reports.";
  readonly tools: Tool[] = ALL_TOOLS;

  private config: Record<string, any> = {
    scanLevel: "standard",
    generateReport: true,
    defaultProjectPath: ".",
  };
  private sensitiveConfig: Record<string, string> = {};

  constructor() { }

  // 1. Contract Method: getConfigSchema
  getConfigSchema(): z.ZodObject<any> {
    return z.object({
      scanLevel: z.string().default("standard"),
      generateReport: z.boolean().default(true),
      defaultProjectPath: z.string().default("."),
    });
  }

  // 2. Contract Method: getSensitiveConfigFields
  getSensitiveConfigFields(): string[] {
    return ["apiKey"];
  }

  // 3. Contract Method: getConfigMeta
  getConfigMeta(): Record<string, any> {
    return {
      scanLevel: {
        type: "string",
        description: "Default audit depth: quick, standard, full, deep",
        default: "standard",
      },
      generateReport: {
        type: "boolean",
        description: "Whether to generate HTML reports automatically",
        default: true,
      },
      defaultProjectPath: {
        type: "string",
        description: "Default project path for code audits",
        default: ".",
      },
    };
  }

  // 4. Contract Method: healthCheck
  async healthCheck(): Promise<{ status: string; version: string; timestamp: string }> {
    return {
      status: "healthy",
      version: this.version,
      timestamp: new Date().toISOString(),
    };
  }

  // Lifecycle Methods required by MCPHub
  async initialize(context?: any): Promise<void> {
    return Promise.resolve();
  }

  async init(context?: any): Promise<void> {
    return Promise.resolve();
  }

  async setup(context?: any): Promise<void> {
    return Promise.resolve();
  }

  async start(context?: any): Promise<void> {
    return Promise.resolve();
  }

  async destroy(): Promise<void> {
    return Promise.resolve();
  }

  async shutdown(): Promise<void> {
    return Promise.resolve();
  }

  async cleanup(): Promise<void> {
    return Promise.resolve();
  }

  getTools(): Tool[] {
    return this.tools;
  }

  async listTools(): Promise<{ tools: Tool[] }> {
    return { tools: this.tools };
  }

  // 5. Contract Method: handleToolCall (Must throw for unknown tools)
  async handleToolCall(name: string, args: Record<string, any> = {}): Promise<{ content: Array<{ type: string; text: string }>; isError?: boolean }> {
    return this.executeTool(name, args);
  }

  async callTool(name: string, args: Record<string, any> = {}): Promise<{ content: Array<{ type: string; text: string }>; isError?: boolean }> {
    return this.executeTool(name, args);
  }

  async execute(name: string, args: Record<string, any> = {}): Promise<{ content: Array<{ type: string; text: string }>; isError?: boolean }> {
    return this.executeTool(name, args);
  }

  async executeTool(name: string, args: Record<string, any> = {}): Promise<{ content: Array<{ type: string; text: string }>; isError?: boolean }> {
    // 5 Required Settings Tools Handlers
    if (name === "nic_architect_configure") {
      const { apiKey, ...rest } = args;
      if (apiKey) {
        this.sensitiveConfig.apiKey = apiKey;
      }
      this.config = { ...this.config, ...rest };
      return {
        content: [{ type: "text", text: JSON.stringify({ success: true, message: "Configuration updated", settings: this.config }, null, 2) }],
      };
    }

    if (name === "nic_architect_status") {
      return {
        content: [{
          type: "text",
          text: JSON.stringify({
            status: "active",
            plugin: this.name,
            displayName: this.displayName,
            version: this.version,
            configured: true,
            settings: this.config,
          }, null, 2),
        }],
      };
    }

    if (name === "nic_architect_remove") {
      this.config = {
        scanLevel: "standard",
        generateReport: true,
        defaultProjectPath: ".",
      };
      this.sensitiveConfig = {};
      return {
        content: [{ type: "text", text: JSON.stringify({ success: true, message: "Plugin configuration and credentials removed" }, null, 2) }],
      };
    }

    if (name === "nic_architect_health_check") {
      const health = await this.healthCheck();
      return {
        content: [{ type: "text", text: JSON.stringify(health, null, 2) }],
      };
    }

    if (name === "nic_architect_get_logs") {
      const maxLines = typeof args.lines === "number" ? args.lines : 50;
      const sampleLogs = [
        `[${new Date().toISOString()}] [INFO] nic-flutter-structure-architect v${this.version} loaded`,
        `[${new Date().toISOString()}] [INFO] Health status: OK`,
        `[${new Date().toISOString()}] [INFO] Ready for multi-tech architecture & security audits`,
      ].slice(-maxLines);

      return {
        content: [{ type: "text", text: JSON.stringify({ success: true, count: sampleLogs.length, logs: sampleLogs }, null, 2) }],
      };
    }

    // Resolve & sanitize project path
    const rawInputPath = (args.projectPath as string) || (args.path as string) || this.config.defaultProjectPath;
    const projectPath = PathUtils.resolveSafePath(rawInputPath);

    if (name === "nic_architect_analyze_project" || name === "nic_architect_full_audit" || name === "analyze_project" || name === "full_flutter_audit") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{
            type: "text",
            text: `Error: projectPath "${projectPath}" does not exist on this machine.\n` +
              `Note: If you are executing via the MCPHub remote cloud web interface, remote servers cannot access your Mac's local filesystem (/Users/...). ` +
              `To scan local projects, run the local MCP server in Claude Desktop or pass relative paths within the workspace.`
          }],
        };
      }

      const meta = ProjectDetector.detect(projectPath);
      const findings: Finding[] = [
        ...SecretScanner.scan(projectPath),
        ...AndroidScanner.scan(projectPath),
        ...IosScanner.scan(projectPath),
        ...MemoryScanner.scan(projectPath),
        ...PerformanceScanner.scan(projectPath),
        ...CodeQualityScanner.scan(projectPath),
      ];

      const score = calculateScore(findings);
      let reportPaths = { html: "", pdfHtml: "", json: "", markdown: "" };

      if (args.generateReport !== false && this.config.generateReport) {
        reportPaths = await FullReportGenerator.generateAllReports(projectPath, meta, findings, score);
      }

      const result = {
        technology: meta.technology,
        metadata: meta,
        score: score.finalScore,
        riskLevel: score.riskLevel,
        explanation: score.explanation,
        findingsCount: findings.length,
        masterClaudePrompt: SolutionGenerator.generateMasterClaudePrompt(findings),
        findings: findings,
        htmlReportPath: reportPaths.html,
        pdfHtmlReportPath: reportPaths.pdfHtml,
        markdownReportPath: reportPaths.markdown,
        jsonReportPath: reportPaths.json,
      };

      return {
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
      };
    }

    if (name === "nic_architect_security_scan" || name === "security_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = [
        ...SecretScanner.scan(projectPath),
        ...AndroidScanner.scan(projectPath),
        ...IosScanner.scan(projectPath),
      ];
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_secret_scan" || name === "secret_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = SecretScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_android_security_scan" || name === "android_security_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = AndroidScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_ios_security_scan" || name === "ios_security_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = IosScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_memory_scan" || name === "memory_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = MemoryScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_performance_scan" || name === "performance_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = PerformanceScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_code_quality_scan" || name === "code_quality_scan") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const findings = CodeQualityScanner.scan(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(findings, null, 2) }],
      };
    }

    if (name === "nic_architect_detect_architecture" || name === "detect_flutter_architecture") {
      if (!fs.existsSync(projectPath)) {
        return {
          isError: true,
          content: [{ type: "text", text: `Error: projectPath "${projectPath}" does not exist.` }],
        };
      }
      const meta = ProjectDetector.detect(projectPath);
      return {
        content: [{ type: "text", text: JSON.stringify(meta, null, 2) }],
      };
    }

    // REQUIRED by MCPHub contract: Must THROW for unknown tool name
    throw new Error(`Unknown tool: ${name}`);
  }

  async startServer(): Promise<Server> {
    const server = new Server(
      {
        name: this.name,
        version: this.version,
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    server.setRequestHandler(ListToolsRequestSchema, async () => {
      return { tools: this.tools as McpTool[] };
    });

    server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args = {} } = request.params;
      return this.executeTool(name, args);
    });

    const transport = new StdioServerTransport();
    await server.connect(transport);
    return server;
  }
}

// CLI entrypoint when executed directly via node / Claude Desktop:
const isCLI = process.argv[1] && (
  process.argv[1].endsWith("index.js") || 
  process.argv[1].endsWith("index.ts")
);

if (isCLI) {
  const plugin = new NicFlutterStructureArchitect();
  plugin.startServer().catch((err) => {
    console.error("Failed to start stdio server:", err);
  });
}
