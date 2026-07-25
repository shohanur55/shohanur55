import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/utils/constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'presentation/pages/home_page.dart';

/// Started in [main] before [runApp] so image bytes are in Flutter's asset
/// cache by the time the widget tree calls [precacheImage]. This eliminates
/// the I/O wait — [precacheImage] only needs to decode, not fetch.
Future<void> _profileBytesPreload = Future.value();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚡ Pre-fetch profile image bytes into Flutter's asset cache BEFORE runApp.
  // This way precacheImage only needs to decode (GPU upload), not do I/O.
  // Fire-and-forget — we store the future and await it later in _warmUpApp.
  _profileBytesPreload = rootBundle
      .load(AppConstants.profileImage)
      .then((_) {})
      .catchError((_) {});

  // dotenv is only needed when the contact form submits — no need to block startup.
  dotenv.load(fileName: ".env").ignore();
  runApp(const MyApp());
}

class PortfolioScrollBehavior extends MaterialScrollBehavior {
  const PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic design size based on actual window size
    final size = MediaQueryData.fromView(View.of(context)).size;
    final isMobile = size.width < 850;
    final designSize = isMobile ? const Size(375, 812) : const Size(1920, 1080);

    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      builder: (_, child) => MaterialApp(
        title: 'Md. Shohanur Rahman Portfolio',
        scrollBehavior: const PortfolioScrollBehavior(),
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const BootstrapShell(),
      ),
    );
  }
}

class BootstrapShell extends StatefulWidget {
  const BootstrapShell({super.key});

  @override
  State<BootstrapShell> createState() => _BootstrapShellState();
}

class _BootstrapShellState extends State<BootstrapShell> {
  late final Future<void> _bootstrapFuture;
  bool _bootstrapStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bootstrapStarted) {
      return;
    }

    _bootstrapStarted = true;
    _bootstrapFuture = _warmUpApp();
  }

  Future<void> _warmUpApp() async {
    // ⚡ Fast-path startup: Precache profile image with a tight safety cap (100ms max wait).
    // Eliminates artificial delays so the app loads almost instantly while preserving
    // smooth visual transition to HomePage.
    try {
      await _profileBytesPreload
          .then((_) {
            if (mounted) {
              return precacheImage(
                const ResizeImage(
                  AssetImage(AppConstants.profileImage),
                  width: 320,
                ),
                context,
              );
            }
          })
          .timeout(const Duration(milliseconds: 100));
    } catch (_) {
      // If precache times out or fails, proceed immediately to avoid blocking user.
    }

    if (!mounted) return;

    // 3. Fire-and-forget: precache project cover images in the background.
    //    These NEVER block the splash — they load silently while the user
    //    reads the hero section, so by the time they scroll down, images are ready.
    _precacheProjectImagesInBackground();
  }

  void _precacheProjectImagesInBackground() {
    final repository = PortfolioRepository();
    for (final project in repository.getProjects()) {
      if (!mounted) return;
      final coverImage = project.imageUrl;
      final ImageProvider<Object> provider = coverImage.startsWith('http')
          ? NetworkImage(coverImage)
          : ResizeImage(AssetImage(coverImage), width: 400);

      precacheImage(provider, context).catchError((e) {
        debugPrint('Background precache failed for "${project.title}": $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: isReady ? const HomePage() : const _AppSplashScreen(),
        );
      },
    );
  }
}

class _AppSplashScreen extends StatelessWidget {
  const _AppSplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Orbiting Arc (Clockwise)
                SizedBox(
                  width: 112,
                  height: 112,
                  child:
                      const CircularProgressIndicator(
                            value: 0.65, // partial circle (arc)
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF64FFDA),
                            ),
                            backgroundColor: Colors.transparent,
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .rotate(duration: 2200.ms),
                ),
                // Inner Orbiting Arc (Counter-Clockwise)
                SizedBox(
                  width: 96,
                  height: 96,
                  child:
                      CircularProgressIndicator(
                            value: 0.35, // partial circle (arc)
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF64FFDA).withValues(alpha: 0.4),
                            ),
                            backgroundColor: Colors.transparent,
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .rotate(
                            duration: 1600.ms,
                            begin: 1,
                            end: 0,
                          ), // opposite direction
                ),
                // Glowing Background Halo
                Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF64FFDA,
                            ).withValues(alpha: 0.08),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                      duration: 1800.ms,
                      curve: Curves.easeInOut,
                    ),
                // Central Logo Container
                Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                          0xFF0B1930,
                        ), // Slightly lighter navy for contrast
                        border: Border.all(
                          color: const Color(
                            0xFF64FFDA,
                          ).withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppConstants.profileImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Color(0xFFE6F1FF),
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(
                      duration: 3.seconds,
                      color: const Color(0xFF64FFDA).withValues(alpha: 0.15),
                    )
                    .scale(
                      begin: const Offset(0.98, 0.98),
                      end: const Offset(1.02, 1.02),
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
                  'Loading portfolio...',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fadeIn(duration: 1.seconds)
                .fadeOut(duration: 1.seconds, delay: 1.seconds),
          ],
        ),
      ),
    );
  }
}
