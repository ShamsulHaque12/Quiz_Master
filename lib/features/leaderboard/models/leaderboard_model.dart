class LeaderboardModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final int xp;
  final int coin;
  final int level;
  final int streak;
  final String? createdAt;
  final String? updatedAt;
  final int accuracy;
  final int bestScore;
  final int totalScore;
  final int totalQuiz;

  // UI properties
  final String rank;
  final String avatar;
  final bool isCurrentUser;
  final String todayXp; // formatted period score

  const LeaderboardModel({
    required this.id,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.xp = 0,
    this.coin = 0,
    this.level = 1,
    this.streak = 0,
    this.createdAt,
    this.updatedAt,
    this.accuracy = 0,
    this.bestScore = 0,
    this.totalScore = 0,
    this.totalQuiz = 0,
    this.rank = '',
    this.avatar = '😊',
    this.isCurrentUser = false,
    this.todayXp = '0',
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      xp: json['xp'] ?? 0,
      coin: json['coin'] ?? 0,
      level: json['level'] ?? 1,
      streak: json['streak'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accuracy: json['accuracy'] ?? 0,
      bestScore: json['best_score'] ?? 0,
      totalScore: json['total_score'] ?? 0,
      totalQuiz: json['total_quiz'] ?? 0,
    );
  }

  LeaderboardModel copyWith({
    String? rank,
    String? avatar,
    bool? isCurrentUser,
    String? todayXp,
  }) {
    return LeaderboardModel(
      id: id,
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      xp: xp,
      coin: coin,
      level: level,
      streak: streak,
      createdAt: createdAt,
      updatedAt: updatedAt,
      accuracy: accuracy,
      bestScore: bestScore,
      totalScore: totalScore,
      totalQuiz: totalQuiz,
      rank: rank ?? this.rank,
      avatar: avatar ?? this.avatar,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      todayXp: todayXp ?? this.todayXp,
    );
  }

  String get displayName => isCurrentUser ? 'You' : (fullName ?? 'User');
  String get name => displayName;
}
