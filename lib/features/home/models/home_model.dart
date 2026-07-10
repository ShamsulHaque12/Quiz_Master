class HomeUserModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final int xp;
  final int coin;
  final int level;
  final int streak; // Maps to database 'streak_day'
  final String? createdAt;
  final String? updatedAt;
  final int accuracy;
  final int bestScore;
  final int totalScore;
  final int totalQuiz;
  final String? lastSpinAt;
  final String? lastStreakClaim;

  HomeUserModel({
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
    this.lastSpinAt,
    this.lastStreakClaim,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) {
    return HomeUserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      xp: json['xp'] ?? 0,
      coin: json['coin'] ?? 0,
      level: json['level'] ?? 1,
      streak: json['streak_day'] ?? 0, // Mapped from streak_day
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accuracy: json['accuracy'] ?? 0,
      bestScore: json['best_score'] ?? 0,
      totalScore: json['total_score'] ?? 0,
      totalQuiz: json['total_quiz'] ?? 0,
      lastSpinAt: json['last_spin_at'],
      lastStreakClaim: json['last_streak_claim'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'xp': xp,
      'coin': coin,
      'level': level,
      'streak_day': streak, // Mapped to streak_day
      'created_at': createdAt,
      'updated_at': updatedAt,
      'accuracy': accuracy,
      'best_score': bestScore,
      'total_score': totalScore,
      'total_quiz': totalQuiz,
      'last_spin_at': lastSpinAt,
      'last_streak_claim': lastStreakClaim,
    };
  }

  HomeUserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    int? xp,
    int? coin,
    int? level,
    int? streak,
    String? createdAt,
    String? updatedAt,
    int? accuracy,
    int? bestScore,
    int? totalScore,
    int? totalQuiz,
    String? lastSpinAt,
    String? lastStreakClaim,
  }) {
    return HomeUserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      coin: coin ?? this.coin,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accuracy: accuracy ?? this.accuracy,
      bestScore: bestScore ?? this.bestScore,
      totalScore: totalScore ?? this.totalScore,
      totalQuiz: totalQuiz ?? this.totalQuiz,
      lastSpinAt: lastSpinAt ?? this.lastSpinAt,
      lastStreakClaim: lastStreakClaim ?? this.lastStreakClaim,
    );
  }

  String get displayName => fullName ?? email?.split('@').first ?? 'User';
}
