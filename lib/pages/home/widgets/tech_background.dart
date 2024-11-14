import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class TechBackground extends StatelessWidget {
  const TechBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // 主背景渐变
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withBlue(
                  ((colorScheme.surface.blue * 1.05).clamp(0, 255)).toInt(),
                ),
              ],
            ),
          ),
        ),

        // 顶部装饰
        Positioned(
          top: -200.h,
          right: -100.w,
          child: Container(
            width: 400.w,
            height: 400.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.08),
                  colorScheme.primary.withOpacity(0),
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // 动态光效1
        Positioned(
          top: 0.3.sh,
          left: -100.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.05),
                  colorScheme.primary.withOpacity(0),
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // 动态光效2
        Positioned(
          bottom: -100.h,
          right: -50.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.08),
                  colorScheme.primary.withOpacity(0),
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // 装饰线条
        CustomPaint(
          size: Size(1.sw, 1.sh),
          painter: LinePainter(
            color: colorScheme.primary.withOpacity(0.05),
          ),
        ),

        // 背景点缀
        ...List.generate(
          15,
          (index) {
            final random = math.Random(index);
            return Positioned(
              left: random.nextDouble() * 1.sw,
              top: random.nextDouble() * 1.sh,
              child: Container(
                width: (2 + random.nextDouble() * 3).w,
                height: (2 + random.nextDouble() * 3).w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  final Color color;

  LinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    // 斜线图案
    const spacing = 100.0;
    const angle = math.pi / 6; // 30度角

    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      final startX = i;
      final startY = 0.0;
      final endX = i + size.height * math.tan(angle);
      final endY = size.height;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
