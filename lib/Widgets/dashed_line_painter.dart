import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
        ..color = color
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

    const double fullDashWidth = 5;
    const double halfDashWidth = 5;
    const double dashSpace = 4;
    double startX = 0;
    final double centerY = size.height / 2;

    canvas.drawRect(
      Rect.fromLTWH(startX, centerY - 2, halfDashWidth, 4),
      paint);
    startX += halfDashWidth + dashSpace;

    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(startX, centerY - 2, fullDashWidth, 4),
        paint);
      startX += fullDashWidth + dashSpace;
    }

    canvas.drawRect(
      Rect.fromLTWH(startX, centerY - 2, halfDashWidth, 4),
      paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}