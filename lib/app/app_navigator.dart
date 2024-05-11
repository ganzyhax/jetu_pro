import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/auth/login_screen.dart';
import 'package:jetu/app/view/auth/verify_screen.dart';
import 'package:jetu/app/view/intercity/intercity_screen.dart';
import 'package:jetu/app/view/security/security_screen.dart';
import 'package:jetu/app/widgets/remote_config_screen.dart';
import 'package:jetu/data/app/app_config.dart';

class AppNavigator {
  static navigateToLogin(BuildContext context, bool isFromDrawer) {
    if (isFromDrawer) {
      Navigator.of(context).pop();
    }
    _pushToPage(
      context,
      const LoginScreen(),
    );
  }

  static navigateToPhoneVerification(
    BuildContext context, {
    required String phone,
    required String verificationId,
  }) {
    _pushToPage(
      context,
      BlocProvider(
        create: (context) => AuthCubit(client: injection()),
        child: VerifyScreen(
          phone: phone,
          pinCode: verificationId,
        ),
      ),
    );
  }

  static navigateToSecurity(BuildContext context) {
    _pushToPage(
      context,
      const SecurityScreen(),
    );
  }

  static navigateToRemoteConfig(BuildContext context,
      {required AppConfig appConfig}) {
    _pushReplacement(
      context,
      RemoteConfigScreen(appConfig: appConfig),
    );
  }

  static navigateToInterCity(BuildContext context) {
    _pushToPage(
      context,
      const IntercityScreen(),
    );
  }

  static _pushToPage(BuildContext context, Widget page,
      {bool showFullPage = true}) {
    return Navigator.of(context, rootNavigator: showFullPage).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static _pushReplacement(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static _pushAndRemoveUntilPage(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  static _pushAndRemoveUntilNoAnimationPage(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => page),
      (route) => false,
    );
  }
}
