import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../home_controller.dart';

class StartCheckButton extends StatelessWidget {
  final HomeController controller;

  const StartCheckButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withBlue(
              (colorScheme.primary.blue * 1.2).clamp(0, 255).toInt(),
            ),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 装饰性波纹效果
          Positioned(
            left: -20.w,
            top: -20.w,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -30.w,
            bottom: -30.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // 按钮内容
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.startCheck,
              borderRadius: BorderRadius.circular(32.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: colorScheme.onPrimary,
                        size: 24.sp,
                      ),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          duration: const Duration(seconds: 2),
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.1, 1.1),
                        ),
                    SizedBox(width: 16.w),
                    Text(
                      '开始检测',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .shimmer(
                          duration: const Duration(seconds: 3),
                          color: Colors.white.withOpacity(0.3),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.3, duration: 800.ms, curve: Curves.easeOutQuart)
        .fadeIn(duration: 600.ms)
        .then()
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          duration: const Duration(seconds: 3),
          begin: const Offset(0.98, 0.98),
          end: const Offset(1.02, 1.02),
        );
  }
}
