import 'package:get/get.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/home/home_page.dart';
import '../pages/check/check_page.dart';
import '../pages/report/report_page.dart';
import '../pages/report/report_detail_page.dart';
import '../pages/report/history_page.dart';
import '../pages/onboarding/onboarding_controller.dart';
import '../pages/home/home_controller.dart';
import '../pages/check/check_controller.dart';
import '../pages/report/report_controller.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingController());
      }),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
    GetPage(
      name: Routes.CHECK,
      page: () => const CheckPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CheckController());
        // 确保ReportController存在以保存检测报告
        if (!Get.isRegistered<ReportController>()) {
          Get.put(ReportController(), permanent: true);
        }
      }),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => const ReportPage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ReportController>()) {
          Get.put(ReportController(), permanent: true);
        }
      }),
    ),
    GetPage(
      name: Routes.REPORT_DETAIL,
      page: () => const ReportDetailPage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ReportController>()) {
          Get.put(ReportController(), permanent: true);
        }
      }),
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryPage(),
      binding: BindingsBuilder(() {
        // 确保控制器单例存在
        if (!Get.isRegistered<ReportController>()) {
          Get.put(ReportController(), permanent: true);
        }
      }),
    ),
  ];
}
