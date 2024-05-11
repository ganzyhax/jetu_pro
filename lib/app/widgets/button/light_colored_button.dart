import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LightColoredButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onPressed;

  const LightColoredButton(
      {required this.icon,
      required this.text,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
