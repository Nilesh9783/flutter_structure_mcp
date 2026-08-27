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
      'fixAvailable': fixAvailable,
    };
  }

  @override
  String toString() {
    return '[$category][$severity] $title in $file:$line';
  }
}
