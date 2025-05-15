import 'package:flutter/material.dart';

class AssetColors {
  static List<List<Color>> get gradientColors => [
    [Color(0xFF6C63FF), Color(0xFF3F3D56)],
    [Color(0xFFFF6584), Color(0xFF3F3D56)],
    [Color(0xFF00C9A7), Color(0xFF3F3D56)],
    [Color(0xFFFFB86C), Color(0xFF3F3D56)],
    [Color(0xFF6B8AFD), Color(0xFF3F3D56)],
  ];

  static List<Color> getColorsForAsset(String code) {
    return gradientColors[code.hashCode % gradientColors.length];
  }
} 