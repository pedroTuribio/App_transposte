import 'package:flutter/material.dart';

import '../tokens/yellow_colors.dart';
import '../tokens/yellow_spacing.dart';
import '../tokens/yellow_typography.dart';

abstract final class YellowTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme.light(
          primary: YellowColors.yellow500,
          onPrimary: YellowColors.blue900,
          secondary: YellowColors.blue700,
          onSecondary: YellowColors.neutral0,
          tertiary: YellowColors.orange500,
          surface: YellowColors.neutral0,
          onSurface: YellowColors.neutral900,
          surfaceContainerHighest: YellowColors.neutral100,
          outline: YellowColors.neutral300,
          error: YellowColors.error,
        ),
        scaffold: YellowColors.neutral50,
        fill: YellowColors.neutral0,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme.dark(
          primary: YellowColors.yellow500,
          onPrimary: YellowColors.blue900,
          secondary: YellowColors.blue500,
          onSecondary: YellowColors.neutral0,
          tertiary: YellowColors.orange500,
          surface: YellowColors.darkSurface,
          onSurface: YellowColors.neutral50,
          surfaceContainerHighest: YellowColors.darkOutline,
          outline: YellowColors.darkOutline,
          error: Color(0xFFFF6B60),
        ),
        scaffold: YellowColors.neutral950,
        fill: YellowColors.darkSurface,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffold,
    required Color fill,
  }) {
    OutlineInputBorder border(Color color, [double width = 1.2]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(YellowSpacing.radiusMd),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: YellowTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: YellowSpacing.md, vertical: 14),
        border: border(scheme.outline),
        enabledBorder: border(scheme.outline),
        focusedBorder: border(YellowColors.yellow700, 2),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 2),
        disabledBorder: border(scheme.outline.withValues(alpha: 0.5)),
        hintStyle: const TextStyle(color: YellowColors.neutral500),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: fill,
        selectedColor: YellowColors.yellow500,
        side: BorderSide(color: scheme.outline),
        shape: const StadiumBorder(),
        labelStyle: YellowTypography.bodyBold.copyWith(color: scheme.onSurface),
        secondaryLabelStyle:
            YellowTypography.bodyBold.copyWith(color: YellowColors.blue900),
        showCheckmark: false,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? YellowColors.blue900
                : YellowColors.neutral0),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? YellowColors.yellow500
                : YellowColors.neutral300),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: YellowColors.yellow500,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
            YellowTypography.caption.copyWith(fontWeight: FontWeight.w600)),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? YellowColors.blue900
                  : scheme.onSurface.withValues(alpha: 0.7),
            )),
      ),
    );
  }
}
