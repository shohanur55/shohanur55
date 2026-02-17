import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../widgets/section_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  static const String _resumeUrl =
      'https://docs.google.com/document/d/1YGXdKA7stmvtRi9U9OLfecD_jILYI2DYRTR49HrdLOA/edit?tab=t.0';
  static const String _githubUrl = 'https://github.com/shohanur55';
  static const String _linkedInUrl =
      'https://www.linkedin.com/in/md-shohanur-rahaman-a56999292/';
  static const String _email = 'mailto:mshohan088@gmail.com';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600;
    final minHeight = size.height * 0.88;
    final horizontalPadding = isDesktop ? 150.0 : (isTablet ? 80.0 : 20.0);
    final verticalPadding = isDesktop ? 50.0 : 30.0;

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
          if (isDesktop) ...[
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
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isDesktop ? 10 : 16),
                  isDesktop
                      ? _buildDesktopLayout(context, isTablet)
                      : _buildMobileLayout(context),
                  const SizedBox(height: 60),
                  _buildScrollIndicator(context),
                  SizedBox(height: isDesktop ? 40 : 24),
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
        Expanded(flex: 2, child: _buildHeroProfileImage()),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroProfileImage(),
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
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
                  Icons.waving_hand,
                  color: AppTheme.primaryColor,
                  size: 22,
                )
                .animate(onPlay: (c) => c.repeat())
                .shake(duration: 2500.ms, hz: 3, curve: Curves.easeInOut),
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
            fontSize: isDesktop ? 64 : 42,
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
              child: DefaultTextStyle(
                style: GoogleFonts.inter(
                  color: AppTheme.secondaryColor,
                  fontSize: isDesktop ? 42 : 28,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  letterSpacing: -0.8,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 1200),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'I build mobile experiences.',
                      speed: const Duration(milliseconds: 70),
                    ),
                    TypewriterAnimatedText(
                      'I am a Flutter Expert.',
                      speed: const Duration(milliseconds: 70),
                    ),
                    TypewriterAnimatedText(
                      'I solve complex problems.',
                      speed: const Duration(milliseconds: 70),
                    ),
                    TypewriterAnimatedText(
                      'I bring ideas to life.',
                      speed: const Duration(milliseconds: 70),
                    ),
                  ],
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
                  fontSize: isDesktop ? 18 : 16,
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
                fontSize: isDesktop ? 13 : 12,
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
              fontSize: isDesktop ? 12 : 11,
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
    IconData? icon,
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
              size: isDesktop ? 16 : 14,
              color: AppTheme.primaryColor.withOpacity(0.9),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            value,
            style: GoogleFonts.firaCode(
              color: AppTheme.primaryColor,
              fontSize: isDesktop ? 15 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor.withOpacity(0.9),
              fontSize: isDesktop ? 13 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDesktop) {
    return Row(
          children: [
            _buildResumeButton(isDesktop),
            const SizedBox(width: 20),
            _buildSocialIcon(FontAwesomeIcons.github, _githubUrl),
            const SizedBox(width: 14),
            _buildSocialIcon(FontAwesomeIcons.linkedin, _linkedInUrl),
            const SizedBox(width: 14),
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
              fontSize: isDesktop ? 15 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          delay: 3500.ms,
          duration: 1500.ms,
          color: AppTheme.primaryColor.withOpacity(0.15),
        );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
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
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -4, duration: 2.seconds, curve: Curves.easeInOut);
  }

  Widget _buildHeroProfileImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow border
            Container(
              width: 280,
              height: 280,
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
                  width: 260,
                  height: 260,
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

  Widget _buildScrollIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scroll',
            style: GoogleFonts.firaCode(
              color: AppTheme.secondaryColor.withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.primaryColor.withOpacity(0.8),
                size: 28,
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(
                begin: 0,
                end: 6,
                duration: 1.5.seconds,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }
}
