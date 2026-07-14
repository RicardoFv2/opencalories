import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/utils/platform_utils.dart';

/// The outline family a glass surface should take.
enum GlassShapeKind {
  /// Superellipse ("squircle") with [LiquidGlassSurface.borderRadius].
  rounded,

  /// Fully rounded capsule — nav bars, tags, small pills.
  pill,

  /// Circle — icon buttons, FABs.
  circle,
}

LiquidShape _shapeFor(GlassShapeKind kind, double borderRadius) {
  switch (kind) {
    case GlassShapeKind.circle:
      return const LiquidOval();
    case GlassShapeKind.pill:
      return const LiquidRoundedSuperellipse(
        borderRadius: DesignTokens.radiusPill,
      );
    case GlassShapeKind.rounded:
      return LiquidRoundedSuperellipse(borderRadius: borderRadius);
  }
}

/// A single floating liquid-glass surface: cards, modals, badges, dialogs,
/// glass buttons.
///
/// Wraps `liquid_glass_renderer`'s [LiquidGlass.withOwnLayer], which already
/// degrades to [FakeGlass] automatically when the shader isn't supported
/// (non-Impeller renderers). Set [animated] to `true` for surfaces whose
/// bounds change continuously (scan sweep overlays, shimmer skeletons) —
/// this forces the fake path up front rather than letting a moving shader
/// shape hit the upstream memory-spike bug on animated geometry.
class LiquidGlassSurface extends StatelessWidget {
  const LiquidGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = DesignTokens.radiusL,
    this.shapeKind = GlassShapeKind.rounded,
    this.settings,
    this.animated = false,
    this.padding,
    this.margin,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final double borderRadius;
  final GlassShapeKind shapeKind;

  /// Defaults to [DesignTokens.glassSettingsNeutral]. Pass
  /// [DesignTokens.glassSettingsAccent] for brand-forward surfaces.
  final LiquidGlassSettings? settings;
  final bool animated;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// If true, [child] is tinted/refracted by the glass. Defaults to false so
  /// text and icons stay crisp and at full contrast on top of the glass.
  final bool glassContainsChild;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    final glass = LiquidGlass.withOwnLayer(
      shape: _shapeFor(shapeKind, borderRadius),
      settings: settings ?? DesignTokens.glassSettingsNeutral,
      // Force the fake fallback under `flutter test` — liquid_glass_renderer's
      // shaders don't compile against the SkSL target the test harness uses.
      fake: animated || kIsTest,
      glassContainsChild: glassContainsChild,
      clipBehavior: clipBehavior,
      child: content,
    );

    return margin != null ? Padding(padding: margin!, child: glass) : glass;
  }
}

/// Groups multiple [LiquidGlassBlob]s so their shapes melt into each other —
/// the signature "liquid" look. Use for the bottom navigation bar (tab pill
/// blending with the selected indicator / center scan button).
///
/// Keep the child count low (the renderer caps at 16 shapes per group) and
/// avoid nesting scopes; one [LiquidGlassScope] per navigation region.
class LiquidGlassScope extends StatelessWidget {
  const LiquidGlassScope({
    super.key,
    required this.child,
    this.settings,
    this.blend = 24,
    this.fake = false,
  });

  final Widget child;
  final LiquidGlassSettings? settings;

  /// Distance (logical px) at which shapes start blending into one another.
  final double blend;

  /// Force the fake fallback for this whole region.
  final bool fake;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      settings: settings ?? DesignTokens.glassSettingsAccent,
      fake: fake || kIsTest,
      child: LiquidGlassBlendGroup(blend: blend, child: child),
    );
  }
}

/// A single shape inside a [LiquidGlassScope]. Must have a [LiquidGlassScope]
/// ancestor.
class LiquidGlassBlob extends StatelessWidget {
  const LiquidGlassBlob({
    super.key,
    required this.child,
    this.borderRadius = DesignTokens.radiusL,
    this.shapeKind = GlassShapeKind.rounded,
    this.padding,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final double borderRadius;
  final GlassShapeKind shapeKind;
  final EdgeInsetsGeometry? padding;
  final bool glassContainsChild;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return LiquidGlass.grouped(
      shape: _shapeFor(shapeKind, borderRadius),
      glassContainsChild: glassContainsChild,
      clipBehavior: clipBehavior,
      child: content,
    );
  }
}
