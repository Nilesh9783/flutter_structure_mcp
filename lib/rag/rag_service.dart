import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'retriever.dart';
import 'package:flutter_architect_mcp/core/logging/logger.dart';
import 'package:flutter_architect_mcp/services/criteria_service.dart';

class RagService {
  final Retriever _retriever = Retriever();

  /// Enriches findings with details from the local knowledge base if matches exist.
  List<Finding> enrichFindings(List<Finding> findings) {
    final enriched = <Finding>[];
    final criteriaService = CriteriaService();

    for (final rawFinding in findings) {
      // 1. First dynamically enrich with Google Sheet rules
      final f = criteriaService.enrichFindingWithSheet(rawFinding);

      // Build a search query based on ID and Title
      final query = '${f.id} ${f.title} ${f.category}';
      final match = _retriever.retrieve(query);

      if (match != null) {
        Logger.debug('RAG Match found for finding ${f.id}: ${match.title}');
        
        // Parse some sections from the markdown if possible, or append the entire content
        final fullContent = match.content;
        
        String parsedDescription = f.description;
        String parsedRisk = f.risk;
        String parsedRec = f.recommendation;

        // Try extracting specific sections from Markdown
        final riskSection = _extractSection(fullContent, 'Why It Matters');
        if (riskSection.isNotEmpty) parsedRisk = riskSection;

        final recSection = _extractSection(fullContent, 'Recommended Fix');
        if (recSection.isNotEmpty) parsedRec = recSection;

        final descSection = _extractSection(fullContent, 'Description');
        if (descSection.isNotEmpty) parsedDescription = descSection;

        final goodEx = _extractSection(fullContent, 'Good Example');
        if (goodEx.isNotEmpty) {
          parsedRec += '\n\n**Good Example:**\n$goodEx';
        }
        
        final badEx = _extractSection(fullContent, 'Bad Example');
        if (badEx.isNotEmpty) {
          parsedDescription += '\n\n**Bad Example:**\n$badEx';
        }

        enriched.add(Finding(
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
          fixAvailable: f.fixAvailable,
        ));
      } else {
        enriched.add(f);
      }
    }

    return enriched;
  }

  String _extractSection(String content, String heading) {
    final lines = content.split('\n');
    final sectionLines = <String>[];
    bool inSection = false;

    for (final line in lines) {
      if (line.trim().startsWith('##') && line.contains(heading)) {
        inSection = true;
        continue;
      }
      if (inSection) {
        if (line.trim().startsWith('##')) {
          break; // Next section started
        }
        sectionLines.add(line);
      }
    }

    return sectionLines.join('\n').trim();
  }
}
