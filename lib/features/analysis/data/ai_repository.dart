import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../settings/data/api_key_repository.dart';
import '../domain/food_analysis.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_repository.g.dart';

@riverpod
AiRepository aiRepository(Ref ref) {
  return AiRepository(ref);
}

class AiRepository {
  final Ref _ref;
  static const _modelName = 'gemini-3-flash-preview';

  static const _systemPrompt = '''
You are a nutritionist. Analyze the image. Return a JSON object with a 'items' list. 
For each item include: name, calories (integer), protein (integer), carbs (integer), fat (integer), portion_estimate (string). 
Do not add any conversational text.
''';

  AiRepository(this._ref);

  Future<FoodAnalysis> analyzeFood(File image) async {
    final imageBytes = await image.readAsBytes();
    final content = [
      Content.multi([
        TextPart(_systemPrompt),
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
    final prompt =
        '''
You are a nutritionist. Estimate the nutritional content for the following food:
Food: $foodName
Portion: $portion

Return a JSON object with a 'items' list containing a single object.
Include: name, calories (integer), protein (integer), carbs (integer), fat (integer), portion_estimate (string).
Do not add any conversational text.
''';

    final content = [Content.text(prompt)];
    final jsonMap = await _generateAndParse(content);
    return FoodAnalysis.fromJson(jsonMap);
  }

  Future<Map<String, dynamic>> _generateAndParse(List<Content> content) async {
    final apiKey = await _ref.read(apiKeyProvider.future);

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API Key found. Please add one in Settings.');
    }

    final model = GenerativeModel(model: _modelName, apiKey: apiKey);

    try {
      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null) {
        throw Exception('Failed to generate analysis. No response from AI.');
      }

      // Sanitization: Remove markdown code blocks using Regex
      final pattern = RegExp(r'```(?:json)?\s*(.*?)\s*```', dotAll: true);
      final match = pattern.firstMatch(text);
      final cleanedJson = match != null ? match.group(1)!.trim() : text.trim();

      // Safe decoding
      return jsonDecode(cleanedJson) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('AI analysis error: $e');
    }
  }
}
