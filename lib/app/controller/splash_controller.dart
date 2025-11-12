import 'dart:async';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // bool isIntro = await sharedPreferences.getBool("@isIntro") ?? false;
    // Timer(Duration(seconds: 4), () {
    //   if (isIntro) {
    //     Get.offAllNamed(AppRoutesPath.HOME);
    //   } else {
    //     Get.offAllNamed(AppRoutesPath.ONBOARDING);
    //   }
    // });
    super.onInit();
  }
}
