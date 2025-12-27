import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_dining,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'OPEN CALORIES',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Hero Image Area
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Placeholder Image (Apple/Scanner visual)
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB90KLW_KTbgpqU3Sp_lJ7_7BxuT6-hgaErq-3qge2Uf9L-amejkYHY3q9Ajel5Hnj8l8oeqt6bGMQANZNzyee2t4uVSTeNAFRg7gs8u0dbOCJRifLelP_py1xKBxze_i-Yu7oudM-WjsQkBswPZD1sY__CYYvqfrcIRXXKxPzzrpnU9ufp8a81_dgfNPRjxV6yv1FgaqQ20_CR0hRHrP72mTwwHzbifezv-i5Wj1nxXyOK1VdbG-myCTBff1of9oT0-Oqd6CWbYNs',
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) =>
                                Container(color: Colors.grey[900]),
                          ),

                          // Overlay Gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppTheme.backgroundDark.withValues(
                                    alpha: 0.1,
                                  ),
                                  AppTheme.backgroundDark.withValues(
                                    alpha: 0.9,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Scanning UI Elements
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  // Corner Brackets
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: _CornerBracket(
                                      isTop: true,
                                      isLeft: true,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: _CornerBracket(
                                      isTop: true,
                                      isLeft: false,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: _CornerBracket(
                                      isTop: false,
                                      isLeft: true,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: _CornerBracket(
                                      isTop: false,
                                      isLeft: false,
                                    ),
                                  ),

                                  // Scanning indicator
                                  Positioned(
                                    bottom: -24,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppTheme.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                              .animate(
                                                onPlay: (c) => c.repeat(),
                                              )
                                              .fade(duration: 1.seconds),
                                          const SizedBox(width: 6),
                                          Text(
                                            'SCANNING...',
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                              fontSize: 10,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Text & Actions
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  color: Colors.white,
                                ),
                            children: [
                              const TextSpan(text: 'See What \n'),
                              TextSpan(
                                text: 'You Eat.',
                                style: TextStyle(
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  decoration: TextDecoration.none,
                                  foreground: Paint()
                                    ..shader =
                                        const LinearGradient(
                                          colors: [
                                            AppTheme.primary,
                                            Color(0xFF34D399),
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Instant calorie analysis and macro breakdowns powered by Open Calories AI.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[400], height: 1.5),
                        ),

                        const SizedBox(height: 32),

                        // Primary Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child:
                              FilledButton(
                                    onPressed: () => context.go('/settings'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      foregroundColor: AppTheme.backgroundDark,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.center_focus_weak),
                                        SizedBox(width: 8),
                                        Text(
                                          'Start Scanning',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate(
                                    onPlay: (c) => c.repeat(period: 3.seconds),
                                  )
                                  .shimmer(
                                    duration: 1.5.seconds,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                        ),

                        const SizedBox(height: 12),

                        // Secondary Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Connect device flow
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bluetooth_connected, size: 20),
                                SizedBox(width: 8),
                                Text('Connect Device'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(8)
              : Radius.zero,
        ),
      ),
    );
  }
}
