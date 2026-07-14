import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

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

  // Macro Nutrient Colors
  static const Color proteinColor = Color(0xFF10B981); // Emerald green
  static const Color carbsColor = Color(0xFF3B82F6); // Blue
  static const Color fatColor = Color(0xFFFFA726); // Orange

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusPill = 999.0;
  static const double radiusCircular = 100.0;

  // Animations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 600);

  // ---------------------------------------------------------------------
  // Elevation surfaces
  //
  // A step above `surface`/`surfaceLight` for stacking translucent panels
  // (e.g. a glass card on top of a glass modal) without everything
  // collapsing into the same flat green-black. Prefer these over inline
  // `Colors.white.withValues(alpha: ...)` so elevation reads consistently
  // across screens.
  // ---------------------------------------------------------------------
  static const Color surface0 = background;
  static const Color surface1 = surface;
  static const Color surface2 = surfaceLight;
  static const Color surface3 = Color(0xFF24402E);

  // ---------------------------------------------------------------------
  // Semantic opacity scale
  //
  // `opacityDisabled` is intentionally higher than a naive 0.5 — WCAG
  // requires disabled controls to stay legible, not just "look greyed out".
  // ---------------------------------------------------------------------
  static const double opacityDisabled = 0.7;
  static const double opacityHint = 0.6;
  static const double opacitySubtle = 0.4;
  static const double opacityFaint = 0.1;

  // ---------------------------------------------------------------------
  // Liquid glass
  //
  // Feeds LiquidGlassSurface/LiquidGlassScope (lib/core/widgets/liquid_glass_surface.dart).
  // Two presets: `glassSettingsNeutral` for general surfaces (cards, modals,
  // sheets, dialogs) and `glassSettingsAccent` for brand-forward surfaces
  // (bottom nav, primary glass CTAs) with a neon-green tint and hotter
  // specular. Keep both understated — liquid glass is a material, not a
  // second neon layer on top of the existing glow language.
  // ---------------------------------------------------------------------
  static const Color glassTint = Color(0xE6081209); // near-black, slight green
  static const Color glassAccentTint = Color(0x3313EC5B); // primary @ ~20%
  static const Color glassBorderColor = Colors.white24;
  static const Color glassHighlightColor = Colors.white70;

  static const LiquidGlassSettings glassSettingsNeutral = LiquidGlassSettings(
    thickness: 18,
    blur: 14,
    chromaticAberration: 0.01,
    lightAngle: 0.78539816339, // 0.25*pi — top-left highlight
    lightIntensity: 0.55,
    ambientStrength: 0.08,
    refractiveIndex: 1.18,
    saturation: 1.35,
    glassColor: glassTint,
  );

  static const LiquidGlassSettings glassSettingsAccent = LiquidGlassSettings(
    thickness: 22,
    blur: 16,
    chromaticAberration: 0.015,
    lightAngle: 0.78539816339,
    lightIntensity: 0.7,
    ambientStrength: 0.12,
    refractiveIndex: 1.22,
    saturation: 1.5,
    glassColor: glassAccentTint,
  );

  // ---------------------------------------------------------------------
  // HUD text styles
  //
  // Centralizes the "cyberpunk HUD label" look (uppercase + tracked-out
  // monospace/Space Grotesk) that was previously copy-pasted as inline
  // TextStyles across scanner/analysis/welcome.
  // ---------------------------------------------------------------------
  static TextStyle get hudLabel => GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: textSecondary,
  );

  static TextStyle get monoLabel =>
      const TextStyle(fontFamily: 'monospace', fontSize: 13, color: textDim);

  static TextStyle get heroNumber => GoogleFonts.spaceGrotesk(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: textPrimary,
    height: 1.0,
  );

  // ---------------------------------------------------------------------
  // Glow
  //
  // Reserve for 1-2 focal points per screen (see plan: "Cyberpunk tal cual"
  // keeps the neon glow language, but it shouldn't be on every surface).
  // ---------------------------------------------------------------------
  static List<BoxShadow> glowPrimary({
    double opacity = 0.35,
    double blur = 24,
  }) => [
    BoxShadow(
      color: primary.withValues(alpha: opacity),
      blurRadius: blur,
      spreadRadius: 2,
    ),
  ];
}
