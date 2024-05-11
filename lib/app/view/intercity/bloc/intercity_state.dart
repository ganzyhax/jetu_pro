part of 'intercity_cubit.dart';

class IntercityState {
  final bool isLoading;
  final bool isRequested;
  final IntercityOrderModel? order;

  IntercityState({
    required this.isLoading,
    required this.isRequested,
    required this.order,
  });

  factory IntercityState.initial() => IntercityState(
        isLoading: false,
        isRequested: false,
        order: null,
      );

  IntercityState copyWith({
    bool? isLoading,
    bool? isRequested,
    IntercityOrderModel? order,
  }) =>
      IntercityState(
        isLoading: isLoading ?? this.isLoading,
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
  final JetuDriverModel? driver;

  IntercityOrderModel({
    this.id,
    this.aPoint,
    this.bPoint,
    this.price,
    this.comment,
    this.date,
    this.time,
    this.status,
    this.driver,
  });

  IntercityOrderModel.fromJson(Map<String, dynamic> data, {String name = ''})
      : id = name.isNotEmpty ? data[name]['id'] : data['id'],
        driver = data['jetu_driver'] != null
            ? JetuDriverModel.fromJson(data['jetu_driver'])
            : null,
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
