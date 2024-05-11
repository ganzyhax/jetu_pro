import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderPaymendScreen extends StatefulWidget {
  final PanelController panelController;
  final JetuOrderModel model;

  const OrderPaymendScreen({
    Key? key,
    required this.panelController,
    required this.model,
  }) : super(key: key);

  @override
  State<OrderPaymendScreen> createState() => _OrderPaymendScreenState();
}

class _OrderPaymendScreenState extends State<OrderPaymendScreen> {
  bool ratingOneSelected = false;
  bool ratingTwoSelected = false;
  bool ratingThreeSelected = false;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      maxHeight: 0.5,
      panelController: widget.panelController,
      panel: Container(
        child: Column(
          children: [
            const BottomSheetTitle(
              title: 'Ожидание оплаты',
              isLargeTitle: true,
            ),
            const Text(
              'Как вам поездка?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            // const SizedBox(height: 2),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                log(rating.toString());
              },
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(
                    () => ratingOneSelected = !ratingOneSelected,
                  ),
                  child: Container(
                    width: 86.42,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: ratingOneSelected
                              ? Colors.amber
                              : Colors.black.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(9.60),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/rating_1.png',
                          width: 34,
                        ),
                        const Text(
                          'Приятная беседа',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                GestureDetector(
                  onTap: () => setState(
                    () => ratingTwoSelected = !ratingTwoSelected,
                  ),
                  child: Container(
                    width: 86.42,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: ratingTwoSelected
                              ? Colors.amber
                              : Colors.black.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(9.60),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/rating_2.png',
                          width: 34,
                        ),
                        const Text(
                          'Чистый салон',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                GestureDetector(
                  onTap: () => setState(
                    () => ratingThreeSelected = !ratingThreeSelected,
                  ),
                  child: Container(
                    width: 86.42,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: ratingThreeSelected
                              ? Colors.amber
                              : Colors.black.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(9.60),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/rating_3.png',
                          width: 34,
                        ),
                        const Text(
                          'Быстро довез',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 3.h),
            const Text(
              'Оплатите наличными',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Поездка',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${widget.model.cost ?? 'не указан'} тг',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Налог',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '+0.0 тг',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Итог:',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.model.cost ?? 'не указан'} ₸',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppButtonV1(
                onTap: () {
                  BlocProvider.of<YandexMapBloc>(context)
                    ..add(YandexMapStopStartTimer());
                  BlocProvider.of<YandexMapBloc>(context)
                    ..add(YandexMapClear(withLoad: true));
                  BlocProvider.of<YandexMapBloc>(context)
                    ..add(YandexMapResetTimers());
                  BlocProvider.of<YandexMapBloc>(context)
                    ..add(YandexMapLoad(isStart: true));
                  context
                      .read<OrderCubit>()
                      .finishOrder(widget.model.id, 'finished');
                },
                text: 'Оплачено')
            // SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
