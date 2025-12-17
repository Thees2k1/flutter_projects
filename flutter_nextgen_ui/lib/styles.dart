import 'package:flutter/material.dart' show Colors, TextStyle, FontWeight;

class TextStyles {
  static final _baseFont = TextStyle(fontFamily: 'Exo', color: Colors.white);

  static TextStyle get h1 => _baseFont.copyWith(
    fontSize: 75,
    letterSpacing: 35,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get h2 => h1.copyWith(fontSize: 40, letterSpacing: 0);
  static TextStyle get h3 =>
      h1.copyWith(fontSize: 24, letterSpacing: 20, fontWeight: FontWeight.w400);
  static TextStyle get body => _baseFont.copyWith(fontSize: 16);
  static TextStyle get btn => _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 10,
  );
}
