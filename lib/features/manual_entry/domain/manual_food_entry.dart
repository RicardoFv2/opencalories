import 'package:freezed_annotation/freezed_annotation.dart';

part 'manual_food_entry.freezed.dart';
part 'manual_food_entry.g.dart';

@freezed
class ManualFoodEntry with _$ManualFoodEntry {
  const factory ManualFoodEntry({
    required String name,
    required String portion,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  }) = _ManualFoodEntry;

  factory ManualFoodEntry.fromJson(Map<String, dynamic> json) =>
      _$ManualFoodEntryFromJson(json);
}
