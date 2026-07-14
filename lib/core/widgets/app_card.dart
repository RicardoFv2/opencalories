import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';

/// The generic "frosted card" surface repeated across meal rows, macro
/// cards, and skeletons. Defaults to a cheap flat translucent fill (no
/// shader) since it's used in lists; pass [glass] for the few cards that
/// should carry real liquid-glass refraction (hero cards, dialogs).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = DesignTokens.radiusL,
    this.glass = false,
    this.animated = false,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool glass;
  final bool animated;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedPadding =
        padding ?? const EdgeInsets.all(DesignTokens.spaceM);
    final inner = Padding(padding: resolvedPadding, child: child);

    Widget card = glass
        ? LiquidGlassSurface(
            borderRadius: borderRadius,
            animated: animated,
            padding: resolvedPadding,
            child: child,
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: inner,
          );

    if (glass && borderColor != null) {
      card = DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor!, width: 1),
          ),
        ),
        child: card,
      );
    }

    if (onTap != null) {
      card = Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap!();
          },
          child: card,
        ),
      );
    }

    return margin != null ? Padding(padding: margin!, child: card) : card;
  }
}
