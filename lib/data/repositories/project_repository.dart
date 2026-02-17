import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project_model.dart';
import '../../core/utils/constants.dart';

class ProjectRepository {
  Future<List<Project>> getProjects() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.projectsDataPath,
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      // In a real app, we would log this error
      print('Error loading projects: $e');
      return [];
    }
  }
}
