import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/security_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/services/criteria_service.dart';
import 'package:flutter_architect_mcp/core/constants/report_constants.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class ReportGenerator {
  final String projectPath;
  final List<Finding> findings;
  final ProjectMetadata metadata;
  final String technologyId;

  ReportGenerator({
    required this.projectPath,
    required List<Finding> findings,
    required this.metadata,
    this.technologyId = 'flutter',
  }) : findings = findings.map((f) => SolutionGenerator.attachSolutionAndPrompt(f)).toList();

  String get technologyName {
    switch (technologyId.toLowerCase()) {
      case 'node': return 'Node.js';
      case 'vue': return 'Vue.js';
      case 'laravel': return 'Laravel';
      case 'python': return 'Python';
      case 'flutter':
      default:
        return 'Flutter';
    }
  }

  Future<Map<String, String>> generateAllReports() async {
    final criteriaService = CriteriaService();
    await criteriaService.initialize();

    final reportsDir = Directory(p.join(projectPath, 'reports', technologyId));
    if (!reportsDir.existsSync()) {
      reportsDir.createSync(recursive: true);
    }

    final scoreDetails = SecurityEngine.calculateScore(findings);

    // 1. JSON Report
    final jsonReportFile = File(p.join(reportsDir.path, 'security-report.json'));
    final jsonMap = {
      'projectPath': projectPath,
      'metadata': metadata.toJson(),
      'score': scoreDetails.finalScore,
      'scoreDetails': {
        'rawScore': scoreDetails.rawScore,
        'criticalCount': scoreDetails.criticalCount,
        'highCount': scoreDetails.highCount,
        'mediumCount': scoreDetails.mediumCount,
        'lowCount': scoreDetails.lowCount,
        'explanation': scoreDetails.explanation,
      },
      'masterClaudePrompt': SolutionGenerator.generateMasterClaudePrompt(findings),
      'findings': findings.map((Finding f) => f.toJson()).toList(),
    };
    await jsonReportFile.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonMap));

    // 2. Markdown Report
    final mdReportFile = File(p.join(reportsDir.path, 'security-report.md'));
    final mdContent = _generateMarkdown(scoreDetails);
    await mdReportFile.writeAsString(mdContent);

    // 3. HTML Report
    final htmlReportFile = File(p.join(reportsDir.path, 'security-report.html'));
    final htmlContent = _generateHtml(scoreDetails);
    await htmlReportFile.writeAsString(htmlContent);

    // 4. PDF HTML View
    final pdfHtmlReportFile = File(p.join(reportsDir.path, 'security-report-pdf.html'));
    final pdfHtmlContent = _generatePdfHtml(scoreDetails);
    await pdfHtmlReportFile.writeAsString(pdfHtmlContent);

    return {
      'json': jsonReportFile.path,
      'markdown': mdReportFile.path,
      'html': htmlReportFile.path,
      'pdfHtml': pdfHtmlReportFile.path,
    };
  }

  String _generateMarkdown(SecurityScoreDetails scoreDetails) {
    final buffer = StringBuffer();
    buffer.writeln('# $technologyName Engineering MCP Analysis Report');
    buffer.writeln('\n## Project Overview');
    buffer.writeln('- **Project Name:** ${metadata.projectName}');
    if (technologyId == 'flutter') {
      buffer.writeln('- **Flutter SDK:** ${metadata.flutterVersion}');
      buffer.writeln('- **Dart SDK:** ${metadata.dartVersion}');
      buffer.writeln('- **State Management:** ${metadata.detectedStateManagement}');
    } else {
      buffer.writeln('- **Runtime/Framework:** ${metadata.dartVersion}');
      if (technologyId == 'vue') {
        buffer.writeln('- **State Management:** ${metadata.detectedStateManagement}');
      }
    }
    buffer.writeln('- **Database:** ${metadata.detectedDatabase}');
    buffer.writeln('- **Router:** ${metadata.detectedRouter}');
    buffer.writeln('- **Network Client:** ${metadata.detectedNetwork}');

    buffer.writeln('\n## Security Score: **${scoreDetails.finalScore}/100**');
    buffer.writeln('```');
    buffer.writeln(scoreDetails.explanation);
    buffer.writeln('```');

    buffer.writeln('\n## Summary of Findings');
    buffer.writeln('- **Critical:** ${scoreDetails.criticalCount}');
    buffer.writeln('- **High:** ${scoreDetails.highCount}');
    buffer.writeln('- **Medium:** ${scoreDetails.mediumCount}');
    buffer.writeln('- **Low:** ${scoreDetails.lowCount}');

    buffer.writeln(_generateMarkdownCriteriaSection());

    if (findings.isNotEmpty) {
      buffer.writeln('\n## 🤖 Master Fix Command for Claude (Fix All Issues)');
      buffer.writeln('Pass this master instruction to Claude to fix all issues in one operation preserving functionality:');
      buffer.writeln('```markdown');
      buffer.writeln(SolutionGenerator.generateMasterClaudePrompt(findings));
      buffer.writeln('```\n');
    }

    buffer.writeln('\n## Detailed Findings List');
    if (findings.isEmpty) {
      buffer.writeln('_No findings detected! Your project passes all architectural, performance, and security checks._');
    } else {
      for (final f in findings) {
        buffer.writeln('\n### [${f.category}] [${f.severity}] ${f.title}');
        buffer.writeln('- **File:** `${f.file}` (Line ${f.line})');
        buffer.writeln('- **Confidence:** ${f.confidence}');
        buffer.writeln('- **Evidence:** `${f.evidence}`');
        buffer.writeln('- **Description:** ${f.description}');
        buffer.writeln('- **Risk:** ${f.risk}');
        buffer.writeln('- **Recommendation:** ${f.recommendation}');
        if (f.suggestedFix.isNotEmpty) {
          buffer.writeln('- **Tailored Code Solution:**\n```\n${f.suggestedFix}\n```');
        }
        if (f.claudePrompt.isNotEmpty) {
          buffer.writeln('- **Claude AI Fix Prompt:**\n```\n${f.claudePrompt}\n```');
        }
        buffer.writeln('- **Auto-Fix Available:** ${f.fixAvailable ? "Yes" : "No"}');
        buffer.writeln('---');
      }
    }

    return buffer.toString();
  }

  String _generateHtmlMetadataSection() {
    final buffer = StringBuffer();
    if (technologyId == 'flutter') {
      buffer.write('''
            <div class="meta-card">
                <div class="meta-label">Flutter SDK</div>
                <div class="meta-value">${metadata.flutterVersion}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">Dart Environment</div>
                <div class="meta-value">${metadata.dartVersion}</div>
            </div>
      ''');
    } else {
      buffer.write('''
            <div class="meta-card">
                <div class="meta-label">Runtime Environment</div>
                <div class="meta-value">${metadata.dartVersion}</div>
            </div>
      ''');
    }

    if (technologyId == 'flutter' || technologyId == 'vue') {
      buffer.write('''
            <div class="meta-card">
                <div class="meta-label">State Management</div>
                <div class="meta-value">${metadata.detectedStateManagement}</div>
            </div>
      ''');
    }

    buffer.write('''
            <div class="meta-card">
                <div class="meta-label">Router</div>
                <div class="meta-value">${metadata.detectedRouter}</div>
            </div>
            <div class="meta-card">
                <div class="meta-label">Network & Database</div>
                <div class="meta-value">${metadata.detectedNetwork} / ${metadata.detectedDatabase}</div>
            </div>
    ''');
    return buffer.toString();
  }

  String _generateHtml(SecurityScoreDetails scoreDetails) {
    final findingsJson = jsonEncode(findings.map((Finding f) => f.toJson()).toList());

    return '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${technologyName} Advanced Audit Report - ${metadata.projectName}</title>
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
            max-width: 550px; 
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
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
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
                    <strong>What this file includes:</strong> Live interactive severity/category filters, detailed vulnerability &amp; memory leak cards, 1-click Claude fix prompt copy buttons, and Master &quot;Fix All with AI&quot; prompt modal.
                </p>
            </div>
            <div style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                <a href="security-report-pdf.html" style="display: inline-flex; align-items: center; gap: 0.35rem; background: #1e293b; border: 1px solid var(--border); color: #cbd5e1; text-decoration: none; font-size: 0.8rem; font-weight: 600; padding: 0.5rem 1rem; border-radius: 6px; transition: all 0.2s;" onmouseover="this.style.borderColor='var(--primary)'" onmouseout="this.style.borderColor='var(--border)'">
                    📄 Open Print-Ready Document View (security-report-pdf.html) &rarr;
                </a>
            </div>
        </div>

        <header>
            <div>
                <h1>${technologyName} Advanced Engineering Audit</h1>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">Automated security, architectural, and lifecycle audit report</p>
            </div>
            <div style="text-align: right;">
                <p style="font-weight: bold;">Date: ${DateTime.now().toLocal().toString().split('.')[0]}</p>
                <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 0.5rem;">Project Name: ${metadata.projectName}</p>
                <div style="display: flex; gap: 0.5rem; justify-content: flex-end; align-items: center; flex-wrap: wrap;">
                    <button onclick="openMasterPromptModal()" style="display: inline-block; background: linear-gradient(135deg, #818cf8 0%, #38bdf8 100%); color: #0b0f19; font-weight: bold; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; border: none; cursor: pointer; transition: opacity 0.2s;" onmouseover="this.style.opacity='0.9'" onmouseout="this.style.opacity='1'">🤖 Fix All with Claude</button>
                    <button onclick="window.print()" style="display: inline-block; background-color: var(--primary); color: #0b0f19; font-weight: 700; border: none; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; cursor: pointer; transition: opacity 0.2s;" onmouseover="this.style.opacity='0.9'" onmouseout="this.style.opacity='1'">🖨️ Download / Print PDF</button>
                    <a href="security-report-pdf.html" style="display: inline-block; background: #1e293b; border: 1px solid var(--border); color: #cbd5e1; font-weight: 600; text-decoration: none; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; transition: all 0.2s;" onmouseover="this.style.borderColor='var(--primary)'" onmouseout="this.style.borderColor='var(--border)'">📄 Print-Ready View</a>
                    <button onclick="openEmailModal()" style="display: inline-block; background-color: #22c55e; color: #0b0f19; font-weight: 600; text-decoration: none; font-size: 0.8rem; padding: 0.45rem 1rem; border-radius: 6px; border: none; cursor: pointer; transition: opacity 0.2s;" onmouseover="this.style.opacity='0.9'" onmouseout="this.style.opacity='1'">Send via Email</button>
                </div>
            </div>
        </header>

        <section class="metadata-grid">
            ${_generateHtmlMetadataSection()}
        </section>

        ${_generateHtmlCriteriaSection()}

        <div style="margin-bottom: 2rem; background: rgba(56, 189, 248, 0.05); padding: 0.75rem 1rem; border-radius: 8px; border: 1px solid var(--border); font-size: 0.85rem; display: flex; justify-content: space-between; align-items: center;">
            <span>📋 <strong style="color: var(--primary); cursor: pointer;" onclick="openEmailModal()">${ReportConstants.criteriaMessage}</strong></span>
            <div style="display: flex; gap: 0.75rem;">
                <button onclick="openMasterPromptModal()" style="background: none; border: none; color: #818cf8; font-weight: bold; cursor: pointer; text-decoration: underline;">🤖 Fix All Issues with AI</button>
                <button onclick="openEmailModal()" style="background: none; border: none; color: var(--primary); font-weight: bold; cursor: pointer; text-decoration: underline;">Review & Send</button>
            </div>
        </div>

        <section class="dashboard">
            <div class="score-card">
                <div class="score-circle">${scoreDetails.finalScore}</div>
                <h3 style="font-size: 1.25rem; margin-bottom: 0.25rem;">Overall Audit Score</h3>
                <p style="color: var(--text-muted); font-size: 0.85rem;">Capped 0 - 100 scale</p>
            </div>
            <div class="stats-card">
                <h3 class="stats-title">Audit Findings Summary</h3>
                <div class="stats-grid">
                    <div class="stat-box critical">
                        <div class="stat-num">${scoreDetails.criticalCount}</div>
                        <div class="stat-lbl">Critical</div>
                    </div>
                    <div class="stat-box high">
                        <div class="stat-num">${scoreDetails.highCount}</div>
                        <div class="stat-lbl">High</div>
                    </div>
                    <div class="stat-box medium">
                        <div class="stat-num">${scoreDetails.mediumCount}</div>
                        <div class="stat-lbl">Medium</div>
                    </div>
                    <div class="stat-box low">
                        <div class="stat-num">${scoreDetails.lowCount}</div>
                        <div class="stat-lbl">Low</div>
                    </div>
                </div>
                <div style="margin-top: 1.5rem; font-size: 0.85rem; color: var(--text-muted); background: rgba(0,0,0,0.2); padding: 1rem; border-radius: 8px;">
                    <strong>Scoring Rationale:</strong><br>
                    ${scoreDetails.explanation.replaceAll('\n', '<br>')}
                </div>
            </div>
        </section>

        <section style="margin-bottom: 2rem;">
            <h3 style="font-size: 1.25rem; margin-bottom: 1rem; display: flex; align-items: center; justify-content: space-between;">
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

            // 1. Synchronous textarea copy inside the user gesture event loop
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

            // 2. Also attempt modern clipboard API if supported
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
            } else {
                const codeEl = document.getElementById('prompt_code_' + index);
                if (codeEl) {
                    copyText(codeEl.innerText, btn);
                }
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
                container.innerHTML = `
                    <div class="empty-state">
                        <h4>No findings match the current filter selection.</h4>
                        <p style="margin-top: 0.5rem; font-size: 0.9rem;">Great job! No unresolved issues found in this view.</p>
                    </div>
                `;
                return;
            }

            filtered.forEach((f, idx) => {
                const item = document.createElement('div');
                item.className = 'finding-item ' + f.severity.toLowerCase();

                let solutionHtml = '';
                if (f.suggestedFix && f.suggestedFix.trim().length > 0) {
                    solutionHtml = `
                        <div class="solution-box">
                            <div class="solution-title">💡 Tailored Code Solution</div>
                            <pre style="color: #4ade80;"><code>` + escapeHtml(f.suggestedFix) + `</code></pre>
                        </div>
                    `;
                }

                let promptHtml = '';
                if (f.claudePrompt && f.claudePrompt.trim().length > 0) {
                    const originalIdx = findings.indexOf(f);
                    promptHtml = `
                        <div class="prompt-box">
                            <div class="prompt-title">
                                <span>🤖 Claude AI Fix Prompt</span>
                                <button class="copy-btn" onclick="copyFindingPrompt(` + originalIdx + `, this)">📋 Copy Prompt</button>
                            </div>
                            <pre style="color: #cbd5e1; max-height: 180px; overflow-y: auto;"><code id="prompt_code_` + originalIdx + `">` + escapeHtml(f.claudePrompt) + `</code></pre>
                        </div>
                    `;
                }

                item.innerHTML = `
                    <div class="finding-header">
                        <div class="finding-title-group">
                            <span class="badge ` + f.severity.toLowerCase() + `">` + f.severity + `</span>
                            <span class="badge category">` + f.category + `</span>
                            <h4 class="finding-title">` + f.title + `</h4>
                        </div>
                        <span style="font-size: 0.85rem; font-weight: bold; color: var(--text-muted)">ID: ` + f.id + `</span>
                    </div>

                    <div class="finding-meta">
                        <span><strong>File:</strong> ` + f.file + ` (Line ` + f.line + `)</span>
                        <span><strong>Confidence:</strong> ` + f.confidence + `</span>
                        ` + (f.fixAvailable ? '<span style="color: var(--low); font-weight: bold;">(Auto-Fix Available)</span>' : '') + `
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Evidence</div>
                        <pre><code>` + escapeHtml(f.evidence) + `</code></pre>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Description</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem;">` + f.description.replace(/\\n/g, '<br>') + `</p>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Risk Analysis</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem;">` + f.risk + `</p>
                    </div>

                    <div class="finding-section">
                        <div class="section-title">Recommendation</div>
                        <p style="font-size: 0.95rem; margin-top: 0.25rem; white-space: pre-line;">` + f.recommendation + `</p>
                    </div>

                    ` + solutionHtml + `
                    ` + promptHtml + `
                `;
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
            updateButtonState('filter-btn', sev, [ 'ALL', 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW' ]);
            renderFindings();
        }

        function filterCategory(cat) {
            currentCategory = cat;
            updateButtonState('filter-btn', cat, [ 'ALL', 'SECURITY', 'MEMORY', 'PERFORMANCE', 'CODE_QUALITY', 'DEPENDENCY' ]);
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

        // Email Sending JavaScript Functions
        function openEmailModal() {
            document.getElementById('emailModal').style.display = 'flex';
            document.getElementById('emailFeedback').style.display = 'none';
        }

        function closeEmailModal() {
            document.getElementById('emailModal').style.display = 'none';
        }

        async function sendEmailReport() {
            const to = document.getElementById('emailTo').value.trim();
            const subject = document.getElementById('emailSubject').value.trim();
            const body = document.getElementById('emailBody').value.trim();
            const feedback = document.getElementById('emailFeedback');
            const btn = document.getElementById('btnSendEmail');
            
            if (!to) {
                feedback.style.display = 'block';
                feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.15)';
                feedback.style.border = '1px solid #ef4444';
                feedback.style.color = '#ef4444';
                feedback.innerText = 'Please enter a valid recipient email address.';
                return;
            }
            
            btn.disabled = true;
            btn.innerText = 'Compiling PDF...';
            feedback.style.display = 'block';
            feedback.style.backgroundColor = 'rgba(56, 189, 248, 0.15)';
            feedback.style.border = '1px solid #38bdf8';
            feedback.style.color = '#38bdf8';
            feedback.innerText = 'Generating PDF report in browser...';
            
            try {
                const element = document.querySelector('.container');
                const opt = {
                    margin: 10,
                    filename: 'security-report.pdf',
                    image: { type: 'jpeg', quality: 0.98 },
                    html2canvas: { scale: 1.5, useCORS: true },
                    jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
                };
                
                document.getElementById('emailModal').style.display = 'none';
                document.getElementById('masterPromptModal').style.display = 'none';
                
                html2pdf().from(element).set(opt).output('datauristring').then(async function(pdfDataUri) {
                    document.getElementById('emailModal').style.display = 'flex';
                    btn.innerText = 'Sending email...';
                    feedback.innerText = 'Sending email payload to server...';
                    
                    const pdfBase64 = pdfDataUri.split(',')[1];
                    const payload = {
                        to: to,
                        subject: subject,
                        body: body,
                        pdfBase64: pdfBase64,
                        filename: 'security-report.pdf'
                    };
                    
                    const ports = [8080, 8089, 8081, 9000];
                    let success = false;
                    let resMsg = '';
                    
                    for (const port of ports) {
                        try {
                            const response = await fetch(`http://localhost:\${port}/api/send-email`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(payload)
                            });
                            if (response.ok) {
                                const resData = await response.json();
                                success = true;
                                resMsg = resData.message || 'Email successfully sent.';
                                break;
                            }
                        } catch (_) {}
                    }
                    
                    btn.disabled = false;
                    btn.innerText = 'Send Report';
                    
                    if (success) {
                        feedback.style.backgroundColor = 'rgba(34, 197, 94, 0.15)';
                        feedback.style.border = '1px solid #22c55e';
                        feedback.style.color = '#22c55e';
                        feedback.innerText = resMsg;
                        setTimeout(closeEmailModal, 3000);
                    } else {
                        feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.15)';
                        feedback.style.border = '1px solid #ef4444';
                        feedback.style.color = '#ef4444';
                        feedback.innerText = 'Failed to connect to local MCP Performance server. Please ensure the server is running.';
                    }
                }).catch(function(err) {
                    document.getElementById('emailModal').style.display = 'flex';
                    btn.disabled = false;
                    btn.innerText = 'Send Report';
                    feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.15)';
                    feedback.style.border = '1px solid #ef4444';
                    feedback.style.color = '#ef4444';
                    feedback.innerText = 'Error compiling PDF: ' + err.toString();
                });
            } catch (e) {
                document.getElementById('emailModal').style.display = 'flex';
                btn.disabled = false;
                btn.innerText = 'Send Report';
                feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.15)';
                feedback.style.border = '1px solid #ef4444';
                feedback.style.color = '#ef4444';
                feedback.innerText = 'Error: ' + e.toString();
            }
        }

        // Initial load
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
                <textarea id="masterPromptText" class="form-control" rows="14" style="font-family: 'Courier New', monospace; font-size: 0.8rem; resize: vertical;" readonly>${SolutionGenerator.generateMasterClaudePrompt(findings).replaceAll('<', '&lt;').replaceAll('>', '&gt;')}</textarea>
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem;">
                <button onclick="closeMasterPromptModal()" class="copy-btn" style="padding: 0.55rem 1.25rem;">Close</button>
                <button onclick="copyMasterPrompt(this)" style="padding: 0.55rem 1.5rem; border-radius: 8px; border: none; background: linear-gradient(135deg, #818cf8 0%, #38bdf8 100%); color: #0b0f19; font-weight: bold; font-size: 0.85rem; cursor: pointer;">📋 Copy Master Prompt</button>
            </div>
        </div>
    </div>

    <!-- Email Modal HTML -->
    <div id="emailModal" class="modal">
        <div class="modal-content">
            <span onclick="closeEmailModal()" class="modal-close">&times;</span>
            <h2 style="font-size: 1.25rem; color: var(--text-color); margin-bottom: 1.25rem; border-bottom: 1px solid var(--border); padding-bottom: 0.5rem;">Send Audit Report</h2>
            
            <div class="form-group">
                <label>To (Recipient Email)</label>
                <input type="email" id="emailTo" class="form-control" placeholder="developer/client email address..." required>
            </div>
            
            <div class="form-group">
                <label>Subject</label>
                <input type="text" id="emailSubject" class="form-control" value="Audit Report: ${metadata.projectName}" required>
            </div>
            
            <div class="form-group">
                <label>Message Summary</label>
                <textarea id="emailBody" class="form-control" rows="8" style="font-family: sans-serif; resize: vertical;">Hello,

