import 'package:get/get.dart';
import '../../../core/utils/logger.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("🚀 SPLASH: onInit called");
  }

  @override
  void onReady() {
    super.onReady();
    print("🚀 SPLASH: onReady called - Starting app logic");
    _startApp();
  }

  void _startApp() async {
    // 1. Minimum 3 seconds delay for Splash screen logo
    print("🚀 SPLASH: Waiting 3 seconds...");
    await Future.delayed(const Duration(seconds: 3));

    try {
      bool isLoggedIn = false;
      
      if (Get.isRegistered<AuthService>()) {
        isLoggedIn = Get.find<AuthService>().isLoggedIn;
        print("🚀 SPLASH: AuthService status found: LoggedIn = $isLoggedIn");
        logger.i("Splash: AuthService found. LoggedIn = $isLoggedIn");
      } else {
        print("🚀 SPLASH: AuthService NOT registered yet!");
        logger.w("Splash: AuthService NOT registered yet!");
      }

      if (isLoggedIn) {
        print("🚀 SPLASH: Navigating to HOME");
        Get.offAllNamed(Routes.HOME);
      } else {
        print("🚀 SPLASH: Navigating to LOGIN");
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      print("❌ SPLASH ERROR: $e");
      logger.e("Splash Logic Error: $e");
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
