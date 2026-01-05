import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import '../../analysis/domain/food_analysis.dart';
import '../../manual_entry/domain/manual_food_entry.dart';

part 'meal_repository.g.dart';

@riverpod
MealRepository mealRepository(Ref ref) {
  return MealRepository(ref.watch(mealsDaoProvider));
}

class MealRepository {
  final MealsDao _dao;

  MealRepository(this._dao);

  Future<void> saveMeal(FoodAnalysis analysis, File imageFile) async {
    // 1. Copy image to app directory for persistence
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = p.join(directory.path, fileName);

    await imageFile.copy(savedPath);

    // 2. Prepare data
    final totalCalories = analysis.items.fold<int>(
      0,
      (sum, item) => sum + item.calories,
    );

    final meal = MealsCompanion.insert(
      createdAt: DateTime.now(),
      imagePath: Value(savedPath),
      totalCalories: totalCalories,
      isManualEntry: const Value(false),
    );

    final items = analysis.items
        .map(
          (item) => FoodItemsCompanion(
            name: Value(item.name),
            calories: Value(item.calories),
            protein: Value(item.protein),
            carbs: Value(item.carbs),
            fat: Value(item.fat),
            // mealId will be auto-generated in DAO
          ),
        )
        .toList();

    // 3. Save to DB
    await _dao.insertMeal(meal, items);
  }

  Future<void> saveManualMeal(ManualFoodEntry entry) async {
    final meal = MealsCompanion.insert(
      createdAt: DateTime.now(),
      imagePath: const Value(null),
      totalCalories: entry.calories ?? 0,
      isManualEntry: const Value(true),
    );

    final items = [
      FoodItemsCompanion(
        name: Value(entry.name),
        calories: Value(entry.calories ?? 0),
        protein: Value(entry.protein ?? 0),
        carbs: Value(entry.carbs ?? 0),
        fat: Value(entry.fat ?? 0),
      ),
    ];

    await _dao.insertMeal(meal, items);
  }
}
