import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import '../../analysis/data/ai_repository.dart';
import '../../history/data/meal_repository.dart';
import '../domain/manual_food_entry.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/widgets/app_button.dart';
import 'package:opencalories/core/widgets/app_card.dart';
import 'package:opencalories/core/widgets/app_text_field.dart';
import 'package:opencalories/core/widgets/macro_chip.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = DesignTokens.surface;
const _tutorialText = DesignTokens.primary;

class ManualFoodEntryScreen extends HookConsumerWidget {
  const ManualFoodEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameKey = useMemoized(() => GlobalKey());
    final aiKey = useMemoized(() => GlobalKey());

    // Auto-start tutorial
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(tutorialServiceProvider.future);
        final tutorialService = ref.read(tutorialServiceProvider.notifier);

        if (!tutorialService.hasShownManualTutorial && context.mounted) {
          ShowCaseWidget.of(context).startShowCase([nameKey, aiKey]);
        }
      });
      return null;
    }, []);

    final nameController = useTextEditingController();
    final portionController = useTextEditingController();

    // We'll use a ValueNotifier/useState to store the estimated nutrition
    final estimatedEntry = useState<ManualFoodEntry?>(null);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isSaving = useState(false);
    final isEstimating = useState(false);

    Future<void> estimateWithAi() async {
      final name = nameController.text.trim();
      final portion = portionController.text.trim();

      if (name.isEmpty || portion.isEmpty) {
        context.showAppSnackBar(l10n.enterNameAndPortionError, isError: true);
        return;
      }

      isEstimating.value = true;
      try {
        final analysis = await ref
            .read(aiRepositoryProvider)
            .analyzeTextDescription(name, portion);

        if (analysis.items.isNotEmpty) {
          final item = analysis.items.first;
          estimatedEntry.value = ManualFoodEntry(
            name: item.name,
            portion: item.portionEstimate,
            calories: item.calories,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
          );

          if (context.mounted) {
            context.showAppSnackBar(l10n.estimationCompleted);
          }
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar(
            l10n.aiEstimationFailed(e.toString()),
            isError: true,
          );
        }
      } finally {
        isEstimating.value = false;
      }
    }

    Future<void> saveEntry() async {
      if (estimatedEntry.value == null) {
        context.showAppSnackBar(l10n.estimateFirstError, isError: true);
        return;
      }

      isSaving.value = true;
      try {
        await ref
            .read(mealRepositoryProvider)
            .saveManualMeal(estimatedEntry.value!);

        if (context.mounted) {
          context.go('/');
          context.showAppSnackBar(
            l10n.loggedFood(
              estimatedEntry.value!.name,
              estimatedEntry.value!.calories ?? 0,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar(
            l10n.errorWithMessage(e.toString()),
            isError: true,
          );
        }
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          l10n.assistedSearchTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ShowCaseWidget(
        onFinish: () {
          ref.read(tutorialServiceProvider.notifier).markManualTutorialShown();
        },
        builder: (context) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.manualEntryDescription,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(l10n.foodDetailsSection),
                const SizedBox(height: 16),
                Showcase(
                  key: nameKey,
                  title: l10n.foodName,
                  description: l10n.foodNameExampleHint,
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
                  child: AppTextField(
                    controller: nameController,
                    label: l10n.foodNameLabel,
                    hint: l10n.foodNameHint,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: portionController,
                  label: l10n.portionLabel,
                  hint: l10n.portionHint,
                ),
                const SizedBox(height: 32),
                Showcase(
                  key: aiKey,
                  title: l10n.aiMagicTitle,
                  description: l10n.aiMagicDesc,
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
                  child: AppButton(
                    label: isEstimating.value
                        ? l10n.estimatingEllipsis
                        : l10n.estimateWithAiAction,
                    icon: const Icon(Icons.auto_awesome, size: 20),
                    variant: AppButtonVariant.primary,
                    expand: true,
                    loading: isEstimating.value,
                    onPressed: () async {
                      await HapticFeedback.lightImpact();
                      estimateWithAi();
                    },
                  ),
                ),
                const SizedBox(height: 48),
                if (estimatedEntry.value != null) ...[
                  _buildSectionTitle(l10n.estimationResultSection),
                  const SizedBox(height: 16),
                  _buildMacroPreview(context, estimatedEntry.value!),
                  const SizedBox(height: 48),
                ],
                AppButton(
                  label: l10n.logFood.toUpperCase(),
                  variant: AppButtonVariant.primary,
                  expand: true,
                  loading: isSaving.value,
                  onPressed: estimatedEntry.value == null
                      ? null
                      : () async {
                          await HapticFeedback.heavyImpact();
                          saveEntry();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroPreview(BuildContext context, ManualFoodEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        AppCard(
          glass: true,
          borderColor: AppTheme.primary.withValues(alpha: 0.3),
          child: Column(
            children: [
              Text(
                l10n.caloriesLabel.toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primary.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${entry.calories ?? 0} ${l10n.kcal}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MacroChip(
                type: MacroType.protein,
                label: l10n.protein,
                grams: (entry.protein ?? 0).toDouble(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MacroChip(
                type: MacroType.carbs,
                label: l10n.carbs,
                grams: (entry.carbs ?? 0).toDouble(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MacroChip(
                type: MacroType.fat,
                label: l10n.fat,
                grams: (entry.fat ?? 0).toDouble(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
