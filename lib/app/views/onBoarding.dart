import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/onBoardingButton.dart';
import 'package:eyeson/app/widgets/onBoardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  // Controller for On-Boarding Screens
  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              // on-Boarding-Screen
              OnBoardingScreen(
                imagePath: "assets/onBroad.gif",
                title: "Discover restaurants on the go",
                subTitle:
                    "You can instantly search, browse and buy or buy best Restaurants all over",
              ),
              // on-Boarding-Screen
              OnBoardingScreen(
                imagePath: "assets/scantranslate.gif",
                title: "Scan and translate text anything anytime",
                subTitle:
                    "You can instantly search, browse and buy or buy best Restaurants all over",
              ),
              // on-Boarding-Screen
              OnBoardingScreen(
                imagePath: "assets/searchanimation.gif",
                title: "Search what you see",
                subTitle:
                    "You can instantly search, browse and buy or buy best Restaurants all over",
              ),
            ],
          ),

          // Skip button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 20),
                child: GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Next/Done button
          Container(
            alignment: Alignment(0, 0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(controller: _controller, count: 3),
                SizedBox(height: 20),
                OnBoardingButton(
                  onTap: () {
                    if (onLastPage) {
                      // Navigate to next screen
                      Get.toNamed(AppRoutesPath.HOME);
                    } else {
                      // To next screen
                      _controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  btn_name: onLastPage ? "Done" : "Next",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
