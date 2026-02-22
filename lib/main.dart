import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
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
        title: 'Shohan Project',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (_) => const HomePage());
        },
      ),
    );
  }
}
