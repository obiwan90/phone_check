import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:get/get.dart';
import '../check_controller.dart';

class CheckListView extends GetView<CheckController> {
  const CheckListView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CheckController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            itemCount: controller.steps.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => _buildCheckItem(context, index),
          ),
        ),
        // 检测结果显示
        Obx(() {
          if (controller.showResult.value) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(20.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.getSuccessCount() == controller.steps.length
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    controller.getSuccessCount() == controller.steps.length
                        ? '检测完成'
                        : '发现${controller.steps.length - controller.getSuccessCount()}项异常',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '正在生成检测报告...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(
                  begin: 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildCheckItem(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final isCompleted = index < controller.currentStep.value;
      final isCurrent = index == controller.currentStep.value;
      final isSuccess = isCompleted ? controller.isStepSuccess(index) : true;

      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: () {}, // 为未来可能的交互预留
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // 图标部分
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStepIcon(index),
                      color: isCurrent
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 28.sp,
                      fill: 1,
                      grade: 0,
                      opticalSize: 48,
                      weight: 500,
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // 文字部分
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.steps[index],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          isCurrent
                              ? controller.getStepDescription(index)
                              : isCompleted
                                  ? isSuccess
                                      ? '检测完成'
                                      : '检测异常'
                                  : controller.getStepDetails(index),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: !isSuccess && isCompleted
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // 状态指示器
                  SizedBox(width: 16.w),
                  if (isCompleted)
                    Icon(
                      isSuccess
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color:
                          isSuccess ? colorScheme.primary : colorScheme.error,
                      size: 24.sp,
                    )
                  else if (isCurrent)
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: index * 100));
    });
  }

  IconData _getStepIcon(int index) {
    switch (index) {
      case 0:
        return Icons.remove_red_eye_rounded;
      case 1:
        return Icons.camera_alt_rounded;
      case 2:
        return Icons.volume_up_rounded;
      case 3:
        return Icons.sensors_rounded;
      case 4:
        return Icons.battery_6_bar_rounded;
      case 5:
        return Icons.network_check_rounded;
      case 6:
        return Icons.storage_rounded;
      case 7:
        return Icons.location_on_rounded;
      case 8:
        return Icons.wifi_rounded;
      case 9:
        return Icons.bluetooth_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
