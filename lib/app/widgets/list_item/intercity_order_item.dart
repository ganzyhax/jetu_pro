import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/intercity/bloc/intercity_cubit.dart';
import 'package:jetu/app/widgets/button/rounded_button.dart';
import 'package:jetu/app/widgets/list_item/user_avatar.dart';
import 'package:jetu/app/widgets/verified.dart';
import 'package:url_launcher/url_launcher.dart';

class IntercityOrderItem extends StatelessWidget {
  final IntercityOrderModel model;

  const IntercityOrderItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(avatarUrl: model.driver?.avatarUrl),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    VerifiedIcon(
                      isVerified: model.driver?.isVerified ?? false,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      model.driver?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '⭐ ${model.driver?.rating ?? ''} ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    model.aPoint?.title ?? 'не указан',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    model.bPoint?.title ?? 'не указан',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${model.price ?? 'не указан'} ₸',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${DateFormat('dd MMM. yyyy').format(model.date!)}, ${DateFormat('HH:mm').format(model.time!)}',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    model.comment ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  const Divider(),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            RoundedButton(
              icon: Ionicons.call,
              onPressed: () => launchUrl(
                Uri.parse("tel://${model.driver?.phone}"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
