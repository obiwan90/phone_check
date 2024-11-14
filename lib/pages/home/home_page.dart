import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/theme_controller.dart';
import 'home_controller.dart';
import 'widgets/tech_background.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            themeController.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness:
            themeController.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            const TechBackground(),
            SafeArea(
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          _buildHeader(context, themeController),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildDeviceInfo(context),
                                  SizedBox(height: 40.h),
                                  _buildBatteryStatus(context),
                                  SizedBox(height: 80.h),
                                  _buildStartButton(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeController themeController) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildIconButton(
            context,
            icon: Symbols.bar_chart_4_bars_rounded,
            onTap: () => Get.toNamed('/history'),
          ),
          SizedBox(width: 12.w),
          Obx(
            () => _buildIconButton(
              context,
              icon: themeController.isDarkMode
                  ? Symbols.light_mode_rounded
                  : Symbols.nightlight_rounded,
              onTap: themeController.toggleTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 24.sp,
              weight: 400,
              grade: 0,
              opticalSize: 24,
              fill: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // 光环效果
            ...List.generate(
              3,
              (index) => Container(
                width: (120 + index * 40).w,
                height: (120 + index * 40).w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.1 - index * 0.03),
                    width: 1,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    duration: Duration(seconds: 2 + index),
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.05, 1.05),
                  ),
            ),
            // 品牌图标
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: GetPlatform.isIOS
                    ? FaIcon(
                        FontAwesomeIcons.apple,
                        size: 64.sp,
                        color: colorScheme.primary,
                      )
                    : FaIcon(
                        FontAwesomeIcons.android,
                        size: 64.sp,
                        color: colorScheme.primary,
                      ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        Text(
          controller.getDeviceModel(),
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          controller.getTotalStorage(),
          style: TextStyle(
            fontSize: 16.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildBatteryStatus(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final batteryLevel = int.tryParse(
          controller.getBatteryLevel().replaceAll('%', ''),
        ) ??
        0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          batteryLevel <= 20
              ? Symbols.battery_alert_rounded
              : batteryLevel <= 50
                  ? Symbols.battery_4_bar_rounded
                  : Symbols.battery_full_rounded,
          color: colorScheme.primary,
          size: 32.sp,
          weight: 400,
          grade: 0,
          opticalSize: 40,
          fill: 1,
        ),
        SizedBox(width: 12.w),
        Text(
          controller.getBatteryLevel(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildStartButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 200.w,
      height: 200.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.startCheck,
          borderRadius: BorderRadius.circular(100.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.play_arrow_rounded,
                color: colorScheme.onPrimary,
                size: 48.sp,
                weight: 400,
                grade: 0,
                opticalSize: 48,
                fill: 1,
              ),
              SizedBox(height: 8.h),
              Text(
                '开始检测',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8))
        .then()
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          duration: const Duration(seconds: 2),
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
        );
  }
}
