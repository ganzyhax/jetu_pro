import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/const/app_const.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/data/app/app_config.dart';
import 'package:store_redirect/store_redirect.dart';

class RemoteConfigScreen extends StatelessWidget {
  final AppConfig appConfig;

  const RemoteConfigScreen({
    Key? key,
    required this.appConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (appConfig.version?.showForceUpdate ?? false)
              showForceUpdateWidget(context),
            if (appConfig.forceScreen?.show ?? false) showForceWidget(context),
          ],
        ),
      ),
    );
  }

  Widget showForceUpdateWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          Text(
            'Пора обновить приложение',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Мы внедрили новые функции, \nкоторые могут быть доступны только после обновление приложения',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 36.h),
          AppButtonV1(
            onTap: () => StoreRedirect.redirect(
              androidAppId:  AppConst.playMarketId,
              iOSAppId:  AppConst.appStoreId,
            ),
            text: 'Обновить',
          ),
        ],
      ),
    );
  }

  Widget showForceWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          Center(
            child: Text(
              appConfig.forceScreen?.title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            appConfig.forceScreen?.desc ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 36.h),
          if (appConfig.forceScreen?.showUpdateButton ?? false)
            AppButtonV1(
              onTap: () => StoreRedirect.redirect(
                androidAppId:  AppConst.playMarketId,
                iOSAppId:  AppConst.appStoreId,
              ),
              text: 'Обновить',
            ),
        ],
      ),
    );
  }
}
