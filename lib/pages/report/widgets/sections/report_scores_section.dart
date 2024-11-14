import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class ReportScoresSection extends StatelessWidget {
  final Map<String, int> categoryScores;

  const ReportScoresSection({
    Key? key,
    required this.categoryScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: categoryScores.entries.map((entry) {
        final score = entry.value;
        return _buildScoreCard(context, entry.key, score);
      }).toList(),
    );
  }

  Widget _buildScoreCard(BuildContext context, String category, int score) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _getScoreColor(score);

    return Container(
      width: (1.sw - 40.w - 12.w) / 2,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                score.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                ' 分',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}
