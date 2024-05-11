import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final GraphQLClient client;

  OrderHistoryCubit({
    required this.client,
  }) : super(OrderHistoryState.initial());

  void init() async {
    emit(state.copyWith(isLoading: true));
    SharedPreferences pref = await SharedPreferences.getInstance();

    final QueryOptions options = QueryOptions(
      document: gql(JetuDriverSubscription.getUserOrderHistory()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "userId": pref.getString(AppSharedKeys.userId),
      },
      parserFn: (json) => JetuOrderList.fromUserJson(json),
    );

    QueryResult result = await client.query(options);
    JetuOrderList res = result.parsedData as JetuOrderList;
    emit(state.copyWith(
      isLoading: false,
      orderList: res.orders,
    ));
  }
}
