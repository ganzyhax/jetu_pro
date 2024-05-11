import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu/app/app_navigator.dart';
import 'package:jetu/app/const/app_const.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resourses/app_icons.dart';

class SignOutDrawer extends StatelessWidget {
  const SignOutDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.logoutIcon,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Войти',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => AppNavigator.navigateToLogin(context, true),
          ),
          const Spacer(),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Image.asset(
              AppIcons.privacyIcon,
              height: 21,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Политика конфиденциальности',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () async => await launchUrl(
              Uri.parse('https://jetutaxi.kz/privacy-policy/ '),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Image.asset(
              AppIcons.securityIcon,
              height: 24,
              width: 24,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Безопасность',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => AppNavigator.navigateToSecurity(context),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.aboutIcon,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'О нас',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => launchUrl(Uri.parse(AppConst.instagramAppSupport)),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.helpIcon,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Служба поддержки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => launchUrl(Uri.parse(AppConst.whatsAppSupport)),
          ),
        ],
      ),
    );
  }
}
