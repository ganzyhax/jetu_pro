import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/button/rounded_button.dart';
import 'package:jetu/app/widgets/verified.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resourses/app_icons.dart';

class OrderItem extends StatelessWidget {
  final JetuOrderModel model;
  final VoidCallback? onTap;
  final bool showPhone;

  const OrderItem({
    Key? key,
    required this.model,
    this.onTap,
    this.showPhone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (model.driver?.avatarUrl == '' ||
                        model.driver?.avatarUrl == null)
                    ? Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: AssetImage('assets/images/jetu_logo.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      )
                    : Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(
                                model.driver!.avatarUrl.toString()),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.sizeScreen.width * 0.4,
                          child: Text(
                            "${model.driver?.name ?? "Не указано"} ${model.driver?.surname ?? ""}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        VerifiedIcon(
                            isVerified: model.driver?.isVerified ?? false)
                      ],
                    ),
                    if (model.createdAt != null ?? false)
                      Text(
                        DateFormat('HH:mm a').format(model.createdAt!),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 4.w),
                Text(
                  '⭐ ${model.driver?.rating ?? ''} ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (showPhone) ...[
                  const Spacer(),
                  SizedBox(width: 12.w),
                  RoundedButton(
                    icon: Ionicons.call,
                    onPressed: () => launchUrl(
                      Uri.parse("tel://${model.driver?.phone}"),
                    ),
                  )
                ]
              ],
            ),
            SizedBox(
              width: context.sizeScreen.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.pointAIcon),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          model.aPointAddress ?? 'не указан',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.pointBIcon),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          model.bPointAddress ?? 'не указан',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Image.asset(
                        AppIcons.cashIcon,
                        width: 24,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Оплата наличными: ${model.cost ?? 'не указан'} тг',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

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
                  // const Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
