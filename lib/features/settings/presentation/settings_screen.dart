import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:opencalories/features/settings/data/api_key_repository.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/theme/app_theme.dart';
import 'package:opencalories/features/settings/data/model_preference_service.dart';
import 'package:opencalories/core/utils/snackbar_utils.dart';
import 'package:opencalories/core/services/tutorial_service.dart';
import 'package:opencalories/core/services/calorie_goal_service.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:opencalories/l10n/app_localizations.dart';
import 'package:opencalories/core/widgets/language_selector.dart';
import 'package:opencalories/core/widgets/app_button.dart';
import 'package:opencalories/core/widgets/app_card.dart';
import 'package:opencalories/core/widgets/app_text_field.dart';
import 'package:opencalories/core/widgets/glass_modal.dart';

/// Tutorial colors (Cyberpunk Theme)
const _tutorialBg = DesignTokens.surface;
const _tutorialText = DesignTokens.primary;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();

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

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ShowCaseWidget(
      onFinish: () {
        ref.read(tutorialServiceProvider.notifier).markSettingsTutorialShown();
      },
      enableAutoScroll: true,
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
              if (!context.mounted) return;
              ShowCaseWidget.of(context).startShowCase([
                _apiKeyFieldKey,
                _getApiKeyButtonKey,
                _calorieGoalKey,
              ]);
            }
          }
        });

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // Settings is reachable both as a pushed route (pre-auth, from
            // Welcome) and as a shell tab root (post-auth) — only show a
            // back arrow when there's actually somewhere to pop to.
            leading: context.canPop()
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => context.pop(),
                  )
                : null,
            title: Text(
              AppLocalizations.of(context)!.connectIntelligence,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // 1. Hero Graphic — local composition (no network image,
                  // so it can never show broken/blank when offline).
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [DesignTokens.surface2, DesignTokens.surface0],
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 96,
                          color: AppTheme.primary.withValues(alpha: 0.12),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.backgroundDark,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
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
                        description: l10n.apiKeyTutorialDesc,
                        tooltipBackgroundColor: _tutorialBg,
                        textColor: _tutorialText,
                        child: AppTextField(
                          controller: _apiKeyController,
                          monospace: true,
                          obscureText: true,
                          showObscureToggle: true,
                          hint: 'AIzaSy...',
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
                      Consumer(
                        builder: (context, ref, child) {
                          final asyncModel = ref.watch(
                            modelPreferenceServiceInitializedProvider,
                          );

                          return asyncModel.when(
                            data: (service) {
                              final currentModel = service.getSelectedModel();
                              return AppCard(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  GlassModal.show(
                                    context: context,
                                    title: l10n.selectAiModelTitle,
                                    child: _ModelOptionList(
                                      service: service,
                                      currentModel: currentModel,
                                      onModelSelected: () => setState(() {}),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            ModelPreferenceService.getFriendlyName(
                                              currentModel,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            ModelPreferenceService.getHint(
                                              currentModel,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.unfold_more,
                                      color: AppTheme.primary,
                                    ),
                                  ],
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, stack) =>
                                Text(l10n.errorWithMessage(err.toString())),
                          );
                        },
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
                    description: l10n.getKeyTutorialDesc,
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
                        description: l10n.calorieGoalTutorialDesc,
                        tooltipBackgroundColor: _tutorialBg,
                        textColor: _tutorialText,
                        child: AppCard(
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
                  AppButton(
                    label: l10n.connectAndContinue,
                    variant: AppButtonVariant.primary,
                    expand: true,
                    onPressed: () async {
                      final key = _apiKeyController.text.trim();
                      // Validate basic Gemini format: starts with AIza, 39 chars, alphanumeric+dashes
                      final isValidFormat = RegExp(
                        r'^AIza[0-9A-Za-z\-_]{35}$',
                      ).hasMatch(key);

                      if (isValidFormat) {
                        await ref.read(apiKeyRepositoryProvider).setApiKey(key);
                        ref.invalidate(apiKeyProvider);
                        if (context.mounted) {
                          context.go('/'); // Go to scanner
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              key.isEmpty
                                  ? l10n.pleaseEnterApiKey
                                  : l10n.invalidKeyFormat,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
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
                  AppButton(
                    label: l10n.resetHints,
                    icon: const Icon(Icons.help_outline, size: 18),
                    variant: AppButtonVariant.secondary,
                    foregroundColor: Colors.grey[400],
                    borderColor: Colors.grey[700],
                    onPressed: () async {
                      await ref.read(tutorialServiceProvider.future);
                      await ref
                          .read(tutorialServiceProvider.notifier)
                          .resetTutorials();
                      if (context.mounted) {
                        context.showAppSnackBar(l10n.hintsReset);
                      }
                    },
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

/// Model picker list shown inside a [GlassModal] — replaces the old native
/// `DropdownButton`, whose 2-line items risked an internal overflow at the
/// dropdown menu's fixed item height.
class _ModelOptionList extends StatelessWidget {
  final ModelPreferenceService service;
  final String currentModel;
  final VoidCallback onModelSelected;

  const _ModelOptionList({
    required this.service,
    required this.currentModel,
    required this.onModelSelected,
  });

  static const _models = ['gemini-3.5-flash'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final modelId in _models) ...[
          _buildOption(context, modelId),
          if (modelId != _models.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String modelId) {
    final isActive = modelId == currentModel;
    return AppCard(
      color: isActive ? AppTheme.primary.withValues(alpha: 0.1) : null,
      borderColor: isActive ? AppTheme.primary : null,
      onTap: () {
        service.setSelectedModel(modelId);
        onModelSelected();
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            isActive ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isActive ? AppTheme.primary : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ModelPreferenceService.getFriendlyName(modelId),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ModelPreferenceService.getHint(modelId),
                  style: TextStyle(
                    fontSize: 12,
                    color: modelId.contains('preview')
                        ? Colors.orange
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const Icon(Icons.bolt, color: AppTheme.primary, size: 20),
        ],
      ),
    );
  }
}
