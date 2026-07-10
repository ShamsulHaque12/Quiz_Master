import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final supabase = Supabase.instance.client;
  final isSpinning = false.obs;
  final selectedIndex = 0.obs;

  // Spin limits
  final canSpin = true.obs;
  final remainingTime = ''.obs;
  Timer? _timer;

  // Streak states
  final streakCount = 0.obs;
  final canClaimStreak = false.obs;
  final lastStreakClaimAt = Rxn<DateTime>();

  String get userId => supabase.auth.currentUser?.id ?? '';

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

  Future<void> checkSpinStatus() async {
    try {
      if (userId.isEmpty) return;
      final data = await supabase
          .from('profiles')
          .select('last_spin_at')
          .eq('id', userId)
          .single();

      final lastSpinStr = data['last_spin_at'];
      if (lastSpinStr != null) {
        final lastSpin = DateTime.parse(lastSpinStr);
        final diff = DateTime.now().difference(lastSpin);
        if (diff.inHours < 24) {
          canSpin.value = false;
          _startTimer(24 * 3600 - diff.inSeconds);
        } else {
          canSpin.value = true;
          remainingTime.value = '';
        }
      } else {
        canSpin.value = true;
        remainingTime.value = '';
      }
    } catch (e) {
      log("Error checking spin status: $e");
    }
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

    // Choose a random prize (not a Miss, unless we want to sometimes miss)
    final random = Random();
    int index;
    do {
      index = random.nextInt(prizes.length);
    } while (prizes[index].isMiss &&
        random.nextDouble() > 0.1); // 10% chance of miss max

    selectedIndex.value = index;
    return index;
  }

  // Rewards the user and updates overall controllers reactively
  Future<void> rewardUser(int index) async {
    isSpinning.value = false;
    final prize = prizes[index];

    try {
      if (userId.isEmpty) return;

      // Current profile
      final profile = await supabase
          .from('profiles')
          .select('xp, coin')
          .eq('id', userId)
          .single();

      int currentXp = profile['xp'] ?? 0;
      int currentCoin = profile['coin'] ?? 0;

      final Map<String, dynamic> updates = {
        'last_spin_at': DateTime.now().toIso8601String(),
      };

      if (prize.isCoins) {
        currentCoin += int.parse(prize.value);
        updates['coin'] = currentCoin;
      } else if (prize.isXp) {
        currentXp += int.parse(prize.value);
        updates['xp'] = currentXp;
      }

      // Update profiles
      await supabase.from('profiles').update(updates).eq('id', userId);

      // Save History
      await supabase.from('spin_history').insert({
        'user_id': userId,
        'reward_type': prize.isCoins ? 'coin' : (prize.isXp ? 'xp' : 'bonus'),
        'reward_amount': (prize.isCoins || prize.isXp)
            ? int.parse(prize.value)
            : 0,
      });

      // Refresh status and timer
      await checkSpinStatus();

      // Refresh Profile Controller
      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchUserProfile();
      }

      // Refresh Home Controller
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().fetchUserProfile();
      }
    } catch (e) {
      log("Error rewarding user in DailySpinController: $e");
    }
  }

  // Check the streak claim status of the user
  Future<void> checkStreakStatus() async {
    try {
      if (userId.isEmpty) return;
      final data = await supabase
          .from('profiles')
          .select('streak_day, last_streak_claim')
          .eq('id', userId)
          .single();

      final int dbStreak = data['streak_day'] ?? 0;
      final String? lastClaimStr = data['last_streak_claim'];

      streakCount.value = dbStreak;

      if (lastClaimStr != null) {
        final lastClaim = DateTime.parse(lastClaimStr);
        lastStreakClaimAt.value = lastClaim;
        final diff = DateTime.now().difference(lastClaim);

        if (diff.inHours >= 48) {
          // Missed a day! Reset streak to 0
          streakCount.value = 0;
          await supabase
              .from('profiles')
              .update({'streak_day': 0})
              .eq('id', userId);
          canClaimStreak.value = true;
        } else if (diff.inHours >= 24) {
          // Can claim the next day's reward
          canClaimStreak.value = true;
        } else {
          // Already claimed today
          canClaimStreak.value = false;
        }
      } else {
        // Never claimed before
        canClaimStreak.value = true;
      }
    } catch (e) {
      log("Error checking streak status: $e");
    }
  }

  // Claim daily streak reward
  Future<void> claimDailyStreak() async {
    if (!canClaimStreak.value) return;

    try {
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

      // Fetch current profile stats to update
      final profile = await supabase
          .from('profiles')
          .select('xp, coin')
          .eq('id', userId)
          .single();

      int currentXp = profile['xp'] ?? 0;
      int currentCoin = profile['coin'] ?? 0;

      currentXp += rewardXp;
      currentCoin += rewardCoin;

      // Update DB
      await supabase
          .from('profiles')
          .update({
            'streak_day': nextStreak,
            'xp': currentXp,
            'coin': currentCoin,
            'last_streak_claim': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Save History
      await supabase.from('spin_history').insert({
        'user_id': userId,
        'reward_type': rewardCoin > 0 ? 'coin' : 'xp',
        'reward_amount': rewardCoin > 0 ? rewardCoin : rewardXp,
      });

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

      // Refresh everything
      await checkStreakStatus();

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchUserProfile();
      }
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().fetchUserProfile();
      }
    } catch (e) {
      log("Error claiming daily streak: $e");
    }
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
