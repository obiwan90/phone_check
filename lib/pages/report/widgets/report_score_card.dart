import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../report_controller.dart';

class ReportScoreCard extends StatelessWidget {
  final int score;
  final String level;
  final ReportController controller;

  const ReportScoreCard({
    Key? key,
    required this.score,
    required this.level,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '检测得分',
            style: TextStyle(
              fontSize: 16.sp,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toString(),
                style: GoogleFonts.notoSans(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                  height: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  '分',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 300.ms)
              .scale(delay: 300.ms, duration: 500.ms),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 600.ms)
              .scale(delay: 600.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
