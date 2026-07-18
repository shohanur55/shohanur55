import 'package:url_launcher/url_launcher.dart';

const String resumeUrl =
    'https://drive.google.com/file/d/15ZxnMprxGZFpmVnPvaCvjqH6z0ujCbZL/view?usp=drive_link';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) throw 'Could not launch $url';
}

class AppConstants {
  static const String projectsDataPath = 'assets/data/projects.json';
  static const String experienceDataPath = 'assets/data/experience.json';
  static const String skillsDataPath = 'assets/data/skills.json';
  // TODO: Compress this image to WebP format for better performance
  static const String profileImage =
      'assets/images/profile.png'; // Updated from screenshot
  // Add more constants as needed
}
