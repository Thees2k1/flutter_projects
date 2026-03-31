import 'dart:convert';

import 'package:flutter/foundation.dart' show Uint8List, ByteData;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

extension GlobalKeyExtension on GlobalKey {
  Future<String?> toBase64() async {
    final RenderRepaintBoundary? boundary =
        currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      return null;
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List? pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) return null;

    return base64Encode(pngBytes);
  }
}
