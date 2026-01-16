import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../settings/data/api_key_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Iniciar la lógica de navegación después del renderizado inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // 1. Tiempo mínimo de espera para que se vea el splash (UX)
    // Esto evita el "flash" y da una sensación de carga profesional
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 2. Obtener el estado de la API Key
    // Usamos read porque estamos en un método asíncrono, pero en el build
    // ya estamos escuchando cambios si fuera necesario.
    // Aquí queremos el valor actual después del delay.
    final apiKeyAsync = ref.read(apiKeyProvider);

    // Esperar a que el provider cargue si aún está cargando
    if (apiKeyAsync.isLoading) {
      // Si aún está cargando después de 2 segundos, esperamos el siguiente valor
      // Esto es un edge case raro, pero buena práctica
      final nextValue = await ref.read(apiKeyProvider.future);
      if (!mounted) return;
      _navigateBasedOnKey(nextValue);
    } else {
      _navigateBasedOnKey(apiKeyAsync.valueOrNull);
    }
  }

  void _navigateBasedOnKey(String? apiKey) {
    if (apiKey != null && apiKey.isNotEmpty) {
      // Tiene Key -> Ir a History (Home)
      context.go('/');
    } else {
      // No tiene Key -> Ir a Welcome
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color del native splash: negro puro
    const nativeSplashColor = Color(0xFF000000);

    return Scaffold(
      backgroundColor: nativeSplashColor,
      body: Container(
        color: nativeSplashColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animado - Usa el mismo logo de la app
              ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/seedream-4.5_Add_a_black_background_use_color_code_000000-0.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback al icono si la imagen no carga
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_dining,
                            size: 64,
                            color: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                  .scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.5, 0.5),
                  )
                  .then()
                  .shimmer(
                    duration: 1500.ms,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),

              const SizedBox(height: 24),

              // Nombre de la App
              Text(
                    'OpenCalories',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms),

              const SizedBox(height: 48),

              // Indicador de Carga Sutil
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 600.ms)
                      .then(delay: (index * 200).ms)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.5, 1.5),
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.5, 1.5),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                      );
                }),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
