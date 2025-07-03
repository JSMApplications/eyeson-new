import 'dart:async';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    Timer(Duration(seconds: 4), () {
      Get.offAllNamed(AppRoutesPath.ONBOARDING);
    });
    super.onInit();
  }
}
