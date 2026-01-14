import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenCalories'**
  String get appTitle;

  /// No description provided for @scanMeal.
  ///
  /// In en, this message translates to:
  /// **'Scan Meal'**
  String get scanMeal;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'OPEN CALORIES PRO: ACTIVE'**
  String get proActive;

  /// No description provided for @alignFoodWithinFrame.
  ///
  /// In en, this message translates to:
  /// **'Align food within frame...'**
  String get alignFoodWithinFrame;

  /// No description provided for @compressingImage.
  ///
  /// In en, this message translates to:
  /// **'Compressing image...'**
  String get compressingImage;

  /// No description provided for @analyzingFood.
  ///
  /// In en, this message translates to:
  /// **'Analyzing food...'**
  String get analyzingFood;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed: {error}'**
  String analysisFailed(String error);

  /// No description provided for @tutorialCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Capture Reality'**
  String get tutorialCaptureTitle;

  /// No description provided for @tutorialCaptureDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your meal directly to start the analysis.'**
  String get tutorialCaptureDesc;

  /// No description provided for @tutorialLoadDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Load Data'**
  String get tutorialLoadDataTitle;

  /// No description provided for @tutorialLoadDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick an existing photo from your device\'s library.'**
  String get tutorialLoadDataDesc;

  /// No description provided for @tutorialTimeCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Capsule'**
  String get tutorialTimeCapsuleTitle;

  /// No description provided for @tutorialTimeCapsuleDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your full log of past meals and daily stats.'**
  String get tutorialTimeCapsuleDesc;

  /// No description provided for @tutorialInspectComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspect Components'**
  String get tutorialInspectComponentsTitle;

  /// No description provided for @tutorialInspectComponentsDesc.
  ///
  /// In en, this message translates to:
  /// **'When multiple items are detected (e.g., Burger + Fries), tap on an item to see its specific portion size and individual macros.'**
  String get tutorialInspectComponentsDesc;

  /// No description provided for @tutorialEraseHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase History'**
  String get tutorialEraseHistoryTitle;

  /// No description provided for @tutorialEraseHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on any meal card to delete it from your log.'**
  String get tutorialEraseHistoryDesc;

  /// No description provided for @mealDetails.
  ///
  /// In en, this message translates to:
  /// **'MEAL DETAILS'**
  String get mealDetails;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'ANALYSIS'**
  String get analysis;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @matchPercent.
  ///
  /// In en, this message translates to:
  /// **'98% Match'**
  String get matchPercent;

  /// No description provided for @detected.
  ///
  /// In en, this message translates to:
  /// **'DETECTED'**
  String get detected;

  /// No description provided for @detectedFoods.
  ///
  /// In en, this message translates to:
  /// **'DETECTED FOODS'**
  String get detectedFoods;

  /// No description provided for @unknownFood.
  ///
  /// In en, this message translates to:
  /// **'Unknown Food'**
  String get unknownFood;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @oneServing.
  ///
  /// In en, this message translates to:
  /// **'1 serving'**
  String get oneServing;

  /// No description provided for @notWhatYouAte.
  ///
  /// In en, this message translates to:
  /// **'Not what you ate? Enter manually'**
  String get notWhatYouAte;

  /// No description provided for @macroDistribution.
  ///
  /// In en, this message translates to:
  /// **'MACRO DISTRIBUTION'**
  String get macroDistribution;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @logFood.
  ///
  /// In en, this message translates to:
  /// **'Log Food'**
  String get logFood;

  /// No description provided for @noItemsToSave.
  ///
  /// In en, this message translates to:
  /// **'No items to save'**
  String get noItemsToSave;

  /// No description provided for @mealSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Meal saved to history!'**
  String get mealSavedToHistory;

  /// No description provided for @errorSavingMeal.
  ///
  /// In en, this message translates to:
  /// **'Error saving meal: {error}'**
  String errorSavingMeal(String error);

  /// No description provided for @connectIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Connect Intelligence'**
  String get connectIntelligence;

  /// No description provided for @unlockGeminiAI.
  ///
  /// In en, this message translates to:
  /// **'Unlock Gemini AI'**
  String get unlockGeminiAI;

  /// No description provided for @geminiDescription.
  ///
  /// In en, this message translates to:
  /// **'To analyze your food with Open Calories, we need to connect to Google\'s Gemini brain.'**
  String get geminiDescription;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @getApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a key? Get one from Google AI Studio'**
  String get getApiKeyHint;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get couldNotLaunchUrl;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Goal'**
  String get dailyCalorieGoal;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @connectAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Connect & Continue'**
  String get connectAndContinue;

  /// No description provided for @keyStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Your key is stored locally on device and never shared.'**
  String get keyStoredLocally;

  /// No description provided for @resetHints.
  ///
  /// In en, this message translates to:
  /// **'Reset Hints'**
  String get resetHints;

  /// No description provided for @hintsReset.
  ///
  /// In en, this message translates to:
  /// **'Hints reset! Tutorials will show again.'**
  String get hintsReset;

  /// No description provided for @pleaseEnterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Please enter an API Key'**
  String get pleaseEnterApiKey;

  /// No description provided for @invalidKeyFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid Key format. It must start with \"AIza\" and be 39 characters long.'**
  String get invalidKeyFormat;

  /// No description provided for @openCalories.
  ///
  /// In en, this message translates to:
  /// **'OPEN CALORIES'**
  String get openCalories;

  /// No description provided for @seeWhat.
  ///
  /// In en, this message translates to:
  /// **'See What '**
  String get seeWhat;

  /// No description provided for @youEat.
  ///
  /// In en, this message translates to:
  /// **'You Eat.'**
  String get youEat;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Instant calorie analysis and macro breakdowns powered by Open Calories AI.'**
  String get welcomeDescription;

  /// No description provided for @startScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// No description provided for @connectDevice.
  ///
  /// In en, this message translates to:
  /// **'Connect Device'**
  String get connectDevice;

  /// No description provided for @deviceIntegrationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Device integration coming soon! ⌚'**
  String get deviceIntegrationComingSoon;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'SCANNING...'**
  String get scanning;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get history;

  /// No description provided for @dailyTotal.
  ///
  /// In en, this message translates to:
  /// **'DAILY TOTAL'**
  String get dailyTotal;

  /// No description provided for @percentOfDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of daily goal ({goal})'**
  String percentOfDailyGoal(int percent, int goal);

  /// No description provided for @noMealsLoggedToday.
  ///
  /// In en, this message translates to:
  /// **'No meals logged today'**
  String get noMealsLoggedToday;

  /// No description provided for @noMealsLoggedForDay.
  ///
  /// In en, this message translates to:
  /// **'No meals logged for this day'**
  String get noMealsLoggedForDay;

  /// No description provided for @deleteMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Meal?'**
  String get deleteMealTitle;

  /// No description provided for @deleteActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteActionCannotBeUndone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @mealDeleted.
  ///
  /// In en, this message translates to:
  /// **'Meal deleted'**
  String get mealDeleted;

  /// No description provided for @scanMealOption.
  ///
  /// In en, this message translates to:
  /// **'Scan Meal'**
  String get scanMealOption;

  /// No description provided for @useAiToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Use AI to analyze your food photo'**
  String get useAiToAnalyze;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @typeInFoodAndPortion.
  ///
  /// In en, this message translates to:
  /// **'Type in food name and portion'**
  String get typeInFoodAndPortion;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String today(String date);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {date}'**
  String yesterday(String date);

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @enterNameAndPortionError.
  ///
  /// In en, this message translates to:
  /// **'Please enter name and portion first'**
  String get enterNameAndPortionError;

  /// No description provided for @aiEstimationCompleted.
  ///
  /// In en, this message translates to:
  /// **'AI estimation completed!'**
  String get aiEstimationCompleted;

  /// No description provided for @aiEstimationFailed.
  ///
  /// In en, this message translates to:
  /// **'AI Estimation failed: {error}'**
  String aiEstimationFailed(String error);

  /// No description provided for @loggedFood.
  ///
  /// In en, this message translates to:
  /// **'Logged {name} with {calories} kcal'**
  String loggedFood(String name, int calories);

  /// No description provided for @manualEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'MANUAL ENTRY'**
  String get manualEntryTitle;

  /// No description provided for @requiredSection.
  ///
  /// In en, this message translates to:
  /// **'REQUIRED'**
  String get requiredSection;

  /// No description provided for @tutorialNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Name Your Fuel'**
  String get tutorialNameTitle;

  /// No description provided for @tutorialNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of your food item.'**
  String get tutorialNameDesc;

  /// No description provided for @foodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodNameLabel;

  /// No description provided for @foodNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tortillas'**
  String get foodNameHint;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @portionLabel.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get portionLabel;

  /// No description provided for @portionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 pieces'**
  String get portionHint;

  /// No description provided for @pleaseEnterPortion.
  ///
  /// In en, this message translates to:
  /// **'Please enter a portion'**
  String get pleaseEnterPortion;

  /// No description provided for @tutorialAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assist'**
  String get tutorialAiTitle;

  /// No description provided for @tutorialAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Let Gemini estimate calories from the food name.'**
  String get tutorialAiDesc;

  /// No description provided for @estimating.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATING...'**
  String get estimating;

  /// No description provided for @estimateWithAiAction.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATE WITH AI'**
  String get estimateWithAiAction;

  /// No description provided for @nutritionOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'NUTRITION (OPTIONAL)'**
  String get nutritionOptionalSection;

  /// No description provided for @tutorialFineTuneTitle.
  ///
  /// In en, this message translates to:
  /// **'Fine-Tune Data'**
  String get tutorialFineTuneTitle;

  /// No description provided for @tutorialFineTuneDesc.
  ///
  /// In en, this message translates to:
  /// **'Manually adjust the nutritional info if needed.'**
  String get tutorialFineTuneDesc;

  /// No description provided for @logMealAction.
  ///
  /// In en, this message translates to:
  /// **'LOG MEAL'**
  String get logMealAction;

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @weeklyInsights.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY INSIGHTS'**
  String get weeklyInsights;

  /// No description provided for @tutorialTimeTravelTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Travel'**
  String get tutorialTimeTravelTitle;

  /// No description provided for @tutorialTimeTravelDesc.
  ///
  /// In en, this message translates to:
  /// **'Use arrows to browse previous weeks history.'**
  String get tutorialTimeTravelDesc;

  /// No description provided for @tutorialSelectDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Day'**
  String get tutorialSelectDayTitle;

  /// No description provided for @tutorialSelectDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap any day to view its meal history.'**
  String get tutorialSelectDayDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
