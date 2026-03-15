import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'model_preference_service.g.dart';

@riverpod
ModelPreferenceService modelPreferenceService(Ref ref) {
  throw UnimplementedError();
}

class ModelPreferenceService {
  final SharedPreferences _prefs;
  static const _keyModel = 'selected_ai_model';
  static const defaultModel = 'gemini-3.1-flash-lite-preview';

  ModelPreferenceService(this._prefs);

  String getSelectedModel() {
    final stored = _prefs.getString(_keyModel);
    // Migration: If the stored model is the old preview or pro version, use the new default
    if (stored == 'gemini-3-flash-preview' ||
        stored == 'gemini-3.1-pro-preview') {
      return defaultModel;
    }
    return stored ?? defaultModel;
  }

  Future<void> setSelectedModel(String model) async {
    await _prefs.setString(_keyModel, model);
  }

  static String getFriendlyName(String modelId) {
    switch (modelId) {
      case 'gemini-2.5-flash':
        return 'Gemini 2.5 Flash';
      case 'gemini-3.1-flash-lite-preview':
        return 'Gemini 3.1 Flash';
      default:
        return 'Gemini 3.1 Flash';
    }
  }

  static String getHint(String modelId) {
    switch (modelId) {
      case 'gemini-2.5-flash':
        return 'Stable (Food Optimized)';
      case 'gemini-3.1-flash-lite-preview':
        return 'Experimental (Lite & Fast)';
      default:
        return '';
    }
  }
}

@riverpod
Future<ModelPreferenceService> modelPreferenceServiceInitialized(
  Ref ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  return ModelPreferenceService(prefs);
}
