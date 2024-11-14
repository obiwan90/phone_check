import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'report_controller.dart';
import 'widgets/report_score_card.dart';
import 'widgets/report_details_section.dart';
import 'widgets/report_suggestions_section.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final reportId = Get.arguments as String;
    final report = controller.getReport(reportId);
    final colorScheme = Theme.of(context).colorScheme;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '报告详情',
            style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: Text('未找到报告'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '报告详情',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, report.deviceModel,
                    controller.formatDate(report.createdAt)),
                SizedBox(height: 24.h),
                ReportScoreCard(
                  score: report.score,
                  level: report.scoreLevel,
                  controller: controller,
                ).animate().fadeIn().slideY(begin: 0.2),
                SizedBox(height: 24.h),
                ReportDetailsSection(
                  categoryScores: report.categoryScores,
                  results: report.checkResults,
                  controller: controller,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                SizedBox(height: 24.h),
                ReportSuggestionsSection(
                  suggestions: report.suggestions,
                  controller: controller,
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String deviceModel, String date) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deviceModel,
          style: GoogleFonts.notoSans(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          date,
          style: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2);
  }
}
