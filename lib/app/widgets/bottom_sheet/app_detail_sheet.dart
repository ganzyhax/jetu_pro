import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppDetailSheet {
  static Future<bool?> open(
    BuildContext context, {
    required Widget widget,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
