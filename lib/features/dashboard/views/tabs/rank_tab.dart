import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class RankTab extends StatelessWidget {
  const RankTab({super.key});

  final List<Map<String, dynamic>> leaderboard = const [
    {'rank': '4', 'name': 'Adnan Sami', 'xp': '2,430 XP', 'avatar': '🚀'},
    {'rank': '5', 'name': 'Nabila Islam', 'xp': '2,150 XP', 'avatar': '🎓'},
    {'rank': '6', 'name': 'Imran Khan', 'xp': '1,980 XP', 'avatar': '🤖'},
    {'rank': '7', 'name': 'Sadia Afrin', 'xp': '1,820 XP', 'avatar': '🌟'},
    {'rank': '8', 'name': 'Tanvir Ahmed', 'xp': '1,710 XP', 'avatar': '👾'},
    {'rank': '9', 'name': 'Fahim Shahriar', 'xp': '1,650 XP', 'avatar': '🦊'},
    {'rank': '10', 'name': 'Farhana Yeasmin', 'xp': '1,590 XP', 'avatar': '🔥'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            'Leaderboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          // Podium Layout (Top 3 Users)
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.01),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place
                _buildPodiumItem(
                  name: 'Kazi Rayhan',
                  xp: '2,650 XP',
                  rank: '2',
                  avatar: '💻',
                  badgeColor: const Color(0xFFC0C0C0), // Silver
                ),
                // 1st Place (Tallest, center)
                _buildPodiumItem(
                  name: 'Shamsul Haque',
                  xp: '3,120 XP',
                  rank: '1',
                  avatar: '🧠',
                  badgeColor: const Color(0xFFFFD700), // Gold
                  isWinner: true,
                ),
                // 3rd Place
                _buildPodiumItem(
                  name: 'Tasnim Ritu',
                  xp: '2,510 XP',
                  rank: '3',
                  avatar: '🎨',
                  badgeColor: const Color(0xFFCD7F32), // Bronze
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Remaining Leaderboard List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 16.h),
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final user = leaderboard[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.015),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Rank Index
                        SizedBox(
                          width: 24.w,
                          child: Text(
                            user['rank'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Avatar
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user['avatar'],
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Name
                        Expanded(
                          child: Text(
                            user['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // XP Points
                        Text(
                          user['xp'],
                          style: TextStyle(
                            color: const Color(0xFF6C63FF),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required String name,
    required String xp,
    required String rank,
    required String avatar,
    required Color badgeColor,
    bool isWinner = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isWinner)
          Icon(
            Icons.workspace_premium_rounded,
            color: badgeColor,
            size: 24.r,
          )
        else
          SizedBox(height: 12.h), // Equal spacing for alignment
        SizedBox(height: 4.h),
        // Avatar circle
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: isWinner ? 72.r : 58.r,
              height: isWinner ? 72.r : 58.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: badgeColor,
                  width: isWinner ? 2.5 : 1.5,
                ),
                boxShadow: isWinner
                    ? [
                        BoxShadow(
                          color: badgeColor.withValues(alpha: 0.15),
                          blurRadius: 16.r,
                          spreadRadius: 2.r,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: TextStyle(fontSize: isWinner ? 32.sp : 24.sp),
                ),
              ),
            ),
            Positioned(
              bottom: -4.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
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
        SizedBox(height: 12.h),
        // Name
        SizedBox(
          width: 80.w,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 2.h),
        // XP Points
        Text(
          xp,
          style: TextStyle(
            color: badgeColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
