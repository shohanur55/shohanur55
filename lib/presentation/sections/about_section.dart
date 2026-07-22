import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../widgets/section_container.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isAvatarHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context) || Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header (03. About Me)
          _buildSectionHeader(context),
          SizedBox(height: isMobile ? 24.h : 40.h),

          // Main Responsive Content Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Cyber Avatar Card & Status Badge
                SizedBox(
                  width: 320,
                  child: _buildAvatarCard(context),
                ),
                const SizedBox(width: 48),
                // Right Side: Bio Content & Career Cards
                Expanded(
                  child: _buildRightContent(context),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatarCard(context),
                SizedBox(height: 28.h),
                _buildRightContent(context),
              ],
            ),
        ],
      ),
    );
  }

  // ─── Section Header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          '03. ',
          style: GoogleFonts.firaCode(
            color: AppTheme.primaryColor,
            fontSize: 22.sp.clamp(18.0, 24.0),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'About Me',
          style: GoogleFonts.inter(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 32.sp.clamp(24.0, 40.0),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.5),
                  AppTheme.cardColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.08, end: 0);
  }

  // ─── Left Side: Avatar Card & Status Badge ─────────────────────────────────
  Widget _buildAvatarCard(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final outerDiameter = isMobile ? 200.0 : 230.0;
    final innerDiameter = isMobile ? 180.0 : 205.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isAvatarHovered = true),
          onExit: (_) => setState(() => _isAvatarHovered = false),
          child: AnimatedScale(
            scale: _isAvatarHovered ? 1.03 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing Outer Ambient Halo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: outerDiameter + 24,
                  height: outerDiameter + 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(
                          alpha: _isAvatarHovered ? 0.35 : 0.18,
                        ),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(
                          alpha: _isAvatarHovered ? 0.45 : 0.2,
                        ),
                        blurRadius: _isAvatarHovered ? 35 : 20,
                        spreadRadius: _isAvatarHovered ? 6 : 2,
                      ),
                    ],
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(0.96, 0.96),
                      end: const Offset(1.04, 1.04),
                      duration: 2500.ms,
                    ),

                // Main Avatar Frame with Border & Profile Image
                Container(
                  width: innerDiameter,
                  height: innerDiameter,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(
                        alpha: _isAvatarHovered ? 0.9 : 0.5,
                      ),
                      width: 2.5,
                    ),
                    color: const Color(0xFF0F172A),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppConstants.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.cardColor,
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Corner Tech Brackets
                Positioned(top: 4, left: 4, child: _buildCyberBracket()),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Transform.rotate(
                    angle: 3.14159,
                    child: _buildCyberBracket(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Glowing "Open to Work" Badge
        _buildAvailabilityBadge(),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.08, end: 0);
  }

  Widget _buildCyberBracket() {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.primaryColor, width: 2),
          left: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live Pulsing Green/Cyan Indicator
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.3, 1.3),
                duration: 1000.ms,
              ),
          const SizedBox(width: 10),
          Text(
            'Open to Opportunities',
            style: GoogleFonts.firaCode(
              color: AppTheme.textColor,
              fontSize: 12.sp.clamp(11.0, 13.0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Right Content: Bio, Role, Timeline & Skill Chips ────────────────────────
  Widget _buildRightContent(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Role Title with Typing Animation
        _TypingRoleText(
          text: 'Flutter Developer & Team Lead',
          style: GoogleFonts.inter(
            color: AppTheme.primaryColor,
            fontSize: isMobile ? 20.sp : 24.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Shohanur Rahaman (Shohan) • 4+ Years Experience (Since 2020)',
          style: GoogleFonts.inter(
            color: AppTheme.textColor.withValues(alpha: 0.8),
            fontSize: isMobile ? 13.sp : 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 20),

        // Bio Text Paragraphs
        _buildBioParagraphs(isMobile),
        const SizedBox(height: 28),

        // Career Experience Cards
        _buildCompanyTimelineCards(context),
        const SizedBox(height: 28),

        // Key Technical Stack Chips
        _buildSkillChipsSection(context),
      ],
    );
  }

  // ─── Bio Paragraphs ──────────────────────────────────────────────────────────
  Widget _buildBioParagraphs(bool isMobile) {
    final textStyle = GoogleFonts.inter(
      color: AppTheme.secondaryColor,
      fontSize: isMobile ? 15.sp.clamp(13.5, 16.0) : 16.sp.clamp(14.0, 17.0),
      height: 1.65,
    );
    final align = isMobile ? TextAlign.left : TextAlign.justify;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: align,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(
                text: 'Senior Flutter Developer and Team Lead with ',
              ),
              TextSpan(
                text: '4+ years of experience ',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    'building scalable, production-ready Android & iOS applications using Flutter and Dart. Proven expertise in ',
              ),
              TextSpan(
                text:
                    'CRM, HRM, Accounting, E-commerce, Government, and Ride-Sharing ',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    'solutions, leveraging Firebase, Supabase, WebRTC, WebSockets, REST APIs, AI integrations, and payment systems.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          textAlign: align,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(text: 'Successfully delivered '),
              TextSpan(
                text: '20+ production applications',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ', led cross-functional engineering teams, and ',
              ),
              TextSpan(
                text: 'improved app load times by up to 20%',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    '. Passionate about solving real-world problems through mobile apps and exploring new technologies. Competitive programmer who loves clean code and complex challenges.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          textAlign: align,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(
                text:
                    'I place strong emphasis on clean architecture (MVVM/Clean), robust state management, and writing maintainable code that other engineers genuinely enjoy working with.',
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 150.ms);
  }

  // ─── Company Experience & App Showcase ────────────────────────────────────────
  Widget _buildCompanyTimelineCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.work_history_outlined,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Experience & Key Contributions',
              style: GoogleFonts.inter(
                color: AppTheme.textColor,
                fontSize: 18.sp.clamp(16.0, 20.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Company 1: SM Technology (Current)
        _buildCompanyCard(
          role: 'Flutter Developer & Team Lead',
          company: 'SM Technology',
          period: 'Currently Working',
          isCurrent: true,
          description:
              'Leading cross-functional engineering teams, driving Flutter architecture standards, code reviews, and delivering high-performance scalable mobile applications.',
          apps: [],
        ),
        const SizedBox(height: 12),

        // Company 2: Genuine Technology & Research Ltd (GTR)
        _buildCompanyCard(
          role: 'Senior Flutter Developer',
          company: 'Genuine Technology & Research Ltd (GTR)',
          period: 'Previously Worked',
          isCurrent: false,
          description:
              'Contributed to live production mobile applications published on Play Store & App Store:',
          apps: [
            {'name': 'Jogajog', 'store': 'Play Store'},
            {'name': 'Halda', 'store': 'Play Store'},
            {'name': 'Atrai', 'store': 'Play Store'},
            {'name': 'Shuttle Bus', 'store': 'Play Store'},
            {'name': 'Neon Rover', 'store': 'App Store'},
            {'name': 'Multifix', 'store': 'App Store'},
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 250.ms);
  }

  Widget _buildCompanyCard({
    required String role,
    required String company,
    required String period,
    required bool isCurrent,
    required String description,
    required List<Map<String, String>> apps,
  }) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? AppTheme.primaryColor.withValues(alpha: 0.4)
              : AppTheme.primaryColor.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    role,
                    style: GoogleFonts.inter(
                      color: AppTheme.textColor,
                      fontSize: isMobile ? 14.5.sp : 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' @ $company',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryColor,
                      fontSize: isMobile ? 13.5.sp : 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent
                        ? AppTheme.primaryColor
                        : AppTheme.secondaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  period,
                  style: GoogleFonts.firaCode(
                    color: isCurrent
                        ? AppTheme.primaryColor
                        : AppTheme.secondaryColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor,
              fontSize: isMobile ? 13.sp : 14.sp,
              height: 1.45,
            ),
          ),
          if (apps.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: apps.map((app) {
                final isAppStore = app['store'] == 'App Store';
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        isAppStore
                            ? FontAwesomeIcons.apple
                            : FontAwesomeIcons.googlePlay,
                        color: AppTheme.primaryColor,
                        size: 11.sp,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        app['name']!,
                        style: GoogleFonts.inter(
                          color: AppTheme.textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Skill Chips Section ──────────────────────────────────────────────────────
  Widget _buildSkillChipsSection(BuildContext context) {
    final skills = [
      'Flutter',
      'Dart',
      'Firebase',
      'Supabase',
      'Kotlin',
      'Swift',
      'REST API',
      'Bloc',
      'Riverpod',
      'GetX',
      'WebRTC',
      'ZegoCloud',
      'ML Kit',
      'BLE',
      'CI/CD',
      'GitHub Actions',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.code_rounded,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Tech Stack Highlights',
              style: GoogleFonts.inter(
                color: AppTheme.textColor,
                fontSize: 18.sp.clamp(16.0, 20.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(skills.length, (index) {
            final skill = skills[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '▸ ',
                    style: GoogleFonts.firaCode(
                      color: AppTheme.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    skill,
                    style: GoogleFonts.firaCode(
                      color: AppTheme.textColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (35 * index).ms)
                .slideX(begin: 0.15, end: 0);
          }),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 350.ms);
  }
}

// ─── Typing Title Animation Widget ───────────────────────────────────────────
class _TypingRoleText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypingRoleText({required this.text, required this.style});

  @override
  State<_TypingRoleText> createState() => _TypingRoleTextState();
}

class _TypingRoleTextState extends State<_TypingRoleText> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() => _showCursor = !_showCursor);
      }
    });
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 65), (timer) {
      if (!mounted) return;
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Text(_displayedText, style: widget.style)),
        Opacity(
          opacity: _showCursor ? 1.0 : 0.0,
          child: Text(
            '|',
            style: widget.style.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
