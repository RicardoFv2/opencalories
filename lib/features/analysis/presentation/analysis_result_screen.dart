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
import 'package:opencalories/features/analysis/presentation/analysis_controller.dart';

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
    // Always watch the controller to allow reactive updates even from history
    final analysisState = ref.watch(analysisControllerProvider);

    return analysisState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (analysis) {
        debugPrint(
          'AnalysisResultScreen: isViewOnly=${widget.isViewOnly}, mealId=${widget.mealId}',
        );
        final items = analysis?.items ?? [];
        final totalCalories = items.fold<int>(
          0,
          (sum, item) => sum + item.calories,
        );
        final totalCarbs = items.fold<int>(0, (sum, item) => sum + item.carbs);
        final totalProtein = items.fold<int>(
          0,
          (sum, item) => sum + item.protein,
        );
        final totalFat = items.fold<int>(0, (sum, item) => sum + item.fat);

        return ShowCaseWidget(
          builder: (context) => _buildContent(
            context,
            analysis,
            items,
            totalCalories,
            totalCarbs,
            totalProtein,
            totalFat,
          ),
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
    int totalFat,
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
                child:
                    Container(
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
                              if ((analysis?.confidence ?? 0) > 0)
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ui.ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                              AppLocalizations.of(
                                                context,
                                              )!.matchPercent(
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
                                      items.isNotEmpty
                                          ? FoodTranslationHelper.getLocalizedFoodItemName(
                                              context,
                                              items.first,
                                            ).toUpperCase()
                                          : AppLocalizations.of(
                                              context,
                                            )!.detected,
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
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
              ),

            // 2. Ingredient Summary Bar (New explicit CTA)
            _buildIngredientSummaryBar(context, items),

            // 3. Calories Hero
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
                child: FilledButton.icon(
                  onPressed: () {
                    context.pop();
                  },
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
            ],
            Expanded(
              flex: 2,
              child:
                  ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () async {
                                if (analysis == null ||
                                    analysis.items.isEmpty) {
                                  if (context.mounted) {
                                    context.showAppSnackBar(
                                      AppLocalizations.of(
                                        context,
                                      )!.noItemsToSave,
                                      isError: true,
                                    );
                                  }
                                  return;
                                }

                                await HapticFeedback.heavyImpact();
                                setState(() => _isSaving = true);
                                try {
                                  if (widget.mealId != null ||
                                      widget.isViewOnly) {
                                    if (widget.mealId == null) {
                                      throw Exception(
                                        'Error: No se encontró el ID del registro para actualizar.',
                                      );
                                    }
                                    // Update existing record
                                    await ref
                                        .read(mealRepositoryProvider)
                                        .updateMeal(widget.mealId!, analysis);
                                    if (context.mounted) {
                                      context.go('/');
                                      context.showAppSnackBar(
                                        'Resumen actualizado correctamente',
                                      );
                                    }
                                  } else {
                                    // Save new record
                                    if (widget.imageFile == null) return;
                                    await ref
                                        .read(mealRepositoryProvider)
                                        .saveMeal(analysis, widget.imageFile!);
                                    if (context.mounted) {
                                      context.go('/');
                                      context.showAppSnackBar(
                                        AppLocalizations.of(
                                          context,
                                        )!.mealSavedToHistory,
                                      );
                                    }
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
                        icon: Icon(
                          (widget.mealId != null || widget.isViewOnly)
                              ? Icons.update
                              : Icons.check_circle,
                        ),
                        label: Text(
                          (widget.mealId != null || widget.isViewOnly)
                              ? 'ACTUALIZAR'
                              : AppLocalizations.of(context)!.logFood,
                        ),
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

  void _showIngredientsDetails(BuildContext context, List<FoodItem> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        bottom: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A), // Solid dark background
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                                    tooltip: 'Refinar con IA',
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
                                    color: Colors.cyanAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  _MacroMiniTag(
                                    label: AppLocalizations.of(context)!.carbs,
                                    value: '${items[i].carbs}g',
                                    color: Colors.amberAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  _MacroMiniTag(
                                    label: AppLocalizations.of(context)!.fat,
                                    value: '${items[i].fat}g',
                                    color: Colors.pinkAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (i < items.length - 1)
                          Divider(color: Colors.white.withValues(alpha: 0.05)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientSummaryBar(
    BuildContext context,
    List<FoodItem> items,
  ) {
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
        onTap: () => _showIngredientsDetails(context, items),
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
                  l10n.foodsDetectedCount(items.length),
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showIngredientsDetails(context, items),
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
        ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Refinar Alimento',
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
                  'Corrige el nombre y deja que la IA recalcule los macros automáticamente.',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: l10n.foodName,
                                labelStyle: const TextStyle(
                                  color: AppTheme.primary,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white24),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _pendingItem = _pendingItem.copyWith(
                                    name: val,
                                    nameTranslations: null,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _portionController,
                              decoration: InputDecoration(
                                labelText: 'Porción (Opcional)',
                                labelStyle: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white24),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _pendingItem = _pendingItem.copyWith(
                                    portionEstimate: val,
                                    portionTranslations: null,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _isReanalyzing
                              ? null
                              : () async {
                                  final name = _nameController.text.trim();
                                  if (name.isEmpty) return;

                                  setState(() => _isReanalyzing = true);

                                  try {
                                    final result = await widget.reanalyzeItem(
                                      name,
                                      _portionController.text.trim(),
                                    );

                                    if (result != null && mounted) {
                                      widget.onSave(result);
                                      Navigator.pop(context);
                                    } else {
                                      setState(() => _isReanalyzing = false);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() => _isReanalyzing = false);
                                      context.showAppSnackBar(
                                        'Error: $e',
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                          icon: _isReanalyzing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome, size: 20),
                          label: Text(
                            _isReanalyzing ? 'ESTIMANDO...' : 'ESTIMAR CON IA',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: _isReanalyzing
                              ? null
                              : () {
                                  final name = _nameController.text.trim();
                                  if (name.isEmpty) return;

                                  widget.onSave(
                                    _pendingItem.copyWith(
                                      name: name,
                                      portionEstimate: _portionController.text
                                          .trim(),
                                      nameTranslations:
                                          null, // Clear translations to force the new name
                                      portionTranslations: null,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text('GUARDAR SIN REESTIMAR'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms, curve: Curves.easeOut);
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
