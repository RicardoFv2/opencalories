import 'package:flutter/material.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/glass_card.dart';

class GlassModal extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;

  const GlassModal({super.key, required this.child, this.title, this.actions});

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          GlassModal(title: title, actions: actions, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GlassCard(
        borderRadius: DesignTokens.radiusXL,
        opacity: 0.15,
        blur: 20,
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spaceL,
          horizontal: DesignTokens.spaceM,
        ),
        borderColor: DesignTokens.primary.withValues(alpha: 0.2),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignTokens.spaceL),
              if (title != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
                const SizedBox(height: DesignTokens.spaceL),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
