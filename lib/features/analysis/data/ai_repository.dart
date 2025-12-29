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
    final apiKey = await _ref.read(apiKeyProvider.future);

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No API Key found. Please add one in Settings.');
    }

    final model = GenerativeModel(model: _modelName, apiKey: apiKey);

    final imageBytes = await image.readAsBytes();
    final content = [
      Content.multi([
        TextPart(_systemPrompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ];

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
      final Map<String, dynamic> jsonMap = jsonDecode(cleanedJson);

      return FoodAnalysis.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Error analyzing food: $e');
    }
  }
}