Please find attached the security and code quality audit report for the project "${metadata.projectName}".

Audit Summary:
- Security Score: ${scoreDetails.finalScore}/100
- Total Findings: ${findings.length}
- Detected Architecture: ${metadata.detectedArchitecture}
- Detected State Management: ${metadata.detectedStateManagement}

All review criteria are added in the sheet. Please check and review the attached PDF report.

Best regards,
Flutter Architect MCP Analyzer</textarea>
            </div>
            
            <div id="emailFeedback" style="padding: 0.75rem; border-radius: 8px; font-size: 0.85rem; margin-bottom: 1.25rem; display: none;"></div>
            
            <div style="display: flex; justify-content: flex-end; gap: 0.75rem;">
                <button onclick="closeEmailModal()" style="padding: 0.55rem 1.25rem; border-radius: 8px; border: 1px solid var(--border); background-color: transparent; color: var(--text-color); font-size: 0.85rem; cursor: pointer; font-weight: 600;">Cancel</button>
                <button onclick="sendEmailReport()" id="btnSendEmail" style="padding: 0.55rem 1.5rem; border-radius: 8px; border: none; background-color: var(--primary); color: #0b0f19; font-weight: bold; font-size: 0.85rem; cursor: pointer; box-shadow: 0 4px 10px rgba(56, 189, 248, 0.2);">Send Report</button>
            </div>
        </div>
    </div>
