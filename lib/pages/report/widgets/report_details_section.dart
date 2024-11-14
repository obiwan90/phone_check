import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../report_controller.dart';
import 'sections/report_header_section.dart';
import 'sections/report_scores_section.dart';
import 'sections/report_chart_section.dart';
import 'sections/report_items_section.dart';

class ReportDetailsSection extends StatelessWidget {
  final Map<String, int> categoryScores;
  final Map<String, dynamic> results;
  final ReportController controller;

  const ReportDetailsSection({
    Key? key,
    required this.categoryScores,
    required this.results,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReportHeaderSection(
          categoryScores: categoryScores,
        ),
        SizedBox(height: 24.h),
        ReportScoresSection(
          categoryScores: categoryScores,
        ),
        SizedBox(height: 24.h),
        ReportChartSection(
          categoryScores: categoryScores,
        ),
        SizedBox(height: 24.h),
        ReportItemsSection(
          results: results,
        ),
      ],
    );
  }
}
