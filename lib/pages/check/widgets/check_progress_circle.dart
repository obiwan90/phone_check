import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../check_controller.dart';
import 'package:get/get.dart';
import 'dart:math';

class CheckProgressCircle extends StatefulWidget {
  final CheckController controller;

  const CheckProgressCircle({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CheckProgressCircle> createState() => _CheckProgressCircleState();
}

class _CheckProgressCircleState extends State<CheckProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    widget.controller.currentStep.listen((value) {
      setState(() {
        _progressAnimation = Tween<double>(
          begin: _progressAnimation.value,
          end: value / widget.controller.steps.length,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOutCubic,
        ));
        _animationController.forward(from: 0);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progressValue =
        widget.controller.currentStep.value / widget.controller.steps.length;

    return SizedBox(
      width: 260.w,
      height: 260.w,
      // decoration: BoxDecoration(
      //   color: colorScheme.surface,
      //   shape: BoxShape.circle,
      //   boxShadow: [
      //     BoxShadow(
      //       color: colorScheme.shadow.withOpacity(0.1),
      //       blurRadius: 30,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),
      child: Stack(
        children: [
          // 底部光效
          Center(
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.7, 1.0],
                ),
              ),
            ),
          ),

          // 进度环
          Center(
            child: SizedBox(
              width: 240.w,
              height: 240.w,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ProgressPainter(
                      progress: _progressAnimation.value,
                      colorScheme: colorScheme,
                    ),
                  );
                },
              ),
            ),
          ),

          // 中心内容
          Center(
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withBlue(
                            (colorScheme.primary.blue * 1.2)
                                .clamp(0, 255)
                                .toInt(),
                          ),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      '${(progressValue * 100).round()}%',
                      style: GoogleFonts.montserrat(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '检测进度',
                    style: GoogleFonts.notoSans(
                      fontSize: 16.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().scale();
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final ColorScheme colorScheme;

  _ProgressPainter({
    required this.progress,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    // 背景圆环
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colorScheme.surfaceVariant.withOpacity(0.1),
          colorScheme.surfaceVariant.withOpacity(0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 8, bgPaint);

    // 进度圆环
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + 2 * pi,
      colors: [
        colorScheme.primary,
        colorScheme.primary.withBlue(
          (colorScheme.primary.blue * 1.2).clamp(0, 255).toInt(),
        ),
      ],
      transform: GradientRotation(startAngle),
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
