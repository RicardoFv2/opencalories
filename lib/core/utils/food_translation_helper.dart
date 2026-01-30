import 'package:flutter/material.dart';
import '../../features/analysis/domain/food_analysis.dart';
import '../../features/history/data/app_database.dart';

class FoodTranslationHelper {
  /// Gets the localized name from a translation map
  static String getLocalizedName(
    BuildContext context, {
    required String fallbackName,
    Map<String, String>? translations,
  }) {
    if (translations == null || translations.isEmpty) {
      return fallbackName;
    }

    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;

    // Try to get translation for current language
    if (translations.containsKey(languageCode)) {
      return translations[languageCode]!;
    }

    // Fallback to English if available
    if (translations.containsKey('en')) {
      return translations['en']!;
    }

    // Final fallback
    return fallbackName;
  }

  /// Gets the localized food name from FoodItem
  static String getLocalizedFoodItemName(BuildContext context, FoodItem item) {
    return getLocalizedName(
      context,
      fallbackName: item.name,
      translations: item.nameTranslations,
    );
  }

  /// Gets the localized food name from MealItem (database)
  static String getLocalizedMealItemName(
    BuildContext context,
    FoodItemEntity item,
  ) {
    return getLocalizedName(
      context,
      fallbackName: item.name,
      translations: item.nameTranslations,
    );
  }

  /// Gets the localized portion estimate
  static String getLocalizedPortion(BuildContext context, FoodItem item) {
    return getLocalizedName(
      context,
      fallbackName: item.portionEstimate,
      translations: item.portionTranslations,
    );
  }

  /// Gets the localized portion estimate from MealItem (database)
  static String getLocalizedMealItemPortion(
    BuildContext context,
    FoodItemEntity item,
  ) {
    return getLocalizedName(
      context,
      fallbackName: item.portionEstimate,
      translations: item.portionTranslations,
    );
  }
}
