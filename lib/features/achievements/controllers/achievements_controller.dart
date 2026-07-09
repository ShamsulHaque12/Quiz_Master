import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Achievement {
  final String title;
  final String description;
  final String xpReward;
  final String rarity;
  final String emoji;
  final Color rarityColor;
  final Color iconBgColor;
  final bool isUnlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.xpReward,
    required this.rarity,
    required this.emoji,
    required this.rarityColor,
    required this.iconBgColor,
    required this.isUnlocked,
  });
}

class AchievementsController extends GetxController {
  final achievements = const [
    // Earned (Unlocked)
    Achievement(
      title: 'First Quiz',
      description: 'Complete your first quiz',
      xpReward: '+100 XP',
      rarity: 'Common',
      emoji: '🎯',
      rarityColor: Color(0xFF6B7280), // Grey
      iconBgColor: Color(0xFF3F1919),
      isUnlocked: true,
    ),
    Achievement(
      title: '100 Correct',
      description: 'Answer 100 questions correctly',
      xpReward: '+500 XP',
      rarity: 'Rare',
      emoji: '✅',
      rarityColor: Color(0xFF3B82F6), // Blue
      iconBgColor: Color(0xFF1E3A1E),
      isUnlocked: true,
    ),
    Achievement(
      title: '10-Day Streak',
      description: 'Play 10 consecutive days',
      xpReward: '+1000 XP',
      rarity: 'Epic',
      emoji: '🔥',
      rarityColor: Color(0xFF8B5CF6), // Purple
      iconBgColor: Color(0xFF3B1E05),
      isUnlocked: true,
    ),
    Achievement(
      title: 'Fast Learner',
      description: 'Finish a quiz in under 2 minutes',
      xpReward: '+300 XP',
      rarity: 'Uncommon',
      emoji: '⚡',
      rarityColor: Color(0xFF10B981), // Green
      iconBgColor: Color(0xFF3A3005),
      isUnlocked: true,
    ),
    Achievement(
      title: 'Sharp Mind',
      description: 'Answer 5 questions correctly in a row',
      xpReward: '+250 XP',
      rarity: 'Common',
      emoji: '🧠',
      rarityColor: Color(0xFF6B7280),
      iconBgColor: Color(0xFF3E1F30),
      isUnlocked: true,
    ),
    // Locked Achievements
    Achievement(
      title: 'Quiz Master',
      description: 'Score 100% in any category',
      xpReward: '2000 XP',
      rarity: 'Legendary',
      emoji: '👑',
      rarityColor: Color(0xFFF59E0B), // Gold
      iconBgColor: Color(0xFF1E293B),
      isUnlocked: false,
    ),
    Achievement(
      title: 'Knowledge Seeker',
      description: 'Play all 10 categories',
      xpReward: '800 XP',
      rarity: 'Rare',
      emoji: '🔍',
      rarityColor: Color(0xFF3B82F6),
      iconBgColor: Color(0xFF1E293B),
      isUnlocked: false,
    ),
    Achievement(
      title: 'Unstoppable',
      description: 'Maintain a 30-day streak',
      xpReward: '5000 XP',
      rarity: 'Legendary',
      emoji: '💎',
      rarityColor: Color(0xFFF59E0B),
      iconBgColor: Color(0xFF1E293B),
      isUnlocked: false,
    ),
    Achievement(
      title: 'Social Star',
      description: 'Share 10 quiz results',
      xpReward: '400 XP',
      rarity: 'Uncommon',
      emoji: '⭐',
      rarityColor: Color(0xFF10B981),
      iconBgColor: Color(0xFF1E293B),
      isUnlocked: false,
    ),
    Achievement(
      title: 'Coin Collector',
      description: 'Earn 1,000 coins total',
      xpReward: '600 XP',
      rarity: 'Rare',
      emoji: '🪙',
      rarityColor: Color(0xFF3B82F6),
      iconBgColor: Color(0xFF1E293B),
      isUnlocked: false,
    ),
  ];

  List<Achievement> get unlockedAchievements =>
      achievements.where((a) => a.isUnlocked).toList();

  List<Achievement> get lockedAchievements =>
      achievements.where((a) => !a.isUnlocked).toList();

  int get unlockedCount => unlockedAchievements.length;
  int get totalCount => achievements.length;
  double get progressRatio => totalCount == 0 ? 0.0 : unlockedCount / totalCount;
}
