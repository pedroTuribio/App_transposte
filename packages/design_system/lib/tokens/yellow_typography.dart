import 'package:flutter/material.dart';

abstract final class YellowTypography {
  static const TextStyle display =
      TextStyle(fontSize: 40, height: 1.1, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const TextStyle title1 =
      TextStyle(fontSize: 28, height: 1.2, fontWeight: FontWeight.w700);
  static const TextStyle title2 =
      TextStyle(fontSize: 22, height: 1.25, fontWeight: FontWeight.w700);
  static const TextStyle title3 =
      TextStyle(fontSize: 18, height: 1.3, fontWeight: FontWeight.w600);
  static const TextStyle bodyLarge =
      TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w400);
  static const TextStyle body =
      TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w400);
  static const TextStyle bodyBold =
      TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w600);
  static const TextStyle caption =
      TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w400);
  static const TextStyle button =
      TextStyle(fontSize: 16, height: 1.2, fontWeight: FontWeight.w700);

  static const TextTheme textTheme = TextTheme(
    displayLarge: display,
    headlineLarge: title1,
    headlineMedium: title2,
    titleLarge: title3,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
  );
}
