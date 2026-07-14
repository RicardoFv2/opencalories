import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencalories/core/theme/design_tokens.dart';
import 'package:opencalories/core/widgets/app_card.dart';

enum MacroType { protein, carbs, fat }

extension MacroTypeColor on MacroType {
  Color get color => switch (this) {
    MacroType.protein => DesignTokens.proteinColor,
    MacroType.carbs => DesignTokens.carbsColor,
    MacroType.fat => DesignTokens.fatColor,
  };
}

/// A single macro readout (dot + grams + label). Sizes to its content —
/// wrap in `Expanded`/`Flexible` (never a fixed `width:`) when laying three
/// out side by side so it can't overflow on narrow screens.
class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.type,
    required this.label,
    required this.grams,
    this.isPrimary = false,
  });

  final MacroType type;
  final String label;
  final double grams;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final color = type.color;
    return AppCard(
      glass: isPrimary,
      borderColor: isPrimary ? color.withValues(alpha: 0.4) : null,
      padding: const EdgeInsets.symmetric(
        vertical: DesignTokens.spaceM,
        horizontal: DesignTokens.spaceS,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: DesignTokens.spaceXS),
          Text(
            '${grams.toStringAsFixed(0)}g',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: DesignTokens.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              color: DesignTokens.textTertiary,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Small inline tag variant (ingredient list rows, refine dialog).
class MacroMiniTag extends StatelessWidget {
  const MacroMiniTag({super.key, required this.type, required this.text});

  final MacroType type;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: type.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: DesignTokens.spaceXS),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: DesignTokens.textSecondary,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Horizontal protein/carbs/fat proportion bar.
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.height = 8,
  });

  final double protein;
  final double carbs;
  final double fat;
  final double height;

  @override
  Widget build(BuildContext context) {
    final total = protein + carbs + fat;
    final radius = BorderRadius.circular(height / 2);

    if (total <= 0) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(
          height: height,
          color: Colors.white.withValues(alpha: 0.08),
        ),
      );
    }

    // At least one segment is guaranteed > 0 here, so total flex is never 0.
    int flexFor(double grams) =>
        grams <= 0 ? 0 : (grams / total * 1000).round().clamp(1, 1000);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              flex: flexFor(protein),
              child: Container(color: DesignTokens.proteinColor),
            ),
            Expanded(
              flex: flexFor(carbs),
              child: Container(color: DesignTokens.carbsColor),
            ),
            Expanded(
              flex: flexFor(fat),
              child: Container(color: DesignTokens.fatColor),
            ),
          ],
        ),
      ),
    );
  }
}
