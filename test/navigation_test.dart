import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:opencalories/features/settings/data/api_key_repository.dart';
import 'package:opencalories/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opencalories/features/history/data/daily_calories_provider.dart';
import 'package:opencalories/features/onboarding/welcome_screen.dart';
import 'package:opencalories/features/onboarding/splash_screen.dart';

// Generate mocks if we were using generated mocks, but for simple storage we can mock manually or use InMemory
// However, since we rely on FlutterSecureStorage, we need to mock it or the repository.
// To keep it simple for this sprint verify, we will override the repository provider.

class MockApiKeyRepository implements ApiKeyRepository {
  String? _key;

  MockApiKeyRepository();

  @override
  Future<void> deleteApiKey() async {
    _key = null;
  }

  @override
  Future<String?> getApiKey() async {
    return _key;
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    _key = apiKey;
  }
}

void main() {
  testWidgets('App redirects to WelcomeScreen when no API key is found', (
    WidgetTester tester,
  ) async {
    // Initialize SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    // We override the repository to start with no key.

    final mockRepo = MockApiKeyRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyRepositoryProvider.overrideWith((ref) => mockRepo)],
        child: const MyApp(),
      ),
    );

    // Verify we're on the splash screen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Initial pump after loading
    await tester.pump();

    // The splash screen has a 2-second navigation delay.
    // Instead of pumAndSettle which might time out, use incremental pumps.
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    // Now wait for everything to settle
    await tester.pumpAndSettle();

    // Verify it navigated to welcome screen
    expect(find.text('Start Scanning'), findsOneWidget);

    // Cleanup to prevent pending timers from leaking to other tests
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
  });

  testWidgets('App allows Home when API key is present', (
    WidgetTester tester,
  ) async {
    final mockRepo = MockApiKeyRepository();
    await mockRepo.setApiKey('test_key');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiKeyRepositoryProvider.overrideWith((ref) => mockRepo),
          dailyCaloriesProvider.overrideWith((ref) => Stream.value(1500)),
        ],
        child: const MyApp(),
      ),
    );

    // Initial state: Splash Screen
    expect(find.text('OpenCalories'), findsOneWidget);

    // Allow time for async value and router
    // SplashScreen has a 2s delay.
    bool found = false;
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      // Look for Scanner Screen title "Scan Meal" or similar unique element
      if (find.text('Scan Meal').evaluate().isNotEmpty) {
        found = true;
        break;
      }
    }
    expect(
      found,
      isTrue,
      reason: 'Should have navigated to Scanner Screen (Camera First)',
    );

    // Verify we are on Scanner Screen
    expect(find.text('Scan Meal'), findsOneWidget);

    // Explicitly dispose to clean up infinite animations or pending timers
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
  });
}
