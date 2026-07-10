import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:quiz_app/service/shared_prefarence_helper.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () async {
      final token = await SharedPreferenceHelper.getAccessToken();
      if (token != null && token.isNotEmpty) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        Get.offNamed(Routes.SIGN_IN);
      }
    });
  }
}
