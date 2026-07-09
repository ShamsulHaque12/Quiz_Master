import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RecentPerformanceCard extends StatelessWidget {
  final int totalQuiz;
  final int bestScore;
  final int dayStreak;

  const RecentPerformanceCard({
    super.key,
    required this.totalQuiz,
    required this.bestScore,
    required this.dayStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF161233).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT PERFORMANCE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceStat(
                value: '$totalQuiz',
                label: 'Total Quiz',
                color: const Color(0xFF00D2FF),
              ),
              _buildVerticalDivider(),
              _buildPerformanceStat(
                value: '$bestScore',
                label: 'Best Score',
                color: const Color(0xFFFFD700),
              ),
              _buildVerticalDivider(),
              _buildPerformanceStat(
                value: '$dayStreak',
                label: 'Day Streak',
                color: const Color(0xFFFF8C00),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStat({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40.h,
      width: 1.w,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
