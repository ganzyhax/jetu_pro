part of 'yandex_map_bloc.dart';

@immutable
class YandexMapState {}

class YandexMapInitial extends YandexMapState {}

class YandexMapLoaded extends YandexMapState {
  List aPoint;
  List bPoint;
  bool isPointAChanged;
  String status;
  List arriveTime;
  List? nearDrivers;
  YandexMapLoaded(
      {required this.aPoint,
      required this.arriveTime,
      this.nearDrivers,
      required this.status,
      required this.bPoint,
      required this.isPointAChanged});
}

class YandexMapLisSetPointA extends YandexMapState {
  bool? isCar;
  Point aPoint;
  bool? withZoom;
  YandexMapLisSetPointA({required this.aPoint, this.isCar, this.withZoom});
}

class YandexMapLisSetPointB extends YandexMapState {
  Point bPoint;
  bool? isCar;
  bool? withZoom;
  YandexMapLisSetPointB({required this.bPoint, this.isCar, this.withZoom});
}

class YandexMapClearNearDrivers extends YandexMapState {}

class YandexMapLisClear extends YandexMapState {
  bool withLoad;
  YandexMapLisClear({required this.withLoad});
}

class YandexMapSetDrivers extends YandexMapState {
  bool inOrder;
  List<dynamic> nearDrivers;
  YandexMapSetDrivers({required this.nearDrivers, required this.inOrder});
}
