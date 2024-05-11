import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/resourses/app_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PaymentMethodBottomSheet {
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
                bottom: context.viewScreen.bottom + 10,
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
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pop('assets/images/kaspi_logo.jpg');
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                    'assets/images/kaspi_logo.jpg')),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Kaspi',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pop('assets/images/halyk_logo.jpg');
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                    'assets/images/halyk_logo.jpg')),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Halyk Bank',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop('');
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(AppIcons.cashIcon)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Наличные',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 8.h),
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
