import 'package:jetu/app/view/order/bloc/order_cubit.dart';
import 'package:jetu/data/model/jetu_order_model.dart';

class OrderState {
  final bool isLoading;
  final OrderType orderType;
  final JetuOrderModel? orderModel;

  final int initFare;
  final int currentFare;
  final bool showFareButton;

  const OrderState({
    required this.isLoading,
    required this.orderType,
    this.orderModel,
    required this.initFare,
    required this.currentFare,
    required this.showFareButton,
  });

  factory OrderState.initial() => const OrderState(
        isLoading: false,
        orderType: OrderType.none,
        orderModel: null,
        initFare: 0,
        currentFare: 0,
        showFareButton: false,
      );

  OrderState copyWith({
    bool? isLoading,
    OrderType? orderType,
    JetuOrderModel? orderModel,
    int? initFare,
    int? currentFare,
    bool? showFareButton,
  }) =>
      OrderState(
        isLoading: isLoading ?? this.isLoading,
        orderType: orderType ?? this.orderType,
        orderModel: orderModel ?? this.orderModel,
        initFare: initFare ?? this.initFare,
        currentFare: currentFare ?? this.currentFare,
        showFareButton: showFareButton ?? this.showFareButton,
      );
}
