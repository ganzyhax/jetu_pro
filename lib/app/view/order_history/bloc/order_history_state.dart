part of 'order_history_cubit.dart';

class OrderHistoryState {
  final bool isLoading;
  final List<JetuOrderModel> orderList;

  OrderHistoryState({
    required this.isLoading,
    required this.orderList,
  });

  factory OrderHistoryState.initial() => OrderHistoryState(
        isLoading: true,
        orderList: [],
      );

  OrderHistoryState copyWith({
    bool? isLoading,
    List<JetuOrderModel>? orderList,
  }) =>
      OrderHistoryState(
        isLoading: isLoading ?? this.isLoading,
        orderList: orderList ?? this.orderList,
      );
}
