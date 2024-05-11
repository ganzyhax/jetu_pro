import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu/app/view/order/alert_fare/liner_card_alert.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/button/app_button_v2.dart';
import 'package:jetu/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu/app/widgets/list_item/user_avatar.dart';
import 'package:jetu/app/widgets/verified.dart';
import 'package:jetu/data/model/jetu_alert_fare_model.dart';

class AlertFareScreen extends StatefulWidget {
  final String orderId;

  const AlertFareScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<AlertFareScreen> createState() => _AlertFareScreenState();
}

class _AlertFareScreenState extends State<AlertFareScreen> {
  @override
  Widget build(BuildContext context) {
    return SubscriptionWrapper<JetuAlertFareList>(
      queryString: JetuOrderSubscription.subscribeAlertOrderFare(),
      variables: {
        "orderId": widget.orderId,
      },
      dataParser: (json) => JetuAlertFareList.fromUserJson(json),
      contentBuilder: (JetuAlertFareList data) {
        
        if (data.orders.isNotEmpty) {
          return SafeArea(
            bottom: false,
            child: Container(
              color: AppColors.black.withOpacity(0.6),
              height: context.sizeScreen.height,
              width: context.sizeScreen.width,
              child: ListView.builder(
                itemCount: data.orders.length,
                itemBuilder: (_, index) {
                  JetuAlertFareModel model = data.orders[index];

                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvatar(avatarUrl: model.driver?.avatarUrl),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${model.driver?.carModel ?? ''} ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    VerifiedIcon(
                                      isVerified:
                                          model.driver?.isVerified ?? false,
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
                                SizedBox(height: 5.h),
                                Text(
                                  '⭐ ${model.driver?.rating ?? ''} ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${model.cost ?? ''} ₸',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<OrderCubit>().rejectAlertFare(
                                        model.id,
                                      );
                                },
                                child: AppButtonV2(
                                  text: 'Отклонить',
                                  height: 30.h,
                                  borderColor: AppColors.black,
                                  textStyle: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AppButtonV1(
                                height: 30.h,
                                onTap: () {
                                  context
                                      .read<OrderCubit>()
                                      .acceptAlertFare(model, widget.orderId);
                                },
                                text: 'Принять',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LinearAnimationCard(
                          orderId: model.id,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Text('');
      },
    );
  }
}
