import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/app_loader.dart';

class AppButtonV1 extends StatelessWidget {
  final bool isActive;
  final bool isLoading;
  final double height;
  final String text;
  final TextStyle? textStyle;
  final Color? bgColor;
  final Color? inActiveColor;
  final Color? inActiveTextColor;
  final VoidCallback? onTap;

  const AppButtonV1({
    Key? key,
    this.isActive = true,
    this.isLoading = false,
    this.height = 46,
    required this.text,
    this.textStyle,
    this.bgColor,
    this.inActiveColor,
    this.inActiveTextColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive
          ? !isLoading
              ? onTap?.call()
              : null
          : null,
      child: Container(
        height: height.h,
        decoration: BoxDecoration(
          color: isActive
              ? bgColor ?? AppColors.blue
              : inActiveColor ??
                  bgColor?.withOpacity(0.6) ??
                  AppColors.blue.withOpacity(0.6),
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
                      color: isActive
                          ? AppColors.white
                          : inActiveTextColor ?? AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
