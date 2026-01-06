import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/image_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../settings/data/api_key_repository.dart';
import '../../analysis/presentation/analysis_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';

class ScannerScreen extends HookConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider.notifier);
    final selectedImage = useState<File?>(null);
    final isProcessing = useState(false);

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
      isProcessing.value = true;
      try {
        final picked = await imageService.pickImage(source);
        if (picked != null) {
          final compressed = await imageService.compressImage(picked);
          selectedImage.value = compressed;
        }
      } finally {
        isProcessing.value = false;
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
                _GlassButton(
                  icon: Icons.photo_library,
                  onTap: () => pickAndProcessImage(ImageSource.gallery),
                ),

                // Shutter Button
                GestureDetector(
                  onTap: () async {
                    if (selectedImage.value == null) {
                      await pickAndProcessImage(ImageSource.camera);
                    } else {
                      // Trigger AI Analysis
                      if (selectedImage.value != null && !isProcessing.value) {
                        isProcessing.value = true;
                        // Logic handled via listen in build
                        try {
                          await ref
                              .read(analysisControllerProvider.notifier)
                              .analyze(selectedImage.value!);
                        } finally {
                          isProcessing.value = false;
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

                _GlassButton(icon: Icons.history, onTap: () => context.go('/')),
              ],
            ),
          ),

          if (isProcessing.value)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
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
