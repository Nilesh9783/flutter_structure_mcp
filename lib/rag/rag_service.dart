import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'retriever.dart';
import 'package:flutter_architect_mcp/core/logging/logger.dart';
import 'package:flutter_architect_mcp/services/criteria_service.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class RagService {
  final Retriever _retriever = Retriever();

  /// Enriches findings with details from the local knowledge base and generates tailored solutions and Claude prompts.
  List<Finding> enrichFindings(List<Finding> findings) {
    final enriched = <Finding>[];
    final criteriaService = CriteriaService();

    for (final rawFinding in findings) {
      // 1. Dynamically enrich severity / confidence / thresholds with Google Sheet rules
      final f = criteriaService.enrichFindingWithSheet(rawFinding);

      // 2. Query knowledge base strictly for the exact rule ID
      final match = _retriever.retrieve(f.id);

      String parsedDescription = f.description;
      String parsedRisk = f.risk;
      String parsedRec = f.recommendation;

      if (match != null) {
        Logger.debug('RAG Match found for finding ${f.id}: ${match.title}');
        final fullContent = match.content;

        final riskSection = _extractSection(fullContent, 'Why It Matters');
        if (riskSection.isNotEmpty && (parsedRisk.isEmpty || parsedRisk.length < 30)) {
          parsedRisk = riskSection;
        }

        final recSection = _extractSection(fullContent, 'Recommended Fix');
        if (recSection.isNotEmpty && (parsedRec.isEmpty || parsedRec.length < 30)) {
          parsedRec = recSection;
        }

        final descSection = _extractSection(fullContent, 'Description');
        if (descSection.isNotEmpty && (parsedDescription.isEmpty || parsedDescription.length < 30)) {
          parsedDescription = descSection;
        }
      }

      final findingWithRAG = Finding(
        id: f.id,
        category: f.category,
        severity: f.severity,
        confidence: f.confidence,
        title: f.title,
        file: f.file,
        line: f.line,
        evidence: f.evidence,
        description: parsedDescription,
        risk: parsedRisk,
        recommendation: parsedRec,
        suggestedFix: f.suggestedFix,
        claudePrompt: f.claudePrompt,
        fixAvailable: f.fixAvailable,
      );

      // 3. Attach accurate, tailored code solutions and Claude fix prompts
      final fullyEnriched = SolutionGenerator.attachSolutionAndPrompt(findingWithRAG);
      enriched.add(fullyEnriched);
    }

    return enriched;
  }

  String _extractSection(String content, String heading) {
    final lines = content.split('\n');
    final sectionLines = <String>[];
    bool inSection = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('##') && trimmed.toLowerCase().contains(heading.toLowerCase())) {
        inSection = true;
        continue;
      }
      if (inSection) {
        if (trimmed.startsWith('##')) {
          break; // Next section started
        }
        sectionLines.add(line);
      }
    }

    return sectionLines.join('\n').trim();
  }
}
