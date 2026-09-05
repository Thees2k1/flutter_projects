import 'package:flutter/rendering.dart';

typedef Typo = ({TextAlign textAlign, TextStyle style});

abstract class StyleConfig {
  static const Typo bodySemiBold = (
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 20),
  );

  static const Typo caption = (
    textAlign: TextAlign.justify,
    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 16),
  );
}

abstract class ColorConfig {
  static const energyBlue = Color.fromARGB(255, 58, 148, 231);
  static const flameOrange = Color.fromARGB(255, 229, 84, 56);
}
