import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/app/view/order/bloc/order_state.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LookingScreen extends StatelessWidget {
  final PanelController panelController;
  final JetuOrderModel orderModel;

  const LookingScreen({
    Key? key,
    required this.panelController,
    required this.orderModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return AppBottomSheet(
          panelController: panelController,
          panel: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.all(16),
              top: false,
              child: Column(
                children: [
                  const BottomSheetTitle(
                    isLargeTitle: true,
                    title: "Поездка запрошена",
                  ),
                  const LinearProgressIndicator(
                    color: AppColors.white,
                    backgroundColor: AppColors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonV1(
                          onTap: () {
                            context.read<OrderCubit>().decreaseFare();
                          },
                          height: 30.h,
                          isActive: state.showFareButton,
                          inActiveColor: AppColors.blue.withOpacity(0.6),
                          inActiveTextColor: AppColors.white.withOpacity(0.6),
                          text: '-50',
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Text(
                        '${state.currentFare} ₸',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: AppButtonV1(
                          onTap: () {
                            context.read<OrderCubit>().increaseFare();
                          },
                          height: 30.h,
                          isActive: true,
                          inActiveColor: AppColors.blue.withOpacity(0.6),
                          inActiveTextColor: AppColors.white.withOpacity(0.6),
                          text: '+50',
                        ),
                      ),
                    ],
                  ),
                  Lottie.asset(
                    'assets/lottie/car_anim.json',
                    height: context.sizeScreen.height * 0.12,
                    width: context.sizeScreen.width,
                  ),
                  SizedBox(height: 14.h),
                  AppButtonV1(
                    onTap: () {
                      context.read<OrderCubit>().setNewFare();
                    },
                    isActive: state.showFareButton,
                    inActiveColor: AppColors.blue.withOpacity(0.6),
                    inActiveTextColor: AppColors.white.withOpacity(0.6),
                    text: 'Изменить стоимость',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
