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
      confidence: (json['conf'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FoodAnalysisImplToJson(_$FoodAnalysisImpl instance) =>
    <String, dynamic>{'items': instance.items, 'conf': instance.confidence};

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      name: json['n'] as String,
      calories: (json['cal'] as num).toInt(),
      protein: (json['p'] as num).toInt(),
      carbs: (json['c'] as num).toInt(),
      fat: (json['f'] as num).toInt(),
      portionEstimate: json['q'] as String,
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'n': instance.name,
      'cal': instance.calories,
      'p': instance.protein,
      'c': instance.carbs,
      'f': instance.fat,
      'q': instance.portionEstimate,
    };
