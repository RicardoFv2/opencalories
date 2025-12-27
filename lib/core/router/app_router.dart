import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/api_key_repository.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final apiKeyAsync = ref.watch(apiKeyProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = apiKeyAsync.isLoading;
      final hasKey =
          apiKeyAsync.valueOrNull != null &&
          apiKeyAsync.valueOrNull!.isNotEmpty;
      final isSettings = state.matchedLocation == '/settings';

      if (isLoading) return null;

      if (!hasKey) {
        return '/settings';
      }

      if (isSettings && hasKey) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ScannerScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
