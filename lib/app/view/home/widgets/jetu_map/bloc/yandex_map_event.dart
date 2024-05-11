part of 'yandex_map_bloc.dart';

@immutable
class YandexMapEvent {}

class YandexMapLoad extends YandexMapEvent {
  bool isStart;

  YandexMapLoad({required this.isStart});
}

class YandexMapSetAPoint extends YandexMapEvent {
  List data;
  YandexMapSetAPoint({required this.data});
}

class YandexMapSetMapLoaded extends YandexMapEvent {
  bool isLoaded;
  YandexMapSetMapLoaded({required this.isLoaded});
}

class YandexMapSetBPoint extends YandexMapEvent {
  List data;
  YandexMapSetBPoint({required this.data});
}

class YandexMapSetBPointMinute extends YandexMapEvent {
  String minute;
  YandexMapSetBPointMinute({required this.minute});
}

class YandexMapDriverOnWayDraw extends YandexMapEvent {
  var driverId;
  JetuOrderModel? order;
  YandexMapDriverOnWayDraw({required this.driverId, required this.order});
}

class YandexMapStartDriverTimer extends YandexMapEvent {
  bool isOnWay;
  var driverId;
  var order;
  YandexMapStartDriverTimer(
      {required this.driverId, required this.isOnWay, required this.order});
}

class YandexMapDriveraArriveTimeSet extends YandexMapEvent {
  List time;
  YandexMapDriveraArriveTimeSet({required this.time});
}

class YandexMapDriverArrived extends YandexMapEvent {
  var driverId;
  YandexMapDriverArrived({required this.driverId});
}

class YandexMapDriverStarted extends YandexMapEvent {
  JetuOrderModel? order;
  YandexMapDriverStarted({required this.order});
}

class YandexMapRequestedOrder extends YandexMapEvent {
  JetuOrderModel? order;
  YandexMapRequestedOrder({required this.order});
}

class YandexMapClear extends YandexMapEvent {
  bool withLoad;
  YandexMapClear({required this.withLoad});
}

class YandexMapNearDriversTick extends YandexMapEvent {}

class YandexMapStopLoadTimer extends YandexMapEvent {}

class YandexMapStopOnWayTimer extends YandexMapEvent {}

class YandexMapStopStartTimer extends YandexMapEvent {}

class YandexMapResetTimers extends YandexMapEvent {}
