import 'dart:async';
import 'package:dotlottie_flutter/dotlottie_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../widgets/section_container.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const List<String> _headlines = <String>[
    'I build mobile experiences.',
    'I am a Flutter Expert.',
    'I solve complex problems.',
    'I bring ideas to life.',
  ];

  Timer? _headlineTimer;
  bool _showDecorations = false;
  int _headlineIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      setState(() => _showDecorations = true);
      _headlineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!mounted) {
          return;
        }
        setState(() {
          _headlineIndex = (_headlineIndex + 1) % _headlines.length;
        });
      });
    });
  }

  @override
  void dispose() {
    _headlineTimer?.cancel();
    super.dispose();
  }

  static const String _resumeUrl =
      'https://docs.google.com/document/d/1YGXdKA7stmvtRi9U9OLfecD_jILYI2DYRTR49HrdLOA/edit?tab=t.0';
  static const String _githubUrl = 'https://github.com/shohanur55';
  static const String _linkedInUrl =
      'https://www.linkedin.com/in/md-shohanur-rahaman-a56999292/';
  static const String _email = 'mailto:mshohan088@gmail.com';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final minHeight = size.height * 0.88;
    final horizontalPadding = isDesktop ? 150.w : (isTablet ? 80.w : 10.w);
    final verticalPadding = isDesktop ? 50.h : 30.h;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundColor,
            AppTheme.backgroundColor,
            AppTheme.cardColor.withOpacity(0.4),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Subtle decorative glow
          if (isDesktop && _showDecorations) ...[
            // Lottie animation on left side as background decoration
            Positioned(
              left: 10,
              top: 100,
              child: Opacity(
                opacity: 0.15,
                child: SizedBox(
                  width: 400.w,
                  height: 400.h,
                  child: IgnorePointer(
                    child: DotLottieView(
                      sourceType: 'asset',
                      source: 'assets/lottie/fnoDIUWfiv.lottie',
                      autoplay: true,
                      loop: true,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.08),
                      AppTheme.primaryColor.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentColor.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
          // Left sidebar email (desktop)
          if (isDesktop) _buildSidebarEmail(context),
          // Main content
          SectionContainer(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isDesktop ? 10.h : 16.h),
                  isDesktop
                      ? _buildDesktopLayout(context, isTablet)
                      : _buildMobileLayout(context),
                  SizedBox(height: isDesktop ? 40.h : 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarEmail(BuildContext context) {
    return Positioned(
      left: 28,
      bottom: 0,
      top: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 1,
              height: 100,
              color: AppTheme.secondaryColor.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            RotatedBox(
              quarterTurns: 3,
              child: TextButton(
                onPressed: () => _launchURL(_email),
                child: Text(
                  'mshohan088@gmail.com',
                  style: GoogleFonts.firaCode(
                    color: AppTheme.secondaryColor,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 1,
              height: 100,
              color: AppTheme.secondaryColor.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _buildContent(context, true, isTablet)),
        const SizedBox(width: 48),
        Expanded(flex: 2, child: _buildHeroProfileImage(true)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _buildHeroProfileImage(false)),
        const SizedBox(height: 32),
        _buildContent(context, false, false),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGreeting(isDesktop),
        const SizedBox(height: 20),
        _buildName(isDesktop),
        const SizedBox(height: 12),
        _buildTypewriter(isDesktop),
        const SizedBox(height: 28),
        _buildBio(context, isDesktop),
        const SizedBox(height: 28),
        _buildQuickStats(isDesktop),
        const SizedBox(height: 20),
        _buildCoreSkills(isDesktop),
        const SizedBox(height: 32),
        _buildActions(context, isDesktop),
      ],
    );
  }

  Widget _buildGreeting(bool isDesktop) {
    return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hi, my name is',
              style: GoogleFonts.firaCode(
                color: AppTheme.primaryColor,
                fontSize: (isDesktop ? 18.0 : 16.sp).clamp(14.0, 20.0),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.waving_hand, color: AppTheme.primaryColor, size: 22),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildName(bool isDesktop) {
    return Text(
          'Md. Shohanur Rahaman.',
          style: GoogleFonts.inter(
            color: AppTheme.textColor,
            fontSize: (isDesktop ? 64.0 : 42.0).sp.clamp(32.0, 80.0),
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -1.2,
          ),
        )
        .animate()
        .fadeIn(delay: 150.ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic)
        .shimmer(
          delay: 800.ms,
          duration: 2.seconds,
          color: AppTheme.primaryColor.withOpacity(0.25),
        );
  }

  Widget _buildTypewriter(bool isDesktop) {
    return SizedBox(
          height: isDesktop ? 64 : 52,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 520 : 320),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _headlines[_headlineIndex],
                  key: ValueKey<int>(_headlineIndex),
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryColor,
                    fontSize: isDesktop ? 42 : 28,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildBio(BuildContext context, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text.rich(
              TextSpan(
                style: GoogleFonts.inter(
                  color: AppTheme.secondaryColor,
                  fontSize: (isDesktop ? 18.0 : 16.sp).clamp(14.0, 20.0),
                  height: 1.7,
                ),
                children: [
                  const TextSpan(
                    text:
                        'I am a results-driven Software Engineer with 4+ years of proven experience in ',
                  ),
                  TextSpan(
                    text: 'Flutter & Dart',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. I have successfully delivered 16+ visually stunning and high-performance applications for ',
                  ),
                  TextSpan(
                    text: 'Android & iOS',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ', many of which are live on the '),
                  TextSpan(
                    text: 'Play Store',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'App Store',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. I specialize in clean, maintainable code and scalable architectures that drive business growth. Beyond product work, I genuinely enjoy tackling complex problems and algorithmic challenges as a ',
                  ),
                  TextSpan(
                    text: 'competitive programmer',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' — breaking down tricky requirements and finding elegant, efficient solutions is something I’m deeply passionate about.',
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            )
            .animate()
            .fadeIn(delay: 450.ms, duration: 600.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }

  Widget _buildQuickStats(bool isDesktop) {
    return Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _buildStatChip('4+ Years', 'Experience', isDesktop),
            _buildStatChip('16+ Apps', 'Delivered', isDesktop),
            _buildStatChip(
              '3 Apps',
              'Live in App Store',
              isDesktop,
              icon: FontAwesomeIcons.appStoreIos,
            ),
            _buildStatChip(
              '5 Apps',
              'Live in Play Store',
              isDesktop,
              icon: FontAwesomeIcons.googlePlay,
            ),
            _buildStatChip('Flutter & Dart', 'Specialty', isDesktop),
          ],
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 500.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildCoreSkills(bool isDesktop) {
    final skills = ['Flutter', 'Dart', 'GetX', 'REST APIs', 'Firebase'];

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Core Stack',
              style: GoogleFonts.firaCode(
                color: AppTheme.secondaryColor.withOpacity(0.9),
                fontSize: (isDesktop ? 13.0 : 12.sp).clamp(12.0, 16.0),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills
                  .map((s) => _buildSkillPill(s, isDesktop))
                  .toList(),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 650.ms, duration: 500.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildSkillPill(String label, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 14 : 12,
        vertical: isDesktop ? 8 : 7,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 6, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.firaCode(
              color: AppTheme.textColor,
              fontSize: (isDesktop ? 12.0 : 11.sp).clamp(10.0, 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    String value,
    String label,
    bool isDesktop, {
    FaIconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 16,
        vertical: isDesktop ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            FaIcon(
              icon,
              size: (isDesktop ? 16.0 : 14.sp).clamp(12.0, 20.0),
              color: AppTheme.primaryColor.withOpacity(0.9),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            value,
            style: GoogleFonts.firaCode(
              color: AppTheme.primaryColor,
              fontSize: (isDesktop ? 15.0 : 13.sp).clamp(12.0, 18.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor.withOpacity(0.9),
              fontSize: (isDesktop ? 13.0 : 12.sp).clamp(11.0, 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDesktop) {
    return Wrap(
          spacing: 14,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildResumeButton(isDesktop),
            if (isDesktop) const SizedBox(width: 6),
            _buildSocialIcon(FontAwesomeIcons.github, _githubUrl),
            _buildSocialIcon(FontAwesomeIcons.linkedin, _linkedInUrl),
            _buildSocialIcon(FontAwesomeIcons.envelope, _email),
          ],
        )
        .animate()
        .fadeIn(delay: 750.ms, duration: 600.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildResumeButton(bool isDesktop) {
    return OutlinedButton(
          onPressed: () => _launchURL(_resumeUrl),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 28 : 24,
              vertical: isDesktop ? 20 : 18,
            ),
            side: const BorderSide(color: AppTheme.primaryColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: AppTheme.primaryColor.withOpacity(0.06),
          ),
          child: Text(
            'Download Resume',
            style: GoogleFonts.firaCode(
              color: AppTheme.primaryColor,
              fontSize: (isDesktop ? 15.0 : 14.sp).clamp(12.0, 18.0),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
  }

  Widget _buildSocialIcon(FaIconData icon, String url) {
    return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            onPressed: () => _launchURL(url),
            icon: FaIcon(icon, color: AppTheme.secondaryColor, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.cardColor.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
  }

  Widget _buildHeroProfileImage(bool isDesktop) {
    final double outerSize = isDesktop ? 280 : 220;
    final double innerSize = isDesktop ? 260 : 200;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow border
            Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.25),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            // Image container
            Container(
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      AppConstants.profileImage,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.cardColor,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 700.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }
}
