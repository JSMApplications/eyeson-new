import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';

class FoodCategory extends StatelessWidget {
  final String? name;
  final size;
  const FoodCategory({this.name, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicWidth(
        child: Container(
          // width: size.width * 0.25,
          height: size.height * 0.06,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.FontColor,
              style: BorderStyle.solid,
              width: 0.2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.dimwhiteColor,
            boxShadow: [
              BoxShadow(
                color: AppTheme.blackColor.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$name",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.FontColor,
                fontSize: size.width * 0.04,
                // height: 2.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
