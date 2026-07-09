import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TopPlayersList extends StatelessWidget {
  final List<dynamic> players;

  const TopPlayersList({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1.5,
        ),
      ),
      child: Column(
        children: List.generate(players.length, (index) {
          final player = players[index];
          final isLast = index == players.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    // Custom Ribbon Badge
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: 14.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D2FF),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.r)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 18.r,
                            height: 18.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: player['color'] as Color,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Center(
                              child: Text(
                                player['rank'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    // Avatar Emoji
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          player['avatar'].toString(),
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Name & general XP
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player['name'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            player['totalXp'].toString(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Today's XP score
                    Text(
                      player['todayXp'].toString(),
                      style: TextStyle(
                        color: const Color(0xFF7B61FF),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  color: Colors.white.withValues(alpha: 0.05),
                  height: 1,
                  thickness: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
            ],
          );
        }),
      ),
    );
  }
}
