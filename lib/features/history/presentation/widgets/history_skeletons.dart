import 'package:flutter/material.dart';
import 'package:opencalories/core/widgets/shimmer_loading.dart';

class SkeletonHistoryCard extends StatelessWidget {
  const SkeletonHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Simulated image leading
          const ShimmerBox(width: 60, height: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simulated time label
                const ShimmerBox(width: 40, height: 12),
                const SizedBox(height: 8),
                // Simulated food names
                const ShimmerBox(width: double.infinity, height: 18),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Simulated calories badge
          const ShimmerBox(width: 70, height: 28, borderRadius: 20),
        ],
      ),
    );
  }
}

class SkeletonHistorySummary extends StatelessWidget {
  const SkeletonHistorySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const ShimmerBox(width: 80, height: 12),
          const SizedBox(height: 16),
          const ShimmerBox(width: 120, height: 48),
          const SizedBox(height: 8),
          const ShimmerBox(width: 40, height: 14),
          const SizedBox(height: 24),
          const ShimmerBox(width: double.infinity, height: 6, borderRadius: 3),
          const SizedBox(height: 8),
          const ShimmerBox(width: 140, height: 12),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => Column(
                children: const [
                  ShimmerBox(width: 40, height: 16),
                  SizedBox(height: 8),
                  ShimmerBox(width: 30, height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
