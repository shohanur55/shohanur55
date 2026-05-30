import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../data/repositories/portfolio_repository.dart';

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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showScrollIndicator = true;
  bool _assetsPrecached = false;
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0);

  // Keys for scrolling to sections
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_assetsPrecached) {
      _assetsPrecached = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _precacheStartupAssets(context);
      });
    }
  }

  Future<void> _precacheStartupAssets(BuildContext context) async {
    final providers = <ImageProvider<Object>>[
      const AssetImage(AppConstants.profileImage),
      ...PortfolioRepository().getProjects().map((project) {
        final image = project.imageUrl;
        return image.startsWith('http')
            ? NetworkImage(image)
            : AssetImage(image);
      }),
    ];

    for (final provider in providers) {
      await precacheImage(provider, context);
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final threshold = maxScroll * 0.85;
    final progress = maxScroll == 0 ? 0.0 : (currentScroll / maxScroll).clamp(0.0, 1.0);

    _scrollProgress.value = progress;
    if (currentScroll > threshold && _showScrollIndicator) {
      setState(() => _showScrollIndicator = false);
    } else if (currentScroll <= threshold && !_showScrollIndicator) {
      setState(() => _showScrollIndicator = true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    GlobalKey key;
    switch (index) {
      case 0:
        key = _heroKey;
        break;
      case 1:
        key = _projectsKey;
        break;
      case 2:
        key = _skillsKey;
        break;
      case 3:
        key = _aboutKey;
        break;
      case 4:
        key = _experienceKey;
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(key: _heroKey),
                ProjectsSection(key: _projectsKey),
                SkillsSection(key: _skillsKey),
                AboutSection(key: _aboutKey),
                ExperienceSection(key: _experienceKey),
                ContactSection(key: _contactKey),
                const Footer(),
              ],
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: _scrollProgress,
            builder: (context, progress, _) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: progress > 0.02 ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 2,
                      backgroundColor: AppTheme.backgroundColor.withOpacity(0.35),
                      valueColor: const AlwaysStoppedAnimation(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_showScrollIndicator)
            Positioned(
              bottom: 160.h,
              right: 30.w,
              child: _buildScrollIndicator(),
            ),
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.8),
                      AppTheme.primaryColor.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.6),
                    width: 1.5.r,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flutter_dash, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Created with Flutter',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 16.sp.clamp(10.0, 18.0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _scrollController.animateTo(
            _scrollController.offset + 600,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scroll',
              style: GoogleFonts.robotoMono(
                color: AppTheme.primaryColor,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
