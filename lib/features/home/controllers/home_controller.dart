import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/sign_up/controllers/sign_up_controller.dart';
import '../../auth/sign_in/controllers/sign_in_controller.dart';
import '../models/home_model.dart';

class HomeController extends GetxController {
  // Streaks and Coins
  final streakCount = 1.obs;
  final coinCount = 0.obs;

  // Level stats
  final userLevel = 1.obs;
  final currentXP = 0.obs;
  final nextLevelXP = 1000.obs;
  final totalXP = 0.obs;

  // Recent Performance stats
  final recentTotalQuiz = 0.obs;
  final recentBestScore = 0.obs;
  final recentDayStreak = 1.obs;

  final displayName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-populate if controllers are registered
    if (Get.isRegistered<SignUpController>()) {
      displayName.value = Get.find<SignUpController>().fullNameController.text
          .trim();
    } else if (Get.isRegistered<SignInController>()) {
      final email = Get.find<SignInController>().emailController.text.trim();
      if (email.isNotEmpty) {
        displayName.value = email.split('@').first;
      }
    }
    fetchUserProfile();
    fetchTopPlayers();
  }

  Future<void> fetchUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        final userModel = HomeUserModel.fromJson(data);

        displayName.value = userModel.fullName ?? '';
        userLevel.value = userModel.level;
        currentXP.value = userModel.xp;
        nextLevelXP.value = userModel.level * 1000;
        totalXP.value = userModel.xp;
        streakCount.value = userModel.streak;
        coinCount.value = userModel.coin;
        recentDayStreak.value = userModel.streak;
        recentTotalQuiz.value = userModel.totalQuiz;
        recentBestScore.value = userModel.bestScore;
      }
    } catch (e) {
      log("Error fetching profile in HomeController: $e");
    }
  }

  final topPlayers = <Map<String, dynamic>>[].obs;

  Future<void> fetchTopPlayers() async {
    try {
      final List<dynamic> data = await Supabase.instance.client
          .from('profiles')
          .select()
          .order('total_score', ascending: false)
          .limit(3);

      final list = <Map<String, dynamic>>[];
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final rank = i + 1;
        Color color;
        if (rank == 1) {
          color = const Color(0xFFFFD700); // Gold
        } else if (rank == 2) {
          color = const Color(0xFFC0C0C0); // Silver
        } else if (rank == 3) {
          color = const Color(0xFFCD7F32); // Bronze
        } else {
          color = const Color(0xFF808080); // Gray
        }

        String avatar = '😊';
        final emojis = ['🦁', '🦊', '🐺', '🦅', '🐹', '🐼', '🐯', '🐨'];
        avatar = emojis[i % emojis.length];

        list.add({
          'rank': rank.toString(),
          'name': item['full_name'] ?? 'User',
          'xp': item['xp'] ?? 0,
          'coin': item['coin'] ?? 0,
          'totalScore': item['total_score'] ?? 0,
          'totalXp': '${item['xp'] ?? 0} XP',
          'todayXp': '${item['total_score'] ?? 0}',
          'avatar': avatar,
          'color': color,
        });
      }
      topPlayers.assignAll(list);
    } catch (e) {
      debugPrint("Error fetching top players: $e");
    }
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
