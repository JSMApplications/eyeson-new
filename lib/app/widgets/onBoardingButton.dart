import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';

class OnBoardingButton extends StatelessWidget {
  final Function()? onTap;
  final String? btn_name;

  const OnBoardingButton({this.onTap, this.btn_name, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.themeColor,
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "$btn_name",
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
