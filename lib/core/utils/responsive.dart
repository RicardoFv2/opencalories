import 'package:flutter/material.dart';
import 'package:opencalories/core/theme/design_tokens.dart';

/// Coarse layout breakpoints. `compact` covers virtually all phones in
/// portrait; `medium`/`expanded` cover phones in landscape, foldables and
/// tablets.
enum Breakpoint { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  Breakpoint get breakpoint {
    final w = screenWidth;
    if (w >= 840) return Breakpoint.expanded;
    if (w >= 600) return Breakpoint.medium;
    return Breakpoint.compact;
  }

  bool get isCompact => breakpoint == Breakpoint.compact;
  bool get isTablet => breakpoint != Breakpoint.compact;

  /// Short viewport (phone in landscape, small phone) — collapse optional
  /// hero content rather than risk overflow.
  bool get isShortHeight => screenHeight < 700;

  EdgeInsets get safePadding => MediaQuery.paddingOf(this);

  /// System text scale, clamped so HUD labels and hero numbers can't blow
  /// past their containers at extreme accessibility settings while still
  /// respecting the user's preference.
  double get clampedTextScale => MediaQuery.textScalerOf(this).scale(1.0).clamp(0.85, 1.3);
}

/// Picks a value for the current breakpoint, falling back to the next
/// smallest tier that was supplied.
T responsiveValue<T>(BuildContext context, {required T compact, T? medium, T? expanded}) {
  switch (context.breakpoint) {
    case Breakpoint.expanded:
      return expanded ?? medium ?? compact;
    case Breakpoint.medium:
      return medium ?? compact;
    case Breakpoint.compact:
      return compact;
  }
}

/// Grid column count for the given breakpoint — used by Weekly's masonry
/// grid and any other multi-column layout that was previously hardcoded to
/// `crossAxisCount: 2`.
int responsiveColumns(BuildContext context) =>
    responsiveValue(context, compact: 2, medium: 3, expanded: 4);

/// Thin [Scaffold] wrapper that standardizes background color and safe-area
/// handling. Optional — screens with bespoke full-bleed layouts (the camera
/// viewfinder in ScannerScreen) should keep composing [Scaffold] directly.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.safeArea = true,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;
  final bool safeArea;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final content = safeArea ? SafeArea(top: !extendBodyBehindAppBar, child: body) : body;

    return Scaffold(
      backgroundColor: backgroundColor ?? DesignTokens.background,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: content,
    );
  }
}
