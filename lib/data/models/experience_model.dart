class ExperienceModel {
  final String id;
  final String company;
  final String role;
  final String duration;
  final List<String> description;
  final List<String> technologies;

  ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
    required this.technologies,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as String,
      company: json['company'] as String,
      role: json['role'] as String,
      duration: json['duration'] as String,
      description: List<String>.from(json['description'] ?? []),
      technologies: List<String>.from(json['technologies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'role': role,
      'duration': duration,
      'description': description,
      'technologies': technologies,
    };
  }
}
