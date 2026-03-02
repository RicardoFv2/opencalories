import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../settings/data/api_key_repository.dart';
import '../../settings/data/model_preference_service.dart';
import '../domain/food_analysis.dart';
import 'package:opencalories/core/services/language_service.dart';

part 'ai_repository.g.dart';

@riverpod
AiRepository aiRepository(Ref ref) {
  return AiRepository(ref);
}

class AiRepository {
  final Ref _ref;

  // Cached model instance to avoid re-initialization overhead
  GenerativeModel? _cachedModel;
  String? _cachedModelName;
  String? _cachedApiKey;
  String? _cachedLanguage;

  AiRepository(this._ref);

  Future<FoodAnalysis> refineAnalysis(
    String originalResponse,
    String userInput,
    String language,
  ) async {
    final prompt =
        '''
Refine this food analysis based on: "$userInput".
Context: $originalResponse

Expert RULE: If unsure between Tortilla/Pupusa, use Tortilla.
TORTILLA: Thin, dry corn disc (70-90kcal).
PUPUSA: Thick, moist, visible cheese/filling at edges (180-350kcal).

Return JSON ONLY (minimized):
{"items":[{"n":"name","q":"qty","cal":int,"p":int,"c":int,"f":int}],"conf":int}

Return "n" and "q" in $language ONLY.
''';
    final content = [Content.text(prompt)];
    final jsonMap = await _generateAndParse(content);
    return FoodAnalysis.fromJson(jsonMap);
  }

  /// CAMBIO 2: System Instruction centralizada.
  /// Define la "personalidad" y el formato estricto JSON una sola vez para toda la clase.
  Content _getSystemInstruction(String language) {
    return Content.system('''
Expert SV Nutritionist. RULE: Distinguish Tortilla vs Pupusa. 
User is in El Salvador. Grilled beef is ALWAYS served with TORTILLAS.

TORTILLA: Thin, flat, dry corn disc, no leaks (70-90kcal). 
PUPUSA: Thick, moist, visible filling/cheese at edges (180-350kcal). 

If unsure, it is a TORTILLA.
If image is blurry, non-food, or unrecognizable, DO NOT throw errors. Instead, return a valid JSON format with generic values: {"items":[{"n":"Unrecognized Food","q":"1 portion","cal":100,"p":0,"c":0,"f":0}],"conf":0}
DO NOT GUESS.
Return JSON ONLY exactly like this format: {"items":[{"n":"name","q":"qty","cal":int,"p":int,"c":int,"f":int}],"conf":int}
Empty items if no food. Return "n" and "q" in $language ONLY.
''');
  }

  /// CAMBIO 3: Configuración de Generación.
  /// Forzamos la respuesta JSON nativa y bajamos la temperatura para datos precisos.
  GenerationConfig get _generationConfig =>
      GenerationConfig(responseMimeType: 'application/json', temperature: 0.2);

  Future<FoodAnalysis> analyzeFood(File image) async {
    final sw = Stopwatch()..start();
    final imageBytes = await image.readAsBytes();
    if (imageBytes.length < 100000) {
      debugPrint(
        '⚠️ Image size (${(imageBytes.length / 1024).toStringAsFixed(1)}KB) is very low. Accuracy may suffer.',
      );
    }
    debugPrint('⏱️ Image read and ready: ${sw.elapsedMilliseconds}ms');
    debugPrint(
      '📸 Final Payload Size: ${(imageBytes.length / 1024).toStringAsFixed(1)}KB',
    );

    // The prompt is simple because the System Instruction already does the heavy lifting.
    final content = [
      Content.multi([
        TextPart(
          'Analyze this meal accurately. User is from El Salvador. Pay close attention to distinguishing tortillas from pupusas.',
        ),
        DataPart('image/jpeg', imageBytes),
      ]),
    ];

    final jsonMap = await _generateAndParse(content);
    debugPrint('⏱️ Total analyzeFood session: ${sw.elapsedMilliseconds}ms');
    return FoodAnalysis.fromJson(jsonMap);
  }

