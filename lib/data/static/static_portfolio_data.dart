import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';

class StaticPortfolioData {
  static final List<Project> projects = [
    Project(
      id: "1",
      title: "Jogajog",
      description: '''
Jogajog is a Flutter-based communication and business collaboration application designed for both personal and professional use.

• Developed a comprehensive communication and collaboration app for managing family, friends, and workplace connections.
• Implemented real-time location sharing, meeting scheduling, and training management features.
• Built a lead management system to track lead stages, assigned products, and overall sales progress.
• Designed dashboards to monitor upcoming meetings, training sessions, and lead generation activities.
• Integrated business workflow features to organize appointments, manage clients, and improve team productivity.
''',
      technologies: [
        "Dart",
        "Flutter",
        "Google Map",
        "REST API",
        "Firebase",
        "GetX",
      ],
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/jogajog/1.png, 2.png, 3.png, 6.png, 9.png, 11.png
      imageUrl: "assets/images/projects/jogajog/1.png",
      images: [
        "assets/images/projects/jogajog/1.png",
        "assets/images/projects/jogajog/2.png",
        "assets/images/projects/jogajog/3.png",
        "assets/images/projects/jogajog/4.png",
        "assets/images/projects/jogajog/5.png",
        "assets/images/projects/jogajog/6.png",
        "assets/images/projects/jogajog/7.png",
        "assets/images/projects/jogajog/8.png",
        "assets/images/projects/jogajog/9.png",
        "assets/images/projects/jogajog/10.png",
        "assets/images/projects/jogajog/11.png",
        "assets/images/projects/jogajog/12.png",
      ],
      githubUrl: null,
      liveUrl: null,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.gtrbd.androidteam.jogajog",
    ),

    Project(
      id: "2",
      title: "Neon Rover",
      description: '''
A Flutter-based event discovery and event management platform designed to connect users with live music, concerts, festivals, and local entertainment.

- Developed a location-aware event discovery system using Google Maps and geolocation services to recommend nearby events.
- Implemented event creation, publishing, and management features for organizers, venues, and promoters.
- Built advanced search and filtering by location, date, ZIP code, and event category for an improved discovery experience.
- Integrated subscription-based premium features for unlimited event promotion and management.
- Developed responsive cross-platform interfaces with REST API integration, secure authentication, and optimized performance.
''',
      technologies: [
        "Flutter",
        "GetX",
        "REST API",
        "Google Map",
        "In-app Purchase",
        "ReveuneCat",
      ],
      imageUrl: "assets/images/projects/neon_rover/1.png",
      images: [
        "assets/images/projects/neon_rover/1.png",
        "assets/images/projects/neon_rover/2.png",
        "assets/images/projects/neon_rover/3.png",
        "assets/images/projects/neon_rover/4.png",
        "assets/images/projects/neon_rover/5.png",
        "assets/images/projects/neon_rover/6.png",
        "assets/images/projects/neon_rover/7.png",
      ],
  
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/multifix/4.jpg, 5.jpg
      githubUrl: null,
      liveUrl: null,

      appStoreUrl: "https://apps.apple.com/gb/app/neon-rover/id6754535849",
    ),

    Project(
      id: "3",
      title: "Multifix",
      description: '''
A cross-platform home service application built with Flutter for Android and iOS, connecting customers with professional contractors and consultants.

- Developed a role-based platform with Customer, Contractor, and Consultant modules.
- Implemented a ticket management system for reporting and tracking home service requests such as plumbing, electrical, and maintenance issues.
- Built task management features enabling contractors to accept, update, and complete assigned jobs efficiently.
- Integrated admin-controlled authentication and role-based access for secure user management.
- Designed a streamlined workflow for home service requests, communication, and service delivery.
''',
      technologies: ["Dart", "Flutter", "GetX", "REST API"],
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/multifix/4.jpg, 5.jpg
      imageUrl: "assets/images/projects/multifix/1.jpg",
      images: [
        "assets/images/projects/multifix/1.jpg",
        "assets/images/projects/multifix/2.jpg",
        "assets/images/projects/multifix/3.jpg",
        "assets/images/projects/multifix/4.jpg",
        "assets/images/projects/multifix/5.jpg",
        "assets/images/projects/multifix/6.jpg",
      ],
      githubUrl: null,
      liveUrl: null,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.app.multifix.multifix&pcampaignid=web_share",
      appStoreUrl: "https://apps.apple.com/gb/app/multifix/id6756261630",
    ),

    Project(
      id: "4",
      title: "Maziwa Hub",
      description: '''
A cross-platform dairy farm and supply chain management application built with Flutter, designed to streamline dairy operations from milk production to market distribution.

- Developed a multi-role platform supporting Milk Producers, Milk Processors, Suppliers, Financial Institutions, and Public Users with role-based access control.
- Built dairy management modules for milk production tracking, product listings, certifications, inventory, and sales management.
- Implemented supply chain features to connect farmers, processors, suppliers, and other stakeholders through a unified platform.
- Integrated market insights, pricing updates, analytics, and reporting to support business decision-making.
- Developed features for financial services, advertisements, stakeholder engagement, and service provider connectivity.
- Built a responsive Flutter application with REST API integration, secure authentication, and a user-friendly interface.
''',
      technologies: ["Dart", "Flutter", "Firebase", "GetX", "REST API"],
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/maziwa_hub/4.jpg, 5.jpg
      imageUrl: "assets/images/projects/maziwa_hub/1.png",
      images: [
        "assets/images/projects/maziwa_hub/1.png",
        "assets/images/projects/maziwa_hub/2.png",
        "assets/images/projects/maziwa_hub/3.png",
        "assets/images/projects/maziwa_hub/4.png",
        "assets/images/projects/maziwa_hub/5.png",
        "assets/images/projects/maziwa_hub/6.png",
      ],
      githubUrl: null,
      liveUrl: null,
      appStoreUrl: "https://apps.apple.com/gb/app/maziwa-hub/id6761703840",
    ),

    Project(
      id: "5",
      title: "Atrai",
      description: '''
A Flutter-based financial and accounting management application designed to help businesses monitor income, expenses, revenue, and overall financial performance.

- Developed modules to track company income, expenses, and cash flow across multiple business operations.
- Implemented financial dashboards with weekly, monthly, quarterly, and yearly revenue and expense analytics.
- Built transaction history features for monitoring all income and expense records with detailed reports.
- Enabled expense categorization and financial insights to improve budgeting and business decision-making.
- Integrated employee reimbursement and requisition management for handling internal financial requests.
- Developed responsive dashboards with REST API integration for real-time financial data management.
''',
      technologies: ["Dart", "Flutter", "REST API", "GetX", "MVC"],
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/atrai/1.png, 3.png, 4.png, 6.png
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
      id: "6",
      title: "Halda",
      description: '''
A Flutter-based HR management application for employee and workforce management.

- Attendance management with check-in, check-out, and attendance tracking.
- Leave request and approval management.
- Salary and payroll information management.
- Employee management with role-based access for Admin and Employees.
- REST API integration with a responsive and user-friendly interface.
''',
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
      id: "7",
      title: "Shuttle Bus",
      description: '''
A cross-platform transportation management application built with Flutter for Android and iOS, enabling organizations and communities to manage shuttle services with real-time location tracking.

- Developed a live GPS tracking system using Google Maps and Supabase Realtime, allowing hosts and passengers to share and monitor locations instantly.
- Implemented background location updates with real-time synchronization, providing accurate bus locations, member tracking, distance calculations, and ETA.
- Built a role-based transportation system where users can create or join shuttle services as Hosts or Passengers using unique service codes.
- Designed features for pickup point selection, destination management, custom routes, and live member tracking to improve transportation coordination.
- Integrated secure Google Sign-In, session management, and role-based access control with Supabase Authentication.
- Built a responsive and scalable Flutter application with real-time communication, delivering a smooth and reliable user experience.
''',
      technologies: [
        "Dart",
        "Flutter",
        "Google Map",
        "Real-Time Transportation",
        "Supabase",
      ],
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/shuttle_bus/1.png, 2.png, 3.png, 4.png, 5.png, 9.png, 10.png, 11.png, 12.png, 13.png
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
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.app.shuttle_bus.shuttle_bus&pcampaignid=web_share",
    ),
    Project(
      id: "8",
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
      // TODO: Compress these images to WebP format for better performance: assets/images/projects/easy_hr/1.png
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
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=dev.gtrbd.easyhrflutter&pcampaignid=web_share",
    ),

    // Project(
    //   id: "7",
    //   title: "Office Management System",
    //   description:
    //       "A system that includes attendance, leave application, leave approval, salary management, and task management for various departments.",
    //   technologies: ["Dart", "Flutter", "Firebase", "GetX"],
    //   imageUrl:
    //       "https://ui-avatars.com/api/?name=OMS&background=2ecc71&color=fff&size=512",
    //   images: [
    //     "https://ui-avatars.com/api/?name=OMS&background=2ecc71&color=fff&size=512",
    //   ],
    //   githubUrl: null,
    //   liveUrl: null,
    // ),
  ];

