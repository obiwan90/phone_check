import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '向上滑动',
            style: GoogleFonts.notoSans(
              fontSize: 14.sp,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Icon(
            Icons.keyboard_arrow_up,
            color: colorScheme.primary,
            size: 24.sp,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .moveY(begin: 0, end: -10, duration: 1000.ms)
              .then()
              .moveY(begin: -10, end: 0, duration: 1000.ms),
        ],
      ),
    );
  }
}
