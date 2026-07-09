import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
            // Header
            Row(
              children: [
                Text('⚙️', style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 10.w),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Customize your preferences and account options',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 28.h),

            // SECTION 1: ACCOUNT
            _buildSectionHeader('ACCOUNT'),
            SizedBox(height: 10.h),
            _buildGroupedCard([
              _buildSettingsActionTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Update user profile photo and name',
                onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
              ),
              _buildSettingsActionTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                subtitle: 'Update your login password securely',
                onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
              ),
            ]),
            SizedBox(height: 24.h),

            // SECTION 2: PREFERENCES
            _buildSectionHeader('PREFERENCES'),
            SizedBox(height: 10.h),
            _buildGroupedCard([
              Obx(
                () => _buildSettingsSwitchTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  subtitle: 'Receive updates and challenge alerts',
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                ),
              ),
            ]),
            SizedBox(height: 24.h),

            // SECTION 3: GENERAL
            _buildSectionHeader('GENERAL'),
            SizedBox(height: 10.h),
            _buildGroupedCard([
              _buildSettingsActionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our data handling guidelines',
                onTap: () {
                  Get.snackbar(
                    'Privacy',
                    'Privacy policy document is loaded online.',
                    backgroundColor: const Color(0xFF6C63FF),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildSettingsActionTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'View user terms and agreements',
                onTap: () {
                  Get.snackbar(
                    'Terms',
                    'Terms of service document is loaded online.',
                    backgroundColor: const Color(0xFF6C63FF),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ]),
            SizedBox(height: 40.h),

            // Footer app info
            Center(
              child: Column(
                children: [
                  Text(
                    'Quiz Master',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Version 1.0.0 (Build 12)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.2),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF8B5CF6), // Premium violet/purple header
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGroupedCard(List<Widget> children) {
    List<Widget> dividedChildren = [];
    for (int i = 0; i < children.length; i++) {
      dividedChildren.add(children[i]);
      if (i < children.length - 1) {
        dividedChildren.add(
          Divider(
            color: Colors.white.withValues(alpha: 0.04),
            thickness: 1,
            height: 1,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Column(children: dividedChildren),
    );
  }

  Widget _buildSettingsActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.7),
                size: 20.r,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.25),
                size: 18.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF6C63FF),
            activeTrackColor: const Color(0xFF6C63FF).withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white.withValues(alpha: 0.7),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
