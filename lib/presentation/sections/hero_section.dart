import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:particles_network/particles_network.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../widgets/section_container.dart';

// ─── Device Size Helper ──────────────────────────────────────────────────────
// < 480   → small phone
// 480-849 → large phone
// 850-1099→ tablet
// ≥ 1100  → desktop
enum _ScreenSize { smallPhone, largePhone, tablet, desktop }

_ScreenSize _getScreenSize(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= 1100) return _ScreenSize.desktop;
  if (w >= 850) return _ScreenSize.tablet;
  if (w >= 480) return _ScreenSize.largePhone;
  return _ScreenSize.smallPhone;
}

class HeroSection extends StatefulWidget {
  final VoidCallback onContactTap;
  const HeroSection({super.key, required this.onContactTap});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  static const List<String> _headlines = <String>[
    'Flutter Developer',
    'App Developer',
    'Problem Solver',
    'Programmer',
    'Tech Enthusiast',
    'Bug Fixer',
    'Lifelong Learner',
  ];

  Timer? _headlineTimer;
  bool _showDecorations = false;
  int _headlineIndex = 0;
  bool _cvHovered = false;
  bool _contactHovered = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _showDecorations = true);
      _headlineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!mounted) return;
        setState(() {
          _headlineIndex = (_headlineIndex + 1) % _headlines.length;
        });
      });
    });
  }

  @override
  void dispose() {
    _headlineTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  static const String _githubUrl = 'https://github.com/shohanur55';
  static const String _linkedInUrl =
      'https://www.linkedin.com/in/md-shohanur-rahaman-a56999292/';
  static const String _email = 'mailto:mshohan088@gmail.com';

  // ─── Responsive dimension helpers ──────────────────────────────────────────
  double _hPad(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 130;
      case _ScreenSize.tablet:
        return 60;
      case _ScreenSize.largePhone:
        return 28;
      case _ScreenSize.smallPhone:
        return 18;
    }
  }

  double _vPad(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 56;
      case _ScreenSize.tablet:
        return 44;
      case _ScreenSize.largePhone:
        return 36;
      case _ScreenSize.smallPhone:
        return 28;
    }
  }

  double _nameFontSize(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 58;
      case _ScreenSize.tablet:
        return 46;
      case _ScreenSize.largePhone:
        return 34;
      case _ScreenSize.smallPhone:
        return 26;
    }
  }

  double _typewriterFontSize(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 32;
      case _ScreenSize.tablet:
        return 26;
      case _ScreenSize.largePhone:
        return 22;
      case _ScreenSize.smallPhone:
        return 18;
    }
  }

  double _bioFontSize(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 16;
      case _ScreenSize.tablet:
        return 15;
      case _ScreenSize.largePhone:
        return 14;
      case _ScreenSize.smallPhone:
        return 13;
    }
  }

  double _profileImageSize(_ScreenSize s) {
    switch (s) {
      case _ScreenSize.desktop:
        return 268;
      case _ScreenSize.tablet:
        return 220;
      case _ScreenSize.largePhone:
        return 180;
      case _ScreenSize.smallPhone:
        return 150;
    }
  }

  // ─── Main build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = _getScreenSize(context);
    final isDesktop = screenSize == _ScreenSize.desktop;
    final isTablet = screenSize == _ScreenSize.tablet;
    final isMobile = !isDesktop && !isTablet;
    final double minHeight = isDesktop
        ? size.height * 0.90
        : size.height * 0.95;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      color: AppTheme.backgroundColor,
      child: Stack(
        children: [
          // ── Particle Network Background ──────────────────────────────────
          Positioned.fill(
            child: ParticleNetwork(
              particleCount: isDesktop
                  ? 110
                  : isTablet
                  ? 70
                  : 45,
              maxSpeed: 0.55,
              maxSize: isDesktop ? 2.0 : 1.6,
              lineWidth: 0.65,
              lineDistance: isDesktop
                  ? 128
                  : isTablet
                  ? 100
                  : 80,
              particleColor: const Color(0xFF64FFDA).withOpacity(0.72),
              lineColor: const Color(0xFF57CBCC).withOpacity(0.32),
              touchColor: const Color(0xFF64FFDA),
              touchActivation: true,
              hoverEffect: isDesktop,
              fill: true,
              drawNetwork: true,
              isComplex: false,
              gravityType: GravityType.none,
              gravityStrength: 0.0,
              gravityDirection: const Offset(0, 1),
              gravityCenter: null,
            ),
          ),

          // ── Gradient overlay ─────────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundColor.withOpacity(0.90),
                    AppTheme.backgroundColor.withOpacity(0.84),
                    AppTheme.cardColor.withOpacity(0.74),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // ── Decorative radial glows (tablet + desktop) ───────────────────
          if (!isMobile && _showDecorations) ...[
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: isDesktop ? 480 : 300,
                height: isDesktop ? 480 : 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.09),
                      AppTheme.primaryColor.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: -60,
              child: Container(
                width: isDesktop ? 280 : 180,
                height: isDesktop ? 280 : 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentColor.withOpacity(0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],

          // ── Main Content ─────────────────────────────────────────────────
          SectionContainer(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: _hPad(screenSize),
              vertical: _vPad(screenSize),
            ),
            child: _buildLayout(context, screenSize),
          ),

          // ── Left sidebar email (desktop only) ────────────────────────────
          if (isDesktop && _showDecorations) _buildSidebarEmail(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  LAYOUT ROUTER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLayout(BuildContext context, _ScreenSize screenSize) {
    switch (screenSize) {
      case _ScreenSize.desktop:
        return _buildDesktopLayout(context, screenSize);
      case _ScreenSize.tablet:
        return _buildTabletLayout(context, screenSize);
      case _ScreenSize.largePhone:
      case _ScreenSize.smallPhone:
        return _buildMobileLayout(context, screenSize);
    }
  }

  // ── Desktop: left content | right panel ──────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context, _ScreenSize s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 53, child: _buildContent(context, s)),
        const SizedBox(width: 56),
        Expanded(flex: 47, child: _buildDesktopRightPanel(s, context)),
      ],
    );
  }

  // ── Tablet: two columns (wide) or stacked (narrow) ───────────────────────
  Widget _buildTabletLayout(BuildContext context, _ScreenSize s) {
    final w = MediaQuery.of(context).size.width;
    // Wide tablet (> 950) → side by side, narrow → stacked
    if (w >= 950) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 55, child: _buildContent(context, s)),
          const SizedBox(width: 36),
          Expanded(flex: 45, child: _buildTabletRightPanel(s, context)),
        ],
      );
    }
    // Narrow tablet → stacked
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeroProfileImage(s),
        const SizedBox(height: 36),
        _buildContent(context, s),
        const SizedBox(height: 28),
        _buildTabletStatsRow(s),
      ],
    );
  }

  // ── Mobile: stacked ───────────────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context, _ScreenSize s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _buildHeroProfileImage(s)),
        const SizedBox(height: 28),
        _buildContent(context, s),
        const SizedBox(height: 24),
        _buildMobileStatsGrid(s),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  RIGHT PANELS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDesktopRightPanel(_ScreenSize s, [BuildContext? ctx]) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeroProfileImage(s),
            const SizedBox(height: 24),
            _buildStatsGrid(s, cols: 3, ctx: ctx),
            const SizedBox(height: 18),
            //   _buildCoreStackRow(s),
          ],
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 700.ms)
        .slideX(begin: 0.07, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildTabletRightPanel(_ScreenSize s, [BuildContext? ctx]) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeroProfileImage(s),
            const SizedBox(height: 20),
            _buildStatsGrid(s, cols: 3, ctx: ctx),
            const SizedBox(height: 16),
            //  _buildCoreStackRow(s),
          ],
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 700.ms)
        .slideX(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  // Tablet stacked: horizontal stats row
  Widget _buildTabletStatsRow(_ScreenSize s) {
    return _buildStatsGrid(s, cols: 3)
        .animate()
        .fadeIn(delay: 600.ms, duration: 500.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  // Mobile: 2-col stats grid
  Widget _buildMobileStatsGrid(_ScreenSize s) {
    return _buildStatsGrid(s, cols: 2)
        .animate()
        .fadeIn(delay: 600.ms, duration: 500.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  STATS GRID
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatsGrid(
    _ScreenSize s, {
    required int cols,
    BuildContext? ctx,
  }) {
    final isSmall = s == _ScreenSize.smallPhone;

    // Compute actual available card width to pick a safe aspect ratio.
    // When a BuildContext is provided we use the real panel width;
    // otherwise fall back to the old heuristic.
    double aspectRatio;
    if (ctx != null && cols == 3) {
      final panelW = MediaQuery.of(ctx).size.width;
      // In side-by-side tablet/desktop layouts the right panel is ~45% of
      // screen width minus padding.  Each card is roughly (panelW - 2*gaps) / 3.
      final cardW = (panelW * 0.45 - 20) / 3.0; // approx cell width
      // Choose aspectRatio so the fixed content (~60 px tall) always fits.
      if (cardW < 80) {
        aspectRatio = 1.20;
      } else if (cardW < 110) {
        aspectRatio = 1.30;
      } else {
        aspectRatio = isSmall ? 1.35 : 1.45;
      }
    } else {
      aspectRatio = cols == 3
          ? (isSmall ? 1.35 : 1.45)
          : (isSmall ? 1.75 : 1.95);
    }

    return GridView.count(
      crossAxisCount: cols,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: aspectRatio,
      children: [
        _buildStatCard(
          '4+',
          'Years Experience',
          Icons.workspace_premium_rounded,
          s,
          ctx: ctx,
        ),
        _buildStatCard(
          '20+',
          'Apps Delivered',
          Icons.phone_android_rounded,
          s,
          ctx: ctx,
        ),
        _buildStatCard(
          '20%',
          'Performance Gains',
          Icons.speed_rounded,
          s,
          ctx: ctx,
        ),
        _buildStatCard(
          'Flutter',
          '& Dart Specialty',
          FontAwesomeIcons.flutter,
          s,
          isFa: true,
          ctx: ctx,
        ),
        _buildStatCard(
          '5 Apps',
          'Live on Play Store',
          FontAwesomeIcons.googlePlay,
          s,
          isFa: true,
          ctx: ctx,
        ),
        _buildStatCard(
          '4 Apps',
          'Live on App Store',
          FontAwesomeIcons.appStoreIos,
          s,
          isFa: true,
          ctx: ctx,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    dynamic icon,
    _ScreenSize s, {
    bool isFa = false,
    BuildContext? ctx,
  }) {
    final isSmall = s == _ScreenSize.smallPhone;
    final isDesktopOrTablet =
        s == _ScreenSize.desktop || s == _ScreenSize.tablet;

    // Detect narrow panel (945-1525 px) to use smaller sizes even on
    // tablet/desktop so content fits the constrained cell height.
    final screenW = ctx != null ? MediaQuery.of(ctx).size.width : 9999.0;
    final isNarrowPanel = screenW >= 915 && screenW < 1525;

    final valueFontSize = isSmall
        ? 13.5
        : isNarrowPanel
        ? 13.5
        : (isDesktopOrTablet ? 18.5 : 14.5);
    final labelFontSize = isSmall
        ? 9.5
        : isNarrowPanel
        ? 9.5
        : (isDesktopOrTablet ? 12.5 : 10.0);
    final iconSize = isSmall
        ? 13.0
        : isNarrowPanel
        ? 13.0
        : (isDesktopOrTablet ? 15.0 : 14.0);
    final iconBoxSize = isSmall
        ? 26.0
        : isNarrowPanel
        ? 26.0
        : (isDesktopOrTablet ? 32.0 : 28.0);
    final hPad = isSmall ? 9.0 : (isNarrowPanel ? 4.0 : 11.0);
    final vPad = isSmall ? 9.0 : (isNarrowPanel ? 4.0 : 11.0);
    final radius = BorderRadius.circular(10);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            // Glassmorphism base
            color: AppTheme.cardColor.withOpacity(0.55),
            borderRadius: radius,
            // Gradient border via gradient + thin inner container trick
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.22),
              width: 1,
            ),
            boxShadow: [
              // Outer cyan glow
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.08),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
              // Deep shadow for depth
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          child: Stack(
            children: [
              // ── Top highlight line (glassmorphism shine) ──
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryColor.withOpacity(0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Card body ───────────────────────────────────
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon pill + value row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon with glowing background bubble
                            Container(
                              width: iconBoxSize,
                              height: iconBoxSize,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.22),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.12),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isFa
                                    ? FaIcon(
                                        icon as FaIconData,
                                        size: iconSize,
                                        color: AppTheme.primaryColor,
                                      )
                                    : Icon(
                                        icon as IconData,
                                        size: iconSize + 1,
                                        color: AppTheme.primaryColor,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Value text
                            Text(
                              value,
                              style: GoogleFonts.firaCode(
                                color: AppTheme.primaryColor,
                                fontSize: valueFontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: (isSmall || isNarrowPanel) ? 3 : 6),
                        // Label
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            color: AppTheme.secondaryColor.withOpacity(0.80),
                            fontSize: labelFontSize,
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  CORE STACK ROW
  // ─────────────────────────────────────────────────────────────────────────
  // Widget _buildCoreStackRow(_ScreenSize s) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: 3,
  //             height: 3,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: AppTheme.primaryColor.withOpacity(0.6),
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             'Core Stack',
  //             style: GoogleFonts.firaCode(
  //               color: AppTheme.secondaryColor.withOpacity(0.7),
  //               fontSize: 10.5,
  //               letterSpacing: 0.8,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Wrap(
  //         spacing: 6,
  //         runSpacing: 6,
  //         children: [
  //           _buildStackBadge('Flutter', FontAwesomeIcons.flutter, s),
  //           _buildStackBadge('Dart', Icons.code, s, isFa: false),
  //           _buildStackBadge('Firebase', FontAwesomeIcons.fire, s),
  //           _buildStackBadge('Git', FontAwesomeIcons.git, s),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildStackBadge(
    String label,
    dynamic icon,
    _ScreenSize s, {
    bool isFa = true,
  }) {
    final fontSize = s == _ScreenSize.smallPhone ? 9.5 : 10.5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.20),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isFa
              ? FaIcon(
                  icon as FaIconData,
                  size: 10,
                  color: AppTheme.primaryColor.withOpacity(0.85),
                )
              : Icon(
                  icon as IconData,
                  size: 10,
                  color: AppTheme.primaryColor.withOpacity(0.85),
                ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.firaCode(
              color: AppTheme.textColor.withOpacity(0.85),
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  SIDEBAR EMAIL
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSidebarEmail() {
    return Positioned(
      left: 24,
      bottom: 0,
      top: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 1,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.primaryColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            RotatedBox(
              quarterTurns: 3,
              child: TextButton(
                onPressed: () => launchURL(_email),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                ),
                child: Text(
                  'mshohan088@gmail.com',
                  style: GoogleFonts.firaCode(
                    color: AppTheme.secondaryColor,
                    fontSize: 11,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 1,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  LEFT CONTENT PANEL
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildContent(BuildContext context, _ScreenSize s) {
    final isDesktop = s == _ScreenSize.desktop;
    final isTablet = s == _ScreenSize.tablet;
    final isSmall = s == _ScreenSize.smallPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGreeting(s),
        SizedBox(height: isSmall ? 12 : 16),
        _buildName(s),
        SizedBox(height: isSmall ? 8 : 10),
        _buildTypewriter(s),
        SizedBox(height: isSmall ? 16 : (isDesktop ? 24 : 20)),
        _buildBio(s),
        SizedBox(height: isSmall ? 20 : (isDesktop || isTablet ? 28 : 24)),
        _buildCoreSkills(s),
        SizedBox(height: isSmall ? 24 : (isDesktop ? 32 : 28)),
        _buildActions(context, s),
        SizedBox(height: isSmall ? 12 : 16),
      ],
    );
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting(_ScreenSize s) {
    final isSmall = s == _ScreenSize.smallPhone;
    final fontSize = isSmall ? 10.5 : 12.5;

    return Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Pulsing dot
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (_, __) => Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(
                        0.65 * _pulseAnimation.value,
                      ),
                      blurRadius: 9 * _pulseAnimation.value,
                      spreadRadius: 1.5 * _pulseAnimation.value,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Available for work',
              style: GoogleFonts.firaCode(
                color: AppTheme.primaryColor,
                fontSize: fontSize,
                letterSpacing: 0.9,
              ),
            ),
            Container(
              width: 1,
              height: 12,
              color: AppTheme.secondaryColor.withOpacity(0.35),
            ),
            const Icon(
              Icons.waving_hand_rounded,
              color: Color(0xFFFFC107),
              size: 16,
            ),
            Text(
              'Hi, my name is',
              style: GoogleFonts.firaCode(
                color: AppTheme.secondaryColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.08, end: 0, curve: Curves.easeOutCubic);
  }

  // ─── Name ────────────────────────────────────────────────────────────────
  Widget _buildName(_ScreenSize s) {
    return ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFCCD6F6), Color(0xFFE6F1FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Md. Shohanur Rahaman.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: _nameFontSize(s),
              fontWeight: FontWeight.w800,
              height: 1.06,
              letterSpacing: s == _ScreenSize.smallPhone ? -0.8 : -1.4,
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 150.ms, duration: 600.ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
  }

  // ─── Typewriter ──────────────────────────────────────────────────────────
  Widget _buildTypewriter(_ScreenSize s) {
    final fontSize = _typewriterFontSize(s);
    final prefixSize = fontSize - 2;
    final rowHeight = fontSize + 20.0;

    return SizedBox(
          height: rowHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "I'm a ",
                  style: GoogleFonts.inter(
                    color: AppTheme.secondaryColor.withOpacity(0.65),
                    fontSize: prefixSize,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      _headlines[_headlineIndex],
                      key: ValueKey<int>(_headlineIndex),
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                _buildBlinkingCursor(fontSize),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildBlinkingCursor(double fontSize) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (_, value, __) => Opacity(
        opacity: value > 0.5 ? 1.0 : 0.0,
        child: Container(
          width: 2.0,
          height: fontSize * 1.1,
          margin: const EdgeInsets.only(left: 2),
          color: AppTheme.primaryColor,
        ),
      ),
      onEnd: () => setState(() {}),
    );
  }

  // ─── Bio ──────────────────────────────────────────────────────────────────
  Widget _buildBio(_ScreenSize s) {
    return Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor,
              fontSize: _bioFontSize(s),
              height: 1.80,
            ),
            children: [
              const TextSpan(
                text:
                    'I specialize in architecting beautiful, highly scalable, and user-centric mobile applications using ',
              ),
              TextSpan(
                text: 'Flutter & Dart',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text: ', focused on performance and efficiency. Delivered ',
              ),
              TextSpan(
                text: '20+ production apps',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' live on '),
              TextSpan(
                text: 'Play Store & App Store',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text:
                    ', with a passion for clean code and scalable architectures.',
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 450.ms, duration: 600.ms)
        .slideY(begin: 0.07, end: 0, curve: Curves.easeOutCubic);
  }

  // ─── Core Skills Pills ────────────────────────────────────────────────────
  Widget _buildCoreSkills(_ScreenSize s) {
    final isSmall = s == _ScreenSize.smallPhone;
    final skills = ['Flutter', 'Dart', 'GetX', 'REST APIs', 'Firebase', 'Git'];

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 1,
                  color: AppTheme.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'Core Stack',
                  style: GoogleFonts.firaCode(
                    color: AppTheme.secondaryColor.withOpacity(0.8),
                    fontSize: isSmall ? 10.0 : 11.5,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmall ? 8 : 10),
            Wrap(
              spacing: isSmall ? 6 : 8,
              runSpacing: isSmall ? 6 : 8,
              children: skills.map((sk) => _buildSkillPill(sk, s)).toList(),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 620.ms, duration: 500.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildSkillPill(String label, _ScreenSize s) {
    final isSmall = s == _ScreenSize.smallPhone;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 13,
        vertical: isSmall ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.26),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.firaCode(
              color: AppTheme.textColor.withOpacity(0.88),
              fontSize: isSmall ? 10.0 : 11.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons ───────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context, _ScreenSize s) {
    final isSmall = s == _ScreenSize.smallPhone;

    return Wrap(
          spacing: isSmall ? 10 : 12,
          runSpacing: isSmall ? 10 : 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildPrimaryButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              onTap: () => launchURL(resumeUrl),
              isHovered: _cvHovered,
              onHover: (h) => setState(() => _cvHovered = h),
              s: s,
              filled: true,
            ),
            _buildPrimaryButton(
              label: 'Get in Touch',
              icon: Icons.send_rounded,
              onTap: widget.onContactTap,
              isHovered: _contactHovered,
              onHover: (h) => setState(() => _contactHovered = h),
              s: s,
              filled: false,
            ),
            _buildSocialIcon(FontAwesomeIcons.github, _githubUrl, s),
            _buildSocialIcon(FontAwesomeIcons.linkedin, _linkedInUrl, s),
          ],
        )
        .animate()
        .fadeIn(delay: 750.ms, duration: 600.ms)
        .slideY(begin: 0.07, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isHovered,
    required ValueChanged<bool> onHover,
    required _ScreenSize s,
    required bool filled,
  }) {
    final isSmall = s == _ScreenSize.smallPhone;
    final isDesktop = s == _ScreenSize.desktop;
    final hPad = isSmall ? 14.0 : (isDesktop ? 22.0 : 18.0);
    final vPad = isSmall ? 10.0 : (isDesktop ? 14.0 : 12.0);
    final fontSize = isSmall ? 11.5 : (isDesktop ? 13.5 : 12.5);
    final iconSize = isSmall ? 13.0 : 15.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: filled
                ? (isHovered
                      ? AppTheme.primaryColor.withOpacity(0.92)
                      : AppTheme.primaryColor.withOpacity(0.09))
                : (isHovered
                      ? AppTheme.cardColor.withOpacity(0.88)
                      : Colors.transparent),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(
                isHovered ? 1.0 : (filled ? 0.75 : 0.45),
              ),
              width: 1.5,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.18),
                      blurRadius: 18,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: filled
                    ? (isHovered
                          ? AppTheme.backgroundColor
                          : AppTheme.primaryColor)
                    : AppTheme.primaryColor,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: GoogleFonts.firaCode(
                  color: filled
                      ? (isHovered
                            ? AppTheme.backgroundColor
                            : AppTheme.primaryColor)
                      : AppTheme.primaryColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(FaIconData icon, String url, _ScreenSize s) {
    final size = s == _ScreenSize.smallPhone ? 16.0 : 18.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        onPressed: () => launchURL(url),
        icon: FaIcon(icon, color: AppTheme.secondaryColor, size: size),
        style: IconButton.styleFrom(
          backgroundColor: AppTheme.cardColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: AppTheme.primaryColor.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PROFILE IMAGE
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeroProfileImage(_ScreenSize s) {
    final double imgSize = _profileImageSize(s);
    final cornerSize = s == _ScreenSize.smallPhone ? 14.0 : 18.0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, __) => Container(
              width: imgSize + 24,
              height: imgSize + 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(
                      0.14 * _pulseAnimation.value,
                    ),
                    blurRadius: 36 * _pulseAnimation.value,
                    spreadRadius: 3 * _pulseAnimation.value,
                  ),
                ],
              ),
            ),
          ),

          // Corner accents
          ...List.generate(4, (i) {
            final isTop = i < 2;
            final isLeft = i.isEven;
            return Positioned(
              top: isTop ? 0 : null,
              bottom: isTop ? null : 0,
              left: isLeft ? 0 : null,
              right: isLeft ? null : 0,
              child: Container(
                width: cornerSize,
                height: cornerSize,
                decoration: BoxDecoration(
                  border: Border(
                    top: isTop
                        ? BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.7),
                            width: 2,
                          )
                        : BorderSide.none,
                    bottom: !isTop
                        ? BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.7),
                            width: 2,
                          )
                        : BorderSide.none,
                    left: isLeft
                        ? BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.7),
                            width: 2,
                          )
                        : BorderSide.none,
                    right: !isLeft
                        ? BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.7),
                            width: 2,
                          )
                        : BorderSide.none,
                  ),
                ),
              ),
            );
          }),

          // Image
          Container(
                width: imgSize,
                height: imgSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.45),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.10),
                      blurRadius: 28,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.5),
                  child: Image.asset(
                    AppConstants.profileImage,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    filterQuality: FilterQuality.medium,
                    gaplessPlayback: true,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.cardColor,
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 350.ms, duration: 700.ms)
              .scale(
                begin: const Offset(0.93, 0.93),
                end: const Offset(1, 1),
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }
}
