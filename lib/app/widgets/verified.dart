import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';

class VerifiedIcon extends StatelessWidget {
  final bool isVerified;

  const VerifiedIcon({Key? key, this.isVerified = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVerified) {
      return Icon(
        Icons.verified,
        size: 18.sp,
        color: AppColors.blue,
      );
    }
    return const SizedBox.shrink();
  }
}