  static final List<ExperienceModel> experience = [
    ExperienceModel(
      id: "1",
      company: "SM Technology, Betopia Group",
      role: "Team Leader",
      duration: "Dec 2024 - present",
      description: [
        "Career progression: Flutter Mobile App Developer → Co-Leader → Team Leader.",
        "Started as a Flutter Mobile App Developer and gradually took ownership of larger modules and team responsibilities.",
        "Led feature delivery across key products including Jogajog, Halda, and Atrai.",
        "Implemented features using GetX, MVC/MVVM patterns, REST APIs, Firebase, C#, and ASP.NET.",
      ],
      technologies: [
        "Flutter",
        "Dart",
        "GetX",
        "REST API",
        "Firebase",
        "C#",
        "ASP.NET",
      ],
    ),
    ExperienceModel(
      id: "2",
      company: "Genuine Technology and Research Ltd (GTR)",
      role: "Flutter Mobile App Developer - Jr. Programmer",
      duration: "Nov 2023 - Dec 2024",
      description: [
        "Working as a Flutter Mobile App Developer.",
        "Contributed to key projects including Jogajog, Halda, and Atrai.",
        "Implemented features using GetX for state management and MVC/MVVM patterns.",
        "Integrated REST APIs and Firebase for backend connectivity.",
      ],
      technologies: [
        "Flutter",
        "Dart",
        "GetX",
        "REST API",
        "Firebase",
        "C#",
        "ASP.NET",
      ],
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
    SkillModel(
      id: "11",
      name: "Real-time Chat via WebSockets",
      category: "Realtime Communication",
      proficiency: 0.85,
      iconUrl: "",
    ),
    SkillModel(
      id: "12",
      name: "WebRTC,Zegocloud- Audio/Video Calling",
      category: "Realtime Communication",
      proficiency: 0.80,
      iconUrl: "",
    ),
    SkillModel(
      id: "13",
      name: "Push Notifications",
      category: "Mobile Engagement",
      proficiency: 0.88,
      iconUrl: "",
    ),
    SkillModel(
      id: "14",
      name: "Android & iOS Deployment",
      category: "App Delivery",
      proficiency: 0.85,
      iconUrl: "",
    ),
  ];
}
