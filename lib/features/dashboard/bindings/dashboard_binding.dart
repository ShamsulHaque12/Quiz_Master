import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../../home/bindings/home_binding.dart';
import '../../leaderboard/bindings/leaderboard_binding.dart';
import '../../profile/bindings/profile_binding.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<QuizController>(() => QuizController());
    
    // Load tab bindings
    HomeBinding().dependencies();
    LeaderboardBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
