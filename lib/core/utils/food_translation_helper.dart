import 'package:flutter/material.dart';
import '../../features/analysis/domain/food_analysis.dart';
import '../../features/history/data/app_database.dart';

/// Simplified helper for getting food names and portions.
/// Translations are now done client-side by looking up against ARB files,
/// not from AI-generated translation maps.
class FoodTranslationHelper {
  /// Gets the food name from FoodItem (returns as-is)
  static String getLocalizedFoodItemName(BuildContext context, FoodItem item) {
    return item.name;
  }

  /// Gets the food name from MealItem (database)
  static String getLocalizedMealItemName(
    BuildContext context,
    FoodItemEntity item,
  ) {
    return item.name;
  }

  /// Gets the portion estimate from FoodItem
  static String getLocalizedPortion(BuildContext context, FoodItem item) {
    return item.portionEstimate;
  }

  /// Gets the portion estimate from MealItem (database)
  static String getLocalizedMealItemPortion(
    BuildContext context,
    FoodItemEntity item,
  ) {
    return item.portionEstimate;
  }
}
