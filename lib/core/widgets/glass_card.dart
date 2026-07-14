import 'package:flutter/material.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';

/// Frosted glass card. Renders real liquid glass refraction where the shader
/// is supported (Impeller) and degrades gracefully to a specular
/// backdrop-blur everywhere else — see [LiquidGlassSurface].
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? color;

  /// Set true if this card's size/position animates continuously (avoids the
  /// upstream memory-spike bug on animated shader geometry).
  final bool animated;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius = DesignTokens.radiusM,
    this.padding,
    this.margin,
    this.borderColor,
    this.color,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final tint = (color ?? Colors.white).withValues(alpha: opacity);
    final settings = DesignTokens.glassSettingsNeutral.copyWith(
      blur: blur,
      glassColor: tint,
    );

    Widget glass = LiquidGlassSurface(
      borderRadius: borderRadius,
      settings: settings,
      animated: animated,
      padding: padding ?? const EdgeInsets.all(DesignTokens.spaceM),
      child: child,
    );

    if (borderColor != null) {
      glass = DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor!, width: 1),
          ),
        ),
        child: glass,
      );
    }

    if (margin != null) {
      glass = Padding(padding: margin!, child: glass);
    }

    return glass;
  }
}
