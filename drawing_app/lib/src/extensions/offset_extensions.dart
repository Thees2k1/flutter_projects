import 'dart:ui' show Offset, Size;

extension OffsetExtensions on Offset {
  static const double standardWidth = 800;
  static const double standardHeight = 600;

  Offset scaleToStandard(Size deviceCanvasSize) {
    final scaleX = standardWidth / deviceCanvasSize.width;
    final scaleY = standardHeight / deviceCanvasSize.height;

    return Offset(dx * scaleX, dy * scaleY);
  }

  Offset scaleFromStandard(Size deviceCanvasSize) {
    final scaleX = deviceCanvasSize.width / standardWidth;
    final scaleY = deviceCanvasSize.height / standardHeight;

    return Offset(dx * scaleX, dy * scaleY);
  }
}
