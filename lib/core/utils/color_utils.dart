import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color fromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
