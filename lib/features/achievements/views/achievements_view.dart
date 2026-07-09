import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/achievements_controller.dart';

class AchievementsView extends GetView<AchievementsController> {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and subtitle
            Row(
              children: [
                Text('🏆', style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 10.w),
                Text(
                  'Achievements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              '${controller.unlockedCount} of ${controller.totalCount} unlocked',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),

            // Overall Progress card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.015),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.unlockedCount}/${controller.totalCount}',
                        style: TextStyle(
                          color: const Color(0xFF8B5CF6), // Purple
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Progress Bar Track
                  Container(
                    height: 10.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: controller.progressRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8000), Color(0xFFFFC000)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Earned Title
            Row(
              children: [
                Text('✅', style: TextStyle(fontSize: 13.sp)),
                SizedBox(width: 8.w),
                Text(
                  'Earned (${controller.unlockedCount})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // List of Unlocked Achievements
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.unlockedAchievements.length,
              itemBuilder: (context, index) {
                final achievement = controller.unlockedAchievements[index];
                return _buildAchievementCard(achievement);
              },
            ),
            SizedBox(height: 24.h),

            // Locked Title
            Row(
              children: [
                Text('🔒', style: TextStyle(fontSize: 13.sp)),
                SizedBox(width: 8.w),
                Text(
                  'Locked (${controller.totalCount - controller.unlockedCount})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // List of Locked Achievements
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.lockedAchievements.length,
              itemBuilder: (context, index) {
                final achievement = controller.lockedAchievements[index];
                return _buildAchievementCard(achievement);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Opacity(
      opacity: achievement.isUnlocked ? 1.0 : 0.45,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.015),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
          ),
        ),
        child: Row(
          children: [
            // Circular Emoji Background Container
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: achievement.isUnlocked 
                    ? achievement.iconBgColor 
                    : const Color(0xFF1E293B),
              ),
              alignment: Alignment.center,
              child: Text(
                achievement.emoji,
                style: TextStyle(fontSize: 22.sp),
              ),
            ),
            SizedBox(width: 14.w),
            // Text Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Rarity capsule pill
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: achievement.rarityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: achievement.rarityColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      achievement.rarity,
                      style: TextStyle(
                        color: achievement.rarityColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Reward column on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  achievement.xpReward,
                  style: TextStyle(
                    color: achievement.isUnlocked 
                        ? const Color(0xFF8B5CF6) 
                        : Colors.white.withValues(alpha: 0.35),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
