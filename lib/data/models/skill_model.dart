class SkillModel {
  final String id;
  final String name;
  final String category; // e.g., "Mobile Development", "Realtime & APIs", etc.
  final double proficiency; // 0.0 to 1.0
  final String iconUrl;
  final bool isFeatured;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    required this.iconUrl,
    this.isFeatured = false,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      proficiency: (json['proficiency'] as num).toDouble(),
      iconUrl: json['iconUrl'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'proficiency': proficiency,
      'iconUrl': iconUrl,
      'isFeatured': isFeatured,
    };
  }
}
