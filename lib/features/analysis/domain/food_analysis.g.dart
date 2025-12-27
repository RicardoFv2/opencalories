// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodAnalysisImpl _$$FoodAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$FoodAnalysisImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FoodAnalysisImplToJson(_$FoodAnalysisImpl instance) =>
    <String, dynamic>{'items': instance.items};

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
      portionEstimate: json['portion_estimate'] as String,
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'portion_estimate': instance.portionEstimate,
    };
