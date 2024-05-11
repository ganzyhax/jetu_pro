import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';

class AppInputUnderline extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEnabled;
  final bool autoFocus;
  final Function(String)? onChange;
  final TextInputType? keyboardType;

  const AppInputUnderline({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isEnabled = false,
    this.autoFocus = false,
    this.onChange,
    this.keyboardType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.2),
      ),
    );

    return TextField(
      enabled: isEnabled,
      autofocus: autoFocus,
      controller: controller,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.black),
        disabledBorder: border,
        labelStyle: const TextStyle(
          color: AppColors.black,
        ),
        enabledBorder: border,
        focusedBorder: border,
        border: border,
      ),
      keyboardType: keyboardType,
      onChanged: (value) {
        EasyDebounce.debounce(
          'search',
          const Duration(milliseconds: 500),
              () => onChange?.call(value),
        );
      },
      onSubmitted: (value) => onChange?.call(value),
    );
  }
}
