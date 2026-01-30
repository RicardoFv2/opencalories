import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/snackbar_utils.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import '../../core/services/tutorial_service.dart';
import '../settings/data/api_key_repository.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_tutorialStarted) {
        _tutorialStarted = true;
        // Wait for entrance animations to complete
        await Future.delayed(const Duration(milliseconds: 1500));
        await ref.read(tutorialServiceProvider.future);
        final tutorialService = ref.read(tutorialServiceProvider.notifier);

        if (!tutorialService.hasShownWelcomeTutorial && mounted) {
          ShowCaseWidget.of(context).startShowCase([_startScanningKey]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive layout
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

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
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isSmallScreen)
                    const SizedBox(height: 16)
                  else
                    const Spacer(),

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
                            .scale(duration: 600.ms, curve: Curves.easeOutBack)
                            .fadeIn(duration: 600.ms),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Welcome Text
                  Text(
                    AppLocalizations.of(context)!.openCalories,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.welcomeDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),

                  if (isSmallScreen)
                    const SizedBox(height: 24)
                  else
                    const Spacer(),

                  // Hero Image Area (Only show on larger screens or reduce size)
                  if (!isSmallScreen)
                    Expanded(
                      flex: 3,
                      child: Container(
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
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Placeholder Image
                            Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB90KLW_KTbgpqU3Sp_lJ7_7BxuT6-hgaErq-3qge2Uf9L-amejkYHY3q9Ajel5Hnj8l8oeqt6bGMQANZNzyee2t4uVSTeNAFRg7gs8u0dbOCJRifLelP_py1xKBxze_i-Yu7oudM-WjsQkBswPZD1sY__CYYvqfrcIRXXKxPzzrpnU9ufp8a81_dgfNPRjxV6yv1FgaqQ20_CR0hRHrP72mTwwHzbifezv-i5Wj1nxXyOK1VdbG-myCTBff1of9oT0-Oqd6CWbYNs',
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stackTrace) =>
                                  Container(color: Colors.grey[900]),
                            ),

                            // Overlay Gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.backgroundDark.withValues(
                                      alpha: 0.1,
                                    ),
                                    AppTheme.backgroundDark.withValues(
                                      alpha: 0.9,
                                    ),
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
                                    color: AppTheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    // Corner Brackets
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: _CornerBracket(
                                        isTop: true,
                                        isLeft: true,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: _CornerBracket(
                                        isTop: true,
                                        isLeft: false,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: _CornerBracket(
                                        isTop: false,
                                        isLeft: true,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: _CornerBracket(
                                        isTop: false,
                                        isLeft: false,
                                      ),
                                    ),

                                    // Scanning indicator
                                    Positioned(
                                      bottom: -24,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.primary.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: AppTheme.primary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                )
                                                .animate(
                                                  onPlay: (c) => c.repeat(),
                                                )
                                                .fade(duration: 1.seconds),
                                            const SizedBox(width: 6),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.scanning,
                                              style: TextStyle(
                                                color: AppTheme.primary,
                                                fontSize: 10,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Action Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Start Scanning Button
                      Showcase(
                        key: _startScanningKey,
                        title: AppLocalizations.of(
                          context,
                        )!.scanMeal, // Use valid key
                        description: AppLocalizations.of(
                          context,
                        )!.tutorialCaptureDesc, // Use valid key
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
                        child: ElevatedButton(
                          onPressed: () {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.startScanning,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          context.push('/settings');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white70,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.unlockGeminiAI, // Use valid key
                        ),
                      ).animate().fadeIn(delay: 800.ms),

                      const SizedBox(height: 12),

                      // Secondary Button (Connect Device)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            context.showAppSnackBar(
                              AppLocalizations.of(
                                context,
                              )!.deviceIntegrationComingSoon,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bluetooth_connected, size: 20),
                              SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.connectDevice),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 32),
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
