import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'intercity_create_state.dart';

class IntercityCreateCubit extends Cubit<IntercityCreateState> {
  final GraphQLClient client;

  IntercityCreateCubit({required this.client})
      : super(IntercityCreateState.initial());

  late SharedPreferences _pref;

  void order() async {
    emit(state.copyWith(isLoading: true));
    _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';

    final order = {
      "user_id": userId,
      "a_city": state.order?.aPoint?.id ?? '',
      "a_address": state.order?.aPoint?.address ?? '',
      "b_city": state.order?.bPoint?.id ?? '',
      "b_address": state.order?.bPoint?.address ?? '',
      "price": state.order?.price ?? '',
      "date": state.order?.date?.toLocal().toString() ?? '',
      "time": state.order?.time?.toLocal().toString() ?? '',
      "status": 'finding',
    };

    if (state.order?.comment?.isNotEmpty ?? false) {
      order.putIfAbsent('comment', () => state.order?.comment ?? '');
    }

    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.createIntercityPost()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"object": order},
    );
    QueryResult res = await client.mutate(options);
    log("crateIntercityOrder: ${res.exception}");
    emit(state.copyWith(isLoading: false));
  }

  void cancelOrder({
    required String orderId,
  }) async {
    emit(state.copyWith(isLoading: true));
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.updateStatusIntercityOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "status": "canceled",
      },
    );
    QueryResult res = await client.mutate(options);
    print('res: ${res.exception}');
    emit(state.copyWith(isLoading: false));
  }

  void setAPoint(String? id, String? title, String? address) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: Point(
            id: id,
            title: title,
            address: address,
          ),
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setBPoint(String? id, String? title, String? address) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: Point(
            id: id,
            title: title,
            address: address,
          ),
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setPrice(String price) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setComment(String comment) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setDate(DateTime date) async {
    log(date.toString());
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setTime(DateTime time) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: time,
        ),
      ),
    );
  }
}
