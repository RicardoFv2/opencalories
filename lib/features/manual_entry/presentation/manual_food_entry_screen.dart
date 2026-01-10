import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../analysis/data/ai_repository.dart';
import '../../history/data/meal_repository.dart';
import '../domain/manual_food_entry.dart';

class ManualFoodEntryScreen extends HookConsumerWidget {
  const ManualFoodEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Please enter name and portion first',
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
            context.showAppSnackBar('AI estimation completed!');
          }
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar('AI Estimation failed: $e', isError: true);
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
            'Logged ${entry.name} with ${entry.calories ?? 0} kcal',
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar('Error: $e', isError: true);
        }
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'MANUAL ENTRY',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('REQUIRED'),
              const SizedBox(height: 16),
              _buildTextField(
                controller: nameController,
                label: 'Food Name',
                hint: 'e.g. Tortillas',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: portionController,
                label: 'Portion',
                hint: 'e.g. 2 pieces',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a portion' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isEstimating.value ? null : estimateWithAi,
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
                    isEstimating.value ? 'ESTIMATING...' : 'ESTIMATE WITH AI',
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
              const SizedBox(height: 48),
              _buildSectionTitle('NUTRITION (OPTIONAL)'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: caloriesController,
                      label: 'Calories',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      suffix: 'kcal',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: proteinController,
                      label: 'Protein',
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
                      label: 'Carbs',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      suffix: 'g',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: fatController,
                      label: 'Fat',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      suffix: 'g',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSaving.value ? null : saveEntry,
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
                      : const Text(
                          'LOG MEAL',
                          style: TextStyle(
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
