import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/analysis/domain/food_analysis.dart';
import '../../features/settings/data/api_key_repository.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/analysis/presentation/analysis_result_screen.dart';
import '../../features/analysis/presentation/full_screen_image_view.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/splash_screen.dart';

import '../../features/history/presentation/history_screen.dart';
import '../../features/history/presentation/weekly_summary_screen.dart';
import '../../features/manual_entry/presentation/manual_food_entry_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final apiKeyAsync = ref.watch(apiKeyProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoading = apiKeyAsync.isLoading;
      final hasKey =
          apiKeyAsync.valueOrNull != null &&
          apiKeyAsync.valueOrNull!.isNotEmpty;

      final isSplash = state.matchedLocation == '/splash';
      final isWelcome = state.matchedLocation == '/welcome';
      final isSettings = state.matchedLocation == '/settings';

      // 1. Si está cargando, dejamos que se muestre lo que corresponda
      // (normalmente será el splash screen al inicio)
      if (isLoading) return null;

      // 2. Si estamos en Splash
      if (isSplash) {
        // En splash screen, no redirigimos desde el router.
        // El propio widget SplashScreen se encarga de navegar cuando termina
        // su animación de tiempo mínimo (2s) + carga de datos.
        return null;
      }

      // 3. Si ya tiene key (Autenticado)
      if (hasKey) {
        // No debería poder ver splash ni welcome
        if (isWelcome || isSplash) {
          return '/';
        }
        return null; // Dejarlo pasar a donde iba (ej. settings, scan, history)
      }

      // 4. Si NO tiene key (No Autenticado)
      if (!hasKey) {
        // Permitir acceso a welcome y settings
        if (isWelcome || isSettings) return null;

        // Cualquier otra ruta protegida redirige a welcome
        // Nota: Si venía de splash, el splash lo mandará a welcome explícitamente,
        // así que esto es un fallback de seguridad.
        return '/welcome';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HistoryScreen()),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScannerScreen(),
      ),
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
          final extra = state.extra as Map<String, dynamic>?;
          final analysis = extra?['analysis'] as FoodAnalysis?;
          final imageFile = extra?['image'] as File?;
          final isViewOnly = extra?['isViewOnly'] as bool? ?? false;
          return AnalysisResultScreen(
            analysis: analysis,
            imageFile: imageFile,
            isViewOnly: isViewOnly,
          );
        },
      ),
      GoRoute(
        path: '/manual-entry',
        builder: (context, state) => const ManualFoodEntryScreen(),
      ),
      GoRoute(
        path: '/image-view',
        builder: (context, state) {
          final imageFile = state.extra as File?;
          return FullScreenImageView(imageFile: imageFile!);
        },
      ),
      GoRoute(
        path: '/weekly',
        builder: (context, state) => const WeeklySummaryScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}
