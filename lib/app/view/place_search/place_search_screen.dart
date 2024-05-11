import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu/app/feature/bloc/place_suggestions_bloc.dart';
import 'package:jetu/app/feature/place_suggestions/place_suggestions_cubit.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/list_item/search_item.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../resourses/app_icons.dart';
import '../../widgets/bottom_sheet/place_confirm_sheet_view.dart';
import '../home/bloc_old/home_cubit.dart';

class PleaseSearchScreen extends StatefulWidget {
  final String text;
  final String hint;
  final MapPickSetPoint mapPickSetPoint;

  const PleaseSearchScreen({
    Key? key,
    required this.text,
    required this.hint,
    required this.mapPickSetPoint,
  }) : super(key: key);

  @override
  State<PleaseSearchScreen> createState() => _PleaseSearchScreenState();
}

class _PleaseSearchScreenState extends State<PleaseSearchScreen> {
  TextEditingController controller = TextEditingController();

  void search(BuildContext context, String text) {
    context.read<PlaceSuggestionsBloc>()
      ..add(PlaceSuggestionsSearch(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceSuggestionsBloc()..add(PlaceSuggestionsLoad()),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
            padding: EdgeInsets.all(12.0.sp),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                _SearchItem(
                  icon: AppIcons.pointAIcon,
                  initText: widget.text,
                  hintText: widget.hint,
                  onChanged: (value) => search(context, value),
                  onSubmitted: (value) => search(context, value),
                  controller: controller..text = widget.text,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.blue.withOpacity(0.05),
                  ),
                  child: Center(
                    child: CupertinoButton(
                      onPressed: () async {
                        // context.read<HomeCubit>().setMapPickPointInit(
                        //       widget.mapPickSetPoint,
                        //     );
                        final feature = await showBarModalBottomSheet<List>(
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return const PlaceConfirmSheetView();
                          },
                        );
                        Navigator.of(context).pop(
                          feature,
                        );
                      },
                      minSize: 0,
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Ionicons.locate,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: 6.w),
                          const Text(
                            "Выбрать на карте",
                            style: TextStyle(
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<PlaceSuggestionsBloc, PlaceSuggestionsState>(
                  builder: (context, state) {
                    if (state is PlaceSuggestionsLoaded) {
                      if (state.suggestions.isEmpty ??
                          true &&
                              !state.isLoading &&
                              state.searchText.isNotEmpty &&
                              controller.text.isNotEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12.sp),
                          margin: EdgeInsets.symmetric(
                            vertical: 12.h,
                          ),
                          child: AppButtonV1(
                            onTap: () => Navigator.of(context).pop(Candidate(
                              name: controller.text,
                              formattedAddress: controller.text,
                            )),
                            text: 'Подтвердить адрес 📍',
                          ),
                        );
                      } else {
                        return Flexible(
                          child: ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: state.suggestions.length ?? 0,
                            itemBuilder: ((context, index) {
                              final suggestion = state.suggestions[index];
                              return Column(
                                children: [
                                  LocationSearchResultItem(
                                    location: suggestion,
                                    onSelected: () {
                                      List data = [];
                                      data.add(suggestion['adress']);
                                      List<String> parts =
                                          suggestion['pos'].split(',');
                                      double latitude = double.parse(parts[1]);
                                      double longitude = double.parse(parts[0]);
                                      data.add(Point(
                                          latitude: latitude,
                                          longitude: longitude));
                                      Navigator.of(context).pop(
                                        data,
                                      );
                                    },
                                  ),
                                ],
                              );
                            }),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final String icon;
  final String initText;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final TextEditingController controller;

  const _SearchItem({
    Key? key,
    required this.icon,
    required this.initText,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CupertinoSearchTextField(
        placeholder: hintText,
        onTap: () {},
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: AppColors.white,
        prefixIcon: SizedBox(
          width: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon ?? '',
                height: 22,
              ),
            ],
          ),
        ),
        onChanged: (value) {
          EasyDebounce.debounce(
            'search',
            const Duration(milliseconds: 700),
            () => onChanged.call(value),
          );
        },
        onSubmitted: onSubmitted,
        autocorrect: true,
        onSuffixTap: () {
          controller.clear();
        },
      ),
    );
  }
}
