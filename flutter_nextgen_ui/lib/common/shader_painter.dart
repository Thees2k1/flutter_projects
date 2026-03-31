import 'dart:ui';

import 'package:flutter/material.dart';

typedef ShaderUpdateCallback = void Function(FragmentShader, Size);

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final ShaderUpdateCallback? update;

  ShaderPainter(this.shader, {this.update});
  @override
  void paint(Canvas canvas, Size size) {
    update?.call(shader, size);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.update != update;
  }
}
