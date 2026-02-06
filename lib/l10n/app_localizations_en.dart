// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OpenCalories';

  @override
  String get scanMeal => 'Scan Meal';

  @override
  String get proActive => 'OPEN CALORIES PRO: ACTIVE';

  @override
  String get alignFoodWithinFrame => 'Align food within frame...';

  @override
  String get compressingImage => 'Compressing image...';

  @override
  String get analyzingFood => 'Analyzing food...';

  @override
  String get analyzeFood => 'Analyze Food';

  @override
  String analysisFailed(String error) {
    return 'Analysis failed: $error';
  }

  @override
  String get tutorialCaptureTitle => 'Capture Reality';

  @override
  String get tutorialCaptureDesc =>
      'Take a photo of your meal directly to start the analysis.';

  @override
  String get tutorialLoadDataTitle => 'Load Data';

  @override
  String get tutorialLoadDataDesc =>
      'Pick an existing photo from your device\'s library.';

  @override
  String get tutorialTimeCapsuleTitle => 'Time Capsule';

  @override
  String get tutorialTimeCapsuleDesc =>
      'Access your full log of past meals and daily stats.';

  @override
  String get tutorialInspectComponentsTitle => 'Inspect Components';

  @override
  String get tutorialInspectComponentsDesc =>
      'When multiple items are detected (e.g., Burger + Fries), tap on an item to see its specific portion size and individual macros.';

  @override
  String get tutorialEraseHistoryTitle => 'Erase History';

  @override
  String get tutorialEraseHistoryDesc =>
      'Swipe left on any meal card to delete it from your log.';

  @override
  String get mealDetails => 'MEAL DETAILS';

  @override
  String get analysis => 'ANALYSIS';

  @override
  String get pro => 'Pro';

  @override
  String matchPercent(int percent) {
    return '$percent% Match';
  }

  @override
  String get detected => 'DETECTED';

  @override
  String get detectedFoods => 'DETECTED FOODS';

  @override
  String get unknownFood => 'Unknown Food';

  @override
  String get more => 'more';

  @override
  String get kcal => 'kcal';

  @override
  String get oneServing => '1 serving';

  @override
  String get notWhatYouAte => 'Not what you ate? Enter manually';

  @override
  String get macroDistribution => 'MACRO DISTRIBUTION';

  @override
  String get carbs => 'Carbs';

  @override
  String get protein => 'Protein';

  @override
  String get fat => 'Fat';

  @override
  String get retake => 'Retake';

  @override
  String get logFood => 'Log Food';

  @override
  String get noItemsToSave => 'No items to save';

  @override
  String get mealSavedToHistory => 'Meal saved to history!';

  @override
  String errorSavingMeal(String error) {
    return 'Error saving meal: $error';
  }

  @override
  String get connectIntelligence => 'Connect Intelligence';

  @override
  String get unlockGeminiAI => 'Unlock Gemini AI';

  @override
  String get geminiDescription =>
      'To analyze your food with Open Calories, we need to connect to Google\'s Gemini brain.';

  @override
  String get apiKey => 'API Key';

  @override
  String get getApiKeyHint =>
      'Don\'t have a key? Get one from Google AI Studio';

  @override
  String get couldNotLaunchUrl => 'Could not launch URL';

  @override
  String get dailyCalorieGoal => 'Daily Calorie Goal';

  @override
  String get target => 'Target';

  @override
  String get connectAndContinue => 'Connect & Continue';

  @override
  String get keyStoredLocally =>
      'Your key is stored locally on device and never shared.';

  @override
  String get resetHints => 'Reset Hints';

  @override
  String get hintsReset => 'Hints reset! Tutorials will show again.';

  @override
  String get pleaseEnterApiKey => 'Please enter an API Key';

  @override
  String get invalidKeyFormat =>
      'Invalid Key format. It must start with \"AIza\" and be 39 characters long.';

  @override
  String get openCalories => 'OPEN CALORIES';

  @override
  String get seeWhat => 'See What ';

  @override
  String get youEat => 'You Eat.';

  @override
  String get welcomeDescription =>
      'Instant calorie analysis and macro breakdowns powered by Open Calories AI.';

  @override
  String get startScanning => 'Start Scanning';

  @override
  String get connectDevice => 'Connect Device';

  @override
  String get deviceIntegrationComingSoon => 'Device integration coming soon! ⌚';

  @override
  String get scanning => 'SCANNING...';

  @override
  String get history => 'HISTORY';

  @override
  String get dailyTotal => 'DAILY TOTAL';

  @override
  String percentOfDailyGoal(int percent, int goal) {
    return '$percent% of daily goal ($goal)';
  }

  @override
  String get noMealsLoggedToday => 'No meals logged today';

  @override
  String get noMealsLoggedForDay => 'No meals logged for this day';

  @override
  String get deleteMealTitle => 'Delete Meal?';

  @override
  String get deleteActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get mealDeleted => 'Meal deleted';

  @override
  String get scanMealOption => 'Scan Meal';

  @override
  String get useAiToAnalyze => 'Use AI to analyze your food photo';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get typeInFoodAndPortion => 'Type in food name and portion';

  @override
  String today(String date) {
    return 'Today, $date';
  }

  @override
  String yesterday(String date) {
    return 'Yesterday, $date';
  }

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get enterNameAndPortionError => 'Please enter name and portion first';

  @override
  String get aiEstimationCompleted => 'AI estimation completed!';

  @override
  String aiEstimationFailed(String error) {
    return 'AI Estimation failed: $error';
  }

  @override
  String loggedFood(String name, int calories) {
    return 'Logged $name with $calories kcal';
  }

  @override
  String get manualEntryTitle => 'MANUAL ENTRY';

  @override
  String get requiredSection => 'REQUIRED';

  @override
  String get tutorialDone => 'Great! You are ready.';

  @override
  String get aiModel => 'AI Model';

  @override
  String get aiModelDescription => 'Choose your preferred AI model';

  @override
  String get quotaErrorHint =>
      'Tip: Switch to Gemini 2.5 Flash in Settings for higher limits.';

  @override
  String get tutorialModelTitle => 'Switch AI Brain';

  @override
  String get tutorialModelDesc => 'Tap here to change your AI model anytime.';

  @override
  String get tutorialNameTitle => 'Name Your Fuel';

  @override
  String get tutorialNameDesc => 'Enter the name of your food item.';

  @override
  String get foodNameLabel => 'Food Name';

  @override
  String get foodNameHint => 'e.g. Tortillas';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get portionLabel => 'Portion';

  @override
  String get portionHint => 'e.g. 2 pieces';

  @override
  String get pleaseEnterPortion => 'Please enter a portion';

  @override
  String get tutorialAiTitle => 'AI Assist';

  @override
  String get tutorialAiDesc =>
      'Let Gemini estimate calories from the food name.';

  @override
  String get estimating => 'ESTIMATING...';

  @override
  String get estimateWithAiAction => 'ESTIMATE WITH AI';

  @override
  String get nutritionOptionalSection => 'NUTRITION (OPTIONAL)';

  @override
  String get tutorialFineTuneTitle => 'Fine-Tune Data';

  @override
  String get tutorialFineTuneDesc =>
      'Manually adjust the nutritional info if needed.';

  @override
  String get logMealAction => 'LOG MEAL';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get weeklyInsights => 'WEEKLY INSIGHTS';

  @override
  String get tutorialTimeTravelTitle => 'Time Travel';

  @override
  String get tutorialTimeTravelDesc =>
      'Use arrows to browse previous weeks history.';

  @override
  String get tutorialSelectDayTitle => 'Select a Day';

  @override
  String get tutorialSelectDayDesc => 'Tap any day to view its meal history.';

  @override
  String get noFoodDetected => 'No food detected in image. Please scan a meal.';

  @override
  String get editFoodItem => 'Edit Food Item';

  @override
  String get foodName => 'Food Name';

  @override
  String get save => 'Save';

  @override
  String foodsDetectedCount(int count) {
    return '$count Foods Detected';
  }

  @override
  String get editDetails => 'Edit';

  @override
  String get logout => 'Logout';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get gallery => 'Gallery';
}
