import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/logging/logger.dart';
import 'package:flutter_architect_mcp/utils/path_utils.dart';

class KnowledgeDocument {
  final String title;
  final String content;
  final String filePath;

  KnowledgeDocument({
    required this.title,
    required this.content,
    required this.filePath,
  });
}

class Retriever {
  final List<KnowledgeDocument> _documents = [];

  Retriever() {
    _loadDocuments();
  }

  void _loadDocuments() {
    try {
      String projectRoot = PathUtils.resolvePackageRoot();

      final knowledgeDir = Directory(p.join(projectRoot, 'knowledge'));
      if (knowledgeDir.existsSync()) {
        _scanDir(knowledgeDir);
      }
      Logger.debug('RAG Loader loaded ${_documents.length} knowledge rule documents.');
    } catch (e, stack) {
      Logger.error('Failed to load RAG knowledge documents', e, stack);
    }
  }

  void _scanDir(Directory dir) {
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && p.extension(entity.path) == '.md') {
        try {
          final content = entity.readAsStringSync();
          final title = p.basenameWithoutExtension(entity.path);
          _documents.add(KnowledgeDocument(
            title: title,
            content: content,
            filePath: entity.path,
          ));
        } catch (_) {}
      }
    }
  }

  /// Retrieves the knowledge document that strictly matches the given rule ID or specific distinctive query.
  KnowledgeDocument? retrieve(String ruleIdOrQuery) {
    if (_documents.isEmpty) return null;

    final target = ruleIdOrQuery.trim().toUpperCase();

    // 1. Exact match by Document Title (e.g. "SEC-SEC-001" or "MEM-001")
    for (final doc in _documents) {
      final docTitle = doc.title.toUpperCase();
      if (docTitle == target || target.startsWith('$docTitle ') || target.startsWith('$docTitle:')) {
        return doc;
      }
    }

    // 2. Exact Rule ID token containment check
    for (final doc in _documents) {
      final docTitle = doc.title.toUpperCase();
      final words = target.split(RegExp(r'[^A-Z0-9_\-]+'));
      if (words.contains(docTitle)) {
        return doc;
      }
    }

    // 3. Distinctive keyword matching (ignoring generic categories like SECURITY, MEMORY, PERFORMANCE)
    final ignoredGenericWords = {'SECURITY', 'MEMORY', 'PERFORMANCE', 'CODE_QUALITY', 'DEPENDENCY', 'LEAK', 'ISSUE', 'FLUTTER', 'CODE'};
    final queryTokens = target
        .split(RegExp(r'[^A-Z0-9]+'))
        .where((t) => t.length >= 4 && !ignoredGenericWords.contains(t))
        .toList();

    if (queryTokens.isNotEmpty) {
      KnowledgeDocument? bestDoc;
      int bestScore = 0;

      for (final doc in _documents) {
        int score = 0;
        final docContentUpper = doc.content.toUpperCase();

        for (final token in queryTokens) {
          if (docContentUpper.contains(token)) {
            score += 1;
          }
        }

        if (score > bestScore && score >= 2) {
          bestScore = score;
          bestDoc = doc;
        }
      }

      if (bestDoc != null) {
        return bestDoc;
      }
    }

    return null;
  }
}
