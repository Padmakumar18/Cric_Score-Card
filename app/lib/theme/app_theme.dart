import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cricket-themed color palette and theme configuration
class AppTheme {
  // Cricket-themed color palette: Deep green + pitch tan + accent saffron
  static const Color primaryGreen = Color(0xFF1B5E20); // Deep cricket green
  static const Color lightGreen = Color(0xFF4CAF50); // Lighter green
  static const Color pitchTan = Color(0xFFD7CCC8); // Cricket pitch color
  static const Color accentSaffron = Color(0xFFFF9800); // Saffron accent
  static const Color darkBrown = Color(0xFF5D4037); // Dark brown
  static const Color lightTan = Color(0xFFF5F5DC); // Light tan
  static const Color errorRed = Color(0xFFD32F2F); // Error color
  static const Color successGreen = Color(0xFF388E3C); // Success color

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Colors.white;
  static const Color cardBackground = Color(0xFFF8F8F8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: accentSaffron,
        surface: surfaceLight,
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
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
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
          backgroundColor: primaryGreen,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(color: textSecondary),
        hintStyle: GoogleFonts.roboto(color: textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: pitchTan,
        labelStyle: GoogleFonts.roboto(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Custom colors for specific cricket elements
  static const Color wicketColor = errorRed;
  static const Color boundaryColor = accentSaffron;
  static const Color sixColor = Color(0xFF4CAF50);
  static const Color dotBallColor = Color(0xFF9E9E9E);
  static const Color wideColor = Color(0xFF2196F3);
  static const Color noBallColor = Color(0xFF9C27B0);
  static const Color byeColor = Color(0xFF607D8B);
}
