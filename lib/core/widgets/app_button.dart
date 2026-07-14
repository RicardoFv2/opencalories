import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart'
    show GlassGlow;
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';

enum AppButtonVariant { primary, secondary, ghost, glass }

/// Unified button. Replaces the various one-off `ElevatedButton`/
/// `OutlinedButton`/`TextButton` call sites and the scanner's private
/// `_CircleButton`/`_GlassButton` (see [AppButton.icon]).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.loading = false,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool expand;
  final bool loading;

  /// Override for secondary/ghost variants that need a more muted look
  /// than the theme default (e.g. a de-emphasized "coming soon" action).
  final Color? foregroundColor;

  /// Override for the secondary variant's outline.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    final child = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(DesignTokens.background),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: DesignTokens.spaceS),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: disabled ? null : onPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: (foregroundColor != null || borderColor != null)
            ? OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: borderColor != null
                    ? BorderSide(color: borderColor!)
                    : null,
              )
            : null,
        child: child,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: disabled ? null : onPressed,
        style: foregroundColor != null
            ? TextButton.styleFrom(foregroundColor: foregroundColor)
            : null,
        child: child,
      ),
      AppButtonVariant.glass => _GlassButtonShell(
        onPressed: disabled ? null : onPressed,
        child: child,
      ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  /// Circular icon-only button (camera shutter row, top-bar actions).
  static Widget iconOnly({
    required IconData icon,
    required VoidCallback? onPressed,
    AppButtonVariant variant = AppButtonVariant.glass,
    double size = 48,
    String? tooltip,
  }) {
    final btn = _GlassIconButton(
      icon: icon,
      onPressed: onPressed,
      variant: variant,
      size: size,
    );
    return tooltip != null ? Tooltip(message: tooltip, child: btn) : btn;
  }
}

void _tap(VoidCallback? onPressed) {
  HapticFeedback.selectionClick();
  onPressed?.call();
}

class _GlassButtonShell extends StatelessWidget {
  const _GlassButtonShell({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassSurface(
      shapeKind: GlassShapeKind.pill,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceM,
      ),
      child: GlassGlow(
        child: GestureDetector(
          onTap: onPressed == null ? null : () => _tap(onPressed),
          child: Opacity(
            opacity: onPressed == null ? DesignTokens.opacityDisabled : 1,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                color: DesignTokens.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              child: IconTheme.merge(
                data: const IconThemeData(color: DesignTokens.textPrimary),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
    required this.variant,
    required this.size,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tappable = GlassGlow(
      child: GestureDetector(
        onTap: onPressed == null ? null : () => _tap(onPressed),
        child: Opacity(
          opacity: onPressed == null ? DesignTokens.opacityDisabled : 1,
          child: Center(
            child: Icon(
              icon,
              color: DesignTokens.textPrimary,
              size: size * 0.45,
            ),
          ),
        ),
      ),
    );

    if (variant != AppButtonVariant.glass) {
      return SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: Colors.white10)),
          ),
          child: tappable,
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: LiquidGlassSurface(
        shapeKind: GlassShapeKind.circle,
        padding: EdgeInsets.zero,
        child: tappable,
      ),
    );
  }
}
