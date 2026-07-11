import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/settings_tile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          // Profile Details Header Card
          Column(
            children: [
              // Avatar
              Obx(() {
                final userImage = controller.profileImage.value;
                final url = controller.avatarUrl.value;
                return Container(
                  width: 84.r,
                  height: 84.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0072FF).withValues(alpha: 0.3),
                        blurRadius: 18.r,
                        spreadRadius: 1.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: userImage != null
                        ? Image.file(userImage, fit: BoxFit.cover)
                        : (url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Text(
                                          '😊',
                                          style: TextStyle(fontSize: 42.sp),
                                        ),
                                      ),
                                )
                              : Center(
                                  child: Text(
                                    '😊',
                                    style: TextStyle(fontSize: 42.sp),
                                  ),
                                )),
                  ),
                );
              }),
              SizedBox(height: 16.h),

              // Username & Email
              Obx(
                () => Text(
                  controller.displayName.value.isNotEmpty
                      ? controller.displayName.value
                      : 'No Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.email.value.isNotEmpty
                      ? controller.email.value
                      : 'xyz@example.com',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 16.h),

              // Level & Streak Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Level Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B3D).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('👑', style: TextStyle(fontSize: 12.sp)),
                        SizedBox(width: 6.w),
                        Obx(
                          () => Text(
                            controller.xpLevelName,
                            style: TextStyle(
                              color: const Color(0xFFFFD700),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Streak Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B3D).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFFF9F0A).withValues(alpha: 0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🔥', style: TextStyle(fontSize: 12.sp)),
                        SizedBox(width: 6.w),
                        Obx(
                          () => Text(
                            '${controller.streakCount.value} day streak',
                            style: TextStyle(
                              color: const Color(0xFFFF9F0A),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Experience Progress Card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('⚡', style: TextStyle(fontSize: 14.sp)),
                        SizedBox(width: 6.w),
                        Obx(
                          () => Text(
                            controller.xpLevelName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Text(
                        'Total: ${controller.currentXP.value} XP',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Glowing custom progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Obx(() {
                      final ratio = controller.xpLevelProgress;
                      return Container(
                        width: double.infinity,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: constraints.maxWidth * ratio,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0072FF), Color(0xFF00D2FF)],
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00D2FF,
                                ).withValues(alpha: 0.3),
                                blurRadius: 6.r,
                                spreadRadius: 1.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 8.h),

                Obx(() {
                  final remaining = controller.xpRemainingToNextLevel;
                  final nextLevel = controller.nextLevelName;
                  if (nextLevel.isEmpty) {
                    return Text(
                      'Max level reached (Enterprise / Professional)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return Text(
                    '$remaining XP until $nextLevel',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // User Stats Row (3 Columns)
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => ProfileStatCard(
                    icon: Text('🎯', style: TextStyle(fontSize: 22.sp)),
                    title: 'Total Quiz',
                    value: '${controller.totalQuiz.value}',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => ProfileStatCard(
                    icon: Text('🏆', style: TextStyle(fontSize: 22.sp)),
                    title: 'Best Score',
                    value: '${controller.bestScore.value}',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => ProfileStatCard(
                    icon: Text('🪙', style: TextStyle(fontSize: 22.sp)),
                    title: 'Coins',
                    value: '${controller.coinCount.value}',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Badges Earned Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Badges Earned',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                Obx(() {
                  // Explicitly register dependencies on reactive variables
                  // so GetX can track updates in this lazy GridView builder
                  controller.coinCount.value;
                  controller.currentXP.value;
                  controller.userLevel.value;
                  controller.totalScore.value;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.badges.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 14.w,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final badge = controller.badges[index];
                      final isLocked = !badge.isUnlocked(controller);
                      return _buildBadgeItem(
                        badge.imagePath,
                        isLocked: isLocked,
                        tooltip: '${badge.title}\n(${badge.description})\n${isLocked ? "Locked 🔒" : "Unlocked! 🎉"}',
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Unified Settings Menu Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.015),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
            ),
            child: Column(
              children: [
                SettingsTile(
                  icon: Text('🏆', style: TextStyle(fontSize: 16.sp)),
                  title: 'Achievements',
                  onTap: () => Get.toNamed(Routes.ACHIEVEMENTS),
                ),
                SettingsTile(
                  icon: Text('🎡', style: TextStyle(fontSize: 16.sp)),
                  title: 'Daily Spin Wheel',
                  onTap: () => Get.toNamed(Routes.DAILY_SPIN),
                ),
                SettingsTile(
                  icon: Text('📊', style: TextStyle(fontSize: 16.sp)),
                  title: 'Statistics',
                  onTap: () => Get.toNamed(Routes.STATISTICS),
                ),
                SettingsTile(
                  icon: Text('⚙️', style: TextStyle(fontSize: 16.sp)),
                  title: 'Settings',
                  showDivider: false,
                  onTap: () {
                    Get.toNamed(Routes.SETTINGS);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: controller.handleLogout,
              icon: Icon(
                Icons.logout_rounded,
                color: const Color(0xFFFF4B5C),
                size: 18.r,
              ),
              label: Text(
                'Log Out',
                style: TextStyle(
                  color: const Color(0xFFFF4B5C),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: const Color(0xFFFF4B5C).withValues(alpha: 0.3),
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String imagePath, {required bool isLocked, required String tooltip}) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: const Color(0xFF161233),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        width: 52.r,
        height: 52.r,
        decoration: BoxDecoration(
          color: isLocked
              ? Colors.white.withValues(alpha: 0.02)
              : const Color(0xFF1D1B3D).withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: isLocked
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFF00D2FF).withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: isLocked
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF00D2FF).withValues(alpha: 0.15),
                    blurRadius: 8.r,
                    spreadRadius: 1.r,
                  ),
                ],
        ),
        padding: EdgeInsets.all(8.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLocked ? 0.25 : 1.0,
              child: ColorFiltered(
                colorFilter: isLocked
                    ? const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0,      0,      0,      1.0, 0,
                      ])
                    : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.dst,
                      ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (isLocked)
              Icon(
                Icons.lock_rounded,
                color: Colors.white.withValues(alpha: 0.65),
                size: 16.r,
              ),
          ],
        ),
      ),
    );
  }
}
