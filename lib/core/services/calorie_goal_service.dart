import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'calorie_goal_service.g.dart';

const String _kDailyCalorieGoal = 'dailyCalorieGoal';
const int _kDefaultGoal = 2500;

@Riverpod(keepAlive: true)
class CalorieGoalService extends _$CalorieGoalService {
  late SharedPreferences _prefs;

  @override
  Future<int> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_kDailyCalorieGoal) ?? _kDefaultGoal;
  }

  Future<void> setGoal(int goal) async {
    await _prefs.setInt(_kDailyCalorieGoal, goal);
    state = AsyncValue.data(goal);
  }
}
