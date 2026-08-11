import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../auth/sign_in/controllers/sign_in_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeController extends GetxController {
  // Streaks and Coins
  final streakCount = 3.obs;
  final coinCount = 150.obs;

  // Level stats
  final userLevel = 1.obs;
  final currentXP = 350.obs;
  final nextLevelXP = 1000.obs;
  final totalXP = 350.obs;

  // Recent Performance stats
  final recentTotalQuiz = 8.obs;
  final recentBestScore = 180.obs;
  final recentDayStreak = 3.obs;

  final displayName = 'Quiz Master'.obs;
  final topPlayers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initUserData();
    loadMockTopPlayers();
  }

  void _initUserData() {
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      displayName.value = profile.displayName.value;
      userLevel.value = profile.userLevel.value;
      currentXP.value = profile.currentXP.value;
      coinCount.value = profile.coinCount.value;
      streakCount.value = profile.streakCount.value;
      recentTotalQuiz.value = profile.totalQuiz.value;
      recentBestScore.value = profile.bestScore.value;
      recentDayStreak.value = profile.streakCount.value;
      return;
    }

    if (Get.isRegistered<SignUpController>()) {
      final name = Get.find<SignUpController>().fullNameController.text.trim();
      if (name.isNotEmpty) displayName.value = name;
    } else if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) {
        displayName.value = email.split('@').first;
      }
    }
  }

  void loadMockTopPlayers() {
    topPlayers.assignAll([
      {
        'rank': '1',
        'name': 'Sophia Vance',
        'xp': 1450,
        'coin': 520,
        'totalScore': 2100,
        'totalXp': '1450 XP',
        'todayXp': '2100',
        'avatar': '🦁',
        'color': const Color(0xFFFFD700), // Gold
      },
      {
        'rank': '2',
        'name': 'David Kim',
        'xp': 1280,
        'coin': 410,
        'totalScore': 1850,
        'totalXp': '1280 XP',
        'todayXp': '1850',
        'avatar': '🦊',
        'color': const Color(0xFFC0C0C0), // Silver
      },
      {
        'rank': '3',
        'name': 'Marcus Roy',
        'xp': 1120,
        'coin': 360,
        'totalScore': 1600,
        'totalXp': '1120 XP',
        'todayXp': '1600',
        'avatar': '🐺',
        'color': const Color(0xFFCD7F32), // Bronze
      },
    ]);
  }

  int get xpUserLevel {
    final xp = currentXP.value;
    if (xp <= 0) return 1;
    return ((xp - 1) / 500).floor() + 1;
  }

  String get xpLevelName {
    final lvl = xpUserLevel;
    final minXp = (lvl - 1) * 500 + 1;
    final maxXp = lvl * 500;
    return 'level $lvl ($minXp - $maxXp) XP';
  }

  double get xpLevelProgress {
    final xp = currentXP.value;
    final lvl = xpUserLevel;
    final minXp = (lvl - 1) * 500;
    return (xp - minXp) / 500.0;
  }

  int get xpInCurrentLevel {
    final xp = currentXP.value;
    final lvl = xpUserLevel;
    final minXp = (lvl - 1) * 500;
    return xp - minXp;
  }

  int get xpMaxInCurrentLevel {
    return 500;
  }

  double get levelProgress => xpLevelProgress;
}
