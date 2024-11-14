import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ReportChartSection extends StatelessWidget {
  final Map<String, int> categoryScores;

  const ReportChartSection({
    Key? key,
    required this.categoryScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
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
            '性能分析',
            style: GoogleFonts.notoSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 24.h),
          AspectRatio(
            aspectRatio: 1.3,
            child: _buildRadarChart(context),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildRadarChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categories = categoryScores.keys.toList();
    final scores = categoryScores.values.map((e) => e.toDouble()).toList();

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        radarBorderData: BorderSide(
          color: colorScheme.primary.withOpacity(0.2),
          width: 2,
        ),
        gridBorderData: BorderSide(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
        ticksTextStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.5),
          fontSize: 10.sp,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        titlePositionPercentageOffset: 0.2,
        getTitle: (index, angle) {
          final double rad = angle * (math.pi / 180.0);
          return RadarChartTitle(
            text: categories[index],
            angle: rad,
          );
        },
        dataSets: [
          RadarDataSet(
            fillColor: colorScheme.primary.withOpacity(0.15),
            borderColor: colorScheme.primary,
            borderWidth: 2,
            entryRadius: 5,
            dataEntries:
                scores.map((score) => RadarEntry(value: score)).toList(),
          ),
        ],
        tickCount: 4,
      ),
    );
  }
}
