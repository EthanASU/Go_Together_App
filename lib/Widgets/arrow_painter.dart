import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2); // Start at the middle
    path.lineTo(size.width - size.height / 2, 0); // Top right corner
    path.lineTo(size.width, size.height / 2); // Middle of the right edge
    path.lineTo(size.width - size.height / 2, size.height); // Bottom right corner
    path.lineTo(0, size.height / 2); // Back to the starting point

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}