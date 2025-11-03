import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern cricket scoreboard theme with light and dark modes
class AppTheme {
  // ============ DARK MODE COLORS ============
  // Primary colors for dark mode
  static const Color darkPrimary = Color(0xFF2563EB); // Vibrant blue
  static const Color darkSecondary = Color(0xFF10B981); // Bright green
  static const Color darkAccent = Color(0xFF8B5CF6); // Purple accent

  // Background colors for dark mode
  static const Color darkBackground = Color(0xFF0A0E1A); // Very dark blue-black
  static const Color darkSurface = Color(0xFF1A1F35); // Dark surface
  static const Color darkCard = Color(0xFF252B42); // Card background

  // Text colors for dark mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFE5E7EB);
  static const Color darkTextTertiary = Color(0xFF9CA3AF);

  // ============ LIGHT MODE COLORS ============
  // Primary colors for light mode
  static const Color lightPrimary = Color(0xFF1E40AF); // Deep blue
  static const Color lightSecondary = Color(0xFF059669); // Green
  static const Color lightAccent = Color(0xFF7C3AED); // Purple

  // Background colors for light mode
  static const Color lightBackground = Color(0xFFF8FAFC); // Soft white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightCard = Color(0xFFFFFFFF); // Card white

  // Text colors for light mode
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // ============ SHARED COLORS ============
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Legacy compatibility colors (mapped to dark mode)
  static const Color primaryBlue = darkPrimary;
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color accentBlue = Color(0xFF93C5FD);
  static const Color darkNavy = darkBackground;
  static const Color cardBlue = darkCard;
  static const Color surfaceBlue = darkSurface;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;
  static const Color textOnPrimary = Colors.white;
  static const Color backgroundDark = darkBackground;
  static const Color surfaceDark = darkSurface;
  static const Color cardBackground = darkCard;

  // ============ DARK THEME ============
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkAccent,
        surface: darkSurface,
        background: darkBackground,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: darkTextPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: darkTextSecondary),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: darkTextTertiary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: darkTextTertiary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: darkTextSecondary),
        hintStyle: GoogleFonts.inter(color: darkTextTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        labelStyle: GoogleFonts.inter(color: darkTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // ============ LIGHT THEME ============
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAccent,
        surface: lightSurface,
        background: lightBackground,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onBackground: lightTextPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: lightTextPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: lightTextSecondary),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          side: const BorderSide(color: lightPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: lightTextTertiary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: lightTextTertiary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: lightTextSecondary),
        hintStyle: GoogleFonts.inter(color: lightTextTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        labelStyle: GoogleFonts.inter(color: lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: lightTextTertiary.withValues(alpha: 0.2)),
      ),
    );
  }

  // Legacy compatibility
  static ThemeData get modernDarkTheme => darkTheme;

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
