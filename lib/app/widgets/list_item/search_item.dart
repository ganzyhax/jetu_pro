import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/bottom_sheet/place_confirm_sheet_view.dart';
import 'package:jetu/data/app/full_location.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../resourses/app_icons.dart';

class LocationSearchResultItem extends StatelessWidget {
  final location;

  final Function() onSelected;

  const LocationSearchResultItem(
      {required this.location, required this.onSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // final result = await showBarModalBottomSheet<FullLocation>(
        //     context: context,
        //     enableDrag: false,
        //     builder: (context) {
        //       return PlaceConfirmSheetView(location);
        //     });
        // if (result == null) return;
        onSelected.call();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppIcons.placeSearchIcon,
                color: AppColors.black.withOpacity(0.6),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['adress'] ?? '',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 245,
                          child: Text(
                            location['fullAdress'] ?? '',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          location['distance'] ?? '',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: AppColors.black.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
