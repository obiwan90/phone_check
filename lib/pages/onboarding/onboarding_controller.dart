import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  void goToHome() {
    Get.offAllNamed('/home');
  }
}
