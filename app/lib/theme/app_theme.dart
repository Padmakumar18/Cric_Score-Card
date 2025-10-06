import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern cricket scoreboard theme based on professional cricket apps
class AppTheme {
  // Modern blue-based color palette inspired by professional cricket apps
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep navy blue
  static const Color lightBlue = Color(0xFF3B82F6); // Bright blue
  static const Color accentBlue = Color(0xFF60A5FA); // Light accent blue
  static const Color darkNavy = Color(0xFF0F172A); // Very dark navy
  static const Color cardBlue = Color(0xFF1E40AF); // Card background blue
  static const Color surfaceBlue = Color(0xFF1F2937); // Surface blue
  static const Color errorRed = Color(0xFFEF4444); // Modern red
  static const Color successGreen = Color(0xFF10B981); // Modern green
  static const Color warningOrange = Color(0xFFF59E0B); // Modern orange

  // Text colors for dark theme
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  // Background colors for dark theme
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color cardBackground = Color(0xFF374151);

  static ThemeData get modernDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentBlue,
        surface: surfaceDark,
        error: errorRed,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: textPrimary),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: textSecondary),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textOnPrimary,
        ),
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: textOnPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textOnPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentBlue,
          side: const BorderSide(color: accentBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(color: textSecondary),
        hintStyle: GoogleFonts.roboto(color: textTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBackground,
        labelStyle: GoogleFonts.roboto(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Legacy light theme (keeping for compatibility)
  static ThemeData get lightTheme => modernDarkTheme;

  // Additional colors for compatibility with existing code
  static const Color primaryGreen = successGreen;
  static const Color accentSaffron = warningOrange;
  static const Color lightGreen = Color(0xFF22C55E);
  static const Color darkBrown = Color(0xFF78716C);
  static const Color pitchTan = Color(0xFFA3A3A3);

  // Custom colors for specific cricket elements
  static const Color wicketColor = errorRed;
  static const Color boundaryColor = warningOrange;
  static const Color sixColor = successGreen;
  static const Color dotBallColor = Color(0xFF6B7280);
  static const Color wideColor = Color(0xFF8B5CF6);
  static const Color noBallColor = Color(0xFFEC4899);
  static const Color byeColor = Color(0xFF06B6D4);
  static const Color undoColor = Color(0xFFEF4444);
}
