import 'package:eyeson/app/controller/splash_controller.dart';
import 'package:eyeson/app/themes/apptheme.dart';
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
      decoration: BoxDecoration(color: AppTheme.whiteColor),
      child: Center(
        child: Image.asset(
          "assets/logo.gif",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
