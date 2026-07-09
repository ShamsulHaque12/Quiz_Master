import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/podium_item.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          
          // Header with Trophy Icon
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: const Color(0xFFFFD700),
                size: 28.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Compete with players worldwide',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.h),

          // Podium Layout (Top 3 Users)
          Obx(() {
            if (controller.podium.length < 3) {
              return const SizedBox.shrink();
            }
            final second = controller.podium[0];
            final first = controller.podium[1];
            final third = controller.podium[2];
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place
                PodiumItem(
                  name: second.name,
                  xp: second.todayXp,
                  rank: second.rank,
                  avatar: second.avatar,
                  badgeColor: const Color(0xFFBDC3C7), // Silver
                ),
                // 1st Place (Tallest, center)
                PodiumItem(
                  name: first.name,
                  xp: first.todayXp,
                  rank: first.rank,
                  avatar: first.avatar,
                  badgeColor: const Color(0xFFFFD700), // Gold
                  isWinner: true,
                ),
                // 3rd Place
                PodiumItem(
                  name: third.name,
                  xp: third.todayXp,
                  rank: third.rank,
                  avatar: third.avatar,
                  badgeColor: const Color(0xFFE5A93C), // Bronze
                ),
              ],
            );
          }),
          SizedBox(height: 20.h),

          // Timeframe Filter Pill Selector
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: const Color(0xFF161233).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Obx(() {
              return Row(
                children: controller.timeframes.map((timeframe) {
                  final isSelected = controller.selectedTimeframe.value == timeframe;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTimeframe(timeframe),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timeframe,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          SizedBox(height: 16.h),

          // Remaining Leaderboard List
          Expanded(
            child: Obx(() {
              final list = controller.leaderboard;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final user = list[index];
                  final isTop3 = index < 3;
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: user.isCurrentUser
                            ? const Color(0xFF6C63FF).withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.015),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: user.isCurrentUser
                              ? const Color(0xFF6C63FF).withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.03),
                          width: user.isCurrentUser ? 1.5 : 1,
                        ),
                        boxShadow: user.isCurrentUser
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                                  blurRadius: 12.r,
                                  spreadRadius: 1.r,
                                )
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Rank Index / Badge
                          SizedBox(
                            width: 28.w,
                            child: Text(
                              user.rank,
                              style: TextStyle(
                                color: isTop3
                                    ? (index == 0
                                        ? const Color(0xFFFFD700)
                                        : index == 1
                                            ? const Color(0xFFBDC3C7)
                                            : const Color(0xFFE5A93C))
                                    : Colors.white.withValues(alpha: 0.35),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          // Avatar
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isTop3
                                    ? (index == 0
                                        ? const Color(0xFFFFD700)
                                        : index == 1
                                            ? const Color(0xFFBDC3C7)
                                            : const Color(0xFFE5A93C))
                                    : Colors.transparent,
                                width: isTop3 ? 1.5 : 0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                user.avatar,
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          
                          // Name & Career XP
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  user.totalXp,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Period XP Points
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (index == 0) ...[
                                Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFFFFD700),
                                  size: 14.r,
                                ),
                                SizedBox(width: 4.w),
                              ],
                              Text(
                                user.todayXp,
                                style: TextStyle(
                                  color: user.isCurrentUser
                                      ? const Color(0xFF9089FF)
                                      : const Color(0xFFFFD700),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
