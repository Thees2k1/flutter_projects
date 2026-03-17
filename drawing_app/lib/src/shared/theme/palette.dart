import 'dart:ui' show Color;

sealed class Palette {
  static const Color blueAccent = Color(0xff3B7CEF);
  static const Color lightPrimary = blueAccent;
  static const Color lightAccent = Color(0xffE9FAFF);
  static Color lightBG = blueAccent;
  static const Color greenAccent = Color(0xff79D377);
  static const Color yellowAccent = Color(0xffFFB800);
  static const Color pinkAccent = Color(0xffFF87CF);
  static const Color redAccent = Color(0xffE8464A);
  static const Color greyAccent = Color(0xffA1ACBC);
  static const Color blackAccent = Color(0xff303337);
  static Color borderColor = blackAccent;
  static Color lightGrey = const Color(0xffF6F6F6);

  static const Color canvasColor = Color(0xfff2f3f7);

  static final accentColors = [
    greenAccent,
    yellowAccent,
    pinkAccent,
    redAccent,
  ];
}
