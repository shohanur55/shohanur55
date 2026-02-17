import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';
import '../../core/utils/constants.dart';

class PortfolioRepository {
  Future<List<Project>> getProjects() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.projectsDataPath,
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }

  Future<List<ExperienceModel>> getExperience() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.experienceDataPath,
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ExperienceModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading experience: $e');
      return [];
    }
  }

  Future<List<SkillModel>> getSkills() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.skillsDataPath,
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => SkillModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading skills: $e');
      return [];
    }
  }
}
