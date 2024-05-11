import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu/app/view/order/bloc/order_state.dart';
import 'package:jetu/app/widgets/app_toast.dart';
import 'package:jetu/data/model/jetu_alert_fare_model.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OrderType { none, requested, onWay, arrived, started, paymend }

class OrderCubit extends Cubit<OrderState> {
  final GraphQLClient client;

  OrderCubit({
    required this.client,
  }) : super(OrderState.initial());

  late SharedPreferences _prefs;

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    bool inOrder = _prefs.getBool('inOrder') ?? false;

    emit(state.copyWith());
  }

  Future<void> changeOrder(
    OrderType orderType,
    JetuOrderModel? orderModel,
  ) async =>
      emit(
        state.copyWith(
          orderType: orderType,
          orderModel: orderModel,
          initFare: int.parse(orderModel?.cost ?? '0'),
          currentFare: int.parse(orderModel?.cost ?? '0'),
        ),
      );

  Future<void> increaseFare() async => emit(
        state.copyWith(
          currentFare: state.currentFare + 50,
          showFareButton: true,
        ),
      );

  Future<void> decreaseFare() async {
    emit(state.copyWith(currentFare: state.currentFare - 50));
    emit(state.copyWith(showFareButton: state.initFare < state.currentFare));
  }

  Future<void> setNewFare() async {
    emit(state.copyWith(
      currentFare: state.currentFare,
      initFare: state.currentFare,
    ));
    emit(state.copyWith(showFareButton: false));
    await updateOrderCost();
    await createOrderFare();
    AppToast.bottom('Стоимость проезда повышена');
  }

  Future<void> createOrderFare() async {
    _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString(AppSharedKeys.userId) ?? '';

    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.createFareAlert()),
      variables: {
        "object": {
          "order_id": state.orderModel?.id,
          "user_id": userId,
          "cost": state.currentFare,
          "isUserSend": true,
        },
      },
    );

    final res = await client.mutate(options);
    log("createOrderFare: ${res.exception}");
  }

  Future<void> updateOrderCost({String? newCost}) async {
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.updateOrderCost()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": state.orderModel?.id,
        "newCost": newCost ?? state.currentFare.toString(),
      },
    );

    final res = await client.mutate(options);
  }

  Future<void> rejectAlertFare(String alertFareId) async {
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.rejectAlertFare()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": alertFareId,
      },
    );

    final res = await client.mutate(options);
    log("rejectAlertFare: $res");
  }

  Future<void> acceptAlertFare(JetuAlertFareModel model, String orderId) async {
    await rejectAlertFare(model.id);
    await updateOrderCost(newCost: model.cost);
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.acceptOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "driverId": model.driver?.id,
      },
    );

    final res = await client.mutate(options);
  }

  Future<void> setRating(JetuOrderModel model, String orderId) async {
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.acceptOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "driverId": model.driver?.id,
      },
    );

    final res = await client.mutate(options);
  }

  Future<void> finishOrder(String orderId, String status) async {
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.updateStatusOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "status": status,
      },
    );

    await client.mutate(options);
  }
// createOrder(String orderId) async {
//   emit(state.copyWith(isLoading: true));
//
//   _prefs = await SharedPreferences.getInstance();
//   String driverId = _prefs.getString(AppSharedKeys.userId) ?? '';
//
//   final MutationOptions options = MutationOptions(
//     document: gql(JetuOrderMutation.acceptOrder()),
//     variables: {
//       "orderId": orderId,
//       "driverId": driverId,
//     },
//   );
//
//   await client.mutate(options);
//   emit(state.copyWith(
//     isLoading: false,
//     isSheetFullView: true,
//     showOrders: false,
//   ));
// }

// changeStatusOrder(String orderId, {required String status}) async {
//   bool showOrders = false;
//   emit(state.copyWith(isLoading: true));
//
//   final MutationOptions options = MutationOptions(
//     document: gql(JetuOrderMutation.updateStatusOrder()),
//     variables: {
//       "orderId": orderId,
//       "status": status,
//     },
//   );
//
//   QueryResult res = await client.mutate(options);
//
//   print(res.exception);
//   if (status == 'finished' || status == 'canceled') {
//     print('showOrders when finished/canceled');
//     showOrders = true;
//   }
//
//   emit(state.copyWith(
//     isLoading: false,
//     isSheetFullView: true,
//     showOrders: showOrders,
//   ));
// }
//
// fetchNewOrders(bool fetch) {
//   emit(state.copyWith(showOrders: fetch));
// }
}
