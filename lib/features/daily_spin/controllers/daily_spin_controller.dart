import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
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

  // Spin limits
  final canSpin = true.obs;
  final remainingTime = ''.obs;
  Timer? _timer;

  // Streak states
  final streakCount = 3.obs;
  final canClaimStreak = true.obs;
  final lastStreakClaimAt = Rxn<DateTime>();

  // Spin Wheel Prizes matching the mockup
  final List<SpinSlice> prizes = const [
    SpinSlice(
      label: '50 XP',
      value: '50',
      colorHex: 0xFF3B82F6,
      isXp: true,
    ), // Blue
    SpinSlice(
      label: '100 Coins',
      value: '100',
      colorHex: 0xFFF59E0B,
      isCoins: true,
    ), // Orange
    SpinSlice(
      label: '250 Coins',
      value: '250',
      colorHex: 0xFF8B5CF6,
      isCoins: true,
    ), // Purple
    SpinSlice(
      label: '25 XP',
      value: '25',
      colorHex: 0xFF10B981,
      isXp: true,
    ), // Green
    SpinSlice(
      label: '200 Coins',
      value: '200',
      colorHex: 0xFFEF4444,
      isCoins: true,
    ), // Red
    SpinSlice(
      label: 'Miss',
      value: '0',
      colorHex: 0xFF6B7280,
      isMiss: true,
    ), // Grey
    SpinSlice(
      label: '150 XP',
      value: '150',
      colorHex: 0xFFEC4899,
      isXp: true,
    ), // Pink
    SpinSlice(
      label: '50 Coins',
      value: '50',
      colorHex: 0xFF06B6D4,
      isCoins: true,
    ), // Cyan
  ];

  @override
  void onInit() {
    super.onInit();
    checkSpinStatus();
    checkStreakStatus();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void checkSpinStatus() {
    // Pure UI implementation allows initial spin or starts countdown
  }

  void _startTimer(int secondsRemaining) {
    _timer?.cancel();
    int current = secondsRemaining;
    _updateRemainingTimeText(current);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (current <= 0) {
        canSpin.value = true;
        remainingTime.value = '';
        timer.cancel();
      } else {
        current--;
        _updateRemainingTimeText(current);
      }
    });
  }

  void _updateRemainingTimeText(int totalSeconds) {
    if (totalSeconds <= 0) {
      remainingTime.value = '';
      return;
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    remainingTime.value =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // Starts the spin calculation and determines the landing index
  int calculateSpinResult() {
    isSpinning.value = true;
    canSpin.value = false; // Block further spins immediately

    final random = Random();
    int index;
    do {
      index = random.nextInt(prizes.length);
    } while (prizes[index].isMiss && random.nextDouble() > 0.1);

    selectedIndex.value = index;
    return index;
  }

  // Rewards the user and updates overall controllers reactively
  Future<void> rewardUser(int index) async {
    isSpinning.value = false;
    final prize = prizes[index];

    final int val = int.tryParse(prize.value) ?? 0;

    // Refresh Profile Controller
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      if (prize.isCoins) {
        profile.coinCount.value += val;
      } else if (prize.isXp) {
        profile.currentXP.value += val;
      }
    }

    // Refresh Home Controller
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      if (prize.isCoins) {
        home.coinCount.value += val;
      } else if (prize.isXp) {
        home.currentXP.value += val;
      }
    }

    // Start countdown timer for next spin demo (e.g. 12 hours)
    _startTimer(12 * 3600);
  }

  void checkStreakStatus() {
    // Synchronize streak status with local ProfileController
    if (Get.isRegistered<ProfileController>()) {
      streakCount.value = Get.find<ProfileController>().streakCount.value;
    }
  }

  // Claim daily streak reward
  Future<void> claimDailyStreak() async {
    if (!canClaimStreak.value) return;

    final nextStreak = streakCount.value + 1;

    int rewardXp = 0;
    int rewardCoin = 0;
    String rewardText = '';

    final dayIndex = ((nextStreak - 1) % 7) + 1;
    switch (dayIndex) {
      case 1:
        rewardXp = 20;
        rewardText = "20 XP";
        break;
      case 2:
        rewardCoin = 10;
        rewardText = "10 Coins";
        break;
      case 3:
        rewardXp = 50;
        rewardText = "50 XP";
        break;
      case 4:
        rewardCoin = 40;
        rewardText = "40 Coins";
        break;
      case 5:
        rewardCoin = 60;
        rewardText = "60 Coins";
        break;
      case 6:
        rewardXp = 100;
        rewardText = "100 XP";
        break;
      case 7:
        rewardCoin = 150;
        rewardText = "150 Coins";
        break;
    }

    streakCount.value = nextStreak;
    canClaimStreak.value = false;
    lastStreakClaimAt.value = DateTime.now();

    // Update ProfileController & HomeController
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.streakCount.value = nextStreak;
      profile.currentXP.value += rewardXp;
      profile.coinCount.value += rewardCoin;
    }
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.streakCount.value = nextStreak;
      home.recentDayStreak.value = nextStreak;
      home.currentXP.value += rewardXp;
      home.coinCount.value += rewardCoin;
    }

    // Show success dialog
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF141129),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF6C63FF).withAlpha(102),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                'Streak Claimed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You claimed your Day $dayIndex reward of $rewardText!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                ),
                child: const Text(
                  'AWESOME',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate dynamic 7-day streak rewards representation
  List<Map<String, dynamic>> get dynamicStreakDays {
    final int currentStreak = streakCount.value;
    final bool claimedToday = !canClaimStreak.value;
    final int currentDayInCycle = currentStreak % 7;
    final bool cycleCompleted =
        (currentStreak > 0 && currentDayInCycle == 0 && claimedToday);

    return [
      {
        'day': '1',
        'reward': '20 XP',
        'type': 'xp',
        'isCompleted':
            cycleCompleted ||
            currentDayInCycle >= 1 ||
            (currentDayInCycle == 0 && currentStreak > 0),
        'isClaimable': !claimedToday && currentDayInCycle == 0,
      },
      {
        'day': '2',
        'reward': '10 Coin',
        'type': 'coin',
        'isCompleted': cycleCompleted || currentDayInCycle >= 2,
        'isClaimable': !claimedToday && currentDayInCycle == 1,
      },
      {
        'day': '3',
        'reward': '50 XP',
        'type': 'xp',
        'isCompleted': cycleCompleted || currentDayInCycle >= 3,
        'isClaimable': !claimedToday && currentDayInCycle == 2,
      },
      {
        'day': '4',
        'reward': '40 Coin',
        'type': 'coin',
        'isCompleted': cycleCompleted || currentDayInCycle >= 4,
        'isClaimable': !claimedToday && currentDayInCycle == 3,
      },
      {
        'day': '5',
        'reward': '60 Coin',
        'type': 'coin',
        'isCompleted': cycleCompleted || currentDayInCycle >= 5,
        'isClaimable': !claimedToday && currentDayInCycle == 4,
      },
      {
        'day': '6',
        'reward': '100 XP',
        'type': 'xp',
        'isCompleted': cycleCompleted || currentDayInCycle >= 6,
        'isClaimable': !claimedToday && currentDayInCycle == 5,
      },
      {
        'day': '7',
        'reward': '150 Coin',
        'type': 'coin',
        'isCompleted': cycleCompleted,
        'isClaimable': !claimedToday && currentDayInCycle == 6,
      },
    ];
  }
}
