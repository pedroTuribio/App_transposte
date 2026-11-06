import 'package:flutter/material.dart';

import '../tokens/yellow_colors.dart';
import '../tokens/yellow_spacing.dart';
import '../tokens/yellow_typography.dart';

enum YellowButtonVariant { primary, secondary, outline, ghost }

/// Botão do Design System Yellow. `onPressed == null` => desabilitado.
class YellowButton extends StatelessWidget {
  const YellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = YellowButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final YellowButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color bg, Color fg, Color? borderColor) = switch (variant) {
      YellowButtonVariant.primary => (
          YellowColors.yellow500,
          YellowColors.blue900,
          null
        ),
      YellowButtonVariant.secondary => (
          YellowColors.blue900,
          YellowColors.neutral0,
          null
        ),
      YellowButtonVariant.outline => (
          Colors.transparent,
          isDark ? YellowColors.yellow500 : YellowColors.blue900,
          isDark ? YellowColors.yellow500 : YellowColors.blue900
        ),
      YellowButtonVariant.ghost => (
          Colors.transparent,
          isDark ? YellowColors.yellow500 : YellowColors.blue700,
          null
        ),
    };

    final disabledBg = (variant == YellowButtonVariant.outline ||
            variant == YellowButtonVariant.ghost)
        ? Colors.transparent
        : (isDark ? YellowColors.darkOutline : YellowColors.neutral200);
    final disabledFg = YellowColors.neutral500;

    final style = ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: const WidgetStatePropertyAll(Size(64, 52)),
      padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: YellowSpacing.lg)),
      textStyle: const WidgetStatePropertyAll(YellowTypography.button),
      shape: WidgetStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(YellowSpacing.radiusMd),
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(
                    color: states.contains(WidgetState.disabled)
                        ? disabledFg.withValues(alpha: 0.5)
                        : borderColor,
                    width: 1.5),
          )),
      backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? disabledBg : bg),
      foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? disabledFg : fg),
      overlayColor:
          WidgetStatePropertyAll(fg.withValues(alpha: 0.08)),
    );

    // Em loading mantém a aparência "ativa" (callback no-op).
    final VoidCallback? effective = isLoading ? () {} : onPressed;

    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: YellowSpacing.sm),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final Widget button = switch (variant) {
      YellowButtonVariant.primary ||
      YellowButtonVariant.secondary =>
        ElevatedButton(style: style, onPressed: effective, child: child),
      YellowButtonVariant.outline =>
        OutlinedButton(style: style, onPressed: effective, child: child),
      YellowButtonVariant.ghost =>
        TextButton(style: style, onPressed: effective, child: child),
    };

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: button,
    );
  }
}
