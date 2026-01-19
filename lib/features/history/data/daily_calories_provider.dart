import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../history/data/app_database.dart';

part 'daily_calories_provider.g.dart';

@riverpod
Stream<int> dailyCalories(Ref ref) {
  final dao = ref.watch(mealsDaoProvider);
  final now = DateTime.now();

  return dao.watchMealsForDate(now).map((meals) {
    return meals.fold<int>(0, (sum, item) => sum + item.meal.totalCalories);
  });
}
