import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DailyChallengeCard extends StatelessWidget {
  final VoidCallback onTap;

  const DailyChallengeCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A00E0).withValues(alpha: 0.3),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side column
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pill badges
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'TODAY',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded,
                              color: const Color(0xFFFF8C00),
                              size: 12.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Streak Bonus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Title
                  Text(
                    'Programming\nFundamentals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Stats row
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.track_changes_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '10 Questions',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '~5 min',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Right side column (Laptop and arrow button)
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 140.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Laptop icon/illustration
                    Container(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.laptop_chromebook_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 68.r,
                      ),
                    ),
                    // Circular arrow button
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
