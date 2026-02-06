import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:opencalories/core/utils/platform_utils.dart';

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonCard({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );

    // Disable infinite animation during tests to allow pumpAndSettle
    if (kIsTest) return card;

    return card
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white10);
  }
}
