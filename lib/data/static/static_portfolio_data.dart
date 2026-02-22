import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';

class StaticPortfolioData {
  static final List<Project> projects = [
    Project(
      id: "1",
      title: "Jogajog",
      description:
          "A Flutter CRM software for efficient customer relationship management.",
      technologies: ["Dart", "Flutter", "REST API", "Firebase", "GetX"],
      imageUrl:
          "https://ui-avatars.com/api/?name=Jogajog&background=e74c3c&color=fff&size=512",
      images: [
        "https://ui-avatars.com/api/?name=Jogajog&background=e74c3c&color=fff&size=512",
      ],
      githubUrl: null,
      liveUrl:
          "https://play.google.com/store/apps/details?id=com.gtrbd.androidteam.jogajog",
    ),
    Project(
      id: "2",
      title: "Halda",
      description:
          "HR app for attendance tracking and management. Users can give/view attendance and perform admin tasks like employee management.",
      technologies: ["Dart", "Flutter", "REST API", "Firebase", "GetX"],
      imageUrl: "assets/images/projects/halda/1.png",
      images: [
        "assets/images/projects/halda/1.png",
        "assets/images/projects/halda/2.png",
        "assets/images/projects/halda/3.png",
      ],
      githubUrl: null,
      liveUrl:
          "https://play.google.com/store/apps/details?id=com.dev.androidteam.gtr.halda",
    ),
    Project(
      id: "3",
      title: "Atrai",
      description:
          "Streamlined accounting software simplifies financial data management for individuals and businesses, ensuring a seamless user experience.",
      technologies: ["Dart", "Flutter", "REST API", "Firebase", "GetX"],
      imageUrl: "assets/images/projects/atrai/1.png",
      images: [
        "assets/images/projects/atrai/1.png",
        "assets/images/projects/atrai/2.png",
        "assets/images/projects/atrai/3.png",
        "assets/images/projects/atrai/4.png",
        "assets/images/projects/atrai/5.png",
        "assets/images/projects/atrai/6.png",
        "assets/images/projects/atrai/7.png",
        "assets/images/projects/atrai/8.png",
      ],
      githubUrl: null,
      liveUrl:
          "https://play.google.com/store/apps/details?id=com.dev.androidteam.gtr.atrai",
    ),
    Project(
      id: "4",
      title: "Shuttle Bus",
      description:
          "Any organization transportation service that operates on a fixed route. Live location sharing for hosts and specific user tracking.",
      technologies: ["Dart", "Flutter", "Firebase", "GetX"],
      imageUrl:
          "https://ui-avatars.com/api/?name=Shuttle+Bus&background=f1c40f&color=fff&size=512",
      images: [
        "https://ui-avatars.com/api/?name=Shuttle+Bus&background=f1c40f&color=fff&size=512",
      ],
      githubUrl: null,
      liveUrl: null,
    ),
    Project(
      id: "5",
      title: "Office Management System",
      description:
          "A system that includes attendance, leave application, leave approval, salary management, and task management for various departments.",
      technologies: ["Dart", "Flutter", "Firebase", "GetX"],
      imageUrl:
          "https://ui-avatars.com/api/?name=OMS&background=2ecc71&color=fff&size=512",
      images: [
        "https://ui-avatars.com/api/?name=OMS&background=2ecc71&color=fff&size=512",
      ],
      githubUrl: null,
      liveUrl: null,
    ),
  ];

  static final List<ExperienceModel> experience = [
    ExperienceModel(
      id: "1",
      company: "Genuine Technology and Research Ltd (GTR)",
      role: "Flutter Mobile App Developer - Jr. Programmer",
      duration: "Nov 2023 - Present",
      description: [
        "Working as a Flutter Mobile App Developer.",
        "Contributed to key projects including Jogajog, Halda, and Atrai.",
        "Implemented features using GetX for state management and MVC/MVVM patterns.",
        "Integrated REST APIs and Firebase for backend connectivity.",
      ],
      technologies: ["Flutter", "Dart", "GetX", "REST API", "Firebase"],
    ),
  ];

  static final List<SkillModel> skills = [
    SkillModel(
      id: "1",
      name: "Flutter",
      category: "Mobile",
      proficiency: 0.95,
      iconUrl: "",
    ),
    SkillModel(
      id: "2",
      name: "Dart",
      category: "Languages",
      proficiency: 0.95,
      iconUrl: "",
    ),
    SkillModel(
      id: "3",
      name: "GetX",
      category: "State Management",
      proficiency: 0.90,
      iconUrl: "",
    ),
    SkillModel(
      id: "4",
      name: "Provider",
      category: "State Management",
      proficiency: 0.85,
      iconUrl: "",
    ),
    SkillModel(
      id: "5",
      name: "API Integration",
      category: "Backend",
      proficiency: 0.90,
      iconUrl: "",
    ),
    SkillModel(
      id: "6",
      name: "Firebase",
      category: "Backend",
      proficiency: 0.85,
      iconUrl: "",
    ),
    SkillModel(
      id: "7",
      name: "SQL / PostgreSQL",
      category: "Database",
      proficiency: 0.80,
      iconUrl: "",
    ),
    SkillModel(
      id: "8",
      name: "C# / ASP.NET",
      category: "Backend",
      proficiency: 0.75,
      iconUrl: "",
    ),
    SkillModel(
      id: "9",
      name: "Git / GitHub",
      category: "Tools",
      proficiency: 0.90,
      iconUrl: "",
    ),
    SkillModel(
      id: "10",
      name: "C / C++",
      category: "Languages",
      proficiency: 0.70,
      iconUrl: "",
    ),
  ];
}
