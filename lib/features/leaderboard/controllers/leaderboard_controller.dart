import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> getLeaderboard() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .order('total_score', ascending: false);

      debugPrint("Leaderboard response: $response");
      debugPrint("Leaderboard count: ${response.length}");

      users.value = response
          .map((e) => LeaderboardModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
    }
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
    final currentUser = Supabase.instance.client.auth.currentUser;

    return List.generate(users.length, (index) {
      final user = users[index];
      final rank = index + 1;
      final isCurrentUser = currentUser != null && user.id == currentUser.id;

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
