import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'check_controller.dart';
import 'widgets/check_progress_circle.dart';
import 'widgets/check_list_view.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GetBuilder<CheckController>(
        init: CheckController(),
        builder: (controller) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withBlue(
                  (colorScheme.surface.blue * 1.05).clamp(0, 255).toInt(),
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, controller),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // 进度圈部分
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CheckProgressCircle(controller: controller),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // 检测列表部分
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32.r),
                              topRight: Radius.circular(32.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32.r),
                              topRight: Radius.circular(32.r),
                            ),
                            child: CheckListView(controller: controller),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CheckController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildBackButton(context),
          ),
          Text(
            '设备检测',
            style: GoogleFonts.notoSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => controller.isChecking.value
                  ? _buildPauseButton(context, controller)
                  : _buildResumeButton(context, controller),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => Get.back(),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Symbols.arrow_back_ios_new_rounded,
          color: colorScheme.primary,
          size: 24.sp,
          weight: 300,
        ),
      ),
    );
  }

  Widget _buildPauseButton(BuildContext context, CheckController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: controller.pauseCheck,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Symbols.pause_rounded,
          color: colorScheme.primary,
          size: 24.sp,
          weight: 300,
        ),
      ),
    );
  }

  Widget _buildResumeButton(BuildContext context, CheckController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: controller.resumeCheck,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Symbols.play_arrow_rounded,
          color: colorScheme.primary,
          size: 24.sp,
          weight: 300,
        ),
      ),
    );
  }
}
