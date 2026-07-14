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
  static const defaultModel = 'gemini-3.5-flash';

  ModelPreferenceService(this._prefs);

  String getSelectedModel() {
    final stored = _prefs.getString(_keyModel);
    // Migration: retired model IDs fall back to the new default.
    if (stored == 'gemini-3-flash-preview' ||
        stored == 'gemini-3.1-pro-preview' ||
        stored == 'gemini-3.1-flash-lite-preview' ||
        stored == 'gemini-2.5-flash') {
      return defaultModel;
    }
    return stored ?? defaultModel;
  }

  Future<void> setSelectedModel(String model) async {
    await _prefs.setString(_keyModel, model);
  }

  static String getFriendlyName(String modelId) {
    switch (modelId) {
      case 'gemini-3.5-flash':
        return 'Gemini 3.5 Flash';
      default:
        return 'Gemini 3.5 Flash';
    }
  }

  static String getHint(String modelId) {
    switch (modelId) {
      case 'gemini-3.5-flash':
        return 'Frontier (Fast & Precise)';
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
