import 'dart:io';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../analysis/data/ai_repository.dart';
import '../../analysis/domain/food_analysis.dart';

part 'analysis_controller.g.dart';

@riverpod
class AnalysisController extends _$AnalysisController {
  @override
  FutureOr<FoodAnalysis?> build() {
    return null; // Initial state is null (no analysis yet)
  }

  Future<void> analyze(File image) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(aiRepositoryProvider).analyzeFood(image),
    );
  }
}
