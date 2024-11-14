import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReportItemsSection extends StatelessWidget {
  final Map<String, dynamic> results;

  const ReportItemsSection({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successResults =
        results.entries.where((e) => e.value['status'] == 'good').toList();
    final failedResults =
        results.entries.where((e) => e.value['status'] != 'good').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '检测项目',
          style: GoogleFonts.notoSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        if (failedResults.isNotEmpty) ...[
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.error_rounded,
                      size: 18.sp,
                      color: colorScheme.error,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '异常项',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${failedResults.length}项)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...failedResults
              .map((entry) => _buildDetailItem(context, entry, isError: true)),
          SizedBox(height: 24.h),
        ],
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.check_circle_rounded,
                    size: 18.sp,
                    color: Colors.green,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '正常项',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '(${successResults.length}项)',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...successResults.map((entry) => _buildDetailItem(context, entry)),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    MapEntry<String, dynamic> entry, {
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = entry.value['status'] as String;
    final info = entry.value['info'] as String;
    final statusColor = _getStatusColor(status, colorScheme);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:
            isError ? colorScheme.error.withOpacity(0.05) : colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isError
              ? colorScheme.error.withOpacity(0.1)
              : colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _getStatusIcon(status),
                        size: 20.sp,
                        color: statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'good':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return colorScheme.error;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'good':
        return Symbols.check_circle_rounded;
      case 'warning':
        return Symbols.warning_rounded;
      case 'error':
        return Symbols.error_rounded;
      default:
        return Symbols.info_rounded;
    }
  }
}
