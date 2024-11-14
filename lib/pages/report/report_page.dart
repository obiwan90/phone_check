import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'report_controller.dart';
import 'widgets/report_details_section.dart';
import 'widgets/report_suggestions_section.dart';

class ReportPage extends GetView<ReportController> {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '检测报告',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Get.toNamed('/history'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() => Column(
                  children: [
                    ReportDetailsSection(
                      categoryScores: Map<String, int>.from({
                        '系统性能': 85,
                        '硬件状态': 90,
                        '内存使用': 75,
                        '电池状态': 95,
                        '存储空间': 80,
                      }),
                      results: controller.checkResults,
                      controller: controller,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    SizedBox(height: 32.h),
                    ReportSuggestionsSection(
                      suggestions: controller.getOptimizationSuggestions(),
                      controller: controller,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    SizedBox(height: 32.h),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
