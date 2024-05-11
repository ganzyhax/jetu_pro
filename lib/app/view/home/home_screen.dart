import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jetu/app/app_navigator.dart';
import 'package:jetu/app/resourses/app_icons.dart';
import 'package:jetu/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/home/bloc_old/home_cubit.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';

import 'package:jetu/app/view/home/widgets/jetu_map/jetu_yandex_map.dart';
import 'package:jetu/app/view/home/widgets/jetu_panels/jetu_request_panel.dart';
import 'package:jetu/app/view/order/alert_fare/alert_fare_screen.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/app/view/order/bloc/order_state.dart';
import 'package:jetu/app/view/order/jetu_looking_screen.dart';
import 'package:jetu/app/view/order/order_arrived_screen.dart';
import 'package:jetu/app/view/order/order_onway_screen.dart';
import 'package:jetu/app/view/order/order_paymend_screen.dart';
import 'package:jetu/app/view/order/order_started_screen.dart';
import 'package:jetu/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu/app/widgets/bottom_sheet/place_confirm_sheet_view.dart';
import 'package:jetu/app/widgets/drawer/app_drawer.dart';
import 'package:jetu/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widgets/bottom_sheet/location_find_bottom_sheet.dart';
import '../../widgets/input/app_input_box.dart';
import '../place_search/place_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapController mapController = MapController();
  int _eventKey = 0;

  @override
  Widget build(BuildContext context) {
    final _player = AudioPlayer();

    void playOrderAcceptAudio() async {
      var content = await rootBundle.load('assets/audio/order_accepted.wav');
      final directory = await getApplicationDocumentsDirectory();
      var file = File("${directory.path}/order_accepted.v1.wav");
      file.writeAsBytesSync(content.buffer.asUint8List());

      await _player.setFilePath(file.path);
      _player.setLoopMode(LoopMode.off);
      _player.setVolume(1.0);
      _player.play();
    }

    void playDriverArrivedAudio() async {
      var content = await rootBundle.load('assets/audio/arrived.wav');
      final directory = await getApplicationDocumentsDirectory();
      var file = File("${directory.path}/arrived.v1.wav");
      file.writeAsBytesSync(content.buffer.asUint8List());

      await _player.setFilePath(file.path);
      _player.setLoopMode(LoopMode.off);
      _player.setVolume(1.0);
      _player.play();
    }

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.appConfig.version?.showForceUpdate ?? false) {
          if (state.storeUpdate) {
            AppNavigator.navigateToRemoteConfig(
              context,
              appConfig: state.appConfig,
            );
          }
        }
        if (state.appConfig.forceScreen?.show ?? false) {
          AppNavigator.navigateToRemoteConfig(
            context,
            appConfig: state.appConfig,
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return SubscriptionWrapper<JetuOrderList>(
            queryString: JetuOrderSubscription.subscribeOrder(),
            variables: {
              "userId": authState.userId,
            },
            dataParser: (json) => JetuOrderList.fromUserJson(json),
            contentBuilder: (JetuOrderList data) {
              if (data.orders.isEmpty) {
                context.read<OrderCubit>().changeOrder(
                      OrderType.none,
                      null,
                    );
              }
              if (data.orders.isNotEmpty) {
                switch (data.orders.first.status) {
                  case "requested":
                    context.read<OrderCubit>().changeOrder(
                          OrderType.requested,
                          data.orders.first,
                        );
                    break;
                  case "onway":
                    playOrderAcceptAudio();
                    context.read<OrderCubit>().changeOrder(
                          OrderType.onWay,
                          data.orders.first,
                        );
                    break;
                  case "arrived":
                    playDriverArrivedAudio();
                    context.read<OrderCubit>().changeOrder(
                          OrderType.arrived,
                          data.orders.first,
                        );
                    break;
                  case "started":
                    context.read<OrderCubit>().changeOrder(
                          OrderType.started,
                          data.orders.first,
                        );
                    break;
                  case "paymend":
                    context.read<OrderCubit>().changeOrder(
                          OrderType.paymend,
                          data.orders.first,
                        );
                    break;
                }
              }
              return BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  PreferredSizeWidget getAppBar() {
                    if ((state.orderType != OrderType.none)) {
                      return AppBarRequested(
                        orderType: state.orderType,
                        onCancelTap: () async {
                          BlocProvider.of<YandexMapBloc>(context)
                            ..add(YandexMapClear(withLoad: true));
                          BlocProvider.of<YandexMapBloc>(context)
                            ..add(YandexMapResetTimers());
                          BlocProvider.of<YandexMapBloc>(context)
                            ..add(YandexMapLoad(isStart: true));

                          await context.read<HomeCubit>().cancelOrder(
                                order: state.orderModel!,
                              );
                          await context.read<OrderCubit>().changeOrder(
                                OrderType.none,
                                null,
                              );
                        },
                      );
                    }
                    return const AppBarDefault();
                  }

                  return Scaffold(
                    drawer: state.orderType != OrderType.none
                        ? const SizedBox.shrink()
                        : const AppDrawer(),
                    extendBodyBehindAppBar: true,
                    resizeToAvoidBottomInset: false,
                    appBar: getAppBar(),
                    body: Stack(
                      children: [
                        JetuYandexMap(),
                        getCurrentScreen(
                          state.orderType,
                          state.orderModel,
                        ),
                        if (state.orderModel?.id != null)
                          AlertFareScreen(orderId: state.orderModel?.id ?? ''),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget getCurrentScreen(OrderType orderType, JetuOrderModel? orderModel) {
    PanelController panelController = PanelController();

    switch (orderType) {
      case OrderType.none:
        return BlocBuilder<YandexMapBloc, YandexMapState>(
          builder: (context, state) {
            if (state is YandexMapLoaded) {
              return SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          AppInputBox(
                            onTap: () async {
                              List? aPoint = await LocationFindBottomSheet.open(
                                context,
                                child: PleaseSearchScreen(
                                  text: state.aPoint[0],
                                  hint: "Откуда?",
                                  mapPickSetPoint: MapPickSetPoint.fromAPoint,
                                ),
                              );

                              BlocProvider.of<YandexMapBloc>(context)
                                ..add(YandexMapSetAPoint(data: aPoint));
                            },
                            primaryIcon: AppIcons.pointAIcon,
                            activeIcon: Ionicons.search,
                            isEnabled: false,
                            hintText:
                                state.aPoint[0].isEmpty || state.aPoint[0] == ''
                                    ? 'Откуда?'
                                    : null,
                            controller: TextEditingController()
                              ..text = state.aPoint[0],
                          ),
                          const SizedBox(height: 12),
                          AppInputBox(
                            onTap: () async {
                              List? bPoint = await LocationFindBottomSheet.open(
                                context,
                                child: PleaseSearchScreen(
                                  text: state.bPoint[0],
                                  hint: "Куда поедете?",
                                  mapPickSetPoint: MapPickSetPoint.fromBPoint,
                                ),
                              );

                              BlocProvider.of<YandexMapBloc>(context)
                                ..add(YandexMapSetBPoint(data: bPoint));
                            },
                            primaryIcon: AppIcons.mapIcon,
                            activeIcon: Ionicons.search,
                            hintText: state.bPoint[0].isEmpty
                                ? 'Куда поедете?'
                                : null,
                            isEnabled: false,
                            controller: TextEditingController()
                              ..text = state.bPoint[0],
                          ),
                        ],
                      ),
                    ),
                    JetuRequestPanel(
                      panelController: panelController,
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        );
      case OrderType.requested:
        // BlocProvider.of<YandexMapBloc>(context)
        //   ..add(YandexMapRequestedOrder(order: orderModel));
        return LookingScreen(
          panelController: panelController,
          orderModel: orderModel!,
        );
      case OrderType.onWay:
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapClear(withLoad: false));
        BlocProvider.of<YandexMapBloc>(context)..add(YandexMapStopLoadTimer());

        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapStartDriverTimer(
              order: orderModel, driverId: orderModel!.driver, isOnWay: true));

        return OrderOnWayScreen(
          model: orderModel!,
          panelController: panelController,
        );
      case OrderType.arrived:
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapClear(withLoad: false));
        BlocProvider.of<YandexMapBloc>(context)..add(YandexMapStopOnWayTimer());
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapDriverArrived(driverId: orderModel!.driver));
        return OrderArrivedScreen(
          model: orderModel!,
          panelController: panelController,
        );
      case OrderType.started:
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapClear(withLoad: false));
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapStartDriverTimer(
              order: orderModel, driverId: orderModel!.driver, isOnWay: false));

        return OrderStartedScreen(
          model: orderModel,
          panelController: panelController,
        );
      case OrderType.paymend:
        BlocProvider.of<YandexMapBloc>(context)..add(YandexMapStopStartTimer());
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapClear(withLoad: true));
        BlocProvider.of<YandexMapBloc>(context)..add(YandexMapResetTimers());
        BlocProvider.of<YandexMapBloc>(context)
          ..add(YandexMapLoad(isStart: true));

        return OrderPaymendScreen(
          model: orderModel!,
          panelController: panelController,
        );
    }
  }
}
