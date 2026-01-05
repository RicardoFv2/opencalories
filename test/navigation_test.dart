import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:opencalories/features/settings/data/api_key_repository.dart';
import 'package:opencalories/main.dart';

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
    // Build our app and trigger a frame.
    // We override the repository to start with no key.

    final mockRepo = MockApiKeyRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyRepositoryProvider.overrideWith((ref) => mockRepo)],
        child: const MyApp(),
      ),
    );

    // Pump to allow the FutureBuilder/AsyncValue to resolve and router into action
    // We use pump with duration to let animations tick but not wait for infinite ones
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));

    // Verify that we are on the Welcome Screen
    expect(find.text('Start Scanning'), findsOneWidget);
    expect(find.text('Scan Meal'), findsNothing);
  });

  testWidgets('App allows Home when API key is present', (
    WidgetTester tester,
  ) async {
    final mockRepo = MockApiKeyRepository();
    await mockRepo.setApiKey('test_key');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyRepositoryProvider.overrideWith((ref) => mockRepo)],
        child: const MyApp(),
      ),
    );

    // Allow time for async value and router
    await tester.pump(const Duration(seconds: 5));

    // Verify we are on History Screen (Home)
    expect(find.text('HISTORY'), findsOneWidget);

    // Explicitly dispose to clean up infinite animations
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
  });
}
