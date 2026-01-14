import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import '../../analysis/data/ai_repository.dart';
import '../../history/data/meal_repository.dart';
import '../domain/manual_food_entry.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/l10n/app_localizations.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

class ManualFoodEntryScreen extends HookConsumerWidget {
  const ManualFoodEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameKey = useMemoized(() => GlobalKey());
    final aiKey = useMemoized(() => GlobalKey());
    final macrosKey = useMemoized(() => GlobalKey());

    // Auto-start tutorial
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(tutorialServiceProvider.future);
        final tutorialService = ref.read(tutorialServiceProvider.notifier);

        if (!tutorialService.hasShownManualTutorial && context.mounted) {
          ShowCaseWidget.of(context).startShowCase([nameKey, aiKey, macrosKey]);
        }
      });
      return null;
    }, []);

    final nameController = useTextEditingController();
    final portionController = useTextEditingController();
    final caloriesController = useTextEditingController();
    final proteinController = useTextEditingController();
    final carbsController = useTextEditingController();
    final fatController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isSaving = useState(false);
    final isEstimating = useState(false);

    Future<void> estimateWithAi() async {
      final name = nameController.text.trim();
      final portion = portionController.text.trim();

      if (name.isEmpty || portion.isEmpty) {
        context.showAppSnackBar(
          AppLocalizations.of(context)!.enterNameAndPortionError,
          isError:
              true, // Using error style (red) or custom logical if needed, but Utils default isError=false.
          // Since original was orange, Utils mainly supports red/normal. Let's strictly follow Utils API.
          // IsError=true makes it red. If we want orange, Utils needs update or we accept red/default.
          // Given simplicity, let's treat validation error as error -> Red.
        );
        return;
      }

      isEstimating.value = true;
      try {
        final analysis = await ref
            .read(aiRepositoryProvider)
            .analyzeTextDescription(name, portion);

        if (analysis.items.isNotEmpty) {
          final item = analysis.items.first;
          caloriesController.text = item.calories.toString();
          proteinController.text = item.protein.toString();
          carbsController.text = item.carbs.toString();
          fatController.text = item.fat.toString();

          if (context.mounted) {
            context.showAppSnackBar(
              AppLocalizations.of(context)!.aiEstimationCompleted,
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar(
            AppLocalizations.of(context)!.aiEstimationFailed(e.toString()),
            isError: true,
          );
        }
      } finally {
        isEstimating.value = false;
      }
    }

    Future<void> saveEntry() async {
      // Unfocus to ensure text fields commit their values
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState?.validate() != true) return;

      isSaving.value = true;
      try {
        final calText = caloriesController.text.trim().replaceAll(',', '.');
        final proteinText = proteinController.text.trim().replaceAll(',', '.');
        final carbsText = carbsController.text.trim().replaceAll(',', '.');
        final fatText = fatController.text.trim().replaceAll(',', '.');

        final entry = ManualFoodEntry(
          name: nameController.text.trim(),
          portion: portionController.text.trim(),
          calories: double.tryParse(calText)?.round(),
          protein: double.tryParse(proteinText)?.round(),
          carbs: double.tryParse(carbsText)?.round(),
          fat: double.tryParse(fatText)?.round(),
        );

        await ref.read(mealRepositoryProvider).saveManualMeal(entry);

        if (context.mounted) {
          context.go('/');
          context.showAppSnackBar(
            AppLocalizations.of(
              context,
            )!.loggedFood(entry.name, entry.calories ?? 0),
          );
        }
      } catch (e) {
        context.showAppSnackBar(
          AppLocalizations.of(context)!.errorWithMessage(e.toString()),
          isError: true,
        );
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.manualEntryTitle,
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
                _buildSectionTitle(
                  AppLocalizations.of(context)!.requiredSection,
                ),
                const SizedBox(height: 16),
                Showcase(
                  key: nameKey,
                  title: AppLocalizations.of(context)!.tutorialNameTitle,
                  description: AppLocalizations.of(context)!.tutorialNameDesc,
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
                  child: _buildTextField(
                    controller: nameController,
                    label: AppLocalizations.of(context)!.foodNameLabel,
                    hint: AppLocalizations.of(context)!.foodNameHint,
                    validator: (v) => v == null || v.isEmpty
                        ? AppLocalizations.of(context)!.pleaseEnterName
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: portionController,
                  label: AppLocalizations.of(context)!.portionLabel,
                  hint: AppLocalizations.of(context)!.portionHint,
                  validator: (v) => v == null || v.isEmpty
                      ? AppLocalizations.of(context)!.pleaseEnterPortion
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Showcase(
                    key: aiKey,
                    title: AppLocalizations.of(context)!.tutorialAiTitle,
                    description: AppLocalizations.of(context)!.tutorialAiDesc,
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
                    child: OutlinedButton.icon(
                      onPressed: isEstimating.value
                          ? null
                          : () async {
                              await HapticFeedback.lightImpact();
                              estimateWithAi();
                            },
                      icon: isEstimating.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primary,
                              ),
                            )
                          : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(
                        isEstimating.value
                            ? AppLocalizations.of(context)!.estimating
                            : AppLocalizations.of(
                                context,
                              )!.estimateWithAiAction,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _buildSectionTitle(
                  AppLocalizations.of(context)!.nutritionOptionalSection,
                ),
                const SizedBox(height: 16),
                Showcase(
                  key: macrosKey,
                  title: AppLocalizations.of(context)!.tutorialFineTuneTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialFineTuneDesc,
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: caloriesController,
                              label: AppLocalizations.of(
                                context,
                              )!.caloriesLabel,
                              hint: '0',
                              keyboardType: TextInputType.number,
                              suffix: AppLocalizations.of(context)!.kcal,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: proteinController,
                              label: AppLocalizations.of(context)!.protein,
                              hint: '0',
                              keyboardType: TextInputType.number,
                              suffix: 'g',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: carbsController,
                              label: AppLocalizations.of(context)!.carbs,
                              hint: '0',
                              keyboardType: TextInputType.number,
                              suffix: 'g',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: fatController,
                              label: AppLocalizations.of(context)!.fat,
                              hint: '0',
                              keyboardType: TextInputType.number,
                              suffix: 'g',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSaving.value
                        ? null
                        : () async {
                            await HapticFeedback.heavyImpact();
                            saveEntry();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSaving.value
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                            AppLocalizations.of(context)!.logMealAction,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
