import 'package:get/get.dart';
import '../models/leaderboard_user_model.dart';

class LeaderboardController extends GetxController {
  // Timeframe selector state
  final selectedTimeframe = 'Daily'.obs;

  // Timeframes list
  final timeframes = const ['Daily', 'Weekly', 'Monthly', 'All Time'];

  // Base list of users
  final _allUsers = const [
    LeaderboardUserModel(
      rank: '1',
      name: 'Rahim Ahmed',
      todayXp: '2,850',
      totalXp: '4,200 XP',
      avatar: '🦁',
    ),
    LeaderboardUserModel(
      rank: '2',
      name: 'Priya Sharma',
      todayXp: '2,720',
      totalXp: '3,980 XP',
      avatar: '🦊',
    ),
    LeaderboardUserModel(
      rank: '3',
      name: 'Karim Hassan',
      todayXp: '2,650',
      totalXp: '3,750 XP',
      avatar: '🐺',
    ),
    LeaderboardUserModel(
      rank: '4',
      name: 'Fatima Khan',
      todayXp: '2,580',
      totalXp: '3,600 XP',
      avatar: '🦅',
    ),
    LeaderboardUserModel(
      rank: '5',
      name: 'You',
      todayXp: '2,510',
      totalXp: '3,420 XP',
      avatar: '😊',
      isCurrentUser: true,
    ),
    LeaderboardUserModel(
      rank: '6',
      name: 'Sakib Al Hasan',
      todayXp: '2,480',
      totalXp: '3,300 XP',
      avatar: '🦋',
    ),
    LeaderboardUserModel(
      rank: '7',
      name: 'Mitu Begum',
      todayXp: '2,350',
      totalXp: '3,100 XP',
      avatar: '🦜',
    ),
  ];

  // Helper method to get the current period score based on the selected timeframe
  String getPeriodScore(LeaderboardUserModel user, String timeframe) {
    // Clean current value
    final cleanXp = int.parse(user.todayXp.replaceAll(',', ''));
    if (timeframe == 'Weekly') {
      return '${(cleanXp * 5.4).toInt()}';
    } else if (timeframe == 'Monthly') {
      return '${(cleanXp * 22.1).toInt()}';
    } else if (timeframe == 'All Time') {
      return '${(cleanXp * 85.6).toInt()}';
    }
    return user.todayXp;
  }

  // Reactive list of users for the selected timeframe
  List<LeaderboardUserModel> get leaderboard {
    final timeframe = selectedTimeframe.value;
    return _allUsers.map((user) {
      final periodScore = getPeriodScore(user, timeframe);
      // Format number with commas
      final formattedScore = _formatNumber(periodScore);
      return LeaderboardUserModel(
        rank: user.rank,
        name: user.name,
        todayXp: formattedScore,
        totalXp: user.totalXp,
        avatar: user.avatar,
        isCurrentUser: user.isCurrentUser,
      );
    }).toList();
  }

  // Podium list (Top 3)
  List<LeaderboardUserModel> get podium {
    final list = leaderboard;
    if (list.length >= 3) {
      // Return 2nd, 1st, 3rd to match podium layout order
      return [list[1], list[0], list[2]];
    }
    return [];
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
