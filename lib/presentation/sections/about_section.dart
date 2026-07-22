import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../widgets/section_container.dart';

// ─── Screen Size Breakpoints Helper ─────────────────────────────────────────
enum _ScreenSize { smallPhone, largePhone, tablet, desktop }

_ScreenSize _getScreenSize(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= 1100) return _ScreenSize.desktop;
  if (w >= 850) return _ScreenSize.tablet;
  if (w >= 480) return _ScreenSize.largePhone;
  return _ScreenSize.smallPhone;
}

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isAvatarHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = _getScreenSize(context);
    final isDesktop =
        screenSize == _ScreenSize.desktop || screenSize == _ScreenSize.tablet;
    final isMobile = !isDesktop;

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header (03. About Me)
          _buildSectionHeader(context, screenSize),
          SizedBox(height: isMobile ? 24 : 40),

          // Main Responsive Content Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Cyber Avatar Card & Status Badge
                SizedBox(
                  width: screenSize == _ScreenSize.desktop ? 320 : 260,
                  child: _buildAvatarCard(context, screenSize),
                ),
                SizedBox(width: screenSize == _ScreenSize.desktop ? 48 : 32),
                // Right Side: Bio Content & Career Cards
                Expanded(child: _buildRightContent(context, screenSize)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatarCard(context, screenSize),
                const SizedBox(height: 28),
                _buildRightContent(context, screenSize),
              ],
            ),
        ],
      ),
    );
  }

  // ─── Section Header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(BuildContext context, _ScreenSize screenSize) {
    final numFontSize = screenSize == _ScreenSize.smallPhone
        ? 18.0
        : (screenSize == _ScreenSize.largePhone ? 20.0 : 22.0);
    final titleFontSize = screenSize == _ScreenSize.smallPhone
        ? 22.0
        : (screenSize == _ScreenSize.largePhone
              ? 26.0
              : (screenSize == _ScreenSize.tablet ? 30.0 : 34.0));

    return Row(
      children: [
        Text(
          '03. ',
          style: GoogleFonts.firaCode(
            color: AppTheme.primaryColor,
            fontSize: numFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'About Me',
          style: GoogleFonts.inter(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 16),
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
  Widget _buildAvatarCard(BuildContext context, _ScreenSize screenSize) {
    final double outerDiameter;
    final double innerDiameter;

    switch (screenSize) {
      case _ScreenSize.smallPhone:
        outerDiameter = 160.0;
        innerDiameter = 145.0;
        break;
      case _ScreenSize.largePhone:
        outerDiameter = 185.0;
        innerDiameter = 168.0;
        break;
      case _ScreenSize.tablet:
        outerDiameter = 205.0;
        innerDiameter = 185.0;
        break;
      case _ScreenSize.desktop:
        outerDiameter = 230.0;
        innerDiameter = 205.0;
        break;
    }

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
                      width: outerDiameter + 20,
                      height: outerDiameter + 20,
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
                            size: 64,
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
        const SizedBox(height: 16),

        // Glowing "Open to Work" Badge
        _buildAvailabilityBadge(screenSize),
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

  Widget _buildAvailabilityBadge(_ScreenSize screenSize) {
    final fontSize = screenSize == _ScreenSize.smallPhone ? 11.5 : 12.5;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize == _ScreenSize.smallPhone ? 12 : 16,
        vertical: 8,
      ),
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
                width: 8,
                height: 8,
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
          const SizedBox(width: 8),
          Text(
            'Open to Opportunities',
            style: GoogleFonts.firaCode(
              color: AppTheme.textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Right Content: Bio, Role, Timeline & Skill Chips ────────────────────────
  Widget _buildRightContent(BuildContext context, _ScreenSize screenSize) {
    final roleFontSize = screenSize == _ScreenSize.smallPhone
        ? 18.0
        : (screenSize == _ScreenSize.largePhone
              ? 20.0
              : (screenSize == _ScreenSize.tablet ? 22.0 : 24.0));

    final subtitleFontSize = screenSize == _ScreenSize.smallPhone
        ? 12.5
        : (screenSize == _ScreenSize.largePhone ? 13.5 : 14.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role Title with Typing Animation
        _TypingRoleText(
          text: 'Flutter Developer & Team Lead',
          style: GoogleFonts.inter(
            color: AppTheme.primaryColor,
            fontSize: roleFontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Shohanur Rahaman (Shohan) • 4+ Years Experience (Since 2020)',
          style: GoogleFonts.inter(
            color: const Color(0xFFCBD5E1),
            fontSize: subtitleFontSize,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),

        // Bio Text Paragraphs
        _buildBioParagraphs(screenSize),
        const SizedBox(height: 28),

        // Career Experience Cards
        _buildCompanyTimelineCards(context, screenSize),
        const SizedBox(height: 28),
      ],
    );
  }

  // ─── Bio Paragraphs ──────────────────────────────────────────────────────────
  Widget _buildBioParagraphs(_ScreenSize screenSize) {
    final fontSize = screenSize == _ScreenSize.smallPhone
        ? 14.0
        : (screenSize == _ScreenSize.largePhone
              ? 14.8
              : (screenSize == _ScreenSize.tablet ? 15.5 : 16.0));

    final textStyle = GoogleFonts.inter(
      color: const Color(
        0xFFCBD5E1,
      ), // High contrast off-white for crisp readability
      fontSize: fontSize,
      height: 1.65,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(text: 'Senior Flutter Developer and Team Lead with '),
              TextSpan(
                text: '4+ years of experience ',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
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
                  color: Colors.white,
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
          textAlign: TextAlign.start,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(text: 'Successfully delivered '),
              TextSpan(
                text: '20+ production applications',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: ', led cross-functional engineering teams, and '),
              TextSpan(
                text: 'improved app load times by up to 20%',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
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
          textAlign: TextAlign.start,
          text: TextSpan(
            style: textStyle,
            children: const [
              TextSpan(text: 'I place strong emphasis on '),
              TextSpan(
                text: 'clean architecture (MVVM/Clean)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    ', robust state management, and writing maintainable code that other engineers genuinely enjoy working with.',
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 150.ms);
  }

  // ─── Company Experience & App Showcase ────────────────────────────────────────
  Widget _buildCompanyTimelineCards(
    BuildContext context,
    _ScreenSize screenSize,
  ) {
    final titleFontSize = screenSize == _ScreenSize.smallPhone
        ? 16.0
        : (screenSize == _ScreenSize.largePhone ? 17.5 : 19.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),

        // Company 1: SM Technology (Current)
        _buildCompanyCard(
          screenSize: screenSize,
          role: 'Flutter Developer & Team Lead',
          company: 'SM Technology',
          period: 'Currently Working',
          isCurrent: true,
          description:
              'Leading cross-functional engineering teams, driving Flutter architecture standards, code reviews, and delivering high-performance scalable mobile applications.',
          apps: [],
        ),
        const SizedBox(height: 12),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 250.ms);
  }

  Widget _buildCompanyCard({
    required _ScreenSize screenSize,
    required String role,
    required String company,
    required String period,
    required bool isCurrent,
    required String description,
    required List<Map<String, String>> apps,
  }) {
    final isSmallPhone = screenSize == _ScreenSize.smallPhone;

    final roleFontSize = isSmallPhone
        ? 14.0
        : (screenSize == _ScreenSize.largePhone ? 15.0 : 16.0);
    final companyFontSize = isSmallPhone
        ? 13.5
        : (screenSize == _ScreenSize.largePhone ? 14.5 : 15.0);
    final descFontSize = isSmallPhone
        ? 13.0
        : (screenSize == _ScreenSize.largePhone ? 13.5 : 14.0);

    return Container(
      padding: EdgeInsets.all(isSmallPhone ? 14 : 18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? AppTheme.primaryColor.withValues(alpha: 0.5)
              : AppTheme.primaryColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role, Company & Period Header
          if (isSmallPhone) ...[
            // Stacked for small mobile screens to prevent text overlap
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    role,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: roleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppTheme.primaryColor.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
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
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '@ $company',
              style: GoogleFonts.inter(
                color: AppTheme.primaryColor,
                fontSize: companyFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: role,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: roleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' @ $company',
                          style: GoogleFonts.inter(
                            color: AppTheme.primaryColor,
                            fontSize: companyFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              color: const Color(0xFFCBD5E1),
              fontSize: descFontSize,
              height: 1.5,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 8 : 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
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
                        size: isSmallPhone ? 11.5 : 12.5,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        app['name']!,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: isSmallPhone ? 11.5 : 12.5,
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
