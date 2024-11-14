import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'onboarding_controller.dart';
import 'widgets/onboarding_page_item.dart';
import 'widgets/scroll_indicator.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(colorScheme),
          PageView(
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              controller.updatePage(index);
              if (index == 2) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.offAllNamed('/home');
                });
              }
            },
            children: [
              Stack(
                children: [
                  OnboardingPageItem(
                    title: '智能检测',
                    subtitle: '全方位检测您的手机性能',
                    iconData: Icons.psychology_outlined,
                    features: const ['硬件状态', '软件性能', '系统安全'],
                    color: colorScheme.primary,
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ScrollIndicator(),
                  ),
                ],
              ),
              Stack(
                children: [
                  OnboardingPageItem(
                    title: '专业诊断',
                    subtitle: '深入分析手机各项指标',
                    iconData: Icons.biotech_outlined,
                    features: const ['智能分析', '精准评分', '优化建议'],
                    color: colorScheme.secondary,
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ScrollIndicator(),
                  ),
                ],
              ),
              OnboardingPageItem(
                title: '开始体验',
                subtitle: '让我们开始检测之旅',
                iconData: Icons.rocket_launch_outlined,
                features: const ['一键检测', '实时反馈', '详细报告'],
                color: colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ColorScheme colorScheme) {
    return Stack(
      children: List.generate(
        4,
        (index) => Positioned(
          top: -100 + index * 200.0,
          right: -100 + math.sin(index * math.pi / 2) * 200,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.05),
                  colorScheme.primary.withOpacity(0),
                ],
              ),
              shape: BoxShape.circle,
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                duration: Duration(seconds: 3 + index),
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
              ),
        ),
      ),
    );
  }
}
