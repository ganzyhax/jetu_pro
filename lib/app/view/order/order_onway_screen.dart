import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/list_item/order_item.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../resourses/app_colors.dart';
import '../../widgets/button/app_button_v2.dart';
import '../home/bloc_old/home_cubit.dart';

class OrderOnWayScreen extends StatelessWidget {
  final PanelController panelController;
  final JetuOrderModel model;

  const OrderOnWayScreen({
    Key? key,
    required this.panelController,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      panelController: panelController,
      panel: Column(
        children: [
          BottomSheetTitle(
            title: 'Водитель в пути ',
          ),
          Text(
            ' ${model.driver?.carColor} ${model.driver?.carModel} ${model.driver?.carNumber}',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
          OrderItem(
            model: model,
            showPhone: true,
          ),
          AppButtonV1(
            onTap: () {
              context.read<HomeCubit>().cancelOrder(
                    order: model,
                  );
            },
            isActive: true,
            bgColor: AppColors.red.withOpacity(0.3),
            text: 'Отменить заказ',
          ),
          // SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
