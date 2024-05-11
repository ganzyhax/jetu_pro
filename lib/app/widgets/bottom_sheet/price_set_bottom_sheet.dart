import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PriceSetBottomSheet {
  static Future<String?> open(
    BuildContext context, {
    required TextEditingController controller,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context,
      expand: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        const String _userPostfix = " ₸";

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.viewScreen.bottom + 10.h,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5.h),
                    Container(
                      width: 66,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(
                        fontSize: 36.sp,
                        color: AppColors.black,
                      ),
                      controller: controller,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      cursorColor: AppColors.blue,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onSubmitted: (value) => Navigator.of(context).pop(
                        value.toString(),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      'Укажите цену',
                      style: TextStyle(
                        color: AppColors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
