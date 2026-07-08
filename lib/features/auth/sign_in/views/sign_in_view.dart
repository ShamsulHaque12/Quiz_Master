import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../controllers/sign_in_controller.dart';
import '../../../../routes/app_pages.dart';
import '../widgets/sign_in_header.dart';
import '../widgets/sign_in_input_field.dart';
import '../widgets/remember_me_section.dart';
import '../widgets/social_sign_in_section.dart';
import '../widgets/sign_up_prompt.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  Future<void> _handleEmailSignIn(BuildContext context) async {
    final success = await controller.signIn();
    if (success) {
      Get.offNamed(Routes.DASHBOARD);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final success = await controller.signInWithGoogle();
    if (success) {
      Get.offNamed(Routes.DASHBOARD);
    }
  }

  void _handlePlayAsGuest() {
    if (controller.playAsGuest()) {
      Get.offNamed(Routes.DASHBOARD);
    }
  }

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

          SafeArea(
            child: GetBuilder<SignInController>(
              builder: (_) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50.h),

                      // Header (Logo, title, subtitle)
                      const SignInHeader(),

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
                        textInputAction: TextInputAction.done,
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
                      SizedBox(height: 20.h),

                      // Remember Me & Forgot Password
                      RememberMeSection(
                        value: controller.rememberMe,
                        onChanged: (val) => controller.toggleRememberMe(),
                        onForgotPasswordTap: () {
                          Get.snackbar(
                            'Reset Password',
                            'Password reset instructions sent to your email.',
                            backgroundColor: const Color(0xFF6C63FF),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.all(16.w),
                            borderRadius: 12.r,
                          );
                        },
                      ),
                      SizedBox(height: 18.h),

                      // Sign In Button
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
                                : () => _handleEmailSignIn(context),
                            borderRadius: BorderRadius.circular(16.r),
                            child: Center(
                              child: controller.isLoading
                                  ? SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: SpinKitCircle(
                                        color: Colors.white,
                                        size: 30.r,
                                      ),
                                    )
                                  : Text(
                                      'Sign In',
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
                      SizedBox(height: 16.h),

                      // Social Sign-In (Google & Guest)
                      SocialSignInSection(
                        onGoogleTap: _handleGoogleSignIn,
                        onGuestTap: _handlePlayAsGuest,
                        isLoading: controller.isLoading,
                      ),
                      SizedBox(height: 16.h),

                      // Sign Up Prompt
                      SignUpPrompt(
                        onSignUpTap: () => Get.toNamed(Routes.SIGN_UP),
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
