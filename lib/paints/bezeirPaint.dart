import 'package:flutter/material.dart';

class BezeirPaint extends CustomPainter {
  final List<Offset> points;

  BezeirPaint({required this.points});

  /// Berzier Paramteric equation
  /// P(t) = B0(1-t)3 + B13t(1-t)2 + B23t2(1-t) + B3t3
  /// Bn are controll points

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color.fromARGB(255, 143, 168, 244);
    Path path = Path();

    path.moveTo(points.first.dx, points.first.dy);
    path.cubicTo(points[1].dx, points[1].dy, points[2].dx, points[2].dy,
        points[3].dx, points[3].dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
