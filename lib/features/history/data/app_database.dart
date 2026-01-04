// unused import removed

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
// unused imports removed
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

// Table Definitions

@DataClassName('MealEntity')
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get imagePath => text()();
  IntColumn get totalCalories => integer()();
}

@DataClassName('FoodItemEntity')
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id)();
  TextColumn get name => text()();
  IntColumn get calories => integer()();
  IntColumn get protein => integer()();
  IntColumn get carbs => integer()();
  IntColumn get fat => integer()();
}

// DAO

@DriftAccessor(tables: [Meals, FoodItems])
class MealsDao extends DatabaseAccessor<AppDatabase> with _$MealsDaoMixin {
  MealsDao(super.db);

  Future<int> insertMeal(MealsCompanion meal, List<FoodItemsCompanion> items) {
    return transaction(() async {
      final mealId = await into(meals).insert(meal);
      await batch((batch) {
        batch.insertAll(
          foodItems,
          items.map((item) => item.copyWith(mealId: Value(mealId))).toList(),
        );
      });
      return mealId;
    });
  }

  Stream<List<MealWithItems>> watchMealsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query =
        select(meals).join([
            leftOuterJoin(foodItems, foodItems.mealId.equalsExp(meals.id)),
          ])
          ..where(meals.createdAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([OrderingTerm.desc(meals.createdAt)]);

    return query.watch().map((rows) {
      final groupedData = <MealEntity, List<FoodItemEntity>>{};

      for (final row in rows) {
        final meal = row.readTable(meals);
        final item = row.readTableOrNull(foodItems);

        if (!groupedData.containsKey(meal)) {
          groupedData[meal] = [];
        }
        if (item != null) {
          groupedData[meal]!.add(item);
        }
      }

      return groupedData.entries.map((entry) {
        return MealWithItems(meal: entry.key, items: entry.value);
      }).toList();
    });
  }

  Future<int> getDailyCalories(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = select(meals)
      ..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay));
    final result = await query.get();

    return result.fold<int>(0, (sum, meal) => sum + meal.totalCalories);
  }

  Future<void> deleteMeal(int mealId) {
    return transaction(() async {
      await (delete(foodItems)..where((t) => t.mealId.equals(mealId))).go();
      await (delete(meals)..where((t) => t.id.equals(mealId))).go();
    });
  }
}

class MealWithItems {
  final MealEntity meal;
  final List<FoodItemEntity> items;

  MealWithItems({required this.meal, required this.items});
}

// Database Class

@DriftDatabase(tables: [Meals, FoodItems], daos: [MealsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Constructor for testing
  // ignore: use_super_parameters
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'opencalories_db');
  }
}

// Provider
@riverpod
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
MealsDao mealsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).mealsDao;
}
