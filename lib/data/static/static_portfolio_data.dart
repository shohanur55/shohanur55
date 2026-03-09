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
      liveUrl: null,
      playStoreUrl:
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
      liveUrl: null,
      playStoreUrl:
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
      liveUrl: null,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.dev.androidteam.gtr.atrai",
    ),
    Project(
      id: "4",
      title: "Shuttle Bus",
      description:
          "Any organization transportation service that operates on a fixed route. Live location sharing for hosts and specific user tracking.",
      technologies: ["Dart", "Flutter", "Firebase", "GetX"],
      imageUrl: "assets/images/projects/shuttle_bus/1.png",
      images: [
        "assets/images/projects/shuttle_bus/1.png",
        "assets/images/projects/shuttle_bus/2.png",
        "assets/images/projects/shuttle_bus/3.png",
        "assets/images/projects/shuttle_bus/4.png",
        "assets/images/projects/shuttle_bus/5.png",
        "assets/images/projects/shuttle_bus/6.png",
        "assets/images/projects/shuttle_bus/7.png",
        "assets/images/projects/shuttle_bus/8.png",
        "assets/images/projects/shuttle_bus/9.png",
        "assets/images/projects/shuttle_bus/10.png",
        "assets/images/projects/shuttle_bus/11.png",
        "assets/images/projects/shuttle_bus/12.png",
        "assets/images/projects/shuttle_bus/13.png",
      ],
      githubUrl: null,
      liveUrl: null,
    ),
    Project(
      id: "5",
      title: "Easy HR",
      description:
          '''Empower your workforce with our Flutter-based HR application. Seamlessly manage attendance, view records, and access a range of functionalities. Whether you're an admin or employee, easily maintain and monitor your team. Contact the app owner for access. Built with Flutter, GetX, and API integration for a streamlined experience.

* Developed an advanced HR application using Flutter, GetX, and API integration.

* Designed for seamless attendance management, user-friendly for admins and employees alike.

* Empowered users to maintain employee records and access diverse functionalities.

* Contact app owner for easy access and efficient team management.

* Ensured smooth performance and state management using the GetX package.

* Optimized user experience with Flutter's local storage for quick data access.

* Secured user logins with Google authentication for enhanced privacy.

* Overcame challenges in data retrieval and display for improved functionality.

* Utilized Firebase for robust data storage and management capabilities.

* Implemented version control and collaboration via GitHub for efficient development.

* Open-sourced the app to foster community exploration and feedback.''',
      technologies: ["Dart", "Flutter", "Rest API", "GetX"],
      imageUrl: "assets/images/projects/easy_hr/1.png",
      images: [
        "assets/images/projects/easy_hr/1.png",
        "assets/images/projects/easy_hr/2.png",
        "assets/images/projects/easy_hr/3.png",
        "assets/images/projects/easy_hr/4.png",
        "assets/images/projects/easy_hr/5.png",
        "assets/images/projects/easy_hr/6.png",
      ],
      githubUrl: null,
      liveUrl: null,
    ),
    Project(
      id: "6",
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
