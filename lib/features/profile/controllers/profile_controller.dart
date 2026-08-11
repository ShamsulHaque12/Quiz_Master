import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../auth/sign_in/controllers/sign_in_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/app_images.dart';
import '../models/badge_model.dart';

class ProfileController extends GetxController {
  // Gamification & stats (Mock initial state for pure UI)
  final userLevel = 1.obs;
  final currentXP = 350.obs;
  final nextLevelXP = 1000.obs;
  final streakCount = 3.obs;

  final totalQuiz = 8.obs;
  final bestScore = 180.obs;
  final coinCount = 150.obs;
  final totalScore = 650.obs;

  final displayName = 'Quiz Master'.obs;
  final email = 'user@quizmaster.app'.obs;
  final avatarUrl = ''.obs;
  final profileImage = Rxn<File>();

  late final List<BadgeModel> badges = [
    BadgeModel(
      id: 1,
      imagePath: AppImages.badge1,
      title: 'Bronze Collector',
      description: 'Unlock at 50 coins',
      isUnlocked: (c) => c.coinCount.value >= 50,
    ),
    BadgeModel(
      id: 2,
      imagePath: AppImages.badge2,
      title: 'Silver Collector',
      description: 'Unlock at 100 coins',
      isUnlocked: (c) => c.coinCount.value >= 100,
    ),
    BadgeModel(
      id: 3,
      imagePath: AppImages.badge3,
      title: 'Gold Collector',
      description: 'Unlock at 200 coins',
      isUnlocked: (c) => c.coinCount.value >= 200,
    ),
    BadgeModel(
      id: 4,
      imagePath: AppImages.badge4,
      title: 'Novice Quizzer',
      description: 'Unlock at 200 XP',
      isUnlocked: (c) => c.currentXP.value >= 200,
    ),
    BadgeModel(
      id: 5,
      imagePath: AppImages.badge5,
      title: 'Apprentice Quizzer',
      description: 'Unlock at 500 XP',
      isUnlocked: (c) => c.currentXP.value >= 500,
    ),
    BadgeModel(
      id: 6,
      imagePath: AppImages.badge6,
      title: 'Adept Quizzer',
      description: 'Unlock at 1000 XP',
      isUnlocked: (c) => c.currentXP.value >= 1000,
    ),
    BadgeModel(
      id: 7,
      imagePath: AppImages.badge7,
      title: 'Challenger Score',
      description: 'Unlock at 400 Score',
      isUnlocked: (c) => c.totalScore.value >= 400,
    ),
    BadgeModel(
      id: 8,
      imagePath: AppImages.badge8,
      title: 'Veteran Score',
      description: 'Unlock at 600 score',
      isUnlocked: (c) => c.totalScore.value >= 600,
    ),
    BadgeModel(
      id: 9,
      imagePath: AppImages.badge9,
      title: 'Elite Score',
      description: 'Unlock at 1000 score',
      isUnlocked: (c) => c.totalScore.value >= 1000,
    ),
    BadgeModel(
      id: 10,
      imagePath: AppImages.badge10,
      title: 'Rising Star',
      description: 'Unlock at level 3',
      isUnlocked: (c) => c.userLevel.value >= 3,
    ),
    BadgeModel(
      id: 11,
      imagePath: AppImages.badge11,
      title: 'Champion',
      description: 'Unlock at level 5',
      isUnlocked: (c) => c.userLevel.value >= 5,
    ),
    BadgeModel(
      id: 12,
      imagePath: AppImages.badge12,
      title: 'Master',
      description: 'Unlock at level 10',
      isUnlocked: (c) => c.userLevel.value >= 10,
    ),
    BadgeModel(
      id: 13,
      imagePath: AppImages.badge13,
      title: 'Grandmaster Quizzer',
      description: 'Unlock at 3000 XP',
      isUnlocked: (c) => c.currentXP.value >= 3000,
    ),
    BadgeModel(
      id: 14,
      imagePath: AppImages.badge14,
      title: 'Wealthy Collector',
      description: 'Unlock at 2000 coin',
      isUnlocked: (c) => c.coinCount.value >= 2000,
    ),
    BadgeModel(
      id: 15,
      imagePath: AppImages.badge15,
      title: 'Legendary Champion',
      description: 'Unlock at level 15',
      isUnlocked: (c) => c.userLevel.value >= 15,
    ),
  ];

  int get xpUserLevel {
    final xp = currentXP.value;
    if (xp <= 500) return 1;
    if (xp <= 1000) return 2;
    if (xp <= 1500) return 3;
    if (xp <= 2000) return 4;
    return 5;
  }

