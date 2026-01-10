import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tutorial_service.g.dart';

/// Keys for tutorial flags
const String _kHomeShowcase = 'hasShownHomeTutorial';
const String _kResultsShowcase = 'hasShownResultsTutorial';
const String _kHistoryShowcase = 'hasShownHistoryTutorial';

@Riverpod(keepAlive: true)
class TutorialService extends _$TutorialService {
  late SharedPreferences _prefs;

  @override
  Future<void> build() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if the home/scanner tutorial has been shown
  bool get hasShownHomeTutorial => _prefs.getBool(_kHomeShowcase) ?? false;

  /// Check if the results tutorial has been shown
  bool get hasShownResultsTutorial =>
      _prefs.getBool(_kResultsShowcase) ?? false;

  /// Check if the history/delete tutorial has been shown
  bool get hasShownHistoryTutorial =>
      _prefs.getBool(_kHistoryShowcase) ?? false;

  /// Mark the home tutorial as shown
  Future<void> markHomeTutorialShown() async {
    await _prefs.setBool(_kHomeShowcase, true);
  }

  /// Mark the results tutorial as shown
  Future<void> markResultsTutorialShown() async {
    await _prefs.setBool(_kResultsShowcase, true);
  }

  /// Mark the history tutorial as shown
  Future<void> markHistoryTutorialShown() async {
    await _prefs.setBool(_kHistoryShowcase, true);
  }

  /// Reset all tutorials (for testing/debugging)
  Future<void> resetTutorials() async {
    await _prefs.remove(_kHomeShowcase);
    await _prefs.remove(_kResultsShowcase);
    await _prefs.remove(_kHistoryShowcase);
  }
}
