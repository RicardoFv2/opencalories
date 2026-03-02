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
  static const defaultModel = 'gemini-3-flash-preview';

  ModelPreferenceService(this._prefs);

  String getSelectedModel() {
    return _prefs.getString(_keyModel) ?? defaultModel;
  }

  Future<void> setSelectedModel(String model) async {
    await _prefs.setString(_keyModel, model);
  }

  static String getFriendlyName(String modelId) {
    switch (modelId) {
      case 'gemini-2.5-flash':
        return 'Gemini 2.5 Flash';
      case 'gemini-3-flash-preview':
        return 'Gemini 3.0 Flash';
      case 'gemini-3.1-pro-preview':
        return 'Gemini 3.1 Pro';
      default:
        return 'Gemini 3.0 Flash';
    }
  }

  static String getHint(String modelId) {
    switch (modelId) {
      case 'gemini-2.5-flash':
        return 'Stable (Food Optimized)';
      case 'gemini-3-flash-preview':
        return 'Experimental (Fastest)';
      case 'gemini-3.1-pro-preview':
        return 'Requires API key with funds';
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
