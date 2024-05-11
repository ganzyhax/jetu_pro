import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app_bar/app_bar_default.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(
        title: "Безопасность",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              Center(
                child: Text(
                  'Экстренный вызов',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  'Если вам требуется помощь полиции или медицинская помощь, позвоните по следующим номерам',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AppButtonV1(
                onTap: () => launchUrl(Uri.parse('tel://103')),
                text: 'Позвонить в скорую помощь'.toUpperCase(),
                bgColor: Colors.pinkAccent,
                textStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              AppButtonV1(
                onTap: () => launchUrl(Uri.parse('tel://112')),
                bgColor: Colors.blueAccent,
                textStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                ),
                text: 'Позвонить в полицию'.toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
