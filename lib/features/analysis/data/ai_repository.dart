import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../settings/data/api_key_repository.dart';
import '../../settings/data/model_preference_service.dart';
import '../domain/food_analysis.dart';
import 'package:opencalories/core/l10n/supported_languages.dart';

part 'ai_repository.g.dart';

@riverpod
AiRepository aiRepository(Ref ref) {
  return AiRepository(ref);
}

class AiRepository {
  final Ref _ref;

  AiRepository(this._ref);

  /// CAMBIO 2: System Instruction centralizada.
  /// Define la "personalidad" y el formato estricto JSON una sola vez para toda la clase.
  Content get _systemInstruction {
    final languages = SupportedLanguages.toPromptString();
    return Content.system('''
You are an expert nutritionist using advanced computer vision and data analysis. 
Analyze the input (visual image or text description) to estimate nutritional values accurately.

CRITICAL INSTRUCTIONS:
1. Identify Cooking Methods: Look for signs of frying (oil sheen), breading, or sauces that add hidden calories.
2. Estimate Portions: Be realistic about serving sizes.
3. Output JSON Only: Do not provide any conversational text.
4. Non-Food Images: If the image does NOT contain any recognizable food, return an EMPTY 'items' array: {"items": []}.

Return a valid JSON object with the following structure:
{
  "items": [
    // List of food items
    {
      "name": "food name in English (string, required)",
      "name_translations": { ... },
      "cooking_method": "inferred method",
      "calories": 100,
      "protein": 10,
      "carbs": 20,
      "fat": 5,
      "portion_estimate": "portion description",
      "portion_translations": { ... }
    }
  ],
  "confidence": 95 // (integer, 0-100) Overall certainty score
}

Use the languages: $languages for translations.
STRICTLY return valid JSON matching this schema.
''');
  }

  /// CAMBIO 3: Configuración de Generación.
  /// Forzamos la respuesta JSON nativa y bajamos la temperatura para datos precisos.
  GenerationConfig get _generationConfig =>
      GenerationConfig(responseMimeType: 'application/json', temperature: 0.2);

  Future<FoodAnalysis> analyzeFood(File image) async {
    final imageBytes = await image.readAsBytes();

    // El prompt es simple porque el System Instruction ya hace el trabajo pesado.
    final content = [
      Content.multi([
        TextPart('Analyze this meal accurately based on the visual evidence.'),
        DataPart('image/jpeg', imageBytes),
      ]),
    ];

    final jsonMap = await _generateAndParse(content);
    return FoodAnalysis.fromJson(jsonMap);
  }

  Future<FoodAnalysis> analyzeTextDescription(
    String foodName,
    String portion,
  ) async {
    // Reutilizamos la lógica. Al pasar solo texto, el System Prompt se adapta.
    final prompt = 'Food Name: $foodName\nPortion Size: $portion';
    final content = [Content.text(prompt)];

    final jsonMap = await _generateAndParse(content);
    return FoodAnalysis.fromJson(jsonMap);
  }

  Future<Map<String, dynamic>> _generateAndParse(List<Content> content) async {
    final apiKey = await _ref.read(apiKeyProvider.future);
    final modelService = await _ref.read(
      modelPreferenceServiceInitializedProvider.future,
    );
    final modelName = modelService.getSelectedModel();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API Key found. Please add one in Settings.');
    }

    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      systemInstruction:
          _systemInstruction, // Inyectamos la instrucción maestra
      generationConfig: _generationConfig, // Inyectamos la config JSON
    );

    try {
      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null) {
        throw Exception('Failed to generate analysis. No response from AI.');
      }

      // CAMBIO 4: Sanitización robusta.
      // Aunque usamos JSON mode, limpiamos bloques markdown por seguridad.
      final cleanJson = text.replaceAll(RegExp(r'^```json|```$'), '').trim();
      debugPrint('AI Raw JSON: $cleanJson'); // Debug log

      final json = jsonDecode(cleanJson) as Map<String, dynamic>;

      // Ensure specific fields
      if (json['confidence'] == null) {
        json['confidence'] = 85;
      } else if (json['confidence'] is String) {
        json['confidence'] = int.tryParse(json['confidence']) ?? 85;
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
