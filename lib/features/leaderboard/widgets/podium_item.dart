import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class PodiumItem extends StatelessWidget {
  final String name;
  final String xp;
  final String rank;
  final String avatar;
  final Color badgeColor;
  final bool isWinner;

  const PodiumItem({
    super.key,
    required this.name,
    required this.xp,
    required this.rank,
    required this.avatar,
    required this.badgeColor,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Trophy/Crown Icon for #1
        if (isWinner)
          Icon(
            Icons.emoji_events_rounded,
            color: const Color(0xFFFFD700), // Gold
            size: 26.r,
          )
        else
          SizedBox(height: 26.h),
        SizedBox(height: 6.h),

        // Avatar circle
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: isWinner ? 76.r : 62.r,
              height: isWinner ? 76.r : 62.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(
                  color: badgeColor,
                  width: isWinner ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.25),
                    blurRadius: isWinner ? 20.r : 12.r,
                    spreadRadius: 1.r,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: TextStyle(fontSize: isWinner ? 36.sp : 28.sp),
                ),
              ),
            ),
            // Floating Rank Badge
            Positioned(
              bottom: -4.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Name
        SizedBox(
          width: 85.w,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 2.h),

        // XP Points
        Text(
          '$xp XP',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),

        // The Podium Block Column
        Container(
          width: isWinner ? 75.w : 64.w,
          height: rank == '1'
              ? 95.h
              : rank == '2'
                  ? 72.h
                  : 58.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: rank == '1'
                  ? [const Color(0xFFFFD700), const Color(0xFFFFA500)] // Gold
                  : rank == '2'
                      ? [const Color(0xFFBDC3C7), const Color(0xFF95A5A6)] // Silver
                      : [const Color(0xFFE5A93C), const Color(0xFF965F00)], // Bronze/Orange
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10.r,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            rank,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: rank == '1' ? 28.sp : 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
