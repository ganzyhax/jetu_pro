import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu/app/feature/place_suggestions/place_suggestions_cubit.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/place_search/place_search_screen.dart';
import 'package:jetu/app/widgets/bottom_sheet/place_confirm_sheet_view.dart';
import 'package:jetu/app/widgets/input/main_input.dart';
import 'package:jetu/app/widgets/list_item/search_item.dart';
import 'package:jetu/data/app/full_location.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LocationFindBottomSheet {
  static Future<List> open(
    BuildContext context, {
    required Widget child,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
