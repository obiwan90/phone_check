import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../home_controller.dart';

class StatusSection extends StatelessWidget {
  final HomeController controller;

  const StatusSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: _buildBatteryCard(context),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3);
  }

  Widget _buildBatteryCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.8),
            colorScheme.primaryContainer.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背景装饰
          Positioned(
            right: -30.w,
            top: -30.w,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.1),
                    colorScheme.primary.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // 内容
          Row(
            children: [
              _buildBatteryIcon(context),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '电池电量',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.getBatteryLevel(),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final batteryLevel = int.tryParse(
          controller.getBatteryLevel().replaceAll('%', ''),
        ) ??
        100;

    return Container(
      width: 64.w,
      height: 64.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Icon(
            batteryLevel <= 20
                ? Icons.battery_0_bar_rounded
                : batteryLevel <= 50
                    ? Icons.battery_4_bar_rounded
                    : Icons.battery_full_rounded,
            color: colorScheme.primary,
            size: 32.sp,
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                duration: const Duration(seconds: 2),
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
              ),
          if (batteryLevel <= 20)
            Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.warning_rounded,
                  color: colorScheme.error,
                  size: 16.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
