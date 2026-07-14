import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/features/analysis/domain/food_analysis.dart';
import 'package:opencalories/features/analysis/presentation/analysis_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencalories/features/history/data/meal_repository.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/utils/food_translation_helper.dart';
import 'package:opencalories/core/widgets/app_button.dart';
import 'package:opencalories/core/widgets/app_card.dart';
import 'package:opencalories/core/widgets/app_text_field.dart';
import 'package:opencalories/core/widgets/liquid_glass_surface.dart';
import 'package:opencalories/core/widgets/macro_chip.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = DesignTokens.surface;
const _tutorialText = DesignTokens.primary;

class AnalysisResultScreen extends ConsumerStatefulWidget {
  final FoodAnalysis? analysis;
  final File? imageFile;
  final bool isViewOnly;
  final int? mealId;

  static const path = '/analysis-result';

  const AnalysisResultScreen({
    super.key,
    this.analysis,
    this.imageFile,
    this.isViewOnly = false,
    this.mealId,
  });

  @override
  ConsumerState<AnalysisResultScreen> createState() =>
      _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends ConsumerState<AnalysisResultScreen> {
  // Showcase key for the detected items section
  final _detectedItemsKey = GlobalKey();
  bool _isSaving = false;
  FoodAnalysis? _originalAnalysis;
  bool _shouldStartTutorial = false;

  @override
  void initState() {
    super.initState();
    if (widget.isViewOnly && widget.analysis != null) {
      _originalAnalysis = widget.analysis;
      // Small delay to ensure ref is accessible
      Future.microtask(() {
        ref
            .read(analysisControllerProvider.notifier)
            .setAnalysis(widget.analysis!);
      });
    }
    _maybeStartTutorial();
  }

  Future<void> _maybeStartTutorial() async {
    // Only show tutorial if there are items and this is not view-only mode
    final items = widget.analysis?.items ?? [];
    if (items.isEmpty || widget.isViewOnly) return;

    // Wait for TutorialService to initialize
    await ref.read(tutorialServiceProvider.future);
    final tutorialService = ref.read(tutorialServiceProvider.notifier);

    if (!tutorialService.hasShownResultsTutorial) {
      // Set flag to trigger tutorial after ShowCaseWidget is built
      if (mounted) {
        setState(() => _shouldStartTutorial = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ShowCaseWidget(
      onFinish: () async {
        await ref
            .read(tutorialServiceProvider.notifier)
            .markResultsTutorialShown();
      },
      builder: (showcaseContext) {
        // Always watch the controller to allow reactive updates even from history
        final analysisState = ref.watch(analysisControllerProvider);

        return analysisState.when(
          loading: () {
            return _buildContent(
              showcaseContext,
              null,
              [],
              0,
              0,
              0,
              0,
              isLoading: true,
            );
          },
          error: (error, stack) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceL),
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: DesignTokens.error, size: 40),
                      const SizedBox(height: DesignTokens.spaceM),
                      Text(
                        l10n.errorWithMessage(error.toString()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: DesignTokens.textSecondary),
                      ),
                      const SizedBox(height: DesignTokens.spaceL),
                      AppButton(
                        label: l10n.retake,
                        variant: AppButtonVariant.primary,
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          data: (analysis) {
            final items = analysis?.items ?? [];
            final totalCalories = items.fold<int>(
              0,
              (sum, item) => sum + item.calories,
            );
            final totalCarbs = items.fold<int>(
              0,
              (sum, item) => sum + item.carbs,
            );
            final totalProtein = items.fold<int>(
              0,
              (sum, item) => sum + item.protein,
            );
            final totalFat = items.fold<int>(0, (sum, item) => sum + item.fat);

            // Trigger tutorial after ShowCaseWidget is ready
            if (_shouldStartTutorial) {
              _shouldStartTutorial = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ShowCaseWidget.of(
                  showcaseContext,
                ).startShowCase([_detectedItemsKey]);
              });
            }
            return _buildContent(
              showcaseContext,
              analysis,
              items,
              totalCalories,
              totalCarbs,
              totalProtein,
              totalFat,
            );
          },
        );
      },
    );
  }

  bool _hasChanges(FoodAnalysis? current) {
    if (!widget.isViewOnly) return true; // Always show check/log for new scans
    if (_originalAnalysis == null || current == null) return false;
    return _originalAnalysis != current;
  }

  Widget _buildContent(
    BuildContext context,
    FoodAnalysis? analysis,
    List<FoodItem> items,
    int totalCalories,
    int totalCarbs,
    int totalProtein,
    int totalFat, {
    bool isLoading = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
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
        title:
            Text(
                  widget.isViewOnly
                      ? AppLocalizations.of(context)!.mealDetails
                      : AppLocalizations.of(context)!.analysis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: AppTheme.primary.withValues(alpha: 0.3),
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
                      if ((analysis?.confidence ?? 0) > 0 || isLoading)
                        Positioned(
                          top: 16,
                          left: 16,
                          child:
                              LiquidGlassSurface(
                                    shapeKind: GlassShapeKind.pill,
                                    settings: DesignTokens.glassSettingsAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome,
                                          color: AppTheme.primary,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isLoading
                                              ? l10n.analyzingEllipsis
                                              : l10n.matchPercent(
                                                  analysis?.confidence ?? 0,
                                                ),
                                          style: GoogleFonts.spaceGrotesk(
                                            color: AppTheme.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate(target: isLoading ? 1 : 0)
                                  .shimmer(duration: 1.seconds),
                        ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLoading
                                  ? l10n.identifyingFoodStatus
                                  : (items.isNotEmpty
                                        ? FoodTranslationHelper.getLocalizedFoodItemName(
                                            context,
                                            items.first,
                                          ).toUpperCase()
                                        : l10n.detected),
                              style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.primary,
                                fontSize: 12,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // Name overlay removed in favor of the summary bar below
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
              ),

            // 2. Ingredient Summary Bar (New explicit CTA)
            _buildIngredientSummaryBar(context, items, isLoading: isLoading),

            // 3. Calories Hero
            const SizedBox(height: 16),
            if (isLoading)
              Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          AppLocalizations.of(context)!.kcal,
                          style: TextStyle(
                            fontSize: 18,
                            color: DesignTokens.primary.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1.5.seconds)
            else
              Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          AppLocalizations.of(context)!.kcal,
                          style: TextStyle(
                            fontSize: 18,
                            color: DesignTokens.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(),
            GestureDetector(
              onTap: () {
                if (!isLoading && items.isNotEmpty) {
                  _showIngredientsDetails(context);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: isLoading
                    ? Container(
                            width: 120,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .shimmer(duration: 1.5.seconds)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            items.isNotEmpty
                                ? '${FoodTranslationHelper.getLocalizedPortion(context, items.first)} ${FoodTranslationHelper.getLocalizedFoodItemName(context, items.first)}${items.length > 1 ? " + ${items.length - 1}" : ""}'
                                : AppLocalizations.of(context)!.oneServing,
                            style: TextStyle(
                              color: DesignTokens.textDim.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: DesignTokens.textDim.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new,
                            size: 14,
                            color: DesignTokens.textDim.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Old manual entry link removed as requested
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
                                isLoading
                                    ? Expanded(
                                        child: Container(color: Colors.white12)
                                            .animate(onPlay: (c) => c.repeat())
                                            .shimmer(duration: 1.5.seconds),
                                      )
                                    : const SizedBox.shrink(),
                                if (!isLoading && carbsPercent > 0)
                                  Expanded(
                                    flex: carbsPercent,
                                    child: Container(
                                      color: DesignTokens.carbsColor,
                                    ),
                                  ),
                                if (!isLoading && proteinPercent > 0)
                                  Expanded(
                                    flex: proteinPercent,
                                    child: Container(
                                      color: DesignTokens.proteinColor,
                                    ),
                                  ),
                                if (!isLoading && fatPercent > 0)
                                  Expanded(
                                    flex: fatPercent,
                                    child: Container(
                                      color: DesignTokens.fatColor,
                                    ),
                                  ),
                                if (!isLoading && totalGrams == 0)
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
                          children: [
                            if (isLoading) ...[
                              Expanded(
                                child: MacroChip(type: MacroType.carbs, label: l10n.carbs, grams: 0)
                                    .animate(onPlay: (c) => c.repeat())
                                    .shimmer(duration: 1.5.seconds),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                    MacroChip(
                                      type: MacroType.protein,
                                      label: l10n.protein,
                                      grams: 0,
                                      isPrimary: true,
                                    ).animate(onPlay: (c) => c.repeat()).shimmer(
                                      duration: 1.5.seconds,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MacroChip(type: MacroType.fat, label: l10n.fat, grams: 0)
                                    .animate(onPlay: (c) => c.repeat())
                                    .shimmer(duration: 1.5.seconds),
                              ),
                            ] else ...[
                              Expanded(
                                child:
                                    MacroChip(
                                      type: MacroType.carbs,
                                      label: l10n.carbs,
                                      grams: totalCarbs.toDouble(),
                                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                    MacroChip(
                                      type: MacroType.protein,
                                      label: l10n.protein,
                                      grams: totalProtein.toDouble(),
                                      isPrimary: true,
                                    ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1, end: 0),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                    MacroChip(
                                      type: MacroType.fat,
                                      label: l10n.fat,
                                      grams: totalFat.toDouble(),
                                    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1, end: 0),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 100), // Spacing for fab
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (!widget.isViewOnly) ...[
              Expanded(
                child: AppButton(
                  label: l10n.retake,
                  icon: const Icon(Icons.replay),
                  variant: AppButtonVariant.glass,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child:
                  AppButton(
                        label: (widget.mealId != null || widget.isViewOnly)
                            ? l10n.updateAction
                            : l10n.logFood,
                        icon: Icon(
                          (widget.mealId != null || widget.isViewOnly)
                              ? Icons.update
                              : Icons.check_circle,
                        ),
                        variant: AppButtonVariant.primary,
                        loading: _isSaving,
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (analysis == null || analysis.items.isEmpty) {
                                  if (context.mounted) {
                                    context.showAppSnackBar(l10n.noItemsToSave, isError: true);
                                  }
                                  return;
                                }

                                await HapticFeedback.heavyImpact();
                                setState(() => _isSaving = true);
                                try {
                                  if (widget.mealId != null || widget.isViewOnly) {
                                    if (widget.mealId == null) {
                                      throw Exception(l10n.errorRecordIdNotFound);
                                    }
                                    // Update existing record
                                    await ref
                                        .read(mealRepositoryProvider)
                                        .updateMeal(widget.mealId!, analysis);
                                    if (context.mounted) {
                                      context.go('/');
                                      context.showAppSnackBar(l10n.summaryUpdatedSuccess);
                                    }
                                  } else {
                                    // Save new record
                                    if (widget.imageFile == null) return;
                                    await ref
                                        .read(mealRepositoryProvider)
                                        .saveMeal(analysis, widget.imageFile!);
                                    if (context.mounted) {
                                      context.go('/');
                                      context.showAppSnackBar(l10n.mealSavedToHistory);
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    context.showAppSnackBar(
                                      l10n.errorSavingMeal(e.toString()),
                                      isError: true,
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isSaving = false);
                                  }
                                }
                              },
                      )
                      .animate(target: _hasChanges(analysis) ? 1 : 0)
                      .fadeIn()
                      .scale()
                      .custom(
                        builder: (context, value, child) =>
                            _hasChanges(analysis)
                            ? child
                            : const SizedBox.shrink(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIngredientsDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final analysis = ref.watch(analysisControllerProvider).value;
          final items = analysis?.items ?? [];

          return SafeArea(
            bottom: false,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A), // Solid dark background
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                12,
                24,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
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
                        AppLocalizations.of(context)!.detectedFoods,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (int i = 0; i < items.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              FoodTranslationHelper.getLocalizedFoodItemName(
                                                context,
                                                items[i],
                                              ),
                                              style: GoogleFonts.spaceGrotesk(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${FoodTranslationHelper.getLocalizedPortion(context, items[i])} • ${items[i].calories} ${AppLocalizations.of(context)!.kcal}',
                                              style: GoogleFonts.spaceGrotesk(
                                                color: Colors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        key: ValueKey('refine_item_$i'),
                                        tooltip: AppLocalizations.of(context)!.refineWithAiTooltip,
                                        onPressed: () => _showEditItemDialog(
                                          context,
                                          items[i],
                                          i,
                                        ),
                                        icon: const Icon(
                                          Icons.auto_awesome,
                                          color: AppTheme.primary,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _MacroMiniTag(
                                        label: AppLocalizations.of(
                                          context,
                                        )!.protein,
                                        value: '${items[i].protein}g',
                                        color: DesignTokens.proteinColor,
                                      ),
                                      const SizedBox(width: 8),
                                      _MacroMiniTag(
                                        label: AppLocalizations.of(
                                          context,
                                        )!.carbs,
                                        value: '${items[i].carbs}g',
                                        color: DesignTokens.carbsColor,
                                      ),
                                      const SizedBox(width: 8),
                                      _MacroMiniTag(
                                        label: AppLocalizations.of(
                                          context,
                                        )!.fat,
                                        value: '${items[i].fat}g',
                                        color: DesignTokens.fatColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (i < items.length - 1)
                              Divider(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientSummaryBar(
    BuildContext context,
    List<FoodItem> items, {
    bool isLoading = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Showcase(
      key: _detectedItemsKey,
      title: l10n.tutorialInspectComponentsTitle,
      description: l10n.tutorialInspectComponentsDesc,
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
        onTap: () => _showIngredientsDetails(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isLoading
                      ? l10n.analyzingIngredientsStatus
                      : l10n.foodsDetectedCount(items.length),
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isLoading)
                FilledButton.icon(
                  onPressed: () => _showIngredientsDetails(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.backgroundDark,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    l10n.editDetails,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ).animate(target: isLoading ? 1 : 0).shimmer(duration: 1.5.seconds),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, FoodItem item, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: _RefineDialog(
              item: item,
              onSave: (newItem) {
                ref
                    .read(analysisControllerProvider.notifier)
                    .updateItem(index, newItem);
              },
              reanalyzeItem: (name, portion) => ref
                  .read(analysisControllerProvider.notifier)
                  .reanalyzeItem(name, portion),
            ),
          ),
        );
      },
    );
  }
}

class _RefineDialog extends StatefulWidget {
  final FoodItem item;
  final Function(FoodItem) onSave;
  final Future<FoodItem?> Function(String, String) reanalyzeItem;

  const _RefineDialog({
    required this.item,
    required this.onSave,
    required this.reanalyzeItem,
  });

  @override
  State<_RefineDialog> createState() => _RefineDialogState();
}

class _RefineDialogState extends State<_RefineDialog> {
  late TextEditingController _nameController;
  late TextEditingController _portionController;
  late FoodItem _pendingItem;
  bool _isReanalyzing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _portionController = TextEditingController(
      text: widget.item.portionEstimate,
    );
    _pendingItem = widget.item;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: LiquidGlassSurface(
        borderRadius: 28,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  l10n.refineFoodTitle,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.refineFoodSubtitle,
              style: GoogleFonts.spaceGrotesk(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppTextField(
                          controller: _nameController,
                          label: l10n.foodName,
                          onChanged: (val) {
                            setState(() {
                              _pendingItem = _pendingItem.copyWith(name: val);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: AppTextField(
                          controller: _portionController,
                          label: l10n.portionOptionalLabel,
                          onChanged: (val) {
                            setState(() {
                              _pendingItem = _pendingItem.copyWith(portionEstimate: val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: _isReanalyzing ? l10n.estimatingEllipsis : l10n.estimateWithAiAction,
                    icon: const Icon(Icons.auto_awesome, size: 20),
                    variant: AppButtonVariant.primary,
                    expand: true,
                    loading: _isReanalyzing,
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;

                      setState(() => _isReanalyzing = true);

                      try {
                        final result = await widget.reanalyzeItem(
                          name,
                          _portionController.text.trim(),
                        );

                        if (result != null && context.mounted) {
                          widget.onSave(result);
                          Navigator.pop(context);
                        } else if (mounted) {
                          setState(() => _isReanalyzing = false);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() => _isReanalyzing = false);
                          context.showAppSnackBar(
                            l10n.errorWithMessage(e.toString()),
                            isError: true,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: l10n.saveWithoutReestimating.toUpperCase(),
                    variant: AppButtonVariant.ghost,
                    expand: true,
                    foregroundColor: Colors.white70,
                    onPressed: _isReanalyzing
                        ? null
                        : () {
                            final name = _nameController.text.trim();
                            if (name.isEmpty) return;

                            widget.onSave(
                              _pendingItem.copyWith(
                                name: name,
                                portionEstimate: _portionController.text.trim(),
                              ),
                            );
                            Navigator.pop(context);
                          },
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    label: l10n.cancel,
                    variant: AppButtonVariant.ghost,
                    expand: true,
                    foregroundColor: Colors.white54,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 200.ms, curve: Curves.easeOut);
  }
}

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
