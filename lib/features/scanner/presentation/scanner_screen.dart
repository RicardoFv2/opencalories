import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/services/image_service.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../settings/data/api_key_repository.dart';
import '../../analysis/presentation/analysis_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

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

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => _ScannerContent(
        cameraKey: _cameraKey,
        galleryKey: _galleryKey,
        historyKey: _historyKey,
      ),
      onComplete: (index, key) {
        // Mark tutorial as shown when completed
        if (key == _historyKey) {
          ref.read(tutorialServiceProvider.notifier).markHomeTutorialShown();
        }
      },
    );
  }
}

class _ScannerContent extends HookConsumerWidget {
  final GlobalKey cameraKey;
  final GlobalKey galleryKey;
  final GlobalKey historyKey;

  const _ScannerContent({
    required this.cameraKey,
    required this.galleryKey,
    required this.historyKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider.notifier);
    final selectedImage = useState<File?>(null);
    final processingStatus = useState<String?>(null);

    // Check and start tutorial on first build
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Wait for TutorialService to initialize
        await ref.read(tutorialServiceProvider.future);
        final tutorialService = ref.read(tutorialServiceProvider.notifier);

        if (!tutorialService.hasShownHomeTutorial) {
          // ignore: use_build_context_synchronously
          ShowCaseWidget.of(
            context,
          ).startShowCase([cameraKey, galleryKey, historyKey]);
        }
      });
      return null;
    }, const []);

    ref.listen(analysisControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (analysis) {
          if (analysis != null && selectedImage.value != null) {
            context.push(
              '/analysis',
              extra: {'analysis': analysis, 'image': selectedImage.value},
            );
          }
        },
        error: (error, stack) {
          context.showAppSnackBar(
            'Analysis failed: ${error.toString()}',
            isError: true,
          );
        },
      );
    });

    Future<void> pickAndProcessImage(ImageSource source) async {
      processingStatus.value = 'Compressing image...';
      try {
        final picked = await imageService.pickImage(source);
        if (picked != null) {
          final compressed = await imageService.compressImage(picked);
          selectedImage.value = compressed;
        }
      } finally {
        processingStatus.value = null;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Viewfinder / Image Preview
          Positioned.fill(
            child: selectedImage.value != null
                ? Image.file(selectedImage.value!, fit: BoxFit.cover)
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
                      onTap: () async {
                        // Clear API key to reset app state (Back to Welcome)
                        await ref.read(apiKeyRepositoryProvider).deleteApiKey();
                        ref.invalidate(apiKeyProvider);
                      },
                    ),
                    const Text(
                      'Scan Meal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _CircleButton(
                      icon: selectedImage.value != null
                          ? Icons.close
                          : Icons.arrow_back,
                      onTap: () {
                        if (selectedImage.value != null) {
                          selectedImage.value = null;
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
                // Active Badge
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: AppTheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'OPEN CALORIES PRO: ACTIVE',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 2.seconds,
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
                        left: 0,
                        right: 0,
                        top: 0,
                        child:
                            Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppTheme.primary,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .moveY(begin: 0, end: 300, duration: 3.seconds),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Align food within frame...',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Button - Showcase Target 2
                Showcase(
                  key: galleryKey,
                  title: 'Load Data',
                  description:
                      'Pick an existing photo from your device\'s library.',
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
                    onTap: () => pickAndProcessImage(ImageSource.gallery),
                  ),
                ),

                // Shutter Button - Showcase Target 1 (Camera)
                Showcase(
                  key: cameraKey,
                  title: 'Capture Reality',
                  description:
                      'Take a photo of your meal directly to start the analysis.',
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
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedImage.value == null) {
                        await HapticFeedback.heavyImpact();
                        await pickAndProcessImage(ImageSource.camera);
                      } else {
                        // Allow analysis if not currently processing
                        if (processingStatus.value == null) {
                          await HapticFeedback.lightImpact();
                          // Process existing image
                          processingStatus.value = 'Analyzing food...';
                          try {
                            await ref
                                .read(analysisControllerProvider.notifier)
                                .analyze(selectedImage.value!);
                          } finally {
                            processingStatus.value = null;
                          }
                        }
                      }
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
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
                                color: AppTheme.primary.withValues(alpha: 0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(
                            selectedImage.value == null
                                ? Icons.camera_alt
                                : Icons.check,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // History Button - Showcase Target 3
                Showcase(
                  key: historyKey,
                  title: 'Time Capsule',
                  description:
                      'Access your full log of past meals and daily stats.',
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
                    onTap: () => context.go('/'),
                  ),
                ),
              ],
            ),
          ),

          if (processingStatus.value != null)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppTheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      processingStatus.value!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
