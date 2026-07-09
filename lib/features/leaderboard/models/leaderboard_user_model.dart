class LeaderboardUserModel {
  final String rank;
  final String name;
  final String todayXp;
  final String totalXp;
  final String avatar;
  final bool isCurrentUser;

  const LeaderboardUserModel({
    required this.rank,
    required this.name,
    required this.todayXp,
    required this.totalXp,
    required this.avatar,
    this.isCurrentUser = false,
  });
}
