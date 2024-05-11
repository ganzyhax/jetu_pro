import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jetu/app/resourses/app_colors.dart';

class AppToast {
  static void center(String? text) async {
    Fluttertoast.showToast(
      msg: text ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.grey.withOpacity(0.6),
      textColor: Colors.black,
      fontSize: 16.0.sp,
    );
  }

  static void bottom(String? text) async {
    Fluttertoast.showToast(
      msg: text ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.black.withOpacity(0.6),
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
  }
}
