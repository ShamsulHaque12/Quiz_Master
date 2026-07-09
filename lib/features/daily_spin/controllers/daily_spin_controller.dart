import 'dart:math';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class SpinSlice {
  final String label;
  final String value;
  final int colorHex;
  final bool isCoins;
  final bool isXp;
  final bool isBonus;
  final bool isMiss;

  const SpinSlice({
    required this.label,
    required this.value,
    required this.colorHex,
    this.isCoins = false,
    this.isXp = false,
    this.isBonus = false,
    this.isMiss = false,
  });
}

class DailySpinController extends GetxController {
  final isSpinning = false.obs;
  final selectedIndex = 0.obs;

  // Spin Wheel Prizes matching the mockup
  final List<SpinSlice> prizes = const [
    SpinSlice(label: '50 XP', value: '50', colorHex: 0xFF3B82F6, isXp: true), // Blue
    SpinSlice(label: '100 Coins', value: '100', colorHex: 0xFFF59E0B, isCoins: true), // Orange
    SpinSlice(label: '2x Bonus', value: '2x', colorHex: 0xFF8B5CF6, isBonus: true), // Purple
    SpinSlice(label: '25 XP', value: '25', colorHex: 0xFF10B981, isXp: true), // Green
    SpinSlice(label: '200 Coins', value: '200', colorHex: 0xFFEF4444, isCoins: true), // Red
    SpinSlice(label: 'Miss', value: '0', colorHex: 0xFF6B7280, isMiss: true), // Grey
    SpinSlice(label: '150 XP', value: '150', colorHex: 0xFFEC4899, isXp: true), // Pink
    SpinSlice(label: '50 Coins', value: '50', colorHex: 0xFF06B6D4, isCoins: true), // Cyan
  ];

  // Daily Streak Bonus Rewards Mockup
  final streakDays = const [
    {'day': '1', 'icon': '⭐', 'isCompleted': true},
    {'day': '2', 'icon': '⭐', 'isCompleted': true},
    {'day': '3', 'icon': '🎯', 'isCompleted': true},
    {'day': '4', 'icon': '⭐', 'isCompleted': true},
    {'day': '5', 'icon': '⭐', 'isCompleted': true},
    {'day': '6', 'icon': '⭐', 'isCompleted': true},
    {'day': '7', 'icon': '💎', 'isCompleted': false},
  ];

  // Starts the spin calculation and determines the landing index
  int calculateSpinResult() {
    isSpinning.value = true;
    
    // Choose a random prize (not a Miss, unless we want to sometimes miss)
    final random = Random();
    int index;
    do {
      index = random.nextInt(prizes.length);
    } while (prizes[index].isMiss && random.nextDouble() > 0.1); // 10% chance of miss max

    selectedIndex.value = index;
    return index;
  }

  // Rewards the user and updates overall controllers reactively
  void rewardUser(int index) {
    isSpinning.value = false;
    final prize = prizes[index];
    
    if (prize.isMiss) return;

    // Update ProfileController stats
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      if (prize.isCoins) {
        profile.coinCount.value += int.parse(prize.value);
      } else if (prize.isXp) {
        profile.currentXP.value += int.parse(prize.value);
        // Handle level up
        if (profile.currentXP.value >= profile.nextLevelXP.value) {
          profile.currentXP.value -= profile.nextLevelXP.value;
          profile.userLevel.value += 1;
        }
      }
    }

    // Update HomeController stats
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      if (prize.isCoins) {
        home.coinCount.value += int.parse(prize.value);
      } else if (prize.isXp) {
        home.currentXP.value += int.parse(prize.value);
        if (home.currentXP.value >= home.nextLevelXP.value) {
          home.currentXP.value -= home.nextLevelXP.value;
          home.userLevel.value += 1;
        }
      }
    }
  }
}
