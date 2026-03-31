import 'dart:math' show min;

import 'package:flutter/material.dart';

class UiScaler extends StatelessWidget {
  final Widget child;

  final Alignment alignment;

  final int referenceHeight;

  const UiScaler({
    super.key,
    required this.child,
    required this.alignment,
    this.referenceHeight = 1080,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double scale = min(screenSize.height / referenceHeight, 1.0);

    return Transform.scale(scale: scale, alignment: alignment, child: child);
  }
}
