import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:opencalories/features/api_key/data/api_key_repository.dart';
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
  testWidgets('App redirects to SettingsScreen when no API key is found', (
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
    await tester.pumpAndSettle();

    // Verify that we are on the Settings Screen
    expect(find.text('Enter your Google AI Studio API Key'), findsOneWidget);
    expect(find.text('OpenCalories'), findsNothing); // Title of Home
  });

  testWidgets('App allows Home when API key is present', (
    WidgetTester tester,
  ) async {
    final mockRepo = MockApiKeyRepository();
    await mockRepo.setApiKey('dummy_key');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyRepositoryProvider.overrideWith((ref) => mockRepo)],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that we are on the Home Screen (or at least NOT on settings)
    // Note: Our Home Screen placeholder has 'Home Screen (Placeholder)' text
    expect(find.text('Home Screen (Placeholder)'), findsOneWidget);
  });
}