  Future<FoodAnalysis> analyzeTextDescription(
    String foodName,
    String portion,
  ) async {
    final prompt =
        '''
Analyze this food: "$foodName" (Portion: "$portion").
Expert SV Nutritionist Logic:
1. QUANTITY IS PRIORITY: Calculate precisely for the requested amount.
2. TORTILLA vs PUPUSA:
   - Tortilla: Thin, dry, corn (70-90kcal).
   - Pupusa: Thick, moist, filling/cheese (180-350kcal).
   - If unsure, use TORTILLA.

Return JSON ONLY (minimized):
{"items":[{"n":"name","q":"qty","cal":int,"p":int,"c":int,"f":int}],"conf":int}
''';
    final content = [Content.text(prompt)];
    final jsonMap = await _generateAndParse(content);
    return FoodAnalysis.fromJson(jsonMap);
  }

  /// Returns a cached or new GenerativeModel instance.
  /// Only creates a new model if the API key or model name has changed.
  Future<GenerativeModel> _getOrCreateModel() async {
    final apiKey = await _ref.read(apiKeyProvider.future);
    final modelService = await _ref.read(
      modelPreferenceServiceInitializedProvider.future,
    );
    final modelName = modelService.getSelectedModel();

    // Get current language for prompt
    final locale = await _ref.read(languageServiceProvider.future);
    final String language = locale?.languageCode == 'es'
        ? 'Spanish'
        : 'English';

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API Key found. Please add one in Settings.');
    }

    // Return cached model if configuration hasn't changed
    if (_cachedModel != null &&
        _cachedModelName == modelName &&
        _cachedApiKey == apiKey &&
        _cachedLanguage == language) {
      return _cachedModel!;
    }

    // Create and cache new model
    _cachedModel = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      systemInstruction: _getSystemInstruction(language),
      generationConfig: _generationConfig,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
    );
    _cachedModelName = modelName;
    _cachedApiKey = apiKey;
    _cachedLanguage = language;

    return _cachedModel!;
  }

  Future<Map<String, dynamic>> _generateAndParse(List<Content> content) async {
    final model = await _getOrCreateModel();

    try {
      final sw = Stopwatch()..start();

      // Use generateContent instead of stream because we parse the complete JSON at the end
      // and streaming with JSON schema can cause Unhandled format exceptions in the Dart SDK.
      final response = await model.generateContent(content);

      debugPrint('⏱️ AI Generation time: ${sw.elapsedMilliseconds}ms');
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Failed to generate analysis. No response from AI.');
      }

      // CAMBIO 4: Sanitización robusta.
      // Aunque usamos JSON mode, limpiamos bloques markdown por seguridad.
      final cleanJson = text.replaceAll(RegExp(r'^```json|```$'), '').trim();
      debugPrint('AI Raw JSON: $cleanJson'); // Debug log

      final json = jsonDecode(cleanJson) as Map<String, dynamic>;

      // Ensure specific fields
      if (json['conf'] == null) {
        json['conf'] = 85;
      } else if (json['conf'] is String) {
        json['conf'] = int.tryParse(json['conf']) ?? 85;
      }

      return json;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on GenerativeAIException catch (e) {
      if (e.message.contains('429') ||
          e.message.toLowerCase().contains('quota') ||
          e.message.toLowerCase().contains('quota') ||
          e.message.toLowerCase().contains('limit')) {
        throw Exception(
          'Rate limit exceeded. Please try again in 30 seconds.\nTip: Switch to Gemini 2.5 Flash in Settings for higher limits.',
        );
      }
      if (e.message.contains('safety')) {
        throw Exception(
          'The AI refused to analyze this image (Safety Guardrail).',
        );
      }
      throw Exception('AI Service Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
