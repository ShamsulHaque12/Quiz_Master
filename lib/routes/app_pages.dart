import 'package:get/get.dart';
import '../features/auth/sign_in/bindings/sign_in_binding.dart';
import '../features/auth/sign_in/views/sign_in_view.dart';
import '../features/auth/sign_up/bindings/sign_up_binding.dart';
import '../features/auth/sign_up/views/sign_up_view.dart';
import '../features/dashboard/bindings/dashboard_binding.dart';
import '../features/dashboard/views/dashboard_view.dart';
import '../features/quiz/bindings/quiz_binding.dart';
import '../features/quiz/views/quiz_view.dart';
import '../features/daily_spin/bindings/daily_spin_binding.dart';
import '../features/daily_spin/views/daily_spin_view.dart';
import '../features/statistics/bindings/statistics_binding.dart';
import '../features/statistics/views/statistics_view.dart';
import '../features/achievements/bindings/achievements_binding.dart';
import '../features/achievements/views/achievements_view.dart';
import '../features/settings/bindings/settings_binding.dart';
import '../features/settings/views/settings_view.dart';
import '../features/edit_profile/bindings/edit_profile_binding.dart';
import '../features/edit_profile/views/edit_profile_view.dart';
import '../features/change_password/bindings/change_password_binding.dart';
import '../features/change_password/views/change_password_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;

  static final routes = [
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.DAILY_SPIN,
      page: () => const DailySpinView(),
      binding: DailySpinBinding(),
    ),
    GetPage(
      name: _Paths.STATISTICS,
      page: () => const StatisticsView(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: _Paths.ACHIEVEMENTS,
      page: () => const AchievementsView(),
      binding: AchievementsBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
  ];
}
