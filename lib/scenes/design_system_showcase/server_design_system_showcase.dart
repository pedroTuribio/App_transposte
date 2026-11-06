import 'package:design_system/design_system.dart';
import 'package:flutter/painting.dart';

class ColorSample {
  const ColorSample(this.name, this.color);
  final String name;
  final Color color;

  String get hex =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

class ColorGroup {
  const ColorGroup(this.title, this.samples);
  final String title;
  final List<ColorSample> samples;
}

class TypographySample {
  const TypographySample(this.name, this.spec, this.style);
  final String name;
  final String spec;
  final TextStyle style;
}

class ShadowSample {
  const ShadowSample(this.name, this.shadows);
  final String name;
  final List<BoxShadow> shadows;
}

class ShowcaseData {
  const ShowcaseData({
    required this.colorGroups,
    required this.typography,
    required this.shadows,
  });

  final List<ColorGroup> colorGroups;
  final List<TypographySample> typography;
  final List<ShadowSample> shadows;
}

abstract class ServerDesignSystemShowcase {
  Future<ShowcaseData> loadShowcase();
}

/// Lê os tokens reais do pacote `design_system`.
class ServerDesignSystemShowcaseImpl implements ServerDesignSystemShowcase {
  const ServerDesignSystemShowcaseImpl();

  @override
  Future<ShowcaseData> loadShowcase() async {
    return const ShowcaseData(
      colorGroups: [
        ColorGroup('Accent · Amarelo / Laranja', [
          ColorSample('yellow-100', YellowColors.yellow100),
          ColorSample('yellow-500', YellowColors.yellow500),
          ColorSample('yellow-700', YellowColors.yellow700),
          ColorSample('orange-500', YellowColors.orange500),
          ColorSample('orange-600', YellowColors.orange600),
        ]),
        ColorGroup('Primárias · Azuis / Escuros', [
          ColorSample('blue-100', YellowColors.blue100),
          ColorSample('blue-500', YellowColors.blue500),
          ColorSample('blue-700', YellowColors.blue700),
          ColorSample('blue-900', YellowColors.blue900),
        ]),
        ColorGroup('Neutras', [
          ColorSample('neutral-0', YellowColors.neutral0),
          ColorSample('neutral-50', YellowColors.neutral50),
          ColorSample('neutral-100', YellowColors.neutral100),
          ColorSample('neutral-200', YellowColors.neutral200),
          ColorSample('neutral-300', YellowColors.neutral300),
          ColorSample('neutral-500', YellowColors.neutral500),
          ColorSample('neutral-700', YellowColors.neutral700),
          ColorSample('neutral-900', YellowColors.neutral900),
        ]),
        ColorGroup('Semânticas', [
          ColorSample('success', YellowColors.success),
          ColorSample('warning', YellowColors.warning),
          ColorSample('error', YellowColors.error),
        ]),
      ],
      typography: [
        TypographySample('Display', '40 / ExtraBold', YellowTypography.display),
        TypographySample('Title 1', '28 / Bold', YellowTypography.title1),
        TypographySample('Title 2', '22 / Bold', YellowTypography.title2),
        TypographySample('Title 3', '18 / SemiBold', YellowTypography.title3),
        TypographySample('Body Large', '16 / Regular', YellowTypography.bodyLarge),
        TypographySample('Body', '14 / Regular', YellowTypography.body),
        TypographySample('Body Bold', '14 / SemiBold', YellowTypography.bodyBold),
        TypographySample('Caption', '12 / Regular', YellowTypography.caption),
      ],
      shadows: [
        ShadowSample('shadow-xs', YellowShadows.xs),
        ShadowSample('shadow-sm', YellowShadows.sm),
        ShadowSample('shadow-md', YellowShadows.md),
        ShadowSample('shadow-lg', YellowShadows.lg),
      ],
    );
  }
}
