import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Color? bgColor;
  final size;
  const ActionButton({
    this.icon,
    this.label,
    this.bgColor,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.45,
      height: size.height * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon, size: size.width * 0.06, color: Colors.black),
            backgroundColor: AppTheme.transparentColor,
          ),
          SizedBox(height: 4),
          Text("$label",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
