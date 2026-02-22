import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';
import '../static/static_portfolio_data.dart';

class PortfolioRepository {
  List<Project> getProjects() {
    return StaticPortfolioData.projects;
  }

  List<ExperienceModel> getExperience() {
    return StaticPortfolioData.experience;
  }

  List<SkillModel> getSkills() {
    return StaticPortfolioData.skills;
  }
}
