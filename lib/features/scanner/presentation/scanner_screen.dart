import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:camera/camera.dart';

import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/services/image_service.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/core/utils/platform_utils.dart';
import '../../settings/data/api_key_repository.dart';
import '../../settings/data/model_preference_service.dart';
import '../../analysis/presentation/analysis_controller.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/widgets/glass_modal.dart';
import '../../history/data/daily_calories_provider.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = DesignTokens.surface;
const _tutorialText = DesignTokens.primary;

final scannerImageProvider = StateProvider<File?>((ref) => null);

class ScannerScreen extends StatefulHookConsumerWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  // Showcase keys
  final _cameraKey = GlobalKey();
  final _galleryKey = GlobalKey();
  final _historyKey = GlobalKey();
  final _modelBadgeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => _ScannerContent(
        cameraKey: _cameraKey,
        galleryKey: _galleryKey,
        historyKey: _historyKey,
        modelBadgeKey: _modelBadgeKey,
      ),
      onFinish: () {
        // Mark tutorial as shown when finished or skipped
        ref.read(tutorialServiceProvider.notifier).markHomeTutorialShown();
      },
    );
  }
}

class _ScannerContent extends HookConsumerWidget {
  final GlobalKey cameraKey;
  final GlobalKey galleryKey;
  final GlobalKey historyKey;
  final GlobalKey modelBadgeKey;

