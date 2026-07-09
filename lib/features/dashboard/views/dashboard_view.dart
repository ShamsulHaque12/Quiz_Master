import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/views/home_view.dart';
import '../../quiz/views/quiz_tab_view.dart';
import '../../leaderboard/views/leaderboard_view.dart';
import '../../profile/views/profile_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  final List<Widget> _tabs = const [
    HomeView(),
    QuizTabView(),
    LeaderboardView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      body: Stack(
        children: [
          // Background decorative gradient glow (Top Right)
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                    blurRadius: 100.r,
                    spreadRadius: 50.r,
                  ),
                ],
              ),
            ),
          ),
          // Background decorative gradient glow (Bottom Left)
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D2FF).withValues(alpha: 0.08),
                    blurRadius: 80.r,
                    spreadRadius: 40.r,
                  ),
                ],
              ),
            ),
          ),

          // Main View Content (padded at bottom to clear the floating bottom bar)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: 96.h),
              child: SafeArea(
                bottom: false,
                child: Obx(
                  () => IndexedStack(
                    index: controller.currentIndex,
                    children: _tabs,
                  ),
                ),
              ),
            ),
          ),

          // Floating Glassmorphic Shifting-Pill Bottom Navigation Bar
          Positioned(
            bottom: 10.h + MediaQuery.of(context).padding.bottom,
            left: 10.w,
            right: 10.w,
            child: Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.w, sigmaY: 16.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161233).withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 24.r,
                          offset: Offset(0, 10.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: Icons.home_rounded,
                          label: 'Home',
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: Icons.menu_book_rounded,
                          label: 'Quiz',
                        ),
                        _buildNavItem(
                          index: 2,
                          icon: Icons.emoji_events_rounded,
                          label: 'Rank',
                        ),
                        _buildNavItem(
                          index: 3,
                          icon: Icons.person_rounded,
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = controller.currentIndex == index;
    final activeColor = const Color(0xFF6C63FF);
    final inactiveColor = Colors.white.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22.r,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
