import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;
  final bool isLargeTitle;

  const BottomSheetTitle({
    Key? key,
    required this.title,
    this.isLargeTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(height: 12.h)
        ],
      ),
    );
  }
}
