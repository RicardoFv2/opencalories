import 'package:flutter/material.dart';
import 'package:opencalories/core/theme/design_tokens.dart';

/// Uppercase, tracked-out label for the "HUD" accent style (scan status,
/// section eyebrows). Centralizes what was previously copy-pasted
/// `TextStyle`s across scanner/analysis/welcome.
class HudLabel extends StatelessWidget {
  const HudLabel(this.text, {super.key, this.color, this.fontSize});

  final String text;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: DesignTokens.hudLabel.copyWith(color: color, fontSize: fontSize),
    );
  }
}

/// A [HudLabel] with an optional trailing action, used to head off a
/// section of content (e.g. "Ingredients" · edit action).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: HudLabel(title)),
        if (trailing != null) trailing!,
      ],
    );
  }
}
