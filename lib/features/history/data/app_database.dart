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
  TextColumn get imagePath => text().nullable()();
  IntColumn get totalCalories => integer()();
  BoolColumn get isManualEntry =>
      boolean().withDefault(const Constant(false))();
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

  Stream<List<MealWithItems>> watchMealsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    // Ensure we cover the full range
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    final query =
        select(meals).join([
            leftOuterJoin(foodItems, foodItems.mealId.equalsExp(meals.id)),
          ])
          ..where(meals.createdAt.isBetweenValues(start, end))
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

  Future<Map<String, int>> getDailyMacros(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = select(foodItems).join([
      innerJoin(meals, meals.id.equalsExp(foodItems.mealId)),
    ])..where(meals.createdAt.isBetweenValues(startOfDay, endOfDay));

    final result = await query.get();

    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;

    for (final row in result) {
      final item = row.readTable(foodItems);
      totalProtein += item.protein;
      totalCarbs += item.carbs;
      totalFat += item.fat;
    }

    return {'protein': totalProtein, 'carbs': totalCarbs, 'fat': totalFat};
  }

  Future<List<Map<String, dynamic>>> getWeeklySummary(
    DateTime weekStart,
  ) async {
    // Return last 7 days data starting from weekStart
    // Or actually, let's make it flexible: range from weekStart to weekStart + 7 days
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));

    final query = select(meals)
      ..where((t) => t.createdAt.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

    final result = await query.get();

    // Group by day
    final Map<DateTime, int> dailyTotals = {};
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      dailyTotals[day] = 0;
    }

    for (final meal in result) {
      final date = DateTime(
        meal.createdAt.year,
        meal.createdAt.month,
        meal.createdAt.day,
      );
      if (dailyTotals.containsKey(date)) {
        dailyTotals[date] = dailyTotals[date]! + meal.totalCalories;
      }
    }

    return dailyTotals.entries
        .map((e) => {'date': e.key, 'totalCalories': e.value})
        .toList();
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(meals, meals.isManualEntry);
        // In SQLite, making a column nullable is tricky,
        // but Drift handles it if we use alterTable or just allow it in Dart.
        // For simply adding a new column and making an old one nullable,
        // we can use alterTable for the nullability if needed.
        await m.alterTable(TableMigration(meals));
      }
    },
  );

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
