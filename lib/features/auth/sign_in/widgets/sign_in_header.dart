import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo Icon (Gradient Squircle)
        Center(
          child: Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3F3D56)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Icon(
              Icons.psychology_rounded,
              size: 40.r,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Title
        Center(
          child: Text(
            'QuizMaster',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // Subtitle
        Center(
          child: Text(
            'Elevate Your Knowledge, Master the Challenge',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
