import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class RuleCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool)? onTap;

  const RuleCheckbox({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: VisualDensity.standard,
      onChanged: (value) => onTap?.call(value!),
      title: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Text(
                'Я прочитал(а) и принимаю условия',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.black,
                ),
              ),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async =>
                    await launchUrl(Uri.parse('https://jetutaxi.kz/offer/')),
                child: Text(
                  'пользовательского соглашения и ',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 11.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async => await launchUrl(
                  Uri.parse('https://jetutaxi.kz/privacy-policy/'),
                ),
                child: Text(
                  'политику конфиденциальности',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 11.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
