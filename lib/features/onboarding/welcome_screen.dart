import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import '../../core/theme/app_theme.dart';
import 'package:opencalories/core/utils/platform_utils.dart';
import 'package:opencalories/core/utils/responsive.dart';
import '../../core/utils/snackbar_utils.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import '../../core/services/tutorial_service.dart';
import '../settings/data/api_key_repository.dart';
import 'package:opencalories/core/widgets/app_button.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = DesignTokens.surface;
const _tutorialText = DesignTokens.primary;

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShowCaseWidget(
      onFinish: () {
        ref.read(tutorialServiceProvider.notifier).markWelcomeTutorialShown();
      },
      builder: (context) => const _WelcomeContent(),
    );
  }
}

class _WelcomeContent extends ConsumerStatefulWidget {
  const _WelcomeContent();

  @override
  ConsumerState<_WelcomeContent> createState() => _WelcomeContentState();
}

class _WelcomeContentState extends ConsumerState<_WelcomeContent> {
  final _startScanningKey = GlobalKey();
  bool _tutorialStarted = false;
  static Timer? _entranceTimer;

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _entranceTimer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_tutorialStarted) {
        _tutorialStarted = true;
        // Wait for entrance animations to complete
        _entranceTimer = Timer(const Duration(milliseconds: 1500), () async {
          _entranceTimer = null;
          if (!mounted) return;

          await ref.read(tutorialServiceProvider.future);
          final tutorialService = ref.read(tutorialServiceProvider.notifier);

          if (!tutorialService.hasShownWelcomeTutorial && mounted) {
            ShowCaseWidget.of(context).startShowCase([_startScanningKey]);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isShortHeight;
    final l10n = AppLocalizations.of(context)!;
    final heroHeight = responsiveValue(
      context,
      compact: 260.0,
      medium: 320.0,
      expanded: 380.0,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: DesignTokens.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DesignTokens.primary.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: isSmallScreen ? 16 : 32),

                        // Logo/Illustration Placeholder
                        Center(
                          child:
                              Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceDark,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_dining_rounded,
                                      size: 64,
                                      color: AppTheme.primary,
                                    ),
                                  )
                                  .animate()
                                  .scale(
                                    duration: 600.ms,
                                    curve: Curves.easeOutBack,
                                  )
                                  .fadeIn(duration: 600.ms),
                        ),

                        SizedBox(height: isSmallScreen ? 24 : 32),

                        // Welcome Text
                        Text(
                              l10n.openCalories,
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .moveY(begin: 20, end: 0),

                        const SizedBox(height: 16),

                        Text(
                              l10n.welcomeDescription,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: DesignTokens.textSecondary,
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .moveY(begin: 20, end: 0),

                        SizedBox(height: isSmallScreen ? 24 : 32),

                        // Hero Area — local decorative composition (no network
                        // dependency; previously an Image.network placeholder
                        // that broke offline with no loading state).
                        if (!isSmallScreen)
                          SizedBox(
                            height: heroHeight,
                            child: const _ScanHero(),
                          ),

                        SizedBox(height: isSmallScreen ? 24 : 32),

                        // Action Buttons
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Showcase(
                              key: _startScanningKey,
                              title: l10n.scanMeal,
                              description: l10n.tutorialCaptureDesc,
                              tooltipBackgroundColor: _tutorialBg,
                              titleTextStyle: const TextStyle(
                                color: _tutorialText,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              descTextStyle: TextStyle(
                                color: _tutorialText.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                              overlayColor: Colors.black.withValues(alpha: 0.7),
                              child: Semantics(
                                label: l10n.startScanning,
                                button: true,
                                child: AppButton(
                                  label: l10n.startScanning,
                                  variant: AppButtonVariant.primary,
                                  expand: true,
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    final hasKey =
                                        ref
                                            .read(apiKeyProvider)
                                            .valueOrNull
                                            ?.isNotEmpty ??
                                        false;
                                    if (hasKey) {
                                      context.push('/scan');
                                    } else {
                                      context.push('/settings');
                                    }
                                  },
                                ),
                              ),
                            ).animate().fadeIn(delay: 600.ms),

                            const SizedBox(height: 16),

                            Semantics(
                              label: l10n.unlockGeminiAI,
                              button: true,
                              child: AppButton(
                                label: l10n.unlockGeminiAI,
                                variant: AppButtonVariant.ghost,
                                expand: true,
                                foregroundColor: Colors.white70,
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.push('/settings');
                                },
                              ),
                            ).animate().fadeIn(delay: 800.ms),

                            const SizedBox(height: 12),

                            Semantics(
                              label: l10n.connectDevice,
                              button: true,
                              child: AppButton(
                                label: l10n.connectDevice,
                                variant: AppButtonVariant.secondary,
                                expand: true,
                                icon: const Icon(
                                  Icons.bluetooth_connected,
                                  size: 20,
                                ),
                                foregroundColor: Colors.white,
                                borderColor: Colors.white.withValues(
                                  alpha: 0.1,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.showAppSnackBar(
                                    l10n.deviceIntegrationComingSoon,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isSmallScreen ? 16 : 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Decorative scan-frame hero — replaces the old network-image placeholder.
/// Fully local (gradient + icon + the existing corner-bracket scan frame),
/// so it never breaks offline and needs no loading state.
class _ScanHero extends StatelessWidget {
  const _ScanHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DesignTokens.surface2, DesignTokens.surface0],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              Icons.local_dining_rounded,
              size: 96,
              color: DesignTokens.primary.withValues(alpha: 0.12),
            ),
          ),

          // Overlay Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundDark.withValues(alpha: 0.05),
                  AppTheme.backgroundDark.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),

          // Scanning UI Elements
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    child: _CornerBracket(isTop: true, isLeft: true),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: _CornerBracket(isTop: true, isLeft: false),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    child: _CornerBracket(isTop: false, isLeft: true),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: _CornerBracket(isTop: false, isLeft: false),
                  ),

                  // Scanning indicator — real liquid glass badge (static,
                  // non-animated geometry; only the dot inside pulses).
                  Positioned(
                    bottom: -24,
                    right: 0,
                    child: LiquidGlassSurface(
                      shapeKind: GlassShapeKind.pill,
                      settings: DesignTokens.glassSettingsAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Builder(
                        builder: (context) {
                          final dot = Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          );

                          final animatedDot = kIsTest
                              ? dot
                              : dot
                                    .animate(onPlay: (c) => c.repeat())
                                    .fade(duration: 1.seconds);

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              animatedDot,
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.scanning,
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(8)
              : Radius.zero,
        ),
      ),
    );
  }
}
