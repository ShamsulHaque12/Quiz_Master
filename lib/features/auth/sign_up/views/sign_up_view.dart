import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/sign_up_controller.dart';
import '../../sign_in/widgets/sign_in_input_field.dart';
import '../../../../routes/app_pages.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  Future<void> _handleSignUp(BuildContext context) async {
    final success = await controller.signUp();
    if (success) {
      Get.snackbar(
        'Registration Success',
        'Account created successfully! Welcome ${controller.fullNameController.text.trim()}.',
        backgroundColor: const Color(0xFF6C63FF),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
      // Navigate to Dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void _showImageSourcePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0C20),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Profile Picture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: const Color(0xFF6C63FF),
                            size: 28.r,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            color: const Color(0xFF00D2FF),
                            size: 28.r,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.profileImage != null) ...[
              SizedBox(height: 16.h),
              Divider(color: Colors.white.withValues(alpha: 0.08)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  controller.removeImage();
                  Get.back();
                },
              ),
            ],
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      body: Stack(
        children: [
          // Background decorative glow (Top Right)
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
          // Background decorative glow (Bottom Left)
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

          SafeArea(
            child: GetBuilder<SignUpController>(
              builder: (_) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Row (Back button & Screen title)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48.w,
                          ), // To balance the back button width
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Profile Image Selector from mobile storage
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 96.r,
                              height: 96.r,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: controller.profileImage != null
                                    ? Image.file(
                                        controller.profileImage!,
                                        fit: BoxFit.cover,
                                        width: 96.r,
                                        height: 96.r,
                                      )
                                    : Icon(
                                        Icons.person_rounded,
                                        size: 48.r,
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _showImageSourcePicker(context),
                                child: Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6C63FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 16.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),

                      // Full Name input
                      SignInInputField(
                        controller: controller.fullNameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icons.person_outline_rounded,
                        errorText: controller.fullNameError,
                      ),
                      SizedBox(height: 16.h),

                      // Email input
                      SignInInputField(
                        controller: controller.emailController,
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        errorText: controller.emailError,
                      ),
                      SizedBox(height: 16.h),

                      // Password input
                      SignInInputField(
                        controller: controller.passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: controller.obscurePassword,
                        errorText: controller.passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 20.r,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Confirm Password input
                      SignInInputField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: controller.obscureConfirmPassword,
                        errorText: controller.confirmPasswordError,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 20.r,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Sign Up Button with SpinKit loading
                      Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF80C2FF), Color(0xFF6C63FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF6C63FF,
                              ).withValues(alpha: 0.25),
                              blurRadius: 16.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: controller.isLoading
                                ? null
                                : () => _handleSignUp(context),
                            borderRadius: BorderRadius.circular(16.r),
                            child: Center(
                              child: controller.isLoading
                                  ? SpinKitCircle(
                                      color: Colors.white,
                                      size: 30.r,
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Already have an account prompt
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: const Color(0xFF6C63FF),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
