import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_analysis.freezed.dart';
part 'food_analysis.g.dart';

@freezed
class FoodAnalysis with _$FoodAnalysis {
  const factory FoodAnalysis({
    required List<FoodItem> items,
    // Confidence score (0-100) representing AI certainty
    @Default(0) int confidence,
  }) = _FoodAnalysis;

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FoodAnalysisFromJson(json);
}

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String name,
    @JsonKey(name: 'name_translations') Map<String, String>? nameTranslations,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    @JsonKey(name: 'portion_estimate') required String portionEstimate,
    @JsonKey(name: 'portion_translations')
    Map<String, String>? portionTranslations,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
