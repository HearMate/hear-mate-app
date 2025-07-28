import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class FlDotTrianglePainter extends FlDotPainter with EquatableMixin {
  final Color color;
  final double size;
  final double strokeWidth;
  final Color strokeColor;

  FlDotTrianglePainter({
    this.color = Colors.transparent,
    this.size = 10,
    this.strokeWidth = 1,
    this.strokeColor = Colors.black,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offset) {
    final paintFill =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final paintStroke =
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    final path = Path();

    final halfSize = size / 2;

    // Triangle points: top, bottom left, bottom right
    path.moveTo(offset.dx, offset.dy - halfSize); // top vertex
    path.lineTo(offset.dx - halfSize, offset.dy + halfSize); // bottom left
    path.lineTo(offset.dx + halfSize, offset.dy + halfSize); // bottom right
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  Size getSize(FlSpot spot) => Size(size, size);

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is! FlDotTrianglePainter || b is! FlDotTrianglePainter) {
      return this;
    }
    return FlDotTrianglePainter(
      color: Color.lerp(a.color, b.color, t) ?? color,
      strokeColor: Color.lerp(a.strokeColor, b.strokeColor, t) ?? strokeColor,
      size: lerpDouble(a.size, b.size, t) ?? size,
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? strokeWidth,
    );
  }

  @override
  Color get mainColor => color;

  @override
  List<Object?> get props => [color, size, strokeWidth, strokeColor];
}
