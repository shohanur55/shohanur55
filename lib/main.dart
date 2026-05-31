import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'presentation/pages/home_page.dart';

void main() {
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
    _bootstrapFuture = _warmUpApp(context);
  }

  Future<void> _warmUpApp(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final repository = PortfolioRepository();
    final providers = <ImageProvider<Object>>[
      const AssetImage(AppConstants.profileImage),
      ...repository.getProjects().expand((project) {
        return project.images.map((image) {
          return image.startsWith('http')
              ? NetworkImage(image)
              : AssetImage(image);
        });
      }),
    ];

    for (final provider in providers) {
      await precacheImage(provider, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
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
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF64FFDA).withOpacity(0.22),
                  width: 4,
                ),
              ),
              child: Center(
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A192F),
                    border: Border.all(
                      color: const Color(0xFF64FFDA).withOpacity(0.22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Color(0xFFE6F1FF),
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Loading portfolio...',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
