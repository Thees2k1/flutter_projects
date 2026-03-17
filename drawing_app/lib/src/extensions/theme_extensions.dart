import 'package:flutter/material.dart' show Brightness, Color, ThemeData;

extension ThemeExtension on ThemeData {
  Color get accentColor => colorScheme.secondary;
  bool get isDark => brightness == Brightness.dark;
}
