import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:opencalories/features/api_key/data/api_key_repository.dart';
import 'package:opencalories/features/home/presentation/home_screen.dart';
import 'package:opencalories/features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final apiKeyAsync = ref.watch(apiKeyProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // While loading the key, we can't determine the auth state definitively.
      // You might want to show a splash screen here, but for now we default to settings
      // if we can't prove we have a key.

      final apiKey = apiKeyAsync.valueOrNull;
      final isSettings = state.uri.path == '/settings';

      if (apiKey == null || apiKey.isEmpty) {
        return isSettings ? null : '/settings';
      }

      // If we have a key, we allow access.
      // Optionally, if we are at settings solely because of a previous redirect (not user action),
      // we could redirect to home. But explicit "allow /home" implies just don't block it.

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
