import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
import '../widgets/footer.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/experience_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Keys for scrolling to sections
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(int index) {
    GlobalKey key;
    switch (index) {
      case 0:
        key = _heroKey;
        break;
      case 1:
        key = _skillsKey;
        break;
      case 2:
        key = _aboutKey;
        break;
      case 3:
        key = _experienceKey;
        break;
      case 4:
        key = _projectsKey;
        break;
      case 5:
        key = _contactKey;
        break;
      default:
        key = _heroKey;
    }

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(onNavTap: _scrollToSection),
      endDrawer: MobileDrawer(onNavTap: _scrollToSection),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(key: _heroKey),
            SkillsSection(key: _skillsKey),
            AboutSection(key: _aboutKey),
            ExperienceSection(key: _experienceKey),
            ProjectsSection(key: _projectsKey),
            ContactSection(key: _contactKey),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
