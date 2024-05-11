import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/app_loader.dart';

class AppButtonV2 extends StatelessWidget {
  final bool isLoading;
  final String text;
  final double height;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Color? bgColor;

  const AppButtonV2({
    Key? key,
    this.isLoading = false,
    required this.text,
    this.height = 46,
    this.textStyle,
    this.borderColor,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const AppLoader()
          else
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
        ],
      ),
    );
  }
}
