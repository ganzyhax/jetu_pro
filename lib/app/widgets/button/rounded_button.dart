import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetu/app/resourses/app_colors.dart';

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const RoundedButton({
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: AppColors.white,
        ),
      ),
    );
  }
}
