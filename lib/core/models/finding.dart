class Finding {
  final String id;
  final String category; // SECURITY, MEMORY, PERFORMANCE, ARCHITECTURE, DEPENDENCY, CODE_QUALITY
  final String severity; // CRITICAL, HIGH, MEDIUM, LOW
  final String confidence; // HIGH, MEDIUM, LOW
  final String title;
  final String file;
  final int line;
  final String evidence;
  final String description;
  final String risk;
  final String recommendation;
  final String suggestedFix; // Specific code solution / snippet
  final String claudePrompt; // Direct command / prompt for Claude to fix this issue
  final bool fixAvailable;

  Finding({
    required this.id,
    required this.category,
    required this.severity,
    required this.confidence,
    required this.title,
    required this.file,
    required this.line,
    required this.evidence,
    required this.description,
    required this.risk,
    required this.recommendation,
    this.suggestedFix = '',
    this.claudePrompt = '',
    this.fixAvailable = false,
  });

  factory Finding.fromJson(Map<String, dynamic> json) {
    return Finding(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      severity: json['severity'] ?? '',
      confidence: json['confidence'] ?? '',
      title: json['title'] ?? '',
      file: json['file'] ?? '',
      line: json['line'] ?? 0,
      evidence: json['evidence'] ?? '',
      description: json['description'] ?? '',
      risk: json['risk'] ?? '',
      recommendation: json['recommendation'] ?? '',
      suggestedFix: json['suggestedFix'] ?? '',
      claudePrompt: json['claudePrompt'] ?? '',
      fixAvailable: json['fixAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'severity': severity,
      'confidence': confidence,
      'title': title,
      'file': file,
      'line': line,
      'evidence': evidence,
      'description': description,
      'risk': risk,
      'recommendation': recommendation,
      'suggestedFix': suggestedFix,
      'claudePrompt': claudePrompt,
      'fixAvailable': fixAvailable,
    };
  }

  Finding copyWith({
    String? id,
    String? category,
    String? severity,
    String? confidence,
    String? title,
    String? file,
    int? line,
    String? evidence,
    String? description,
    String? risk,
    String? recommendation,
    String? suggestedFix,
    String? claudePrompt,
    bool? fixAvailable,
  }) {
    return Finding(
      id: id ?? this.id,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
      title: title ?? this.title,
      file: file ?? this.file,
      line: line ?? this.line,
      evidence: evidence ?? this.evidence,
      description: description ?? this.description,
      risk: risk ?? this.risk,
      recommendation: recommendation ?? this.recommendation,
      suggestedFix: suggestedFix ?? this.suggestedFix,
      claudePrompt: claudePrompt ?? this.claudePrompt,
      fixAvailable: fixAvailable ?? this.fixAvailable,
    );
  }

  @override
  String toString() {
    return '[$category][$severity] $title in $file:$line';
  }
}
