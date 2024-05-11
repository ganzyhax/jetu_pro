import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetu/app/app_navigator.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/home/bloc_old/home_cubit.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/view/home/widgets/jetu_service/jetu_services_list.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet/comment_set_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet/payment_method_sheet.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../resourses/app_colors.dart';
import '../../../../resourses/app_icons.dart';
import '../../../../widgets/bottom_sheet/price_set_bottom_sheet.dart';

class JetuRequestPanel extends StatefulWidget {
  final PanelController panelController;

  const JetuRequestPanel({
    Key? key,
    required this.panelController,
  }) : super(key: key);

  @override
  State<JetuRequestPanel> createState() => _JetuRequestPanelState();
}

class _JetuRequestPanelState extends State<JetuRequestPanel> {
  final TextEditingController aPointController = TextEditingController();
  final TextEditingController bPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  String serviceId = '';

  String currencyIcon = '';
  @override
  void initState() {
    aPointController.addListener(updateState);
    bPointController.addListener(updateState);
    priceController.addListener(updateState);
    commentController.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    aPointController.dispose();
    bPointController.dispose();
    priceController.dispose();
    commentController.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return BlocBuilder<YandexMapBloc, YandexMapState>(
          builder: (_, mapState) {
            if (mapState is YandexMapLoaded) {
              if (aPointController.text != mapState.aPoint[0]) {
                aPointController.text = mapState.aPoint[0];
              }

              return AppBottomSheet(
                panelController: widget.panelController,
                panel: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    JetuServicesListWidget(),
                    SizedBox(height: 10.h),
                    _MenuItem(
                      onTap: () {
                        PriceSetBottomSheet.open(
                          context,
                          controller: priceController,
                        );
                      },
                      icon: AppIcons.priceIcon,
                      title: priceController.text.isEmpty
                          ? 'Предложите цену'
                          : priceController.text,
                    ),
                    _MenuItem(
                      onTap: () {
                        CommentSetBottomSheet.open(
                          context,
                          controller: commentController,
                        );
                      },
                      icon: AppIcons.commentIcon,
                      title: commentController.text.isEmpty
                          ? 'Комментарий, пожелание'
                          : commentController.text,
                    ),
                    _MenuItem(
                      onTap: () async {
                        currencyIcon = await PaymentMethodBottomSheet.open(
                              context,
                              controller: commentController,
                            ) ??
                            '';

                        setState(() {});
                      },
                      icon: (currencyIcon == '')
                          ? AppIcons.cashIcon
                          : (currencyIcon),
                      title: (currencyIcon == '')
                          ? 'Наличные'
                          : (currencyIcon.contains('kaspi'))
                              ? 'Kaspi Bank'
                              : 'Halyk Bank',
                      showArrowIcon: true,
                    ),
                    SizedBox(height: 10.h),
                    AppButtonV1(
                      onTap: () {
                        state.isLogged
                            ? context.read<HomeCubit>().sendOrder(
                                  currency: (currencyIcon == '')
                                      ? 'Наличные'
                                      : (currencyIcon.contains('kaspi')
                                          ? 'Kaspi Bank'
                                          : 'Halyk Bank'),
                                  cost: priceController.text,
                                  comment: commentController.text,
                                  aPoint: mapState.aPoint[1],
                                  bPoint: mapState.bPoint[1],
                                  aPointAddress: mapState.aPoint[0],
                                  bPointAddress: mapState.bPoint[0],
                                  serviceId:
                                      context.read<HomeCubit>().state.serviceId,
                                )
                            : AppNavigator.navigateToLogin(context, false);
                      },
                      isActive: priceController.text.isNotEmpty &&
                          mapState.bPoint[0].length != 0,
                      isLoading: false,
                      text: 'Заказать',
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String title;
  final bool showArrowIcon;

  const _MenuItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.showArrowIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (icon.endsWith(".png") || icon.endsWith(".jpg"))
                  Image.asset(
                    icon,
                    width: 24,
                  )
                else
                  SvgPicture.asset(icon),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (showArrowIcon) const Icon(Icons.keyboard_arrow_right)
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0, color: AppColors.grey)
          ],
        ),
      ),
    );
  }
}
