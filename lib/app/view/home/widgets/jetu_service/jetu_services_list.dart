import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu/app/app_navigator.dart';
import 'package:jetu/app/const/app_const.dart';
import 'package:jetu/app/services/jetu_service/grapql_query.dart';
import 'package:jetu/app/view/home/bloc_old/home_cubit.dart';
import 'package:jetu/app/view/home/widgets/jetu_service/cubit/jetu_service_cubit.dart';
import 'package:jetu/app/widgets/card/jetu_select_card.dart';
import 'package:jetu/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu/data/model/jetu_services_model.dart';

class JetuServicesListWidget extends StatelessWidget {
  List<JetuServicesModel> localData = [
    JetuServicesModel(
      id: '60f5bda2-5973-4054-90c0-8540cbad5384',
      title: 'Эконом',
      icon: 'images/car_1.png',
      isActive: true,
      height: 58,
      width: 136,
    ),
    JetuServicesModel(
      id: '80ed943c-da58-4f0a-aa59-c1e08399441e',
      title: 'Комфорт',
      icon: 'images/car_2.png',
      isActive: true,
      height: 56,
      width: 136,
    ),
    JetuServicesModel(
      id: '71bc89a0-5212-4735-b3ba-92482be6f3cb',
      title: 'Бизнес',
      icon: 'images/car_3.png',
      isActive: true,
      height: 56,
      width: 116,
    ),
    JetuServicesModel(
      id: 'b3116f14-b987-4530-a5e2-22ca100a3938',
      title: 'Грузовой',
      icon: 'images/car_4.png',
      isActive: true,
      height: 56,
      width: 116,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JetuServiceCubit()..init(localData),
      child: BlocBuilder<JetuServiceCubit, JetuServiceState>(
        builder: (context, state) {
          context.read<HomeCubit>().setServiceId(state.selectedId);

          return SizedBox(
            height: 90,
            child: ListView.builder(
              itemCount: state.services.length,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, index) {
                final service = state.services[index];
                if (service.isActive ?? false) {
                  return JetuSelectCard(
                    isSelected: state.selectedId == service.id,
                    onTap: () => onSelect(context, model: service),
                    model: service,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  void onSelect(
    BuildContext context, {
    required JetuServicesModel model,
  }) {
    if (model.id == AppConst.intercityServiceId) {
      AppNavigator.navigateToInterCity(context);
    } else {
      context.read<JetuServiceCubit>()..selectService(model);
    }
  }
}
