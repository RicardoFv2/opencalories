import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import '../../analysis/domain/food_analysis.dart';

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
      imagePath: savedPath,
      totalCalories: totalCalories,
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
}
