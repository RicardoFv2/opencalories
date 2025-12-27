import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/api_key_repository.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/analysis/presentation/analysis_result_screen.dart';
import '../../features/onboarding/welcome_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final apiKeyAsync = ref.watch(apiKeyProvider);

  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) {
      final isLoading = apiKeyAsync.isLoading;
      final hasKey =
          apiKeyAsync.valueOrNull != null &&
          apiKeyAsync.valueOrNull!.isNotEmpty;

      final isWelcome = state.matchedLocation == '/welcome';
      final isSettings = state.matchedLocation == '/settings';

      if (isLoading) return null;

      // If user has key, they shouldn't be on welcome or settings (unless explicitly navigated)
      // But for initial load, if hasKey is true, we want to go to / (Scanner)
      if (hasKey) {
        if (isWelcome || isSettings) {
          // If we are just launching and have key, go home.
          // Note: User might manually navigate to settings later, handle that case?
          // For now, let's just say if you have a key, you can't go to welcome.
          return isWelcome ? '/' : null;
        }
        return null;
      }

      // If no key
      if (!hasKey) {
        // Allow access to welcome and settings
        if (isWelcome || isSettings) return null;
        // Redirect everything else to welcome
        return '/welcome';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ScannerScreen()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/analysis',
        builder: (context, state) {
          final imageFile = state.extra as File?;
          return AnalysisResultScreen(imageFile: imageFile);
        },
      ),
    ],
  );
}
