import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/extensions/context_extensions.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/intercity/create/bloc/intercity_create_cubit.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/button/app_button_v2.dart';
import 'package:jetu/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu/app/widgets/input/app_input_underline.dart';

class IntercityCreateScreen extends StatelessWidget {
  const IntercityCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IntercityCreateCubit(
        client: injection(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SubscriptionWrapper<IntercityOrderModelList>(
              queryString: JetuDriverSubscription.getIntercityOrders(),
              variables: {"userId": authState.userId},
              dataParser: (json) => IntercityOrderModelList.fromUserJson(json),
              contentBuilder: (data) {
                if (data.orders.isNotEmpty) {
                  return _OrderRequestCreated(
                    order: data.orders.first,
                  );
                }
                return _OrderRequestScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderRequestScreen extends StatelessWidget {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<IntercityCreateCubit, IntercityCreateState>(
        builder: (context, state) {
          return ListView(
            children: [
              _ListSelectItem(
                onTap: () => AppDetailSheet.open(
                  context,
                  widget: AppCitySelect(
                    onAddress: (id, title, address) =>
                        context.read<IntercityCreateCubit>()
                          ..setAPoint(
                            id,
                            title,
                            address,
                          ),
                  ),
                ),
                icon: Icons.radio_button_checked_outlined,
                title: state.order?.aPoint?.title ?? 'Откуда?',
                subTitle: state.order?.aPoint?.address ?? '',
              ),
              _ListSelectItem(
                onTap: () => AppDetailSheet.open(
                  context,
                  widget: AppCitySelect(
                    onAddress: (id, title, address) =>
                        context.read<IntercityCreateCubit>()
                          ..setBPoint(
                            id,
                            title,
                            address,
                          ),
                  ),
                ),
                icon: Icons.radio_button_checked_outlined,
                title: state.order?.bPoint?.title ?? 'Куда?',
                subTitle: state.order?.bPoint?.address ?? '',
              ),
              _ListInputItem(
                isPrice: true,
                icon: Icons.payments_outlined,
                hint: 'Цена',
                keyboardType: TextInputType.number,
                controller: priceController,
              ),
              _ListInputItem(
                isPrice: false,
                icon: Icons.comment_outlined,
                hint: 'Комментарий',
                controller: commentController,
              ),
              _ListSelectItem(
                onTap: () => DatePicker.showDatePicker(
                  context,
                  locale: DateTimePickerLocale.ru,
                  initialDateTime: DateTime.now(),
                  dateFormat: 'EEEE dd MMMM',
                  pickerMode: DateTimePickerMode.datetime,
                  onConfirm: (value, List<int> index) =>
                      context.read<IntercityCreateCubit>().setDate(value),
                ),
                icon: Icons.date_range_outlined,
                title: dateFormat(
                  state.order?.date,
                  'MM/dd/yyyy',
                  'Дата',
                ),
              ),
              _ListSelectItem(
                onTap: () => DatePicker.showDatePicker(
                  context,
                  locale: DateTimePickerLocale.ru,
                  initialDateTime: DateTime.now(),
                  dateFormat: 'HH:mm',
                  pickerMode: DateTimePickerMode.datetime,
                  onConfirm: (value, List<int> index) =>
                      context.read<IntercityCreateCubit>().setTime(value),
                ),
                icon: Icons.timer_outlined,
                title: dateFormat(
                  state.order?.time,
                  'HH:mm',
                  'Время',
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                ),
                child: AppButtonV1(
                  onTap: () {
                    context.read<IntercityCreateCubit>()..order();
                  },
                  isLoading: state.isLoading,
                  isActive: state.order?.aPoint?.id != null &&
                      state.order?.bPoint?.id != null &&
                      state.order?.price != null &&
                      state.order?.date != null &&
                      state.order?.time != null,
                  text: 'Создать объявление',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String dateFormat(DateTime? data, String dataFormat, String initText) {
    if (data == null) {
      return initText;
    }
    return DateFormat(dataFormat).format(data);
  }
}

class _OrderRequestCreated extends StatelessWidget {
  final IntercityOrderModel order;

  const _OrderRequestCreated({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(order.time!.toString());
    return SafeArea(
      child: BlocBuilder<IntercityCreateCubit, IntercityCreateState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ваш объявление успешно создан,ожидайте звонки от водителей',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  width: context.sizeScreen.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.sp),
                    color: AppColors.blue.withOpacity(0.05),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.aPoint?.title}: ${order.aPoint?.address}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${order.bPoint?.title}: ${order.bPoint?.address}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${order.price} ₸',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        '${DateFormat('HH:mm').format(order.time!)} ${DateFormat('dd.MM').format(order.date!)}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        '${order.comment ?? ''}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.read<IntercityCreateCubit>()
                    ..cancelOrder(
                      orderId: order.id ?? '',
                    ),
                  child: AppButtonV2(
                    isLoading: state.isLoading,
                    text: 'Отменить объявление',
                    textStyle: TextStyle(
                      color: AppColors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListSelectItem extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String? title;
  final String subTitle;

  const _ListSelectItem({
    Key? key,
    this.onTap,
    required this.icon,
    this.title,
    this.subTitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap?.call(),
      leading: Icon(
        icon,
        color: AppColors.blue,
      ),
      dense: true,
      minLeadingWidth: 0,
      title: Text(
        title ?? '',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subTitle.isNotEmpty
          ? Text(
              subTitle ?? '',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12.sp,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.black,
        size: 14.sp,
      ),
    );
  }
}

class _ListInputItem extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final bool isPrice;

  const _ListInputItem({
    Key? key,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.isPrice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.blue,
      ),
      dense: true,
      minLeadingWidth: 0,
      title: AppInputUnderline(
        controller: controller,
        hintText: hint ?? '',
        isEnabled: true,
        keyboardType: keyboardType,
        onChange: (value) {
          if (isPrice) {
            context.read<IntercityCreateCubit>().setPrice(
                  value,
                );
          } else {
            context.read<IntercityCreateCubit>().setComment(
                  value,
                );
          }
        },
      ),
    );
  }
}
