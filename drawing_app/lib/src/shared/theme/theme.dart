import 'package:flutter/material.dart';
import 'palette.dart';
export 'palette.dart';

sealed class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: Palette.lightPrimary,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Palette.lightAccent,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Palette.lightBG,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.lightPrimary.withAlpha((255 * .7).ceil()),
      elevation: .0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palette.lightPrimary.withAlpha((.7 * 255).ceil()),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: .none,
      focusedBorder: .none,
    ),
  );
}
