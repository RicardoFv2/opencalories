import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/food_analysis.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../history/data/meal_repository.dart';

class AnalysisResultScreen extends ConsumerWidget {
  final FoodAnalysis? analysis;
  final File? imageFile;
  final bool isViewOnly;

  const AnalysisResultScreen({
    super.key,
    this.analysis,
    this.imageFile,
    this.isViewOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate totals
    final items = analysis?.items ?? [];
    final totalCalories = items.fold<int>(
      0,
      (sum, item) => sum + item.calories,
    );
    final totalCarbs = items.fold<int>(0, (sum, item) => sum + item.carbs);
    final totalProtein = items.fold<int>(0, (sum, item) => sum + item.protein);
    final totalFat = items.fold<int>(0, (sum, item) => sum + item.fat);

    final detectedName = items.isNotEmpty
        ? (items.length > 3
              ? '${items.take(3).map((e) => e.name).join(', ')} +${items.length - 3} more'
              : items.map((e) => e.name).join(', '))
        : 'Unknown Food';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isViewOnly ? 'MEAL DETAILS' : 'ANALYSIS',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.usb, size: 16, color: AppTheme.primary),
                SizedBox(width: 4),
                Text(
                  'Pro',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Scanned Image Card
            if (imageFile != null)
              GestureDetector(
                onTap: () => context.push('/image-view', extra: imageFile),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                      ),
                    ],
                    image: DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
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
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: AppTheme.primary,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '98% Match',
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DETECTED',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[950],
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(32),
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      12,
                                      24,
                                      24,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome,
                                              color: AppTheme.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'DETECTED FOODS',
                                              style: GoogleFonts.spaceGrotesk(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Flexible(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: items.length,
                                            separatorBuilder:
                                                (context, index) => Divider(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.05),
                                                ),
                                            itemBuilder: (context, index) {
                                              final item = items[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.name,
                                                      style:
                                                          GoogleFonts.spaceGrotesk(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${item.portionEstimate} • ${item.calories} kcal',
                                                      style:
                                                          GoogleFonts.spaceGrotesk(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        _MacroMiniTag(
                                                          label: 'Protein',
                                                          value:
                                                              '${item.protein}g',
                                                          color: Colors.blue,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        _MacroMiniTag(
                                                          label: 'Carbs',
                                                          value:
                                                              '${item.carbs}g',
                                                          color: Colors.orange,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        _MacroMiniTag(
                                                          label: 'Fat',
                                                          value: '${item.fat}g',
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                detectedName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
              ),

            // 2. Calories Hero
            const SizedBox(height: 16),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  '$totalCalories',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Positioned(
                  top: 4,
                  right: -32,
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().scale(
              delay: 200.ms,
              duration: 400.ms,
              curve: Curves.easeOutBack,
            ),
            Text(
              items.isNotEmpty ? items.first.portionEstimate : '1 serving',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),

            const SizedBox(height: 32),

            // 3. Macro Distribution Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MACRO DISTRIBUTION',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Target Met',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 12,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(color: AppTheme.primary),
                            ),
                            Expanded(
                              flex: 93,
                              child: Container(color: Colors.white30),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(color: Colors.white10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MacroCard(
                          label: 'Carbs',
                          value: '${totalCarbs}g',
                          color: Colors.white,
                          isPrimary: false,
                        ),
                        _MacroCard(
                          label: 'Protein',
                          value: '${totalProtein}g',
                          color: AppTheme.primary,
                          isPrimary: true,
                        ),
                        _MacroCard(
                          label: 'Fat',
                          value: '${totalFat}g',
                          color: Colors.white38,
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Micronutrients
            // 4. Micronutrients (Placeholder for future AI update)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     children: [
            //       _NutrientRow(
            //         icon: Icons.bolt,
            //         label: 'Potassium',
            //         sub: 'Electrolyte Balance',
            //         value: '422mg',
            //         color: AppTheme.primary,
            //       ),
            //       // ...
            //     ],
            //   ),
            // ),
            const SizedBox(height: 100), // Spacing for fab
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isViewOnly
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.replay),
                      label: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (imageFile == null || analysis == null) return;

                        // Show loading or just await
                        try {
                          await ref
                              .read(mealRepositoryProvider)
                              .saveMeal(analysis!, imageFile!);
                          if (context.mounted) {
                            context.go('/'); // Go home/history
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Meal saved to history!'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error saving meal: $e')),
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Log Food'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isPrimary;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppTheme.primary.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: isPrimary
            ? Border.all(color: AppTheme.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppTheme.primary : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isPrimary ? AppTheme.primary : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

// class _NutrientRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String sub;
//   final String value;
//   final Color color;

//   const _NutrientRow({
//     required this.icon,
//     required this.label,
//     required this.sub,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Icon(icon, size: 18, color: color),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     sub,
//                     style: const TextStyle(color: Colors.grey, fontSize: 10),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _MacroMiniTag extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroMiniTag({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
