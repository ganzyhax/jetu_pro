part of 'intercity_create_cubit.dart';

class IntercityCreateState {
  final bool isLoading;
  final List<JetuOrderModel> orderList;
  final bool isRequested;
  final IntercityOrderModel? order;

  IntercityCreateState({
    required this.isLoading,
    required this.orderList,
    required this.isRequested,
    required this.order,
  });

  factory IntercityCreateState.initial() => IntercityCreateState(
        isLoading: false,
        orderList: [],
        isRequested: false,
        order: null,
      );

  IntercityCreateState copyWith({
    bool? isLoading,
    List<JetuOrderModel>? orderList,
    bool? isRequested,
    IntercityOrderModel? order,
  }) =>
      IntercityCreateState(
        isLoading: isLoading ?? this.isLoading,
        orderList: orderList ?? this.orderList,
        isRequested: isRequested ?? this.isRequested,
        order: order ?? this.order,
      );
}

class IntercityOrderModel {
  final String? id;
  final Point? aPoint;
  final Point? bPoint;
  final String? price;
  final String? comment;
  final DateTime? date;
  final DateTime? time;
  final String? status;

  IntercityOrderModel({
    this.id,
    this.aPoint,
    this.bPoint,
    this.price,
    this.comment,
    this.date,
    this.time,
    this.status,
  });

  IntercityOrderModel.fromJson(Map<String, dynamic> data, {String name = ''})
      : id = name.isNotEmpty ? data[name]['id'] : data['id'],
        aPoint = name.isNotEmpty
            ? Point.fromJson(data[name]['jetu_city'])
            : Point.fromJson(data['jetu_city'], address: data['a_address']),
        bPoint = name.isNotEmpty
            ? Point.fromJson(data[name]['jetuCityByBCity'])
            : Point.fromJson(data['jetuCityByBCity'],
                address: data['b_address']),
        price = name.isNotEmpty ? data[name]['price'] : data['price'],
        comment = name.isNotEmpty ? data[name]['comment'] : data['comment'],
        date = name.isNotEmpty
            ? DateTime.parse(data[name]['date']).toLocal()
            : DateTime.parse(data['date']).toLocal(),
        time = name.isNotEmpty
            ? DateTime.parse(data[name]['time']).toLocal()
            : DateTime.parse(data['time']).toLocal(),
        status = name.isNotEmpty ? data[name]['status'] : data['status'];
}

class IntercityOrderModelList {
  final List<IntercityOrderModel> orders;

  IntercityOrderModelList.fromUserJson(Map<String, dynamic> data)
      : orders = (data["jetu_intercity_orders"] as List)
            .map((e) => IntercityOrderModel.fromJson(e))
            .toList();
}

class Point {
  final String? id;
  final String? title;
  final String? address;

  Point({
    this.id,
    this.title,
    this.address,
  });

  Point.fromJson(Map<String, dynamic> data, {String address = ''})
      : id = data['id'],
        title = data['title'],
        address = address;
}

class PointList {
  final List<Point> points;

  PointList.fromUserJson(Map<String, dynamic> data)
      : points =
            (data["jetu_city"] as List).map((e) => Point.fromJson(e)).toList();
}
