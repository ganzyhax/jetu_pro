import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetu/app/resourses/app_colors.dart';

import '../bottom_sheet/place_confirm_sheet_view.dart';

class AppInputBox extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool isEnabled;
  final bool autoFocus;
  final Function(String)? onChange;
  final TextInputType? keyboardType;
  final String? primaryIcon;
  final IconData? activeIcon;
  final VoidCallback? onTap;

  const AppInputBox({
    Key? key,
    this.hintText,
    required this.controller,
    this.isEnabled = false,
    this.autoFocus = false,
    this.onChange,
    this.keyboardType,
    this.activeIcon,
    this.primaryIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.transparent,
      ),
    );

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        height: 50,
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.50,
              color: AppColors.black.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    primaryIcon ?? '',
                    height: 22,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                hintText ?? controller.text,
                maxLines: 2,
                style: TextStyle(
                  color: hintText != null
                      ? AppColors.black.withOpacity(0.5)
                      : AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
