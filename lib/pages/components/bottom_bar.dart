import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 40)
      ..shader = const RadialGradient(
        colors: [
          Colors.red,
          Colors.green,
        ],
      ).createShader(
        Rect.fromCenter(width: 450, height: 450, center: const Offset(0, 200)),
      );

    var path = Path();
    path.moveTo(0, size.height * 1.00);
    path.quadraticBezierTo(size.width * 0.02, size.height * 0.71,
        size.width * 0.06, size.height * 0.49);
    path.cubicTo(size.width * 0.13, size.height * 0.11, size.width * 0.43,
        size.height * -0.02, size.width * 0.44, size.height * 0.20);
    path.cubicTo(size.width * 0.44, size.height * 0.92, size.width * 0.50,
        size.height * 0.44, size.width * 0.50, size.height * 0.88);
    path.cubicTo(size.width * 0.50, size.height * 0.43, size.width * 0.56,
        size.height * 0.96, size.width * 0.56, size.height * 0.20);
    path.cubicTo(size.width * 0.57, size.height * 0.02, size.width * 0.83,
        size.height * 0.16, size.width * 0.94, size.height * 0.49);
    path.quadraticBezierTo(size.width * 0.99, size.height * 0.74,
        size.width * 1.00, size.height * 1.00);
    path.lineTo(0, size.height * 1.00);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
