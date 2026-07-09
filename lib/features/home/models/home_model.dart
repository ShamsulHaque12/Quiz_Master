class ChallengeModel {
  final String title;
  final String category;
  final int questionsCount;
  final int timeMinutes;
  final bool hasStreakBonus;

  ChallengeModel({
    required this.title,
    required this.category,
    required this.questionsCount,
    required this.timeMinutes,
    required this.hasStreakBonus,
  });
}
