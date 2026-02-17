import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Enhanced Color Palette
  static const Color primaryColor = Color(0xFF64FFDA); // Neon Green/Cyan
  static const Color secondaryColor = Color(0xFF8892B0); // Slate
  static const Color backgroundColor = Color(0xFF0A192F); // Navy
  static const Color cardColor = Color(0xFF112240); // Light Navy
  static const Color accentColor = Color(0xFF57CBCC); // Teal-ish
  static const Color textColor = Color(0xFFCCD6F6); // Lightest Slate
  static const Color errorColor = Color(0xFFFF5252);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: cardColor,
        background: backgroundColor,
        secondary: secondaryColor,
        onPrimary: backgroundColor,
        onSurface: textColor,
        onBackground: textColor,
        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: textColor,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.inter(
          color: textColor,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.firaCode(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyLarge: GoogleFonts.inter(
          color: secondaryColor,
          fontSize: 18,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          color: secondaryColor,
          fontSize: 16,
          height: 1.6,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                primaryColor.withOpacity(0.1),
              ),
            ),
      ),
      iconTheme: const IconThemeData(color: primaryColor, size: 24),
    );
  }
}
