import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencalories/core/theme/design_tokens.dart';

class AppTheme {
  // Aliases for convenience, pointing to tokens
  static const primary = DesignTokens.primary;
  static const backgroundDark = DesignTokens.background;
  static const surfaceDark = DesignTokens.surface;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
      textTheme: GoogleFonts.spaceGroteskTextTheme(),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        surface: surfaceDark,
        onSurface: DesignTokens.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: DesignTokens.textPrimary,
        centerTitle: true,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: backgroundDark,
          textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceL,
            vertical: DesignTokens.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: backgroundDark,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF333333),
        contentTextStyle: TextStyle(color: DesignTokens.textPrimary),
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(color: DesignTokens.textSecondary),
          bodyMedium: const TextStyle(color: DesignTokens.textSecondary),
        ),
      ),
    );
  }
}
