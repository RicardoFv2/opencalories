import 'package:flutter/material.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';

/// Tinted pill badge — replaces the repeated "primary @ 10% fill / 30%
/// border" pattern used for kcal badges, confidence tags, etc.
class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    this.leading,
    required this.label,
    this.color = DesignTokens.primary,
    this.glass = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: DesignTokens.spaceM,
      vertical: DesignTokens.spaceS,
    ),
  });

  final Widget? leading;
  final String label;
  final Color color;

  /// Use real liquid glass instead of a flat tint — for badges floating
  /// over photos/camera preview where legibility over varied backgrounds
  /// matters more than list-rendering cost.
  final bool glass;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: DesignTokens.spaceXS),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (glass) {
      return LiquidGlassSurface(
        shapeKind: GlassShapeKind.pill,
        settings: DesignTokens.glassSettingsAccent,
        padding: padding,
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(padding: padding, child: content),
    );
  }
}

/// Convenience alias for a floating glass badge (camera/photo overlays).
class GlassBadge extends StatelessWidget {
  const GlassBadge({
    super.key,
    this.leading,
    required this.label,
    this.color = DesignTokens.primary,
  });

  final Widget? leading;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      AppPill(leading: leading, label: label, color: color, glass: true);
}
