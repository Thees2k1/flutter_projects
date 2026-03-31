enum StrokeType {
  normal,
  eraser,
  line,
  polygon,
  square,
  circle;

  factory StrokeType.fromString(String value) {
    switch (value) {
      case 'normal':
        return StrokeType.normal;
      case 'eraser':
        return StrokeType.eraser;
      case 'line':
        return StrokeType.line;
      case 'polygon':
        return StrokeType.polygon;
      case 'square':
        return StrokeType.square;
      case 'circle':
        return StrokeType.circle;
      default:
        return StrokeType.normal;
    }
  }

  @override
  String toString() => switch (this) {
    StrokeType.circle => 'circle',
    StrokeType.eraser => 'eraser',
    StrokeType.square => 'square',
    StrokeType.line => 'line',
    StrokeType.polygon => 'polygon',
    _ => 'normal',
  };
}
