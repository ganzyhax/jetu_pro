import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu/app/widgets/list_item/order_item.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderStartedScreen extends StatelessWidget {
  final PanelController panelController;
  final JetuOrderModel model;

  const OrderStartedScreen({
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
          const BottomSheetTitle(
            title: 'Направление к месту назначение',
          ),
          OrderItem(
            model: model,
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
          const SizedBox(height: 5),
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
              print(rating);
            },
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
