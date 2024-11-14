import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPageItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final List<String> features;
  final Color color;

  const OnboardingPageItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.features,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            _buildIcon(),
            SizedBox(height: 40.h),
            _buildTitle(colorScheme),
            SizedBox(height: 40.h),
            _buildFeatures(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...List.generate(3, (index) {
          final size = 160.w - index * 20.w;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1 - index * 0.02),
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                duration: Duration(seconds: 2 + index),
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
              );
        }),
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            iconData,
            size: 48.sp,
            color: color,
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              duration: 2000.ms,
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
            ),
      ],
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutQuad),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 16.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }

  Widget _buildFeatures(ColorScheme colorScheme) {
    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: color,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  feature,
                  style: GoogleFonts.notoSans(
                    fontSize: 16.sp,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 200 + index * 100))
            .slideX(begin: 0.2, curve: Curves.easeOutQuad);
      }).toList(),
    );
  }
}
