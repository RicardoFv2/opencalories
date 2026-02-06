import 'package:flutter/material.dart';

class DesignTokens {
  // Colors - Cyberpunk Forest Theme
  static const Color primary = Color(0xFF13EC5B); // Neon Green
  static const Color background = Color(0xFF000000); // True Black
  static const Color surface = Color(0xFF102216); // Deep Forest
  static const Color surfaceLight = Color(0xFF1A2E21);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE0E0E0); // grey[300]
  static const Color textTertiary = Color(0xFFBDBDBD); // grey[400]
  static const Color textDim = Colors.white54;

  // Accents
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  // Animations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 600);
}
