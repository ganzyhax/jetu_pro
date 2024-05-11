import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc_deleted/jetu_map_cubit.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc_deleted/jetu_map_state.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/app/widgets/button/menu_button.dart';

import '../../view/home/bloc_old/home_cubit.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenu;

  const AppBarDefault({Key? key, this.showMenu = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          leading: showMenu ? const MenuButton() : SizedBox(width: 24.w),
          centerTitle: true,
          title: Text(
            'Ваш адрес',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.transparent,
          elevation: 0,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}

class AppBarRequested extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onCancelTap;
  final OrderType orderType;

  const AppBarRequested({
    Key? key,
    this.onCancelTap,
    required this.orderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JetuMapCubit, JetuMapState>(
      builder: (context, state) {
        return (orderType == OrderType.onWay || orderType == OrderType.started)
            ? Container()
            : AppBar(
                leading: const SizedBox.shrink(),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (orderType == OrderType.requested ||
                            orderType == OrderType.arrived)
                          GestureDetector(
                            onTap: () => onCancelTap?.call(),
                            child: Text(
                              'Отменить поездку',
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AppBarBack({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JetuMapCubit, JetuMapState>(
      builder: (context, state) {
        return Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              title: title != null
                  ? Text(
                      title ?? '',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.black,
                ),
              ),
            ),
            const Divider(
              height: 0,
              color: AppColors.black,
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(74);
}
