import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_analysis.freezed.dart';
part 'food_analysis.g.dart';

@freezed
class FoodAnalysis with _$FoodAnalysis {
  const factory FoodAnalysis({required List<FoodItem> items}) = _FoodAnalysis;

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FoodAnalysisFromJson(json);
}

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String name,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    @JsonKey(name: 'portion_estimate') required String portionEstimate,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
