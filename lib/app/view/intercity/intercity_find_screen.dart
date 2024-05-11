import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu/app/view/intercity/bloc/intercity_cubit.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu/app/widgets/list_item/intercity_order_item.dart';

class IntercityFindScreen extends StatelessWidget {
  const IntercityFindScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _OrdersScreen(),
    );
  }
}

class _OrdersScreen extends StatelessWidget {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<IntercityCubit, IntercityState>(
        builder: (context, state) {
          return ListView(
            children: [
              _ListSelectItem(
                onTap: () => AppDetailSheet.open(
                  context,
                  widget: AppCitySelect(
                    onAddress: (id, title, address) =>
                        context.read<IntercityCubit>()
                          ..setAPoint(
                            id,
                            title,
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
                        context.read<IntercityCubit>()..setBPoint(id, title),
                  ),
                ),
                icon: Icons.radio_button_checked_outlined,
                title: state.order?.bPoint?.title ?? 'Куда?',
                subTitle: state.order?.bPoint?.address ?? '',
              ),
              _ListSelectItem(
                onTap: () => DatePicker.showDatePicker(
                  context,
                  locale: DateTimePickerLocale.ru,
                  initialDateTime: DateTime.now(),
                  dateFormat: 'EEEE dd MMMM',
                  pickerMode: DateTimePickerMode.datetime,
                  onConfirm: (value, List<int> index) =>
                      context.read<IntercityCubit>().setDate(value),
                ),
                icon: Icons.date_range_outlined,
                title: dateFormat(
                  state.order?.date,
                  'dd MMM. yyyy',
                  'Дата',
                ),
              ),
              const Divider(),
              SizedBox(height: 12.h),
              const _OrderList(),
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

class _OrderList extends StatelessWidget {
  const _OrderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntercityCubit, IntercityState>(
      builder: (context, state) {
        if (state.order?.date != null &&
            state.order?.aPoint?.id != null &&
            state.order?.bPoint?.id != null) {
          return SubscriptionWrapper<IntercityOrderModelList>(
            queryString: JetuOrderSubscription.getIntercityOrders(),
            dataParser: (json) => IntercityOrderModelList.fromUserJson(json),
            variables: {
              "start": DateFormat('yyyy-MM-dd').format(state.order!.date!),
              "end": DateFormat('yyyy-MM-dd').format(
                state.order!.date!.add(
                  const Duration(days: 1),
                ),
              ),
              "aCity": state.order?.aPoint?.id ?? '',
              "bCity": state.order?.bPoint?.id ?? '',
            },
            contentBuilder: (data) {
              if (data.orders.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.orders.length,
                  itemBuilder: (context, index) {
                    final order = data.orders[index];
                    return IntercityOrderItem(
                      model: order,
                    );
                  },
                );
              }
              return Center(
                child: Text(
                  'В этот день ничего не найдено 😢',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
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
