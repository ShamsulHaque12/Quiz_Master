import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Also lazy put QuizController so categories tab has immediate access to general config if needed
    Get.lazyPut<QuizController>(() => QuizController());
  }
}
