import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.05, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.30, 0, 0);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.00,
        size.width * 0.50, size.height * 0.10);
    path.quadraticBezierTo(
        size.width * 0.65, size.height * 0.01, size.width, 0);
    path.quadraticBezierTo(size.width * 0.90, size.height * 0.30,
        size.width * 0.95, size.height * 0.50);
    path.quadraticBezierTo(
        size.width * 0.90, size.height * 0.70, size.width, size.height);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.99,
        size.width * 0.50, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 1.00, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
