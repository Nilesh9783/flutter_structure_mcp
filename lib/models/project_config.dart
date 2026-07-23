class ProjectConfig {
  final String projectName;
  final String architecture;
  final String stateManagement;
  final String backend;
  final String database;
  final String router;
  final String network;

  const ProjectConfig({
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.backend,
    required this.database,
    required this.router,
    this.network = '',
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) {
    return ProjectConfig(
      projectName: json['projectName'] ?? '',
      architecture: json['architecture'] ?? '',
      stateManagement: json['stateManagement'] ?? '',
      backend: json['backend'] ?? '',
      database: json['database'] ?? '',
      router: json['router'] ?? '',
      network: json['network'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'architecture': architecture,
      'stateManagement': stateManagement,
      'backend': backend,
      'database': database,
      'router': router,
      'network': network,
    };
  }
}
