import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';

class StatPoint {
  final String label;
  final double value;

  const StatPoint(this.label, this.value);
}

class StatisticsController extends GetxController {
  final selectedTimeframe = 'Weekly'.obs; // Default to Weekly
  final timeframes = const ['Daily', 'Weekly', 'Monthly'];

  // Summary Metrics
  final totalQuizzes = '148'.obs;
  final avgAccuracy = '84%'.obs;
  final totalXP = '4,850'.obs;
  
  String get totalCoins {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>().coinCount.value.toString();
    }
    return '320';
  }

  // Mock Data Points
  final dailyData = const [
    StatPoint('08:00', 50),
    StatPoint('10:00', 120),
    StatPoint('12:00', 80),
    StatPoint('14:00', 200),
    StatPoint('16:00', 150),
    StatPoint('18:00', 300),
    StatPoint('20:00', 220),
  ];

  final weeklyData = const [
    StatPoint('Mon', 320),
    StatPoint('Tue', 450),
    StatPoint('Wed', 300),
    StatPoint('Thu', 620),
    StatPoint('Fri', 480),
    StatPoint('Sat', 700),
    StatPoint('Sun', 850),
  ];

  final monthlyData = const [
    StatPoint('Week 1', 1200),
    StatPoint('Week 2', 1800),
    StatPoint('Week 3', 1500),
    StatPoint('Week 4', 2400),
  ];

  List<StatPoint> get currentChartData {
    switch (selectedTimeframe.value) {
      case 'Daily':
        return dailyData;
      case 'Monthly':
        return monthlyData;
      case 'Weekly':
      default:
        return weeklyData;
    }
  }

  void changeTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
  }
}
