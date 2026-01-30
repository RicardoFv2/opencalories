import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:opencalories/features/settings/data/api_key_repository.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/features/settings/data/model_preference_service.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/core/services/calorie_goal_service.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/widgets/language_selector.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = Color(0xFF102216); // Deep Forest
const _tutorialText = Color(0xFF13EC5B); // Neon Green

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;

  final _apiKeyFieldKey = GlobalKey();
  final _getApiKeyButtonKey = GlobalKey();
  final _calorieGoalKey = GlobalKey();
  bool _tutorialStarted = false;

  @override
  void initState() {
    super.initState();
    final currentKey = ref.read(apiKeyProvider).valueOrNull;
    if (currentKey != null) {
      _apiKeyController.text = currentKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        ref.read(tutorialServiceProvider.notifier).markSettingsTutorialShown();
      },
      builder: (context) {
        // Trigger tutorial if needed after frame
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!_tutorialStarted) {
            _tutorialStarted = true;
            await ref.read(tutorialServiceProvider.future);
            final tutorialService = ref.read(tutorialServiceProvider.notifier);
            final hasKey =
                ref.read(apiKeyProvider).valueOrNull?.isNotEmpty ?? false;

            if ((!tutorialService.hasShownSettingsTutorial || !hasKey) &&
                mounted) {
              // Wait for any screen transition to finish
              await Future.delayed(const Duration(milliseconds: 800));
              if (mounted) {
                ShowCaseWidget.of(context).startShowCase([
                  _getApiKeyButtonKey,
                  _apiKeyFieldKey,
                  _calorieGoalKey,
                ]);
              }
            }
          }
        });

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              AppLocalizations.of(context)!.connectIntelligence,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // 1. Hero Graphic
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          blurRadius: 15,
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCyQpXAOclKcePKfVsBD87ITisJezg4kpOcFKaLUM_H_vvnnE99DxDbPTEcK3MVzatJapxNntZ80lDpS7buLyig3_IG79Z83mgyxzWbpeXrApUCO5Gizpphnq76RNfjDBklQabqMe-xlyUO72jL0ulyJ5jvHCcsMOTBh1JEHhNxb6lGUGDsRPRvaf92xrwGgl5TS8Q3-5JJyqhKJOu1TiljSEyYvLFvXsEphXlomRVR9hum5hdHt0mITzByvPwiMCedmlj5YIcBuVM',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppTheme.backgroundDark, Colors.transparent],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 2. Headline
                  Text(
                    AppLocalizations.of(context)!.unlockGeminiAI,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.geminiDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 3. API Key Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.apiKey,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Showcase(
                        key: _apiKeyFieldKey,
                        description:
                            'Ingresa tu API Key de Google AI Studio aquí',
                        tooltipBackgroundColor: _tutorialBg,
                        textColor: _tutorialText,
                        child: TextField(
                          controller: _apiKeyController,
                          obscureText: _obscureApiKey,
                          style: const TextStyle(fontFamily: 'monospace'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.surfaceDark,
                            hintText: 'AIzaSy...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureApiKey
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureApiKey = !_obscureApiKey;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 3.5 AI Model Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.aiModel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final asyncModel = ref.watch(
                              modelPreferenceServiceInitializedProvider,
                            );

                            return asyncModel.when(
                              data: (service) {
                                final currentModel = service.getSelectedModel();
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currentModel,
                                    isExpanded: true,
                                    dropdownColor: AppTheme.surfaceDark,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppTheme.primary,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'gemini-2.5-flash',
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ModelPreferenceService.getFriendlyName(
                                                'gemini-2.5-flash',
                                              ),
                                            ),
                                            Text(
                                              ModelPreferenceService.getHint(
                                                'gemini-2.5-flash',
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'gemini-3-flash-preview',
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ModelPreferenceService.getFriendlyName(
                                                'gemini-3-flash-preview',
                                              ),
                                            ),
                                            Text(
                                              ModelPreferenceService.getHint(
                                                'gemini-3-flash-preview',
                                              ),
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        service.setSelectedModel(value);
                                        setState(() {}); // Refresh UI
                                      }
                                    },
                                  ),
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (err, stack) =>
                                  Text('Error loading settings: $err'),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 8),
                        child: Text(
                          AppLocalizations.of(context)!.aiModelDescription,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Showcase(
                    key: _getApiKeyButtonKey,
                    description: 'Toca aquí para obtener una llave gratis',
                    tooltipBackgroundColor: _tutorialBg,
                    textColor: _tutorialText,
                    child: TextButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(
                          'https://aistudio.google.com/app/apikey',
                        );
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          if (context.mounted) {
                            context.showAppSnackBar(
                              AppLocalizations.of(context)!.couldNotLaunchUrl,
                              isError: true,
                            );
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.getApiKeyHint,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 4. Daily Calorie Goal
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.dailyCalorieGoal,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Showcase(
                        key: _calorieGoalKey,
                        description:
                            'Ajusta tu meta diaria para el seguimiento',
                        tooltipBackgroundColor: _tutorialBg,
                        textColor: _tutorialText,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final calorieGoal = ref.watch(
                                calorieGoalServiceProvider,
                              );
                              final goalValue = calorieGoal.valueOrNull ?? 2500;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.target,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '$goalValue ${AppLocalizations.of(context)!.kcal}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: goalValue.toDouble(),
                                    min: 1200,
                                    max: 5000,
                                    divisions: 38,
                                    activeColor: AppTheme.primary,
                                    inactiveColor: Colors.white10,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                            calorieGoalServiceProvider.notifier,
                                          )
                                          .setGoal(value.toInt());
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // New Language Selector
                  LanguageSelector(),

                  const SizedBox(height: 48),

                  // 5. Connect Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () async {
                        final key = _apiKeyController.text.trim();
                        // Validate basic Gemini format: starts with AIza, 39 chars, alphanumeric+dashes
                        final isValidFormat = RegExp(
                          r'^AIza[0-9A-Za-z\-_]{35}$',
                        ).hasMatch(key);

                        if (isValidFormat) {
                          await ref
                              .read(apiKeyRepositoryProvider)
                              .setApiKey(key);
                          ref.invalidate(apiKeyProvider);
                          if (context.mounted) {
                            context.go('/'); // Go to scanner
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                key.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.pleaseEnterApiKey
                                    : AppLocalizations.of(
                                        context,
                                      )!.invalidKeyFormat,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.backgroundDark,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                        elevation: 8,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.connectAndContinue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.keyStoredLocally,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // 6. Reset Hints Button
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(tutorialServiceProvider.future);
                      await ref
                          .read(tutorialServiceProvider.notifier)
                          .resetTutorials();
                      if (context.mounted) {
                        context.showAppSnackBar(
                          AppLocalizations.of(context)!.hintsReset,
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                      side: BorderSide(color: Colors.grey[700]!),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: Text(AppLocalizations.of(context)!.resetHints),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
