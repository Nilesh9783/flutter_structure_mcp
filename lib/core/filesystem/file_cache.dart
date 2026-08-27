import 'dart:io';
import '../models/finding.dart';

class FileCache {
  static final Map<String, _CacheEntry> _cache = {};

  static bool isCached(File file) {
    final path = file.absolute.path;
    if (!_cache.containsKey(path)) return false;

    final stat = file.statSync();
    final entry = _cache[path]!;
    return entry.lastModified == stat.modified.millisecondsSinceEpoch &&
        entry.size == stat.size;
  }

  static List<Finding> getFindings(File file) {
    final path = file.absolute.path;
    if (isCached(file)) {
      return _cache[path]!.findings;
    }
    return [];
  }

  static void setFindings(File file, List<Finding> findings) {
    final path = file.absolute.path;
    final stat = file.statSync();
    _cache[path] = _CacheEntry(
      lastModified: stat.modified.millisecondsSinceEpoch,
      size: stat.size,
      findings: findings,
    );
  }

  static void clear() {
    _cache.clear();
  }
}

class _CacheEntry {
  final int lastModified;
  final int size;
  final List<Finding> findings;

  _CacheEntry({
    required this.lastModified,
    required this.size,
    required this.findings,
  });
}
