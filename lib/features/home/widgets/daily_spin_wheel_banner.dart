import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class DailySpinWheelBanner extends StatelessWidget {
  const DailySpinWheelBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DAILY_SPIN),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE65C00), Color(0xFFF9D423)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE65C00).withValues(alpha: 0.25),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          children: [
            // Wheel Emoji
            Text(
              '🎡',
              style: TextStyle(fontSize: 36.sp),
            ),
            SizedBox(width: 14.w),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Spin Wheel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Win XP, coins and bonus multipliers!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Giftbox circular button
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              child: Icon(
                Icons.card_giftcard_rounded,
                color: Colors.white,
                size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
