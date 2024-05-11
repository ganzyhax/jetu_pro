import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/resourses/app_icons.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/widgets/app_toast.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/rule_checkbox.dart';
import 'package:jetu/app/widgets/text_field_input.dart';

import '../../widgets/app_bar/app_bar_default.dart';

class LoginScreen extends StatefulWidget {
  final bool isForgetPassword;

  const LoginScreen({Key? key, this.isForgetPassword = false})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool ruleAgree = true;

  @override
  void initState() {
    _phoneController.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.error.isNotEmpty) {
            AppToast.center(state.error);
          }

          if (state.success) {}
        },
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              alignment: Alignment.topCenter,
              color: AppColors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Войти / Регистрация',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: context.sizeScreen.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.50,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AppIcons.kzFlag,
                                  width: 24.w,
                                ),
                                Text(
                                  '+7',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                const VerticalDivider(
                                  color: AppColors.black,
                                  width: 0.5,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: TextFieldInput(
                              hintText: 'Номер телефона',
                              textInputType: TextInputType.phone,
                              textEditingController: _phoneController,
                              isPhoneInput: true,
                              autoFocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.sizeScreen.height * 0.025),
                    RuleCheckbox(
                      value: ruleAgree,
                      onTap: (value) => setState(() => ruleAgree = value),
                    ),
                    SizedBox(height: 12.h),
                    AppButtonV1(
                      onTap: () {
                        if (!state.isLoading &&
                            ruleAgree &&
                            _phoneController.text.length == 13) {
                          String ph = _phoneController.text.replaceAll(' ', '');
                          print(ph); //7475419877
                          if (ph == '7475419877') {
                            context.read<AuthCubit>().verifyTest(
                                  context: context,
                                  phone: _phoneController.text,
                                );
                          } else {
                            context.read<AuthCubit>().login(
                                  context: context,
                                  phone: _phoneController.text,
                                );
                          }
                        }
                      },
                      isActive: ruleAgree && _phoneController.text.length == 13,
                      isLoading: state.isLoading,
                      text: 'Продолжить',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
