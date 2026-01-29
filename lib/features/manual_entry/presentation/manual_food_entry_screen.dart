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
        context.showAppSnackBar(
          AppLocalizations.of(context)!.enterNameAndPortionError,
          isError: true,
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
          estimatedEntry.value = ManualFoodEntry(
            name: item.name,
            portion: item.portionEstimate,
            calories: item.calories,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
          );

          if (context.mounted) {
            context.showAppSnackBar('¡Estimación completada!');
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
      if (estimatedEntry.value == null) {
        context.showAppSnackBar(
          'Por favor, estima primero con IA.',
          isError: true,
        );
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
            AppLocalizations.of(context)!.loggedFood(
              estimatedEntry.value!.name,
              estimatedEntry.value!.calories ?? 0,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showAppSnackBar(
            AppLocalizations.of(context)!.errorWithMessage(e.toString()),
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
        title: const Text(
          'Búsqueda Asistida',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
                const Text(
                  'Describe lo que comiste y la IA hará el resto.',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('DETALLES DEL ALIMENTO'),
                const SizedBox(height: 16),
                Showcase(
                  key: nameKey,
                  title: 'Nombre del Alimento',
                  description: 'Ej: 2 arepas, 1 hamburguesa, etc.',
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
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: portionController,
                  label: AppLocalizations.of(context)!.portionLabel,
                  hint: AppLocalizations.of(context)!.portionHint,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Showcase(
                    key: aiKey,
                    title: 'Magia de IA',
                    description: 'Pulsa aquí para que la IA estime los macros.',
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
                    child: ElevatedButton.icon(
                      onPressed: isEstimating.value
                          ? null
                          : () async {
                              await HapticFeedback.lightImpact();
                              estimateWithAi();
                            },
                      icon: isEstimating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(
                        isEstimating.value ? 'ESTIMANDO...' : 'ESTIMAR CON IA',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                ),
                const SizedBox(height: 48),
                if (estimatedEntry.value != null) ...[
                  _buildSectionTitle('ESTIMACIÓN RESULTANTE'),
                  const SizedBox(height: 16),
                  _buildMacroPreview(estimatedEntry.value!),
                  const SizedBox(height: 48),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (isSaving.value || estimatedEntry.value == null)
                        ? null
                        : () async {
                            await HapticFeedback.heavyImpact();
                            saveEntry();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: estimatedEntry.value == null
                          ? Colors.white12
                          : AppTheme.primary,
                      foregroundColor: estimatedEntry.value == null
                          ? Colors.white24
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSaving.value
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'REGISTRAR ALIMENTO',
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
      ),
    );
  }

  Widget _buildMacroPreview(ManualFoodEntry entry) {
    return Column(
      children: [
        _MacroBox(
          label: 'Calorías',
          value: '${entry.calories} kcal',
          color: AppTheme.primary,
          isMain: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MacroBox(
                label: 'Prot',
                value: '${entry.protein}g',
                color: const Color(0xFF4ADE80),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MacroBox(
                label: 'Carb',
                value: '${entry.carbs}g',
                color: const Color(0xFF60A5FA),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MacroBox(
                label: 'Grasa',
                value: '${entry.fat}g',
                color: const Color(0xFFF87171),
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

class _MacroBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isMain;

  const _MacroBox({
    required this.label,
    required this.value,
    required this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMain ? 20 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: isMain ? 14 : 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMain ? 28 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
