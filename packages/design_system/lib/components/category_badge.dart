import 'package:flutter/material.dart';

import '../tokens/yellow_colors.dart';
import '../tokens/yellow_spacing.dart';
import '../tokens/yellow_typography.dart';

enum BadgeTone { accent, success, info, neutral, danger }

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.accent,
    this.icon,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (tone) {
      BadgeTone.accent => (YellowColors.yellow100, YellowColors.orange600),
      BadgeTone.success => (const Color(0xFFD9F3E5), YellowColors.success),
      BadgeTone.info => (YellowColors.blue100, YellowColors.blue700),
      BadgeTone.neutral => (YellowColors.neutral200, YellowColors.neutral700),
      BadgeTone.danger => (const Color(0xFFFCE0DE), YellowColors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: YellowSpacing.sm + 2, vertical: YellowSpacing.xs + 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(YellowSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: YellowSpacing.xs),
          ],
          Text(label,
              style: YellowTypography.caption
                  .copyWith(color: fg, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
