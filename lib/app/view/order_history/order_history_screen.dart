import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/resourses/app_icons.dart';
import 'package:jetu/app/view/order_history/bloc/order_history_cubit.dart';
import 'package:jetu/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu/app/widgets/app_loader.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryCubit(
        client: injection(),
      )..init(),
      child: Scaffold(
        appBar: const AppBarBack(
          title: "История заказов",
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const AppLoader();
                  }
                  if (state.orderList.isEmpty) {
                    return Center(
                      child: Text(
                        'Пока вы еще не сделали ни одной поездки',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: state.orderList.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    itemBuilder: (context, index) {
                      final order = state.orderList[index];
                      String currency =
                          (order.currency.toString().contains('Kaspi'))
                              ? ' тг, Kaspi Bank'
                              : (order.currency.toString().contains('Halyk'))
                                  ? 'Halyk Bank'
                                  : 'Наличные';
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.w,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: ListTile(
                          horizontalTitleGap: 0,
                          contentPadding: const EdgeInsets.all(0),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusText(order.status ?? ''),
                                style: TextStyle(
                                  color: statusColor(order.status ?? ''),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.pointAIcon,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      order.aPointAddress ?? '',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.pointBIcon,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      order.bPointAddress ?? '',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: order.cost,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' тг , ' + currency,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    DateFormat('d MMM в HH:mm', 'ru')
                                        .format(order.createdAt!),
                                    style: TextStyle(
                                      color: AppColors.black.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Divider(
                          thickness: 1.h,
                          color: AppColors.white.withOpacity(0.2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'finished':
        return AppColors.green;
      case 'canceled':
        return AppColors.red;
      default:
        return AppColors.blue;
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'finished':
        return 'Выполнен';
      case 'canceled':
        return 'Отменен';
      default:
        return 'Не указан';
    }
  }
}
