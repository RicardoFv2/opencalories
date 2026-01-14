import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../settings/data/api_key_repository.dart';
import '../domain/food_analysis.dart';
import 'package:opencalories/core/l10n/supported_languages.dart';

part 'ai_repository.g.dart';

@riverpod
AiRepository aiRepository(Ref ref) {
  return AiRepository(ref);
}

class AiRepository {
  final Ref _ref;
  static const _modelName = 'gemini-3-flash-preview';

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

Return a valid JSON object with an 'items' list. 
For each item include: 
- name: food name in English (string, required)
- name_translations: object with food names in: $languages
- cooking_method: inferred method (e.g., "deep fried", "grilled") - Useful for calorie accuracy.
- calories: estimated total calories (integer) - Account for oils/fats!
- protein: protein in grams (integer)
- carbs: carbohydrates in grams (integer)
- fat: fat in grams (integer)
- portion_estimate: portion size description in English (string, required)
- portion_translations: object with portion descriptions in: $languages

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

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API Key found. Please add one in Settings.');
    }

    final model = GenerativeModel(
      model: _modelName,
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

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on GenerativeAIException catch (e) {
      if (e.message.contains('429')) {
        throw Exception('Rate limit exceeded. Please try again later.');
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
