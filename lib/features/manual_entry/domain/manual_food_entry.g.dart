// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_food_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManualFoodEntryImpl _$$ManualFoodEntryImplFromJson(
  Map<String, dynamic> json,
) => _$ManualFoodEntryImpl(
  name: json['name'] as String,
  portion: json['portion'] as String,
  calories: (json['calories'] as num?)?.toInt(),
  protein: (json['protein'] as num?)?.toInt(),
  carbs: (json['carbs'] as num?)?.toInt(),
  fat: (json['fat'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ManualFoodEntryImplToJson(
  _$ManualFoodEntryImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'portion': instance.portion,
  'calories': instance.calories,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fat': instance.fat,
};
