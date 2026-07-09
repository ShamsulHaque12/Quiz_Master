import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Streaks and Coins from the mockup
  final streakCount = 7.obs;
  final coinCount = 320.obs;

  // Level stats
  final userLevel = 12.obs;
  final currentXP = 850.obs;
  final nextLevelXP = 1000.obs;
  final totalXP = 4850.obs;

  // Recent Performance stats
  final recentTotalQuiz = 48.obs;
  final recentBestScore = 280.obs;
  final recentDayStreak = 7.obs;

  // Top Players list
  final topPlayers = const [
    {
      'rank': '1',
      'name': 'Rahim Ahmed',
      'totalXp': '4,200 XP',
      'todayXp': '2,850',
      'avatar': '🦁',
      'color': Color(0xFFFFD700), // Gold
    },
    {
      'rank': '2',
      'name': 'Priya Sharma',
      'totalXp': '3,980 XP',
      'todayXp': '2,720',
      'avatar': '🦊',
      'color': Color(0xFFC0C0C0), // Silver
    },
    {
      'rank': '3',
      'name': 'Karim Hassan',
      'totalXp': '3,750 XP',
      'todayXp': '2,650',
      'avatar': '🐺',
      'color': Color(0xFFCD7F32), // Bronze
    },
  ].obs;

  double get levelProgress => currentXP.value / nextLevelXP.value;
}
