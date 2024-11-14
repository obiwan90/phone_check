import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'report_controller.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = Get.find<ReportController>();

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Symbols.history_rounded,
              size: 24.sp,
              weight: 500,
            ),
            SizedBox(width: 8.w),
            Text(
              '检测历史',
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Symbols.delete_outline_rounded,
              weight: 500,
            ),
            onPressed: controller.showDeleteAllConfirmDialog,
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.hasReports()) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.history_rounded,
                    size: 48.sp,
                    color: colorScheme.primary,
                    weight: 500,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  '暂无检测历史',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '完成设备检测后，报告将显示在这里',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale();
        }

        // 按日期分组
        final groupedReports = <String, List<dynamic>>{};
        for (var report in controller.reports) {
          final date = DateFormat('yyyy年MM月dd日').format(report.createdAt);
          groupedReports.putIfAbsent(date, () => []).add(report);
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: groupedReports.length,
          itemBuilder: (context, groupIndex) {
            final date = groupedReports.keys.elementAt(groupIndex);
            final reports = groupedReports[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                  child: Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${reports.length}条记录',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...reports.asMap().entries.map((entry) {
                  final index = entry.key;
                  final report = entry.value;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
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
                      child: InkWell(
                        onTap: () =>
                            Get.toNamed('/report/detail', arguments: report.id),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getScoreColor(
                                                    report.score, colorScheme)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getScoreIcon(report.score),
                                                size: 16.sp,
                                                color: _getScoreColor(
                                                    report.score, colorScheme),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                report.scoreLevel,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: _getScoreColor(
                                                      report.score,
                                                      colorScheme),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Symbols.phone_iphone_rounded,
                                              size: 16.sp,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                report.deviceModel,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${report.score}分',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          color: _getScoreColor(
                                              report.score, colorScheme),
                                        ),
                                      ),
                                      Text(
                                        controller
                                            .getReportTimeAgo(report.createdAt),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceVariant
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Symbols.schedule_rounded,
                                          size: 16.sp,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(report.createdAt),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(32.w, 32.w),
                                      ),
                                      icon: Icon(
                                        Symbols.delete_outline_rounded,
                                        size: 20.sp,
                                        color: colorScheme.error,
                                        weight: 500,
                                      ),
                                      onPressed: () => controller
                                          .showDeleteConfirmDialog(report.id),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: index * 100),
                      )
                      .slideX(begin: 0.1);
                }).toList(),
              ],
            );
          },
        );
      }),
    );
  }

  Color _getScoreColor(int score, ColorScheme colorScheme) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 90) return Symbols.check_circle_rounded;
    if (score >= 80) return Symbols.thumb_up_rounded;
    if (score >= 70) return Symbols.warning_rounded;
    return Symbols.error_rounded;
  }
}
