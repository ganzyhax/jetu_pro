import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/input/app_input_underline.dart';

class AppInputMain extends StatelessWidget {
  final IconData primaryIcon;
  final IconData? activeIcon;
  final String hintText;
  final TextEditingController controller;
  final Widget? trialingWidget;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool autoFocus;
  final Function(String)? onChange;

  const AppInputMain({
    Key? key,
    required this.primaryIcon,
    this.activeIcon,
    required this.hintText,
    required this.controller,
    this.trialingWidget,
    this.onTap,
    this.isEnabled = false,
    this.autoFocus = false,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (controller.text.isEmpty)
            Icon(
              primaryIcon,
              size: 21.sp,
              color: AppColors.black,
            ),
          if (controller.value.text.isNotEmpty)
            Icon(
              activeIcon ?? Icons.add,
              size: 21.sp,
              color: AppColors.black,
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppInputUnderline(
              hintText: hintText,
              controller: controller,
              isEnabled: isEnabled,
              autoFocus: autoFocus,
              onChange: (value) => onChange?.call(value),
            ),
          ),
          trialingWidget ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
