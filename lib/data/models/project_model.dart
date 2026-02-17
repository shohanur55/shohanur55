class Project {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final String? githubUrl;
  final String? liveUrl;

  final List<String> images; // New field for gallery

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    List<String>? images, // Optional in constructor
    this.githubUrl,
    this.liveUrl,
  }) : images = images ?? [imageUrl]; // Default to single image if not provided

  factory Project.fromJson(Map<String, dynamic> json) {
    var imgList = json['images'] as List<dynamic>?;
    List<String> images = imgList != null
        ? List<String>.from(imgList)
        : [json['imageUrl'] as String];

    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      imageUrl: json['imageUrl'] as String,
      images: images,
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
    );
  }
}
