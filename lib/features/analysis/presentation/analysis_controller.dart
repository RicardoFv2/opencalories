import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
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
    final result = await AsyncValue.guard(
      () => ref.read(aiRepositoryProvider).analyzeFood(image),
    );

    state = result.whenData((analysis) {
      final sortedItems = List<FoodItem>.from(analysis.items)
        ..sort((a, b) => b.protein.compareTo(a.protein));
      return analysis.copyWith(items: sortedItems);
    });
  }

  void setAnalysis(FoodAnalysis analysis) {
    state = AsyncValue.data(analysis);
  }

  void updateItem(int index, FoodItem newItem) {
    state.whenData((analysis) {
      if (analysis == null) return;

      final newItems = List<FoodItem>.from(analysis.items);
      if (index >= 0 && index < newItems.length) {
        newItems[index] = newItem;
        state = AsyncValue.data(analysis.copyWith(items: newItems));
      }
    });
  }

  Future<FoodItem?> reanalyzeItem(String name, String portion) async {
    final aiRepo = ref.read(aiRepositoryProvider);
    try {
      final analysis = await aiRepo.analyzeTextDescription(name, portion);
      if (analysis.items.isNotEmpty) {
        return analysis.items.first;
      }
    } catch (e) {
      debugPrint('Error re-analyzing item: $e');
    }
    return null;
  }
}
