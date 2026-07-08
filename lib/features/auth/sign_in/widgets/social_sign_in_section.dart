import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SocialSignInSection extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onGuestTap;
  final bool isLoading;

  const SocialSignInSection({
    super.key,
    required this.onGoogleTap,
    required this.onGuestTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Google Sign-In Button
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onGoogleTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                        child: Text(
                          'G',
                          style: TextStyle(
                            color: const Color(0xFF4285F4),
                            fontWeight: FontWeight.w900,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Play as Guest Button
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onGuestTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Center(
                child: Text(
                  'Play as Guest',
                  style: TextStyle(
                    color: const Color(0xFF9C96FF),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
