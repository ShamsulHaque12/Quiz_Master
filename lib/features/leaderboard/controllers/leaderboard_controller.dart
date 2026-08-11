import 'package:get/get.dart';
import '../models/leaderboard_model.dart';

class LeaderboardController extends GetxController {
  // Timeframe selector state
  final selectedTimeframe = 'Daily'.obs;

  // Timeframes list
  final timeframes = const ['Daily', 'Weekly', 'Monthly', 'All Time'];

  // Base list of users
  RxList<LeaderboardModel> users = <LeaderboardModel>[].obs;

  @override
  void onInit() {
    getLeaderboard();
    super.onInit();
  }

  void getLeaderboard() {
    // Populate rich mock leaderboard for pure UI demo
    users.value = [
      const LeaderboardModel(
        id: '1',
        fullName: 'Sophia Vance',
        totalScore: 2450,
        xp: 1450,
        coin: 520,
      ),
      const LeaderboardModel(
        id: '2',
        fullName: 'David Kim',
        totalScore: 2180,
        xp: 1280,
        coin: 410,
      ),
      const LeaderboardModel(
        id: '3',
        fullName: 'Marcus Roy',
        totalScore: 1920,
        xp: 1120,
        coin: 360,
      ),
      const LeaderboardModel(
        id: '4',
        fullName: 'Elena Rostova',
        totalScore: 1750,
        xp: 980,
        coin: 290,
      ),
      const LeaderboardModel(
        id: '5',
        fullName: 'Quiz Master (You)',
        totalScore: 1540,
        xp: 850,
        coin: 250,
      ),
      const LeaderboardModel(
        id: '6',
        fullName: 'Liam Chen',
        totalScore: 1320,
        xp: 740,
        coin: 210,
      ),
      const LeaderboardModel(
        id: '7',
        fullName: 'Chloe Bennett',
        totalScore: 1150,
        xp: 620,
        coin: 180,
      ),
      const LeaderboardModel(
        id: '8',
        fullName: 'Alexander Wright',
        totalScore: 980,
        xp: 510,
        coin: 140,
      ),
    ];
  }

  // Helper method to get the current period score based on the selected timeframe
  int getPeriodScore(LeaderboardModel user, String timeframe) {
    if (timeframe == 'Weekly') {
      return (user.totalScore * 5.4).toInt();
    } else if (timeframe == 'Monthly') {
      return (user.totalScore * 22.1).toInt();
    } else if (timeframe == 'All Time') {
      return (user.totalScore * 85.6).toInt();
    }
    return user.totalScore;
  }

  // Reactive list of users for the selected timeframe
  List<LeaderboardModel> get leaderboard {
    final timeframe = selectedTimeframe.value;

    return List.generate(users.length, (index) {
      final user = users[index];
      final rank = index + 1;
      final isCurrentUser = (user.fullName ?? '').contains('(You)');

      String avatar = '😊';
      final emojis = ['🦁', '🦊', '🐺', '🦅', '🐹', '🐼', '🐯', '🐨'];
      avatar = emojis[index % emojis.length];

      final periodScore = getPeriodScore(user, timeframe);
      final formattedScore = _formatNumber(periodScore.toString());

      return user.copyWith(
        rank: rank.toString(),
        avatar: avatar,
        isCurrentUser: isCurrentUser,
        todayXp: formattedScore,
      );
    });
  }

  // Podium list (Top 3)
  List<LeaderboardModel> get podium {
    return leaderboard;
  }

  void changeTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
  }

  String _formatNumber(String numberString) {
    final number = int.tryParse(numberString) ?? 0;
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
