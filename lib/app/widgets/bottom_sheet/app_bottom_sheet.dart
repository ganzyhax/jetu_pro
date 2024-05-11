import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_city/app_city_cubit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppBottomSheet extends StatelessWidget {
  final PanelController panelController;
  final Widget? panel;
  final double? maxHeight;

  final Widget Function(ScrollController)? panelBuilder;

  const AppBottomSheet({
    Key? key,
    this.maxHeight,
    required this.panelController,
    this.panel,
    this.panelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      color: AppColors.white,
      controller: panelController,
      backdropEnabled: false,
      maxHeight: (maxHeight == null)
          ? context.sizeScreen.height * 0.42
          : context.sizeScreen.height * maxHeight!,
      minHeight: (maxHeight == null)
          ? context.sizeScreen.height * 0.42
          : context.sizeScreen.height * maxHeight!,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      panelSnapping: true,
      snapPoint: 0.3,
      panelBuilder: panelBuilder,
      panel: panel,
    );
  }
}

class AppCitySelect extends StatelessWidget {
  final Function(String, String, String) onAddress;

  const AppCitySelect({
    Key? key,
    required this.onAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCityCubit(client: injection()),
      child: BlocBuilder<AppCityCubit, AppCityState>(
        builder: (context, state) {
          return Container(
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Закрыть'),
                  ),
                  CupertinoSearchTextField(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.black,
                    ),
                    style: const TextStyle(color: AppColors.black),
                    autofocus: true,
                    onChanged: (value) => context.read<AppCityCubit>()
                      ..search(
                        value,
                      ),
                  ),
                  SizedBox(
                    height: context.sizeScreen.height * 0.8,
                    child: ListView.builder(
                      itemCount: state.cityList.length,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                      ),
                      itemBuilder: (context, index) {
                        final city = state.cityList[index];
                        return InkWell(
                          onTap: () async {
                            await onAddress.call(
                              city.id ?? '',
                              city.title ?? '',
                              city.address ?? '',
                            );
                            Navigator.of(context).pop();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.h,
                              horizontal: 12.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.title ?? '',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  city.address ?? '',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