</body>
</html>
''';
  }

  String _generatePdfHtml(SecurityScoreDetails scoreDetails) {
    // 1. Calculate category counts
    int countSecurityHigh = 0, countSecurityMedium = 0, countSecurityLow = 0;
    int countPerfHigh = 0, countPerfMedium = 0, countPerfLow = 0;
    int countMemHigh = 0, countMemMedium = 0, countMemLow = 0;
    int countMaintHigh = 0, countMaintMedium = 0, countMaintLow = 0;

    for (final f in findings) {
      final isHigh = f.severity == 'CRITICAL' || f.severity == 'HIGH';
      final isMedium = f.severity == 'MEDIUM';
      final isLow = f.severity == 'LOW';

      if (f.category == 'SECURITY' || f.category == 'DEPENDENCY') {
        if (isHigh) countSecurityHigh++;
        if (isMedium) countSecurityMedium++;
        if (isLow) countSecurityLow++;
      } else if (f.category == 'PERFORMANCE') {
        if (isHigh) countPerfHigh++;
        if (isMedium) countPerfMedium++;
        if (isLow) countPerfLow++;
      } else if (f.category == 'MEMORY') {
        if (isHigh) countMemHigh++;
        if (isMedium) countMemMedium++;
        if (isLow) countMemLow++;
      } else if (f.category == 'CODE_QUALITY' || f.category == 'ARCHITECTURE') {
        if (isHigh) countMaintHigh++;
        if (isMedium) countMaintMedium++;
        if (isLow) countMaintLow++;
      }
    }

    final totalHigh = countSecurityHigh + countPerfHigh + countMemHigh + countMaintHigh;
    final totalMedium = countSecurityMedium + countPerfMedium + countMemMedium + countMaintMedium;
    final totalLow = countSecurityLow + countPerfLow + countMemLow + countMaintLow;
    final totalIssues = totalHigh + totalMedium + totalLow;

    // Helper functions inside the render scope
    String guessComponent(String filePath) {
      final name = p.basenameWithoutExtension(filePath);
      final parts = name.split('_');
      return parts.map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join(' ');
    }

    String getLines(Finding f) {
      if (f.id == 'QAL-001') {
        final match = RegExp(r'\d+').firstMatch(f.evidence);
        if (match != null) return match.group(0)!;
      }
      return '-';
    }

    String getFocusArea(String filePath) {
      if (filePath.contains('/screens/') || filePath.contains('/views/')) {
        return 'UI / View';
      } else if (filePath.contains('/bloc/') || filePath.contains('/provider/') || filePath.contains('/controller/')) {
        return 'Business Logic';
      } else if (filePath.contains('/utils/') || filePath.contains('/helpers/')) {
        return 'Utility Helpers';
      } else if (filePath.contains('/models/')) {
        return 'Data Model';
      } else if (filePath.contains('pubspec.')) {
        return 'Configuration';
      }
      return 'General';
    }

    // 2. Format findings lists
    final securityFindings = findings.where((f) => f.category == 'SECURITY' || f.category == 'DEPENDENCY').toList();
    final performanceFindings = findings.where((f) => f.category == 'PERFORMANCE').toList();
    final memoryFindings = findings.where((f) => f.category == 'MEMORY').toList();
    final debtFindings = findings.where((f) => (f.category == 'CODE_QUALITY' || f.category == 'ARCHITECTURE') && f.id != 'QAL-002').toList();
    final todoFindings = findings.where((f) => f.id == 'QAL-002').toList();

    // Remediation recommendations
    final securityRemediations = securityFindings
        .map((f) => f.recommendation)
        .where((r) => r.isNotEmpty)
        .toSet()
        .toList();

    if (securityRemediations.isEmpty) {
      if (technologyId == 'flutter') {
        securityRemediations.addAll([
          'Migrate user credentials to flutter_secure_storage (backed by Android Keystore and iOS Keychain).',
          'Pass external API keys during build using --dart-define or flutter_dotenv. Apply HTTP/Package SHA-1 restrictions in the Google Cloud Console.'
        ]);
      } else {
        securityRemediations.addAll([
          'Migrate user credentials and sensitive application keys to environment variables (.env files) or vault services.',
          'Never store secrets or private tokens in frontend templates or client-side assets.'
        ]);
      }
    }

    final securityRows = securityFindings.isEmpty
        ? '<tr><td colspan="5" style="text-align: center; color: #64748b; padding: 16px;">No security issues detected.</td></tr>'
        : securityFindings.map((f) => '''
            <tr>
              <td><code>${f.id}</code></td>
              <td><span class="badge badge-${f.severity.toLowerCase()}">&nbsp;${f.severity}&nbsp;</span></td>
              <td><code>${f.file}</code></td>
              <td style="text-align: center;">${f.line}</td>
              <td><strong>${f.title}</strong>: ${f.description}<br/><em style="font-size: 11px; color: #64748b; display: block; margin-top: 4px;">Risk: ${f.risk}</em></td>
            </tr>
          ''').join('\n');

    final performanceRows = performanceFindings.isEmpty
        ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No performance issues detected.</td></tr>'
        : performanceFindings.map((f) => '''
            <tr>
              <td>${guessComponent(f.file)}</td>
              <td><code>${f.file}</code></td>
              <td style="text-align: center;">${f.line}</td>
              <td>${f.title}</td>
            </tr>
          ''').join('\n');

    final memoryRows = memoryFindings.isEmpty
        ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No memory leaks detected.</td></tr>'
        : memoryFindings.map((f) => '''
            <tr>
              <td><code>${f.id} (${f.severity})</code></td>
              <td><code>${f.file}</code></td>
              <td style="text-align: center;">${f.line}</td>
              <td>${f.title}</td>
            </tr>
          ''').join('\n');

    final debtRows = debtFindings.isEmpty
        ? '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 16px;">No structural debt issues detected.</td></tr>'
        : debtFindings.map((f) => '''
            <tr>
              <td><code>${f.file}</code></td>
              <td style="text-align: center;">${getLines(f)}</td>
              <td>${getFocusArea(f.file)}</td>
              <td>${f.recommendation}</td>
            </tr>
          ''').join('\n');

    final todoRows = todoFindings.isEmpty
        ? '<tr><td colspan="3" style="text-align: center; color: #64748b; padding: 16px;">No unresolved TODO comments detected.</td></tr>'
        : todoFindings.map((f) => '''
            <tr>
              <td><code>${f.file}</code></td>
              <td style="text-align: center;">${f.line}</td>
              <td>${f.description.replaceAll('Found a developer note: ', '').replaceAll('"', '')}</td>
            </tr>
          ''').join('\n');

    // Build phases for action plan
    final phase1Items = securityFindings.isEmpty
        ? '<li>No security hotfixes required. Basic security hygiene maintained.</li>'
        : securityFindings.take(3).map((f) => '<li>${f.recommendation}</li>').join('\n');

    final phase2Items = (performanceFindings.isNotEmpty || memoryFindings.isNotEmpty)
        ? [
            ...performanceFindings.take(2).map((f) => '<li>${f.recommendation}</li>'),
            ...memoryFindings.take(2).map((f) => '<li>${f.recommendation}</li>')
          ].take(3).join('\n')
        : '<li>No high-priority performance or lifecycle leaks to address.</li>';

    final phase3Items = (debtFindings.isNotEmpty || todoFindings.isNotEmpty)
        ? [
            ...debtFindings.take(2).map((f) => '<li>${f.recommendation}</li>'),
            ...todoFindings.take(2).map((f) => '<li>Address pending TODO comments in ${f.file} at line ${f.line}.</li>')
          ].take(3).join('\n')
        : '<li>No code quality or maintainability changes proposed for this phase.</li>';

    return """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PDF Download View - Code Quality & Security Audit Report</title>
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

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .btn-secondary {
            background-color: #ffffff;
            border-color: #cbd5e1;
            color: #334155;
        }

        .btn-secondary:hover {
            background-color: #f8fafc;
            color: #0f172a;
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

        .header-divider {
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            margin: 20px 0;
        }

        .meta-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
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
            font-family: Menlo, Monaco, Consolas, "Courier New", monospace;
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
            page-break-inside: avoid;
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

        .action-box li {
            margin-bottom: 4px;
        }

        .code-box {
            background-color: #0f172a;
            border-radius: 6px;
            padding: 16px;
            margin-top: 10px;
            margin-bottom: 24px;
            overflow-x: auto;
            page-break-inside: avoid;
        }

        .code-box pre {
            margin: 0;
            font-family: Menlo, Monaco, Consolas, "Courier New", monospace;
            font-size: 11px;
            color: #cbd5e1;
            line-height: 1.5;
        }

        .code-box-title {
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            margin-top: 14px;
        }

        .action-plan-section {
            page-break-inside: avoid;
        }

        @media print {
            .action-bar {
                display: none !important;
            }
            body {
                padding: 0;
                max-width: 100%;
            }
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
            background-color: #ffffff; 
            border: 1px solid #cbd5e1; 
            padding: 24px; 
            border-radius: 12px; 
            max-width: 550px; 
            width: 90%; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.15); 
            position: relative;
            animation: modalFadeIn 0.3s ease-out;
            color: #1e293b;
            text-align: left;
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
            color: #64748b; 
            cursor: pointer;
            transition: color 0.2s;
        }
        .modal-close:hover {
            color: #2563eb;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block; 
            font-size: 12px; 
            color: #475569; 
            margin-bottom: 6px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .form-control {
            width: 100%; 
            padding: 10px; 
            border-radius: 8px; 
            border: 1px solid #cbd5e1; 
            background-color: #ffffff; 
            color: #1e293b; 
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-control:focus {
            border-color: #2563eb;
        }
    </style>
</head>
<body>
    <div class="action-bar" style="display: flex; justify-content: space-between; align-items: center; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 0.85rem 1.25rem; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.2rem;">
                <span style="background: #0f172a; color: white; font-size: 0.7rem; font-weight: 800; padding: 0.2rem 0.5rem; border-radius: 4px; text-transform: uppercase;">File 2 of 2</span>
                <span style="font-weight: 700; color: #0f172a; font-size: 1rem;">📄 Print-Ready Audit Document (security-report-pdf.html)</span>
            </div>
            <p style="font-size: 0.8rem; color: #64748b; margin: 0; line-height: 1.4;">
                <strong>What this file includes:</strong> Formatted A4 layout with Executive Summary tables, scoring deduction breakdown, 3-Phase Remediation Action Plan, and Master Claude Batch Fix Prompt.
            </p>
        </div>
        <div style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
            <a class="btn btn-secondary" href="security-report.html" style="font-weight: 600;">📊 Interactive Dashboard</a>
            <button class="btn btn-primary" onclick="window.print()" style="font-weight: 700;">🖨️ Save as PDF / Print</button>
            <button class="btn btn-secondary" onclick="downloadPdf()">📥 Direct PDF Download</button>
            <button class="btn btn-secondary" style="background-color: #22c55e; color: #0b0f19; border: none; font-weight: 600;" onclick="openEmailModal()">Send Email</button>
        </div>
    </div>

    <div id="report-content">
        <div class="header-card">
            <h1>Code Quality & Security Audit Report</h1>
            <p>Comprehensive Static Code & Dependency Analysis</p>
            <div class="header-divider"></div>
            <div class="meta-grid">
                <div class="meta-col">
                    <span class="meta-label">Project</span>
                    <span class="meta-val">${metadata.projectName}</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">Dart SDK</span>
                    <span class="meta-val">${metadata.dartVersion}</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">Target Platforms</span>
                    <span class="meta-val">${metadata.targetPlatforms.isEmpty ? 'Android, iOS' : metadata.targetPlatforms.join(', ')}</span>
                </div>
                <div class="meta-col">
                    <span class="meta-label">State / Network</span>
                    <span class="meta-val">${metadata.detectedStateManagement} / ${metadata.detectedNetwork}</span>
                </div>
            </div>
        </div>

        <h2>1. Executive Summary & Category Breakdown</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 40%;">Category</th>
                    <th style="text-align: center; width: 15%;">High Severity</th>
                    <th style="text-align: center; width: 15%;">Medium Severity</th>
                    <th style="text-align: center; width: 15%;">Low Severity</th>
                    <th style="text-align: center; width: 15%;">Total Issues</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Security & Secrets</td>
                    <td style="text-align: center; color: #b91c1c; font-weight: ${countSecurityHigh > 0 ? '700' : 'normal'};">${countSecurityHigh}</td>
                    <td style="text-align: center; color: #b45309; font-weight: ${countSecurityMedium > 0 ? '700' : 'normal'};">${countSecurityMedium}</td>
                    <td style="text-align: center; color: #15803d; font-weight: ${countSecurityLow > 0 ? '700' : 'normal'};">${countSecurityLow}</td>
                    <td style="text-align: center; font-weight: bold;">${countSecurityHigh + countSecurityMedium + countSecurityLow}</td>
                </tr>
                <tr>
                    <td>Performance & UI Lag</td>
                    <td style="text-align: center; color: #b91c1c; font-weight: ${countPerfHigh > 0 ? '700' : 'normal'};">${countPerfHigh}</td>
                    <td style="text-align: center; color: #b45309; font-weight: ${countPerfMedium > 0 ? '700' : 'normal'};">${countPerfMedium}</td>
                    <td style="text-align: center; color: #15803d; font-weight: ${countPerfLow > 0 ? '700' : 'normal'};">${countPerfLow}</td>
                    <td style="text-align: center; font-weight: bold;">${countPerfHigh + countPerfMedium + countPerfLow}</td>
                </tr>
                <tr>
                    <td>Memory & Lifecycle Leaks</td>
                    <td style="text-align: center; color: #b91c1c; font-weight: ${countMemHigh > 0 ? '700' : 'normal'};">${countMemHigh}</td>
                    <td style="text-align: center; color: #b45309; font-weight: ${countMemMedium > 0 ? '700' : 'normal'};">${countMemMedium}</td>
                    <td style="text-align: center; color: #15803d; font-weight: ${countMemLow > 0 ? '700' : 'normal'};">${countMemLow}</td>
                    <td style="text-align: center; font-weight: bold;">${countMemHigh + countMemMedium + countMemLow}</td>
                </tr>
                <tr>
                    <td>Maintainability & Class Size</td>
                    <td style="text-align: center; color: #b91c1c; font-weight: ${countMaintHigh > 0 ? '700' : 'normal'};">${countMaintHigh}</td>
                    <td style="text-align: center; color: #b45309; font-weight: ${countMaintMedium > 0 ? '700' : 'normal'};">${countMaintMedium}</td>
                    <td style="text-align: center; color: #15803d; font-weight: ${countMaintLow > 0 ? '700' : 'normal'};">${countMaintLow}</td>
                    <td style="text-align: center; font-weight: bold;">${countMaintHigh + countMaintMedium + countMaintLow}</td>
                </tr>
                <tr style="font-weight: bold; background-color: #f1f5f9 !important; border-top: 2px solid #cbd5e1;">
                    <td>Total Detected Issues</td>
                    <td style="text-align: center;">${totalHigh}</td>
                    <td style="text-align: center;">${totalMedium}</td>
                    <td style="text-align: center;">${totalLow}</td>
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
                    <th style="width: 35%;">Finding Details & Risk</th>
                </tr>
            </thead>
            <tbody>
                ${securityRows}
            </tbody>
        </table>

        <div class="action-box">
            <div class="action-box-title">Security Remediation Action Items</div>
            <ul>
                ${securityRemediations.map((r) => '<li>' + r + '</li>').join('\n')}
            </ul>
        </div>

        <h2>3. High-Priority Performance Flaws: Controller in build()</h2>
        <p style="font-size: 11px; color: #64748b; margin-top: -6px; margin-bottom: 12px;">Instantiating controllers inside build() forces memory re-allocations on every frame render, causing UI stutter, dropped text inputs, and lost scroll states.</p>
        <table>
            <thead>
                <tr>
                    <th style="width: 25%;">Component / Area</th>
                    <th style="width: 45%;">File Path</th>
                    <th style="text-align: center; width: 10%;">Line</th>
                    <th style="width: 20%;">Issue Description</th>
                </tr>
            </thead>
            <tbody>
                ${performanceRows}
            </tbody>
        </table>

        <div class="code-box-title">Standard Fix Architecture:</div>
        <div class="code-box">
            <pre><code>class _SafeInputWidgetState extends State&lt;SafeInputWidget&gt; {
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
  Widget build(BuildContext context) =&gt; TextField(controller: _controller);
}</code></pre>
        </div>

        <h2>4. Memory & Resource Leaks</h2>
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

        <h2>5. Class Bloat & Technical Debt (Files > ${CriteriaService().maxLinesOfCode} LOC)</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 45%;">File Location</th>
                    <th style="text-align: center; width: 10%;">Lines</th>
                    <th style="width: 20%;">Category / Focus Area</th>
                    <th style="width: 25%;">Architectural Action</th>
                </tr>
            </thead>
            <tbody>
                ${debtRows}
            </tbody>
        </table>

        <h2>6. Unresolved Production TODOs</h2>
        <table>
            <thead>
                <tr>
                    <th style="width: 60%;">File Path</th>
                    <th style="text-align: center; width: 10%;">Line</th>
                    <th style="width: 30%;">Missing Feature / Incomplete Code</th>
                </tr>
            </thead>
            <tbody>
                ${todoRows}
            </tbody>
        </table>

        <div class="action-plan-section">
            <h2>7. Recommended Action Plan</h2>
            <div style="font-size: 12px; margin-bottom: 12px;">
                <strong>Phase 1 — Hotfix (Days 1–2):</strong>
                <ul style="margin: 4px 0 12px 0; padding-left: 20px;">
                    ${phase1Items}
                </ul>
                
                <strong>Phase 2 — Performance & Memory (Days 3–5):</strong>
                <ul style="margin: 4px 0 12px 0; padding-left: 20px;">
                    ${phase2Items}
                </ul>
                
                <strong>Phase 3 — Refactoring & Debt (Week 2):</strong>
                <ul style="margin: 4px 0 0 0; padding-left: 20px;">
                    ${phase3Items}
                </ul>
            </div>
        </div>

        <div class="action-plan-section">
            <h2>8. Master Claude AI Fix Command (Automated Batch Fix)</h2>
            <p style="font-size: 11px; color: #64748b; margin-top: -6px; margin-bottom: 12px;">Pass the prompt below to Claude to automatically apply non-breaking fixes for all identified findings:</p>
            <div class="code-box">
                <pre><code>${SolutionGenerator.generateMasterClaudePrompt(findings).replaceAll('<', '&lt;').replaceAll('>', '&gt;')}</code></pre>
            </div>
        </div>

        ${_generatePdfCriteriaSection()}
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        function downloadPdf() {
            try {
                if (typeof html2pdf !== 'undefined') {
                    const element = document.getElementById('report-content');
                    const opt = {
                        margin:       [10, 10, 10, 10],
                        filename:     'security-report-${metadata.projectName}.pdf',
                        image:        { type: 'jpeg', quality: 0.98 },
                        html2canvas:  { scale: 2, useCORS: true, logging: false },
                        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
                    };
                    html2pdf().from(element).set(opt).save().catch(function() {
                        window.print();
                    });
                } else {
                    window.print();
                }
            } catch (_) {
                window.print();
            }
        }

        // Email Sending Functions
        function openEmailModal() {
            document.getElementById('emailModal').style.display = 'flex';
            document.getElementById('emailFeedback').style.display = 'none';
        }

        function closeEmailModal() {
            document.getElementById('emailModal').style.display = 'none';
        }

        async function sendEmailReport() {
            const to = document.getElementById('emailTo').value.trim();
            const subject = document.getElementById('emailSubject').value.trim();
            const body = document.getElementById('emailBody').value.trim();
            const feedback = document.getElementById('emailFeedback');
            const btn = document.getElementById('btnSendEmail');
            
            if (!to) {
                feedback.style.display = 'block';
                feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
                feedback.style.border = '1px solid #ef4444';
                feedback.style.color = '#b91c1c';
                feedback.innerText = 'Please enter a valid recipient email address.';
                return;
            }
            
            btn.disabled = true;
            btn.innerText = 'Compiling PDF...';
            feedback.style.display = 'block';
            feedback.style.backgroundColor = 'rgba(37, 99, 235, 0.1)';
            feedback.style.border = '1px solid #2563eb';
            feedback.style.color = '#1d4ed8';
            feedback.innerText = 'Generating PDF report in browser...';
            
            try {
                const element = document.getElementById('report-content');
                
                const opt = {
                    margin:       [15, 15, 15, 15],
                    filename:     'security-report-${metadata.projectName}.pdf',
                    image:        { type: 'jpeg', quality: 0.98 },
                    html2canvas:  { scale: 2, useCORS: true, logging: false },
                    jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
                };
                
                // Hide modal temporarily for PDF capture
                document.getElementById('emailModal').style.display = 'none';
                
                html2pdf().from(element).set(opt).output('datauristring').then(async function(pdfDataUri) {
                    // Show modal again
                    document.getElementById('emailModal').style.display = 'flex';
                    
                    btn.innerText = 'Sending email...';
                    feedback.innerText = 'Sending email payload to server...';
                    
                    const pdfBase64 = pdfDataUri.split(',')[1];
                    const payload = {
                        to: to,
                        subject: subject,
                        body: body,
                        pdfBase64: pdfBase64,
                        filename: 'security-report-${metadata.projectName}.pdf'
                    };
                    
                    // Auto-port discovery for Shelf server
                    const ports = [8080, 8089, 8081, 9000];
                    let success = false;
                    let resMsg = '';
                    
                    for (const port of ports) {
                        try {
                            const response = await fetch(`http://localhost:\${port}/api/send-email`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(payload)
                            });
                            if (response.ok) {
                                const resData = await response.json();
                                success = true;
                                resMsg = resData.message || 'Email successfully sent.';
                                break;
                            }
                        } catch (_) {
                            // Try next port
                        }
                    }
                    
                    btn.disabled = false;
                    btn.innerText = 'Send Report';
                    
                    if (success) {
                        feedback.style.backgroundColor = 'rgba(22, 163, 74, 0.1)';
                        feedback.style.border = '1px solid #16a34a';
                        feedback.style.color = '#15803d';
                        feedback.innerText = resMsg;
                        setTimeout(closeEmailModal, 3000);
                    } else {
                        feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
                        feedback.style.border = '1px solid #ef4444';
                        feedback.style.color = '#b91c1c';
                        feedback.innerText = 'Failed to connect to local MCP Performance server. Please ensure the server is running.';
                    }
                }).catch(function(err) {
                    document.getElementById('emailModal').style.display = 'flex';
                    btn.disabled = false;
                    btn.innerText = 'Send Report';
                    feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
                    feedback.style.border = '1px solid #ef4444';
                    feedback.style.color = '#b91c1c';
                    feedback.innerText = 'Error compiling PDF: ' + err.toString();
                });
            } catch (e) {
                document.getElementById('emailModal').style.display = 'flex';
                btn.disabled = false;
                btn.innerText = 'Send Report';
                feedback.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
                feedback.style.border = '1px solid #ef4444';
                feedback.style.color = '#b91c1c';
                feedback.innerText = 'Error: ' + e.toString();
            }
        }
    </script>

    <!-- Email Modal HTML -->
    <div id="emailModal" class="modal">
        <div class="modal-content">
            <span onclick="closeEmailModal()" class="modal-close">&times;</span>
            <h2 style="font-size: 16px; font-weight: 700; color: #0f172a; margin-bottom: 16px; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px;">Send Audit Report</h2>
            
            <div class="form-group">
                <label>To (Recipient Email)</label>
                <input type="email" id="emailTo" class="form-control" placeholder="developer/client email address..." required>
            </div>
            
            <div class="form-group">
                <label>Subject</label>
                <input type="text" id="emailSubject" class="form-control" value="Audit Report: ${metadata.projectName}" required>
            </div>
            
            <div class="form-group">
                <label>Message Summary</label>
                <textarea id="emailBody" class="form-control" rows="8" style="font-family: sans-serif; resize: vertical;">Hello,

Please find attached the security and code quality audit report for the project "${metadata.projectName}".

Audit Summary:
- Security Score: ${scoreDetails.finalScore}/100
- Total Findings: ${findings.length}
- Detected Architecture: ${metadata.detectedArchitecture}
- Detected State Management: ${metadata.detectedStateManagement}

All review criteria are added in the sheet. Please check and review the attached PDF report.

Best regards,
Flutter Architect MCP Analyzer</textarea>
            </div>
            
            <div id="emailFeedback" style="padding: 10px; border-radius: 8px; font-size: 12px; margin-bottom: 16px; display: none;"></div>
            
            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button onclick="closeEmailModal()" style="padding: 8px 16px; border-radius: 8px; border: 1px solid #cbd5e1; background-color: transparent; color: #475569; font-size: 13px; cursor: pointer; font-weight: 600;">Cancel</button>
                <button onclick="sendEmailReport()" id="btnSendEmail" style="padding: 8px 20px; border-radius: 8px; border: none; background-color: #2563eb; color: #ffffff; font-weight: bold; font-size: 13px; cursor: pointer; box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);">Send Report</button>
            </div>
        </div>
    </div>
</body>
</html>
""";
  }

  String _generateMarkdownCriteriaSection() {
    final criteriaService = CriteriaService();
    final buffer = StringBuffer();
    buffer.writeln('\n## Analysis Criteria Observed');
    buffer.writeln('The analysis was performed based on the following dynamic sheet and local configuration criteria:\n');
    
    final grouped = <String, List<Map<String, String>>>{};
    for (final criteria in criteriaService.sheetCriteria) {
      final category = criteria['Category'] ?? 'General';
      grouped.putIfAbsent(category, () => []).add(criteria);
    }

    for (final category in grouped.keys) {
      buffer.writeln('### $category');
      for (final criteria in grouped[category]!) {
        final subcategory = criteria['Subcategory'] ?? '';
        final name = criteria['Rule Name'] ?? criteria['Analysis Criteria'] ?? '';
        final check = criteria['What to Check / Trigger Condition'] ?? criteria['What to Check'] ?? '';
        final type = criteria['Analysis Type'] ?? 'Static';
        final threshold = criteria['Threshold / Configuration'] ?? '';
        final thresholdStr = threshold.isNotEmpty ? ' [Threshold: $threshold]' : '';
        buffer.writeln('- **$name** ($subcategory - $type): $check$thresholdStr');
      }
      buffer.writeln();
    }

    final codeQuality = criteriaService.defaultCriteria['code_quality'];
    if (codeQuality is Map) {
      buffer.writeln('### Local Threshold Parameters');
      buffer.writeln('- **Max Lines of Code per file:** ${criteriaService.maxLinesOfCode}');
      buffer.writeln('- **Max lines per function:** ${codeQuality['max_function_lines'] ?? 50}');
      buffer.writeln('- **Allow TODO comments:** ${codeQuality['allow_todo_comments'] ?? false}');
      buffer.writeln('- **Enforce class prefixes:** ${codeQuality['enforce_class_prefixes'] ?? true}');
    }
    return buffer.toString();
  }

  String _generateHtmlCriteriaSection() {
    final criteriaService = CriteriaService();
    final buffer = StringBuffer();
    buffer.writeln('''
        <section class="meta-card" style="margin-bottom: 2rem; max-height: 400px; overflow-y: auto;">
            <h2 style="font-size: 1.25rem; color: var(--primary); margin-bottom: 0.5rem;">Analysis Criteria Observed</h2>
            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">This report is based on the following dynamic sheet and local configuration criteria:</p>
            <div style="display: flex; flex-wrap: wrap; gap: 1rem;">
    ''');

    final grouped = <String, List<Map<String, String>>>{};
    for (final criteria in criteriaService.sheetCriteria) {
      final category = criteria['Category'] ?? 'General';
      grouped.putIfAbsent(category, () => []).add(criteria);
    }

    for (final category in grouped.keys) {
      buffer.writeln('<div style="flex: 1; min-width: 280px; background: rgba(255,255,255,0.01); padding: 1rem; border-radius: 8px; border: 1px solid var(--border); box-sizing: border-box;">');
      buffer.writeln('<h3 style="font-size: 0.95rem; color: var(--text-color); border-bottom: 1px solid var(--border); padding-bottom: 0.25rem; margin-bottom: 0.5rem;">$category</h3>');
      buffer.writeln('<ul style="list-style-type: none; font-size: 0.8rem; color: var(--text-muted); padding-left: 0;">');
      for (final criteria in grouped[category]!) {
        final name = criteria['Rule Name'] ?? criteria['Analysis Criteria'] ?? '';
        final check = criteria['What to Check / Trigger Condition'] ?? criteria['What to Check'] ?? '';
        final threshold = criteria['Threshold / Configuration'] ?? '';
        final thresholdStr = threshold.isNotEmpty ? ' <span style="color: var(--primary); font-size: 0.7rem; font-weight: 500;">(Threshold: $threshold)</span>' : '';
        buffer.writeln('<li style="margin-bottom: 0.5rem;"><strong style="color: var(--text-color); font-weight: 600;">$name:</strong> $check$thresholdStr</li>');
      }
      buffer.writeln('</ul>');
      buffer.writeln('</div>');
    }

    final codeQuality = criteriaService.defaultCriteria['code_quality'];
    if (codeQuality is Map) {
      buffer.writeln('<div style="background: rgba(255,255,255,0.01); padding: 1rem; border-radius: 8px; border: 1px solid var(--border);">');
      buffer.writeln('<h3 style="font-size: 0.95rem; color: var(--text-color); border-bottom: 1px solid var(--border); padding-bottom: 0.25rem; margin-bottom: 0.5rem;">Local Threshold Parameters</h3>');
      buffer.writeln('<ul style="list-style-type: none; font-size: 0.8rem; color: var(--text-muted); padding-left: 0;">');
      buffer.writeln('<li style="margin-bottom: 0.25rem;"><strong style="color: var(--text-color); font-weight: 600;">Max Lines of Code:</strong> ${criteriaService.maxLinesOfCode}</li>');
      buffer.writeln('<li style="margin-bottom: 0.25rem;"><strong style="color: var(--text-color); font-weight: 600;">Max Function Lines:</strong> ${codeQuality['max_function_lines'] ?? 50}</li>');
      buffer.writeln('<li style="margin-bottom: 0.25rem;"><strong style="color: var(--text-color); font-weight: 600;">Allow TODO:</strong> ${codeQuality['allow_todo_comments'] ?? false}</li>');
      buffer.writeln('<li style="margin-bottom: 0.25rem;"><strong style="color: var(--text-color); font-weight: 600;">Enforce class prefixes:</strong> ${codeQuality['enforce_class_prefixes'] ?? true}</li>');
      buffer.writeln('</ul>');
      buffer.writeln('</div>');
    }

    buffer.writeln('</div></section>');
    return buffer.toString();
  }

  String _generatePdfCriteriaSection() {
    final criteriaService = CriteriaService();
    final buffer = StringBuffer();
    buffer.writeln('<h2>8. Analysis Criteria Observed</h2>');
    buffer.writeln('<p style="font-size: 11px; color: #64748b; margin-top: -6px; margin-bottom: 12px;">The project is audited against the following rules:</p>');
    buffer.writeln('<div style="font-size: 11px; color: #334155; margin-bottom: 12px; display: flex; flex-wrap: wrap; gap: 10px;">');

    final grouped = <String, List<Map<String, String>>>{};
    for (final criteria in criteriaService.sheetCriteria) {
      final category = criteria['Category'] ?? 'General';
      grouped.putIfAbsent(category, () => []).add(criteria);
    }

    for (final category in grouped.keys) {
      buffer.writeln('<div style="width: 48%; min-width: 250px; background-color: #f8fafc; border: 1px solid #e2e8f0; padding: 8px; border-radius: 6px; box-sizing: border-box;">');
      buffer.writeln('<strong style="color: #0f172a; border-bottom: 1px solid #cbd5e1; display: block; padding-bottom: 2px; margin-bottom: 4px;">$category</strong>');
      buffer.writeln('<ul style="margin: 0; padding-left: 12px; list-style-type: square; color: #475569;">');
      for (final criteria in grouped[category]!) {
        final name = criteria['Rule Name'] ?? criteria['Analysis Criteria'] ?? '';
        final check = criteria['What to Check / Trigger Condition'] ?? criteria['What to Check'] ?? '';
        final threshold = criteria['Threshold / Configuration'] ?? '';
        final thresholdStr = threshold.isNotEmpty ? ' <span style="color: #2563eb; font-size: 9px; font-weight: 500;">(Threshold: $threshold)</span>' : '';
        buffer.writeln('<li><strong>$name:</strong> $check$thresholdStr</li>');
      }
      buffer.writeln('</ul>');
      buffer.writeln('</div>');
    }

    final codeQuality = criteriaService.defaultCriteria['code_quality'];
    if (codeQuality is Map) {
      buffer.writeln('<div style="background-color: #f8fafc; border: 1px solid #e2e8f0; padding: 8px; border-radius: 6px;">');
      buffer.writeln('<strong style="color: #0f172a; border-bottom: 1px solid #cbd5e1; display: block; padding-bottom: 2px; margin-bottom: 4px;">Local Threshold Parameters</strong>');
      buffer.writeln('<ul style="margin: 0; padding-left: 12px; list-style-type: square; color: #475569;">');
      buffer.writeln('<li><strong>Max Lines of Code:</strong> ${criteriaService.maxLinesOfCode}</li>');
      buffer.writeln('<li><strong>Max Function Lines:</strong> ${codeQuality['max_function_lines'] ?? 50}</li>');
      buffer.writeln('<li><strong>Allow TODO:</strong> ${codeQuality['allow_todo_comments'] ?? false}</li>');
      buffer.writeln('<li><strong>Enforce class prefixes:</strong> ${codeQuality['enforce_class_prefixes'] ?? true}</li>');
      buffer.writeln('</ul>');
      buffer.writeln('</div>');
    }

    buffer.writeln('</div>');
    return buffer.toString();
  }
}
