import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? subTitle;
  final bool imageHeight;

  const OnBoardingScreen({
    this.imagePath,
    this.title,
    this.subTitle,
    this.imageHeight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return imageHeight
        ? Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: imagePath == "assets/sp3.png"
                  ? const Color(0xff7d64df)
                  : AppTheme.blackColor,
              // image: DecorationImage(
              //     image: AssetImage("${imagePath}"), fit: BoxFit.fill)
            ),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage("${imagePath}"), fit: BoxFit.fill)),
                )
              ],
            ),
          )
        : Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                image: DecorationImage(
                    image: AssetImage("${imagePath}"), fit: BoxFit.fill)),
          );
  }
}








 // child: Padding(
      //   // padding: const EdgeInsets.all(16),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset(
      //         "$imagePath",
      //         fit: BoxFit.fill,
      //         // width: 300,
      //         // height: 300,
      //       ),
      //       // Text(
      //       //   "$title",
      //       //   style: TextStyle(
      //       //     fontSize: 25,
      //       //     fontWeight: FontWeight.w600,
      //       //     color: AppTheme.themeColor,
      //       //   ),
      //       //   textAlign: TextAlign.center,
      //       // ),
      //       // SizedBox(height: 20),
      //       // Container(
      //       //   // height: 150,
      //       //   padding: EdgeInsets.symmetric(vertical: 20),
      //       //   child: DefaultTextStyle(
      //       //     style: TextStyle(
      //       //       fontSize: 30,
      //       //       fontWeight: FontWeight.w600,
      //       //       color: AppTheme.themeColor,
      //       //     ),
      //       //     textAlign: TextAlign.center,
      //       //     child: AnimatedTextKit(
      //       //       repeatForever: true,
      //       //       pause: const Duration(milliseconds: 150),
      //       //       isRepeatingAnimation: true,
      //       //       animatedTexts: [
      //       //         TypewriterAnimatedText(
      //       //           textAlign: TextAlign.center,
      //       //           "$title",
      //       //           speed: const Duration(milliseconds: 200),
      //       //         ),
      //       //       ],
      //       //     ),
      //       //   ),
      //       // ),
      //       // Container(
      //       //   height: 60,
      //       //   padding: EdgeInsets.symmetric(vertical: 20),
      //       //   child: DefaultTextStyle(
      //       //     style: TextStyle(
      //       //       fontSize: 16,
      //       //       color: AppTheme.FontColor,
      //       //     ),
      //       //     textAlign: TextAlign.center,
      //       //     child: AnimatedTextKit(
      //       //       repeatForever: true,
      //       //       pause: const Duration(milliseconds: 150),
      //       //       isRepeatingAnimation: true,
      //       //       animatedTexts: [
      //       //         TypewriterAnimatedText(
      //       //           textAlign: TextAlign.center,
      //       //           "$subTitle",
      //       //           speed: const Duration(milliseconds: 200),
      //       //         ),
      //       //       ],
      //       //     ),
      //       //   ),
      //       // ),
      //       // Text(
      //       //   "$subTitle",
      //       //   style: TextStyle(
      //       //     fontSize: 16,
      //       //     color: AppTheme.FontColor,
      //       //   ),
      //       //   textAlign: TextAlign.center,
      //       // ),
      //     ],
      //   ),
      // ),