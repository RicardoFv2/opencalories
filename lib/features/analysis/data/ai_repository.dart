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
Identify food in image/text. Return JSON:
{
  "items": [
    {
      "name": "English name",
      "name_translations": { ... },
      "cooking_method": "method",
      "calories": int,
      "protein": int,
      "carbs": int,
      "fat": int,
      "portion_estimate": "desc",
      "portion_translations": { ... }
    }
  ],
  "confidence": int
}
Empty "items" if no food. Use languages: $languages for all translations.
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
    // We use a more explicit prompt for refinements to ensure the AI respects the user's correction.
    final prompt =
        '''
REFINEMENT REQUEST:
The user has corrected the identification of this food item.
Current Identification: "$foodName"
Current Portion/Quantity: "$portion"

STRICT INSTRUCTIONS:
1. QUANTITY IS PRIORITY: If "$foodName" or "$portion" contains numbers or quantifiers (e.g., "2 tortillas", "500ml", "un par de huevos"), YOU MUST calculate the nutritional values for THAT EXACT QUANTITY.
2. INGREDIENT SUBSTITUTION: If the user changed the substance (e.g., from "Bread" to "Tortilla"), discard all old nutritional data and start fresh for the new ingredient.
3. CONFLICT RESOLUTION: If "$foodName" and "$portion" seem to conflict, prioritize the quantity information found in "$foodName" (e.g., if Name is "2 egg whites" and Portion is "1 unit", calculate precisely for 2 egg whites).
4. OUTPUT FORMAT: Ensure the name in "name_translations" for the current locale precisely reflects "$foodName".
5. PORTION REFLECTION: Ensure "portion_estimate" in the JSON reflects the actual quantity used for calculation.
''';
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
      final response = await _withTimeout(
        () => model.generateContent(content),
        timeout: const Duration(seconds: 30),
      );
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

  Future<T> _withTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 2,
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await operation().timeout(timeout);
      } on TimeoutException {
        attempt++;
        if (attempt >= maxRetries) {
          throw Exception(
            'Analysis timeout. Please check your connection and try again.',
          );
        }
        // Exponential backoff
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    throw Exception('Max retries exceeded');
  }
}