  String get xpLevelName {
    final xp = currentXP.value;
    if (xp <= 500) return 'Beginner';
    if (xp <= 1000) return 'Intermediate';
    if (xp <= 1500) return 'Advanced';
    if (xp <= 2000) return 'Expert / Master';
    return 'Enterprise / Professional Level';
  }

  double get xpLevelProgress {
    final xp = currentXP.value;
    if (xp <= 500) return xp / 500.0;
    if (xp <= 1000) return (xp - 500) / 500.0;
    if (xp <= 1500) return (xp - 1000) / 500.0;
    if (xp <= 2000) return (xp - 1500) / 500.0;
    return 1.0;
  }

  int get xpRemainingToNextLevel {
    final xp = currentXP.value;
    if (xp <= 500) return 500 - xp;
    if (xp <= 1000) return 1000 - xp;
    if (xp <= 1500) return 1500 - xp;
    if (xp <= 2000) return 2000 - xp;
    return 0;
  }

  String get nextLevelName {
    final xp = currentXP.value;
    if (xp <= 500) return 'Intermediate';
    if (xp <= 1000) return 'Advanced';
    if (xp <= 1500) return 'Expert / Master';
    if (xp <= 2000) return 'Enterprise / Professional Level';
    return '';
  }

  int get xpInCurrentLevel {
    final xp = currentXP.value;
    if (xp <= 500) return xp;
    if (xp <= 1000) return xp - 500;
    if (xp <= 1500) return xp - 1000;
    if (xp <= 2000) return xp - 1500;
    return xp - 2000;
  }

  int get xpMaxInCurrentLevel {
    return 500;
  }

  @override
  void onInit() {
    super.onInit();
    final name = getUserName();
    if (name.isNotEmpty && name != 'No Name') {
      displayName.value = name;
    }
    email.value = getUserEmail();
    profileImage.value = getUserImage();
  }

  void updateProfile({required String newName, File? newImage}) {
    displayName.value = newName;
    if (newImage != null) {
      profileImage.value = newImage;
    }
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().displayName.value = newName;
    }
  }

  String getUserName() {
    if (Get.isRegistered<SignUpController>()) {
      final name = Get.find<SignUpController>().fullNameController.text.trim();
      if (name.isNotEmpty) return name;
    }
    if (Get.isRegistered<SignInController>()) {
      final inputEmail = Get.find<SignInController>().emailController.text.trim();
      if (inputEmail.isNotEmpty) {
        final username = inputEmail.split('@').first;
        return username
            .split(RegExp(r'[^a-zA-Z0-9]'))
            .map(
              (str) => str.isEmpty
                  ? ''
                  : '${str[0].toUpperCase()}${str.substring(1)}',
            )
            .join(' ');
      }
    }
    return displayName.value;
  }

  String getUserEmail() {
    if (Get.isRegistered<SignUpController>()) {
      final inputEmail = Get.find<SignUpController>().emailController.text.trim();
      if (inputEmail.isNotEmpty) return inputEmail;
    }
    if (Get.isRegistered<SignInController>()) {
      final inputEmail = Get.find<SignInController>().emailController.text.trim();
      if (inputEmail.isNotEmpty) return inputEmail;
    }
    return email.value;
  }

  File? getUserImage() {
    if (Get.isRegistered<SignUpController>()) {
      return Get.find<SignUpController>().profileImage;
    }
    return profileImage.value;
  }

  void handleLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F0C20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14.sp,
              ),
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
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateUserStats({
    required int addedScore,
    required int addedXP,
    required int addedCoins,
  }) async {
    final newScore = totalScore.value + addedScore;
    final newXP = currentXP.value + addedXP;
    final newCoins = coinCount.value + addedCoins;
    final newTotalQuiz = totalQuiz.value + 1;
    final newBestScore = addedScore > bestScore.value ? addedScore : bestScore.value;

    int newLevel = userLevel.value;
    int tempXP = newXP;
    while (tempXP >= newLevel * 1000) {
      newLevel++;
    }

    totalScore.value = newScore;
    currentXP.value = newXP;
    coinCount.value = newCoins;
    totalQuiz.value = newTotalQuiz;
    bestScore.value = newBestScore;
    userLevel.value = newLevel;

    // Sync with HomeController if available
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.currentXP.value = newXP;
      home.userLevel.value = newLevel;
      home.coinCount.value = newCoins;
      home.recentTotalQuiz.value = newTotalQuiz;
      home.recentBestScore.value = newBestScore;
    }
  }

  Future<void> recordQuizAttempt({
    required String category,
    required int totalQuestion,
    required int correct,
    required int wrong,
    required int skip,
    required int score,
    required int xp,
    required int coin,
    required double accuracy,
    required DateTime startedAt,
    required DateTime completedAt,
  }) async {
    log("Recorded local quiz attempt for $category: score $score, accuracy $accuracy%");
  }
}
