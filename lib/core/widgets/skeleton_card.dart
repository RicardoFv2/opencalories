import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonCard({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white10);
  }
}
