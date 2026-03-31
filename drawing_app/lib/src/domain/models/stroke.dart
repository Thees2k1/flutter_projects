import 'dart:ui' show Color;
import 'package:flutter/material.dart' show Offset, Colors;

import 'stroke_type.dart';

sealed class Stroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final double opacity;
  final StrokeType strokeType;
  final DateTime createdAt = DateTime.now();

  Stroke({
    required this.points,
    this.size = 1,
    this.opacity = 1,
    this.color = Colors.black,
    this.strokeType = StrokeType.normal,
  });

  Stroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
  });

  Map<String, dynamic> toJson();

  factory Stroke.fromJson(Map<String, dynamic> json) {
    final points = (json['points'] as List<dynamic>)
        .map((point) => Offset((point as List<dynamic>)[0], point[1] as double))
        .toList();
    final color = Color(json['color'] as int);
    final size = double.parse(json['size']);
    //  final size = double.parse(json['size'].toString());
    final opacity = double.parse(json['opacity'].toString());
    final strokeType = StrokeType.fromString(json['strokeType'] as String);

    switch (strokeType) {
      case StrokeType.normal:
        return NormalStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
        );
      case StrokeType.eraser:
        return EraserStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
        );
      case StrokeType.line:
        return LineStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
        );
      case StrokeType.circle:
        return CircleStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
          filled: (json['filled'] as bool?) ?? false,
        );
      case StrokeType.square:
        return SquareStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
          filled: (json['filled'] as bool?) ?? false,
        );
      case StrokeType.polygon:
        return PolygonStroke(
          points: points,
          color: color,
          size: size,
          opacity: opacity,
          sides: (json['sides'] as int?) ?? 3,
          filled: (json['filled'] as bool?) ?? false,
        );
    }
  }
}

final class NormalStroke extends Stroke {
  NormalStroke({required super.points, super.color, super.size, super.opacity})
    : super(strokeType: StrokeType.normal);

  @override
  NormalStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
  }) {
    return NormalStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.toARGB32(),
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
    };
  }
}

final class SquareStroke extends Stroke {
  bool filled;
  SquareStroke({
    required super.points,
    super.color,
    super.opacity,
    super.size,
    this.filled = false,
  }) : super(strokeType: StrokeType.square);

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.toARGB32(),
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
      'filled': filled,
    };
  }

  @override
  Stroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
    bool? filled,
  }) {
    return SquareStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      filled: filled ?? this.filled,
    );
  }
}

final class CircleStroke extends Stroke {
  final bool filled;

  CircleStroke({
    required super.points,
    this.filled = false,
    super.color,
    super.size,
    super.opacity,
  }) : super(strokeType: StrokeType.circle);

  @override
  CircleStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
    bool? filled,
  }) {
    return CircleStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      filled: filled ?? this.filled,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.value,
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
      'filled': filled,
    };
  }
}

final class PolygonStroke extends Stroke {
  final int sides;
  final bool filled;

  PolygonStroke({
    required super.points,
    required this.sides,
    this.filled = false,
    super.color,
    super.size,
    super.opacity,
  }) : super(strokeType: StrokeType.polygon);

  @override
  PolygonStroke copyWith({
    List<Offset>? points,
    int? sides,
    Color? color,
    double? size,
    double? opacity,
    bool? filled,
  }) {
    return PolygonStroke(
      points: points ?? this.points,
      sides: sides ?? this.sides,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      filled: filled ?? this.filled,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'sides': sides,
      'color': color.toARGB32(),
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
      'filled': filled,
    };
  }
}

final class LineStroke extends Stroke {
  LineStroke({required super.points, super.color, super.size, super.opacity})
    : super(strokeType: StrokeType.line);

  @override
  LineStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
  }) {
    return LineStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.value,
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
    };
  }
}

final class EraserStroke extends Stroke {
  EraserStroke({required super.points, super.color, super.size, super.opacity})
    : super(strokeType: StrokeType.eraser);

  @override
  EraserStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    double? opacity,
  }) {
    return EraserStroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.toARGB32(),
      'size': size,
      'opacity': opacity,
      'strokeType': strokeType.toString(),
    };
  }
}
