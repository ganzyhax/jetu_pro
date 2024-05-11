import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/data/model/jetu_services_model.dart';

class JetuSelectCard extends StatelessWidget {
  final JetuServicesModel model;
  final bool isSelected;
  final VoidCallback? onTap;

  const JetuSelectCard({
    Key? key,
    required this.model,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        width: 110,
        margin: EdgeInsets.only(left: 5.w),
        padding: EdgeInsets.all(2.sp),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: isSelected ? AppColors.blue : AppColors.transparent,
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 15,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/${model.icon ?? ''}',
              height: model.height,
              width: model.width,
              fit: BoxFit.contain,
            ),
            Text(
              model.title ?? '',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
