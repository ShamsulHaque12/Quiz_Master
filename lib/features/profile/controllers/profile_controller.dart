import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../auth/sign_in/controllers/sign_in_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // Gamification & stats matching mockup
  final userLevel = 12.obs;
  final currentXP = 4850.obs;
  final nextLevelXP = 5000.obs; // 4850 + 150 = 5000
  final streakCount = 7.obs;
  
  final totalQuiz = 48.obs;
  final bestScore = 280.obs;
  final coinCount = 320.obs;

  final displayName = ''.obs;
  final profileImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    displayName.value = getUserName();
    profileImage.value = getUserImage();
  }

  void updateProfile({required String newName, File? newImage}) {
    displayName.value = newName;
    if (newImage != null) {
      profileImage.value = newImage;
    }
  }

  String getUserName() {
    if (Get.isRegistered<SignUpController>()) {
      final name = Get.find<SignUpController>().fullNameController.text.trim();
      if (name.isNotEmpty) return name;
    }
    if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) {
        // Capitalize words
        final username = email.split('@').first;
        return username.split(RegExp(r'[^a-zA-Z0-9]'))
            .map((str) => str.isEmpty ? '' : '${str[0].toUpperCase()}${str.substring(1)}')
            .join(' ');
      }
    }
    return 'Rafiq Islam';
  }

  String getUserEmail() {
    if (Get.isRegistered<SignUpController>()) {
      final email = Get.find<SignUpController>().emailController.text.trim();
      if (email.isNotEmpty) return email;
    }
    if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) return email;
    }
    return 'rafiq@example.com';
  }

  File? getUserImage() {
    if (Get.isRegistered<SignUpController>()) {
      return Get.find<SignUpController>().profileImage;
    }
    return null;
  }

  void handleLogout() {
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
}
