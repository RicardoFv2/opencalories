import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/features/analysis/domain/food_analysis.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencalories/features/history/data/meal_repository.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/utils/food_translation_helper.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

class AnalysisResultScreen extends ConsumerStatefulWidget {
  final FoodAnalysis? analysis;
  final File? imageFile;
  final bool isViewOnly;

  static const path = '/analysis-result';

  const AnalysisResultScreen({
    super.key,
    this.analysis,
    this.imageFile,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<AnalysisResultScreen> createState() =>
      _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends ConsumerState<AnalysisResultScreen> {
  // Showcase key for the detected items section
  final _detectedItemsKey = GlobalKey();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _maybeStartTutorial();
  }

  Future<void> _maybeStartTutorial() async {
    // Wait for the widget tree to be built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Only show tutorial if there are items and this is not view-only mode
      final items = widget.analysis?.items ?? [];
      if (items.isEmpty || widget.isViewOnly) return;

      // Wait for TutorialService to initialize
      await ref.read(tutorialServiceProvider.future);
      final tutorialService = ref.read(tutorialServiceProvider.notifier);

      if (!tutorialService.hasShownResultsTutorial) {
        // ignore: use_build_context_synchronously
        ShowCaseWidget.of(context).startShowCase([_detectedItemsKey]);
        await tutorialService.markResultsTutorialShown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final items = widget.analysis?.items ?? [];
    final totalCalories = items.fold<int>(
      0,
      (sum, item) => sum + item.calories,
    );
    final totalCarbs = items.fold<int>(0, (sum, item) => sum + item.carbs);
    final totalProtein = items.fold<int>(0, (sum, item) => sum + item.protein);
    final totalFat = items.fold<int>(0, (sum, item) => sum + item.fat);

    final detectedName = items.isNotEmpty
        ? (items.length > 3
              ? '${items.take(3).map((e) => FoodTranslationHelper.getLocalizedFoodItemName(context, e)).join(', ')} +${items.length - 3} ${AppLocalizations.of(context)!.more}'
              : items
                    .map(
                      (e) => FoodTranslationHelper.getLocalizedFoodItemName(
                        context,
                        e,
                      ),
                    )
                    .join(', '))
        : AppLocalizations.of(context)!.unknownFood;

    return ShowCaseWidget(
      builder: (context) => _buildContent(
        context,
        items,
        totalCalories,
        totalCarbs,
        totalProtein,
        totalFat,
        detectedName,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<FoodItem> items,
    int totalCalories,
    int totalCarbs,
    int totalProtein,
    int totalFat,
    String detectedName,
  ) {
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
          widget.isViewOnly
              ? AppLocalizations.of(context)!.mealDetails
              : AppLocalizations.of(context)!.analysis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Scanned Image Card
            if (widget.imageFile != null)
              GestureDetector(
                onTap: () =>
                    context.push('/image-view', extra: widget.imageFile),
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
                      image: FileImage(widget.imageFile!),
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
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: AppTheme.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppLocalizations.of(context)!.matchPercent(
                                      widget.analysis?.confidence ?? 0,
                                    ),
                                    style: GoogleFonts.spaceGrotesk(
                                      color: AppTheme.primary,
                                      fontSize: 11,
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
                              AppLocalizations.of(context)!.detected,
                              style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.primary,
                                fontSize: 12,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Showcase(
                              key: _detectedItemsKey,
                              title: AppLocalizations.of(
                                context,
                              )!.tutorialInspectComponentsTitle,
                              description: AppLocalizations.of(
                                context,
                              )!.tutorialInspectComponentsDesc,
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
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) => Container(
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF1A1A1A,
                                        ), // Solid dark background
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                                              borderRadius:
                                                  BorderRadius.circular(2),
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
                                                AppLocalizations.of(
                                                  context,
                                                )!.detectedFoods,
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
                                                        .withValues(
                                                          alpha: 0.05,
                                                        ),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FoodTranslationHelper.getLocalizedFoodItemName(
                                                          context,
                                                          item,
                                                        ),
                                                        style:
                                                            GoogleFonts.spaceGrotesk(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${FoodTranslationHelper.getLocalizedPortion(context, item)} • ${item.calories} ${AppLocalizations.of(context)!.kcal}',
                                                        style:
                                                            GoogleFonts.spaceGrotesk(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.6,
                                                                  ),
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          _MacroMiniTag(
                                                            label:
                                                                AppLocalizations.of(
                                                                  context,
                                                                )!.protein,
                                                            value:
                                                                '${item.protein}g',
                                                            color: Colors
                                                                .cyanAccent,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          _MacroMiniTag(
                                                            label:
                                                                AppLocalizations.of(
                                                                  context,
                                                                )!.carbs,
                                                            value:
                                                                '${item.carbs}g',
                                                            color: Colors
                                                                .amberAccent,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          _MacroMiniTag(
                                                            label:
                                                                AppLocalizations.of(
                                                                  context,
                                                                )!.fat,
                                                            value:
                                                                '${item.fat}g',
                                                            color: Colors
                                                                .pinkAccent,
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
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ), // Close GestureDetector
                            ), // Close Showcase
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
                Positioned(
                  top: 4,
                  right: -32,
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: Text(
                      AppLocalizations.of(context)!.kcal,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                items.isNotEmpty
                    ? FoodTranslationHelper.getLocalizedPortion(
                        context,
                        items.first,
                      )
                    : AppLocalizations.of(context)!.oneServing,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => context.push('/manual-entry'),
              icon: const Icon(Icons.edit, size: 16),
              label: Text(AppLocalizations.of(context)!.notWhatYouAte),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Macro Distribution Chart
            Builder(
              builder: (context) {
                final totalGrams = totalCarbs + totalProtein + totalFat;
                final carbsPercent = totalGrams > 0
                    ? (totalCarbs / totalGrams * 100).round()
                    : 0;
                final proteinPercent = totalGrams > 0
                    ? (totalProtein / totalGrams * 100).round()
                    : 0;
                final fatPercent = totalGrams > 0
                    ? (totalFat / totalGrams * 100).round()
                    : 0;

                return Padding(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.macroDistribution,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            // Removed "Target Met" as it was non-functional
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
                                if (proteinPercent > 0)
                                  Expanded(
                                    flex: proteinPercent,
                                    child: Container(color: AppTheme.primary),
                                  ),
                                if (carbsPercent > 0)
                                  Expanded(
                                    flex: carbsPercent,
                                    child: Container(color: Colors.blueAccent),
                                  ),
                                if (fatPercent > 0)
                                  Expanded(
                                    flex: fatPercent,
                                    child: Container(
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                if (totalGrams == 0)
                                  Expanded(
                                    flex: 1,
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
                              label: AppLocalizations.of(context)!.carbs,
                              value: '${totalCarbs}g',
                              color: Colors.blueAccent,
                              isPrimary: false,
                            ),
                            _MacroCard(
                              label: AppLocalizations.of(context)!.protein,
                              value: '${totalProtein}g',
                              color: AppTheme.primary,
                              isPrimary: true,
                            ),
                            _MacroCard(
                              label: AppLocalizations.of(context)!.fat,
                              value: '${totalFat}g',
                              color: Colors.orangeAccent,
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      floatingActionButton: widget.isViewOnly
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
                      label: Text(AppLocalizations.of(context)!.retake),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (widget.analysis == null ||
                                  widget.analysis!.items.isEmpty) {
                                if (context.mounted) {
                                  context.showAppSnackBar(
                                    AppLocalizations.of(context)!.noItemsToSave,
                                    isError: true,
                                  );
                                }
                                return;
                              }

                              await HapticFeedback.heavyImpact();
                              setState(() => _isSaving = true);
                              try {
                                if (widget.imageFile == null) return;

                                await ref
                                    .read(mealRepositoryProvider)
                                    .saveMeal(
                                      widget.analysis!,
                                      widget.imageFile!,
                                    );
                                if (context.mounted) {
                                  context.go('/'); // Go home/history
                                  context.showAppSnackBar(
                                    AppLocalizations.of(
                                      context,
                                    )!.mealSavedToHistory,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  context.showAppSnackBar(
                                    AppLocalizations.of(
                                      context,
                                    )!.errorSavingMeal(e.toString()),
                                    isError: true,
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isSaving = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: Text(AppLocalizations.of(context)!.logFood),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
