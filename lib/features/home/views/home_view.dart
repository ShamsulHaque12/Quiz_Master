import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../auth/sign_in/controllers/sign_in_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';
import '../../quiz/widgets/category_card.dart';
import '../widgets/home_header.dart';
import '../widgets/level_progress_card.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/top_players_list.dart';
import '../widgets/daily_spin_wheel_banner.dart';
import '../widgets/recent_performance_card.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String _getUserName() {
    if (Get.isRegistered<SignUpController>()) {
      final name = Get.find<SignUpController>().fullNameController.text.trim();
      if (name.isNotEmpty) return name;
    }
    if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) {
        return email.split('@').first;
      }
    }
    return 'Rafiq Islam';
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final displayName = (userName.isEmpty) ? 'Rafiq Islam' : userName;
    final dashboardController = Get.find<DashboardController>();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        // User Greeting Header Row
        Obx(() => HomeHeader(
              displayName: displayName,
              streakCount: controller.streakCount.value,
              coinCount: controller.coinCount.value,
            )),
        SizedBox(height: 20.h),

        // Gamification Level Progress Card
        Obx(() => LevelProgressCard(
              userLevel: controller.userLevel.value,
              totalXP: controller.totalXP.value,
              currentXP: controller.currentXP.value,
              nextLevelXP: controller.nextLevelXP.value,
              progress: controller.levelProgress,
            )),
        SizedBox(height: 24.h),

        // Daily Challenge Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Daily Challenge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
              ),
              child: Text(
                '2x XP',
                style: TextStyle(
                  color: const Color(0xFFFFD700),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Programming Fundamentals Card
        DailyChallengeCard(
          onTap: () => Get.toNamed(Routes.QUIZ),
        ),
        SizedBox(height: 24.h),

        // Categories Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => dashboardController.changeTabIndex(1),
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: const Color(0xFF6C63FF),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF6C63FF),
                    size: 10.r,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // 2x2 Grid of Category Cards
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.85,
          children: [
            CategoryCard(
              name: 'Programming',
              icon: Text('💻', style: TextStyle(fontSize: 26.sp)),
              gradient: const LinearGradient(
                colors: [Color(0xFF0091FF), Color(0xFF00D2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            CategoryCard(
              name: 'General Knowledge',
              icon: Text('🌍', style: TextStyle(fontSize: 26.sp)),
              gradient: const LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            CategoryCard(
              name: 'Science',
              icon: Text('🔬', style: TextStyle(fontSize: 26.sp)),
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            CategoryCard(
              name: 'Math',
              icon: Text('📐', style: TextStyle(fontSize: 26.sp)),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8000), Color(0xFFFF9E00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Top Players Today Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Top Players Today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => dashboardController.changeTabIndex(2),
              child: Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                      color: const Color(0xFF6C63FF),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF6C63FF),
                    size: 10.r,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Top Players List Card
        Obx(() => TopPlayersList(
              players: controller.topPlayers.toList(),
            )),
        SizedBox(height: 24.h),

        // Daily Spin Wheel Banner
        const DailySpinWheelBanner(),
        SizedBox(height: 24.h),

        // RECENT PERFORMANCE Card
        Obx(() => RecentPerformanceCard(
              totalQuiz: controller.recentTotalQuiz.value,
              bestScore: controller.recentBestScore.value,
              dayStreak: controller.recentDayStreak.value,
            )),
      ],
    );
  }
}
