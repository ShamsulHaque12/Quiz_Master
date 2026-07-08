import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../../auth/sign_in/controllers/sign_in_controller.dart';
import '../../../../routes/app_pages.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

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
    return 'Guest Player';
  }

  String _getUserEmail() {
    if (Get.isRegistered<SignUpController>()) {
      final email = Get.find<SignUpController>().emailController.text.trim();
      if (email.isNotEmpty) return email;
    }
    if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) return email;
    }
    return 'guest.player@quizmaster.com';
  }

  File? _getUserImage() {
    if (Get.isRegistered<SignUpController>()) {
      return Get.find<SignUpController>().profileImage;
    }
    return null;
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F0C20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
        ),
        title: Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (Get.isRegistered<SignInController>()) {
                Get.find<SignInController>().emailController.clear();
                Get.find<SignInController>().passwordController.clear();
              }
              if (Get.isRegistered<SignUpController>()) {
                Get.find<SignUpController>().fullNameController.clear();
                Get.find<SignUpController>().emailController.clear();
                Get.find<SignUpController>().passwordController.clear();
                Get.find<SignUpController>().confirmPasswordController.clear();
                Get.find<SignUpController>().removeImage();
              }
              Get.offAllNamed(Routes.SIGN_IN);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final userEmail = _getUserEmail();
    final userImage = _getUserImage();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Profile Picture Header
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: userImage != null
                      ? Image.file(userImage, fit: BoxFit.cover)
                      : Icon(
                          Icons.person_rounded,
                          color: Colors.white.withValues(alpha: 0.4),
                          size: 48.r,
                        ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'LVL 12',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // User Name & Email
          Text(
            userName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),
          Text(
            userEmail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20.h),

          // User Stats Row
          Row(
            children: [
              Expanded(
                child: _buildProfileStatCard(
                  icon: Icons.play_circle_outline_rounded,
                  iconColor: const Color(0xFF6C63FF),
                  title: 'Quizzes Played',
                  value: '42',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildProfileStatCard(
                  icon: Icons.track_changes_rounded,
                  iconColor: const Color(0xFF00E5FF),
                  title: 'Avg. Accuracy',
                  value: '84%',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Profile Settings List
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildSettingsTile(
                  icon: Icons.emoji_events_outlined,
                  iconColor: const Color(0xFFFFD700),
                  title: 'My Achievements',
                  onTap: () {
                    Get.snackbar(
                      'Achievements',
                      'Achievements showcase coming soon!',
                      backgroundColor: const Color(0xFF6C63FF),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                _buildSettingsTile(
                  icon: Icons.settings_outlined,
                  iconColor: const Color(0xFF00D2FF),
                  title: 'Settings & Privacy',
                  onTap: () {
                    Get.snackbar(
                      'Settings',
                      'Settings page coming soon!',
                      backgroundColor: const Color(0xFF6C63FF),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent,
                  title: 'Logout',
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22.r),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 18.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 12.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
