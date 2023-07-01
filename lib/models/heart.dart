import 'dart:math';
import 'dart:ui';

Path drawHeart(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    // Method to draw a h Path drawHeart() {
      final path = Path();
      path.moveTo(size.width / 2, size.height / 5);
      path.cubicTo(
          size.width / 2, 0.0, 0.0, size.height / 3.5, 0.0, size.height / 2.5);
      path.cubicTo(
          0.0, size.height / 1.5, size.width / 2, size.height, size.width / 2, size.height);
      path.cubicTo(size.width / 2, size.height, size.width, size.height / 1.5,
          size.width, size.height / 2.5);
      path.cubicTo(
          size.width, size.height / 3.5, size.width / 2, 0.0, size.width / 2, 0.0);
      path.close();
      return path;
    
  }