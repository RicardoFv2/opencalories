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
      imagePath: '/tmp/test.jpg',
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
      MealsCompanion.insert(createdAt: now, imagePath: 'a', totalCalories: 500),
      [],
    );

    // Meal 2: 300 kcal
    await dao.insertMeal(
      MealsCompanion.insert(createdAt: now, imagePath: 'b', totalCalories: 300),
      [],
    );

    // Meal 3: Yesterday (should not be counted)
    await dao.insertMeal(
      MealsCompanion.insert(
        createdAt: now.subtract(const Duration(days: 1)),
        imagePath: 'c',
        totalCalories: 1000,
      ),
      [],
    );

    final daily = await dao.getDailyCalories(now);
    expect(daily, 800);
  });
}
