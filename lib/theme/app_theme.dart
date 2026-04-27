import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF595B8C);
  static const primaryContainer = Color(0xFFC4C4FC);
  static const primaryDim = Color(0xFF4D4F7F);
  static const onPrimary = Color(0xFFFBF7FF);
  static const onPrimaryContainer = Color(0xFF3C3D6C);
  static const secondary = Color(0xFF5D5D72);
  static const secondaryContainer = Color(0xFFE2E0F9);
  static const onSecondaryContainer = Color(0xFF505064);
  static const tertiary = Color(0xFF745479);
  static const tertiaryContainer = Color(0xFFF5CDF9);
  static const onTertiaryContainer = Color(0xFF604266);
  static const surface = Color(0xFFFCF8FE);
  static const surfaceDim = Color(0xFFDBD8E4);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF6F2FB);
  static const surfaceContainer = Color(0xFFF0ECF6);
  static const surfaceContainerHigh = Color(0xFFEAE7F1);
  static const surfaceContainerHighest = Color(0xFFE4E1ED);
  static const onSurface = Color(0xFF32323B);
  static const onSurfaceVariant = Color(0xFF5F5E68);
  static const outlineVariant = Color(0xFFB3B0BC);
  static const outline = Color(0xFF7B7984);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 57, fontWeight: FontWeight.w800, color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.primary,
          letterSpacing: -1.5,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface,
          letterSpacing: -0.5,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.manrope(
          fontSize: 10, fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant, letterSpacing: 1.5,
        ),
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}