  const _ScannerContent({
    required this.cameraKey,
    required this.galleryKey,
    required this.historyKey,
    required this.modelBadgeKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider.notifier);
    final selectedImage = ref.watch(scannerImageProvider);
    final processingStatus = useState<String?>(null);
    final rebuildTrigger = useState(0); // Force rebuild for badge update
    final l10n = AppLocalizations.of(context)!;

    // Camera state
    final cameraController = useState<CameraController?>(null);
    final isCameraInitialized = useState(false);

    // Initialize camera and reset state
    useEffect(() {
      // 1. Reset any previous scan/analysis state
      Future.microtask(() {
        ref.read(scannerImageProvider.notifier).state = null;
        ref.invalidate(analysisControllerProvider);
      });

      Future<void> initCamera() async {
        try {
          final cameras = await availableCameras();
          if (cameras.isNotEmpty) {
            // Use the first camera (usually back camera)
            final controller = CameraController(
              cameras.first,
              ResolutionPreset.high,
              enableAudio:
                  false, // Disable audio to prevent web permission issues
            );

            await controller.initialize();

            if (context.mounted) {
              cameraController.value = controller;
              isCameraInitialized.value = true;
            }
          }
        } catch (e) {
          debugPrint('Error initializing camera: $e');
        }
      }

      initCamera();

      // Check and start tutorial on first build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Wait for TutorialService to initialize
        await ref.read(tutorialServiceProvider.future);
        final tutorialService = ref.read(tutorialServiceProvider.notifier);

        if (!tutorialService.hasShownHomeTutorial) {
          if (context.mounted) {
            ShowCaseWidget.of(
              context,
            ).startShowCase([cameraKey, galleryKey, historyKey, modelBadgeKey]);
          }
        }
      });

      return () {
        cameraController.value?.dispose();
      };
    }, const []);

    Future<void> captureImage() async {
      final controller = cameraController.value;
      if (controller == null || !controller.value.isInitialized) return;

      if (controller.value.isTakingPicture) return;

      try {
        await HapticFeedback.mediumImpact();

        final XFile image = await controller.takePicture();
        final file = File(image.path);

        // Immediate visual feedback (150-300ms perceived response)
        ref.read(scannerImageProvider.notifier).state = file;

        // Compress without blocking UI
        final compressed = await ref
            .read(imageServiceProvider.notifier)
            .compressImage(file);

        // Update state behind the scenes if the user hasn't discarded the image
        if (ref.read(scannerImageProvider) != null) {
          ref.read(scannerImageProvider.notifier).state = compressed;
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
        if (context.mounted) {
          context.showAppSnackBar(
            l10n.analysisFailed('Capture failed'),
            isError: true,
          );
        }
      }
    }

    Future<void> pickAndProcessImage(ImageSource source) async {
      try {
        final picked = await imageService.pickImage(source);
        if (picked != null) {
          ref.read(scannerImageProvider.notifier).state = picked;

          // Process immediately
          ref.read(analysisControllerProvider.notifier).analyze(picked);

          // Navigate immediately
          if (context.mounted) {
            context.push('/analysis', extra: {'image': picked});
          }
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
      }
    }

    ref.listen(analysisControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (analysis) {
          if (analysis != null && selectedImage != null) {
            if (analysis.items.isEmpty) {
              // Show not-food alert
              context.showAppSnackBar(l10n.noFoodDetected, isError: true);
              ref.read(scannerImageProvider.notifier).state =
                  null; // Clear the invalid image

              // If we are covered by AnalysisResultScreen (optimistic UI), pop it.
              final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
              if (!isCurrent && context.canPop()) {
                context.pop();
              }
              return;
            }
            // Since we push immediately now, we don't need ScannerScreen to push again.
            // But we keep this just in case we didn't push immediately for some reason.
            final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
            if (isCurrent) {
              context.push(
                '/analysis',
                extra: {'analysis': analysis, 'image': selectedImage},
              );
            }
          }
        },
        error: (error, stack) {
          context.showAppSnackBar(
            l10n.analysisFailed(error.toString()),
            isError: true,
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Viewfinder / Image Preview
          Positioned.fill(
            child: selectedImage != null
                ? Image.file(selectedImage, fit: BoxFit.cover)
                : (isCameraInitialized.value && cameraController.value != null)
                ? CameraPreview(cameraController.value!)
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
          ),

          // 2. Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ),

          // 3. Top Bar
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleButton(
                      icon: Icons.logout,
                      semanticLabel: l10n.logout,
                      onTap: () async {
                        // Clear API key to reset app state (Back to Welcome)
                        await ref.read(apiKeyRepositoryProvider).deleteApiKey();
                        ref.invalidate(apiKeyProvider);
                      },
                    ),
                    Text(
                      l10n.scanMeal,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _CircleButton(
                      icon: selectedImage != null
                          ? Icons.close
                          : Icons.arrow_back,
                      semanticLabel: selectedImage != null
                          ? l10n.close
                          : l10n.back,
                      onTap: () {
                        if (selectedImage != null) {
                          ref.read(scannerImageProvider.notifier).state = null;
                        } else {
                          if (context.canPop()) context.pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Main Content (Scanner Frame)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Daily Calories Badge (New Overlay)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: const _DailyCaloriesBadge(),
                  ),
                ),

                // Active Badge
                Showcase(
                  key: modelBadgeKey,
                  title: l10n.tutorialModelTitle,
                  description: l10n.tutorialModelDesc,
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
                  child: Consumer(
                    builder: (context, ref, child) {
                      final asyncModel = ref.watch(
                        modelPreferenceServiceInitializedProvider,
                      );
                      return asyncModel.when(
                        data: (service) {
                          final currentModel = service.getSelectedModel();
                          final friendlyName =
                              ModelPreferenceService.getFriendlyName(
                                currentModel,
                              );

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              GlassModal.show(
                                context: context,
                                title: 'Select AI Model',
                                child: _ModelSelectorSheet(
                                  service: service,
                                  currentModel: currentModel,
                                  onModelSelected: () {
                                    rebuildTrigger.value++; // Refresh badge
                                  },
                                ),
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                final badge = Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (kIsTest)
                                        const Icon(
                                          Icons.bolt,
                                          color: AppTheme.primary,
                                          size: 16,
                                        )
                                      else
                                        const Icon(
                                              Icons.bolt,
                                              color: AppTheme.primary,
                                              size: 16,
                                            )
                                            .animate(
                                              onPlay: (c) =>
                                                  c.repeat(reverse: true),
                                            )
                                            .scale(
                                              begin: const Offset(1, 1),
                                              end: const Offset(1.05, 1.05),
                                              duration: 2.seconds,
                                            ),
                                      const SizedBox(width: 8),
                                      Text(
                                        friendlyName.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                      ),
                                    ],
                                  ),
                                );

                                if (kIsTest) return badge;

                                return badge;
                              },
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (error, stack) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Framing Overlay
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: _ScannerOverlayPainter(),
                        child: Container(),
                      ),

                      // Center Reticle
                      Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.8),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Scan Line
                      Positioned(
                            left: -20,
                            right: -20,
                            top: 0,
                            child: Builder(
                              builder: (context) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primary.withValues(
                                              alpha: 0.8,
                                            ),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppTheme.primary.withValues(
                                              alpha: 0.2,
                                            ),
                                            AppTheme.primary.withValues(
                                              alpha: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .moveY(
                            begin: 0,
                            end: 300,
                            duration: 2.5.seconds,
                            curve: Curves.easeInOut,
                          ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.alignFoodWithinFrame,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 5. Bottom Controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 0,
            right: 0,
            child: selectedImage != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child:
                        Row(
                          children: [
                            // Retake Button
                            _GlassButton(
                              icon: Icons.refresh,
                              semanticLabel: l10n.retake,
                              onTap: () async {
                                await HapticFeedback.mediumImpact();
                                ref.read(scannerImageProvider.notifier).state =
                                    null;
                                // Re-initialize camera if needed or just ensure preview resumes
                                if (isCameraInitialized.value &&
                                    cameraController.value != null &&
                                    !cameraController
                                        .value!
                                        .value
                                        .isStreamingImages) {
                                  await cameraController.value!.resumePreview();
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                            // Analyze Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (processingStatus.value == null) {
                                    await HapticFeedback.heavyImpact();

                                    // Local list of statuses to cycle through
                                    final statuses = [
                                      l10n.analyzingFood,
                                      l10n.analyzingProteins,
                                      l10n.calculatingMacros,
                                      l10n.estimatingPortions,
                                      'IDENTIFYING LOCAL INGREDIENTS...',
                                      'FINALIZING REPORT...',
                                    ];

                                    processingStatus.value = statuses[0];

                                    // Logic to cycle statuses every 2 seconds
                                    final statusTimer = Timer.periodic(
                                      const Duration(seconds: 2),
                                      (timer) {
                                        if (timer.tick < statuses.length) {
                                          processingStatus.value =
                                              statuses[timer.tick];
                                        } else {
                                          timer.cancel();
                                        }
                                      },
                                    );

                                    try {
                                      // Start analysis
                                      ref
                                          .read(
                                            analysisControllerProvider.notifier,
                                          )
                                          .analyze(selectedImage);

                                      // Push immediately for optimistic UI
                                      if (context.mounted) {
                                        context.push(
                                          '/analysis',
                                          extra: {'image': selectedImage},
                                        );
                                      }
                                    } finally {
                                      statusTimer.cancel();
                                      processingStatus.value = null;
                                    }
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: processingStatus.value != null
                                        ? AppTheme.primary.withValues(
                                            alpha: 0.5,
                                          )
                                        : AppTheme.primary,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      if (processingStatus.value == null)
                                        BoxShadow(
                                          color: AppTheme.primary.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (processingStatus.value != null)
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      else
                                        const Icon(
                                          Icons.search,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        processingStatus.value != null
                                            ? l10n.analyzingFood.toUpperCase()
                                            : l10n.analyzeFood.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().slideY(
                          begin: 1,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery Button - Showcase Target 2
                      Showcase(
                        key: galleryKey,
                        title: l10n.tutorialLoadDataTitle,
                        description: l10n.tutorialLoadDataDesc,
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
                        child: _GlassButton(
                          icon: Icons.photo_library,
                          semanticLabel: l10n.gallery,
                          onTap: () => pickAndProcessImage(ImageSource.gallery),
                        ),
                      ),

                      // Shutter Button - Showcase Target 1 (Camera)
                      Showcase(
                        key: cameraKey,
                        title: l10n.tutorialCaptureTitle,
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
                        child: Semantics(
                          button: true,
                          label: l10n.scanning,
                          child: GestureDetector(
                            onTap: () async {
                              if (isCameraInitialized.value &&
                                  cameraController.value != null) {
                                await captureImage();
                              } else {
                                await HapticFeedback.heavyImpact();
                                await pickAndProcessImage(ImageSource.camera);
                              }
                            },
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // History Button - Showcase Target 3
                      Showcase(
                        key: historyKey,
                        title: l10n.tutorialTimeCapsuleTitle,
                        description: l10n.tutorialTimeCapsuleDesc,
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
                        child: _GlassButton(
                          icon: Icons.history,
                          semanticLabel: l10n.history,
                          onTap: () => context.go('/'),
                        ),
                      ),
                    ],
                  ),
          ),

          if (processingStatus.value != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Stack(
                  children: [
                    // Moving scan line with gradient
                    Positioned.fill(
                      child: Builder(
                        builder: (context) {
                          return Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        AppTheme.primary.withValues(alpha: 0.4),
                                        AppTheme.primary.withValues(alpha: 0.0),
                                      ],
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.8,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .slideY(
                                begin: -1.0,
                                end: 8.0,
                                duration: 2.seconds,
                                curve: Curves.linear,
                              );
                        },
                      ),
                    ),
                    // Centered Text with Glass effect
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: AppTheme.primary,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                                  processingStatus.value!,
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .fade(begin: 0.5, end: 1, duration: 800.ms),
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
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final length = 30.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), Offset(length, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, length), paint);

    // Top Right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - length, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - length),
      paint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - length, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModelSelectorSheet extends StatelessWidget {
  final ModelPreferenceService service;
  final String currentModel;
  final VoidCallback onModelSelected;

  const _ModelSelectorSheet({
    required this.service,
    required this.currentModel,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(
          context,
          'gemini-2.5-flash',
          isActive: currentModel == 'gemini-2.5-flash',
        ),
        const SizedBox(height: 12),
        _buildOption(
          context,
          'gemini-3-flash-preview',
          isActive: currentModel == 'gemini-3-flash-preview',
        ),
        const SizedBox(height: 12),
        _buildOption(
          context,
          'gemini-3.1-pro-preview',
          isActive: currentModel == 'gemini-3.1-pro-preview',
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String modelId, {
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        service.setSelectedModel(modelId);
        onModelSelected();
        context.pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isActive ? AppTheme.primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ModelPreferenceService.getFriendlyName(modelId),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ModelPreferenceService.getHint(modelId),
                    style: TextStyle(
                      fontSize: 12,
                      color: modelId.contains('preview')
                          ? Colors.orange
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              const Icon(Icons.bolt, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DailyCaloriesBadge extends ConsumerWidget {
  const _DailyCaloriesBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch daily calories
    final dailyCaloriesAsync = ref.watch(dailyCaloriesProvider);

    return dailyCaloriesAsync.when(
      data: (calories) {
        return GestureDetector(
          onTap: () => context.go('/'), // Quick access to history
          child:
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$calories kcal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(
                    begin: -0.5,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
