import 'package:flutter/material.dart';

extension ThemeContextEx on BuildContext {
  ThemeData get theme => Theme.of(this);
}
