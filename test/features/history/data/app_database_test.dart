import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencalories/features/history/data/app_database.dart';

void main() {
  late AppDatabase database;
  late MealsDao dao;

  setUp(() {
    // Use in-memory database for testing
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dao = MealsDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('insertMeal adds a meal and items to the database', () async {
    final meal = MealsCompanion.insert(
      createdAt: DateTime.now(),
      imagePath: const Value('/tmp/test.jpg'),
      totalCalories: 500,
    );

    final items = [
      const FoodItemsCompanion(
        name: Value('Test Food'),
        calories: Value(500),
        protein: Value(20),
        carbs: Value(50),
        fat: Value(10),
      ),
    ];

    final mealId = await dao.insertMeal(meal, items);

    expect(mealId, isPositive);

    final dayMeals = await dao.watchMealsForDate(DateTime.now()).first;
    expect(dayMeals.length, 1);
    expect(dayMeals.first.meal.totalCalories, 500);
    expect(dayMeals.first.items.length, 1);
    expect(dayMeals.first.items.first.name, 'Test Food');
  });

  test('getDailyCalories returns correct sum', () async {
    final now = DateTime.now();

    // Meal 1: 500 kcal
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now,
        imagePath: const Value('a'),
        totalCalories: 500,
      ),
      [],
    );

    // Meal 2: 300 kcal
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now,
        imagePath: const Value('b'),
        totalCalories: 300,
      ),
      [],
    );

    // Meal 3: Yesterday (should not be counted)
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now.subtract(const Duration(days: 1)),
        imagePath: const Value('c'),
        totalCalories: 1000,
      ),
      [],
    );

    final daily = await dao.getDailyCalories(now);
    expect(daily, 800);
  });

  test('watchMealsForDateRange filters correctly', () async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: yesterday,
        imagePath: const Value('y'),
        totalCalories: 100,
      ),
      [],
    );
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now,
        imagePath: const Value('t'),
        totalCalories: 200,
      ),
      [],
    );
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: tomorrow,
        imagePath: const Value('tm'),
        totalCalories: 300,
      ),
      [],
    );

    // Query range: Yesterday to Today (Inclusive start/end handling in UI might differ,
    // but DAO should handle range as start <= t < end+1day if we implemented it that way.
    // Let's check implementation: isBetweenValues(start, end) where end is date+1day.
    // So if update used endDate + 1day, it covers the whole endDate day.

    final result = await dao.watchMealsForDateRange(yesterday, now).first;
    expect(result.length, 2); // Yesterday + Today
    expect(result.any((m) => m.meal.totalCalories == 100), isTrue);
    expect(result.any((m) => m.meal.totalCalories == 200), isTrue);
    expect(result.any((m) => m.meal.totalCalories == 300), isFalse);
  });

  test('getDailyMacros aggregates correctly', () async {
    final now = DateTime.now();
    final items = [
      const FoodItemsCompanion(
        name: Value('Chicken'),
        calories: Value(200),
        protein: Value(30),
        carbs: Value(0),
        fat: Value(10),
      ),
      const FoodItemsCompanion(
        name: Value('Rice'),
        calories: Value(200),
        protein: Value(4),
        carbs: Value(45),
        fat: Value(1),
      ),
    ];

    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now,
        imagePath: const Value('m'),
        totalCalories: 400,
      ),
      items,
    );

    final macros = await dao.getDailyMacros(now);
    expect(macros['protein'], 34);
    expect(macros['carbs'], 45);
    expect(macros['fat'], 11);
  });

  test('getWeeklySummary aggregates 7 days', () async {
    final today = DateTime.now();
    final weekStart = today.subtract(
      const Duration(days: 3),
    ); // Start 3 days ago

    // Insert meal 3 days ago (Start day)
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: weekStart,
        imagePath: const Value('1'),
        totalCalories: 500,
      ),
      [],
    );

    // Insert meal today (Start + 3)
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: today,
        imagePath: const Value('2'),
        totalCalories: 300,
      ),
      [],
    );

    // Insert meal tomorrow (Start + 4) - Should also be included in 7 day window
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: today.add(const Duration(days: 1)),
        imagePath: const Value('3'),
        totalCalories: 200,
      ),
      [],
    );

    // Insert meal 8 days after start (Should be excluded)
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: weekStart.add(const Duration(days: 8)),
        imagePath: const Value('4'),
        totalCalories: 100,
      ),
      [],
    );

    final summary = await dao.getWeeklySummary(weekStart);

    expect(summary.length, 7);

    // Check specific days
    final startDaySummary = summary.firstWhere(
      (d) =>
          (d['date'] as DateTime).year == weekStart.year &&
          (d['date'] as DateTime).month == weekStart.month &&
          (d['date'] as DateTime).day == weekStart.day,
    );
    expect(startDaySummary['totalCalories'], 500);

    final todaySummary = summary.firstWhere(
      (d) =>
          (d['date'] as DateTime).year == today.year &&
          (d['date'] as DateTime).month == today.month &&
          (d['date'] as DateTime).day == today.day,
    );
    expect(todaySummary['totalCalories'], 300);
  });
}
