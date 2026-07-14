import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';
import 'package:opencalories/features/settings/data/api_key_repository.dart';
import 'package:opencalories/l10n/app_localizations.dart';

/// Root shell for the three persistent tabs (Home, Insights, Settings) plus
/// a floating center action that pushes the full-screen Scanner.
class LiquidGlassBottomNav extends ConsumerWidget {
  const LiquidGlassBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasKey = ref.watch(apiKeyProvider).valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: DesignTokens.background,
      extendBody: true,
      body: navigationShell,
      // Pre-auth, `/settings` is reached as a one-off push from Welcome, not
      // a real tab destination yet — hide the bar so the other two tabs
      // don't look available before there's an API key.
      bottomNavigationBar: hasKey ? _NavBar(navigationShell: navigationShell) : null,
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.spaceL,
        0,
        DesignTokens.spaceL,
        MediaQuery.paddingOf(context).bottom + DesignTokens.spaceS,
      ),
      child: SizedBox(
        height: 84,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Real liquid glass pill — static geometry (no shape animation),
            // which keeps it on the renderer's cached/optimized path.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LiquidGlassSurface(
                shapeKind: GlassShapeKind.pill,
                settings: DesignTokens.glassSettingsAccent,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavItem(
                          icon: Icons.home_rounded,
                          label: l10n.navHome,
                          selected: navigationShell.currentIndex == 0,
                          onTap: () => _select(context, 0),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.insights_rounded,
                          label: l10n.navInsights,
                          selected: navigationShell.currentIndex == 1,
                          onTap: () => _select(context, 1),
                        ),
                      ),
                      const SizedBox(width: 72),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.settings_rounded,
                          label: l10n.navSettings,
                          selected: navigationShell.currentIndex == 2,
                          onTap: () => _select(context, 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Solid neon CTA — kept opaque/flat on purpose (the cyberpunk
            // "bold accent button" language), floating above the glass pill.
            Positioned(bottom: 20, child: _ScanButton(label: l10n.navScan)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? DesignTokens.primary : DesignTokens.textDim;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/scan');
        },
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DesignTokens.primary,
            boxShadow: DesignTokens.glowPrimary(opacity: 0.5, blur: 20),
          ),
          child: const Icon(Icons.camera_alt_rounded, color: Colors.black, size: 26),
        ),
      ),
    );
  }
}
