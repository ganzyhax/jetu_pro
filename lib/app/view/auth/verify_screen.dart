import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/home/bloc/home_bloc.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu/app/widgets/app_toast.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final String pinCode;

  const VerifyScreen({
    Key? key,
    required this.phone,
    required this.pinCode,
  }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  static const maxTime = 3 * 60; // 3 минуты в секундах
  int remainingTime = maxTime;
  Timer? _timer;
  bool isSms = false;

  void startTimer() {
    _timer?.cancel(); // Отменяем предыдущий таймер, если он был запущен
    remainingTime = maxTime; // Сбрасываем время до начального значения
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          isSms = true;
        });

        _timer?.cancel();
      }
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const AppBarBack(),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OtpHeader(address: widget.phone),
                  SizedBox(
                    height: 68.h,
                    child: Pinput(
                      length: 6,
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      defaultPinTheme: defaultPinTheme,
                      onCompleted: (code) {
                        if (widget.pinCode == code) {
                          context.read<AuthCubit>()
                            ..verify(
                              context: context,
                              verificationId: widget.pinCode,
                              code: code,
                              phone: widget.phone,
                            );
                          context.read<YandexMapBloc>()
                            ..add(YandexMapLoad(isStart: false));
                        } else {
                          AppToast.center('Не правильный пин код!');
                        }
                      },
                      focusedPinTheme: defaultPinTheme.copyWith(
                        height: 68.h,
                        width: 64.w,
                      ),
                      errorPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Не получили код? ',
                          style: TextStyle(
                            color: Color(0xFF121212),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.44,
                          ),
                        ),
                        TextSpan(
                          text: (isSms == true)
                              ? 'Отправить еще раз'
                              : formatTime(remainingTime),
                          style: TextStyle(
                            color: Color(0xFF1D26FD),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.44,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36.h),
                  AppButtonV1(
                    onTap: () {
                      if (controller.text.length == 6) {
                        context.read<AuthCubit>()
                          ..verify(
                            context: context,
                            verificationId: widget.pinCode,
                            code: controller.text,
                            phone: widget.phone,
                          );
                      }
                    },
                    isActive: true,
                    isLoading: state.isLoading,
                    text: 'Отправить',
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      'SMS с кодом доставляется до 3 минут.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

class OtpHeader extends StatelessWidget {
  final String address;

  const OtpHeader({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Регистрация',
          style: TextStyle(
            fontSize: 24.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите код, отправленный на номер',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+7 $address',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
