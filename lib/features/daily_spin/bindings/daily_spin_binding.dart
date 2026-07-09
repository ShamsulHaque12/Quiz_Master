import 'package:get/get.dart';
import '../controllers/daily_spin_controller.dart';

class DailySpinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailySpinController>(() => DailySpinController());
  }
}
