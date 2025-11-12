import 'package:eyeson/app/controller/splash_controller.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/views/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // Splash screen controller
  SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    // Size for Responsiveness
    final Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            color: AppTheme.blackColor,
            image: DecorationImage(image: AssetImage("assets/eye-main.png"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: Get.width * 0.9,
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(100)),
              color: AppTheme.themeColor,
              onPressed: () {
                Get.to(() => OnBoarding());
              },
              child: Text("Get Started", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: Get.height * 0.1),
          ],
        ));
  }
}
