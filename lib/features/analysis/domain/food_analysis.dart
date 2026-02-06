import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_analysis.freezed.dart';
part 'food_analysis.g.dart';

@freezed
class FoodAnalysis with _$FoodAnalysis {
  const factory FoodAnalysis({
    required List<FoodItem> items,
    // Confidence score (0-100) representing AI certainty
    @JsonKey(name: 'conf') @Default(0) int confidence,
  }) = _FoodAnalysis;

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FoodAnalysisFromJson(json);
}

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    @JsonKey(name: 'n') required String name,
    @JsonKey(name: 'cal') required int calories,
    @JsonKey(name: 'p') required int protein,
    @JsonKey(name: 'c') required int carbs,
    @JsonKey(name: 'f') required int fat,
    @JsonKey(name: 'q') required String portionEstimate,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
