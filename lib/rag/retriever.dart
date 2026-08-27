import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/logging/logger.dart';

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
      final scriptUri = Platform.script;
      final scriptPath = scriptUri.isScheme('file') ? scriptUri.toFilePath() : '.';
      String projectRoot = p.dirname(p.dirname(scriptPath));

      if (!Directory(p.join(projectRoot, 'knowledge')).existsSync()) {
        projectRoot = Directory.current.path;
      }

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

  /// Retrieves the most relevant knowledge document matching the given query tokens.
  KnowledgeDocument? retrieve(String query) {
    if (_documents.isEmpty) return null;

    final tokens = query
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 3)
        .toList();

    if (tokens.isEmpty) return null;

    KnowledgeDocument? bestDoc;
    double bestScore = 0.0;

    for (final doc in _documents) {
      double score = 0.0;
      final docLower = doc.content.toLowerCase();
      final titleLower = doc.title.toLowerCase();

      for (final token in tokens) {
        if (titleLower.contains(token)) {
          score += 10.0; // High score for title match
        }
        if (docLower.contains(token)) {
          score += 1.0;  // Standard score for body match
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestDoc = doc;
      }
    }

    // Only return if it meets a minimum matching threshold
    return bestScore > 1.0 ? bestDoc : null;
  }
}
