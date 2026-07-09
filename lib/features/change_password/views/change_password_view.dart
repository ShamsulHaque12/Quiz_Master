import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

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
            // Title Header
            Row(
              children: [
                Text('🔒', style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 10.w),
                Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text(
                'Choose a strong password to protect your account',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 36.h),

            // CURRENT PASSWORD
            _buildInputLabel('CURRENT PASSWORD'),
            SizedBox(height: 10.h),
            Obx(() => _buildPasswordField(
                  controller: controller.currentPasswordController,
                  obscureText: controller.obscureCurrentPassword.value,
                  hintText: 'Enter current password',
                  onToggleVisibility: controller.toggleCurrentPasswordVisibility,
                )),
            SizedBox(height: 24.h),

            // NEW PASSWORD
            _buildInputLabel('NEW PASSWORD'),
            SizedBox(height: 10.h),
            Obx(() => _buildPasswordField(
                  controller: controller.newPasswordController,
                  obscureText: controller.obscureNewPassword.value,
                  hintText: 'Enter new password (min. 6 chars)',
                  onToggleVisibility: controller.toggleNewPasswordVisibility,
                )),
            SizedBox(height: 24.h),

            // CONFIRM NEW PASSWORD
            _buildInputLabel('CONFIRM NEW PASSWORD'),
            SizedBox(height: 10.h),
            Obx(() => _buildPasswordField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  hintText: 'Re-enter new password',
                  onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                )),
            SizedBox(height: 48.h),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF8B5CF6),
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String hintText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 14.sp,
          ),
          icon: Icon(
            Icons.lock_outline_rounded,
            color: Colors.white.withValues(alpha: 0.45),
            size: 20.r,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: Colors.white.withValues(alpha: 0.35),
              size: 20.r,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
