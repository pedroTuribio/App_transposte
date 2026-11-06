import 'package:flutter/painting.dart';

/// Sombras shadow-xs ... shadow-lg.
abstract final class YellowShadows {
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0D101828), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x1A101828), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F101828), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A101828), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0F101828), blurRadius: 3, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1F101828), blurRadius: 24, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x14101828), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> navTop = [
    BoxShadow(color: Color(0x1A101828), blurRadius: 8, offset: Offset(0, -2)),
  ];
}
