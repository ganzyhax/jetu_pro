import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';

import 'package:jetu/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu/data/model/jetu_driver_model.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';
part 'yandex_map_event.dart';
part 'yandex_map_state.dart';

class YandexMapBloc extends Bloc<YandexMapEvent, YandexMapState> {
  Timer? _timer;

  final GraphQLClient client;

  YandexMapBloc({required this.client}) : super(YandexMapInitial()) {
    List aPoint = ['', Point(latitude: 0, longitude: 0)];
    List bPoint = ['', Point(latitude: 0, longitude: 0)];
    String status = '';
    bool isPointAChanged = false;
    List arriveTime = [];
    bool startedAddedApoint = false;
    bool onWayZoomed = false;
    bool startedZoomed = false;
    bool mustChangeStartedTimer = true;
    bool mustChangeOnwayTimer = true;
    bool mustChangeLoadTimer = true;
    bool mustAddNearDriver = true;
    List<Point> nearDrivers = [];
    List<String> nearDriversId = [];
    bool isMapLoaded = false;

    on<YandexMapEvent>((event, emit) async {
      if (event is YandexMapClear) {
        bPoint = ['', Point(latitude: 0, longitude: 0)];
        arriveTime = [];
        nearDrivers.clear();
        try {
          _timer!.cancel();
        } catch (e) {}

        mustChangeLoadTimer = false;
        log('STOP TIMER LOAD');
        if (event.withLoad) {
          emit(YandexMapLisClear(withLoad: true));
        } else {
          emit(YandexMapLisClear(withLoad: false));
        }

        emit(YandexMapLoaded(
            nearDrivers: nearDrivers,
            arriveTime: arriveTime,
            status: status,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapLoad) {
        log('MUST LOAD MAP');
        if (mustChangeLoadTimer) {
          try {
            _timer!.cancel();
          } catch (e) {}
          var coordinate = await Geolocator.getCurrentPosition();

          if (event.isStart) {
            nearDriversId.clear();
            log('LOAD TIMER GOOD && START');
            nearDrivers.clear();
            onWayZoomed = false;
            startedZoomed = false;

            arriveTime = [];
            status = '';
            startedAddedApoint = false;
            bPoint = ['', Point(latitude: 0, longitude: 0)];

            try {
              aPoint = await test(coordinate.latitude, coordinate.longitude);
              aPoint[1] = Point(
                  latitude:
                      double.parse(aPoint[1]['pos'].toString().split(' ')[0]),
                  longitude:
                      double.parse(aPoint[1]['pos'].toString().split(' ')[1]));
            } catch (e) {
              aPoint = ['', Point(latitude: 0, longitude: 0)];
              aPoint[1] = Point(
                  latitude: coordinate.latitude,
                  longitude: coordinate.longitude);
            }

            emit(YandexMapLisSetPointA(
                aPoint: Point(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude)));

            emit(YandexMapLoaded(
                status: status,
                nearDrivers: nearDrivers,
                arriveTime: arriveTime,
                aPoint: aPoint,
                bPoint: bPoint,
                isPointAChanged: isPointAChanged));
          }

          if (status == '') {
            List nearDriversSorted =
                removeDuplicates(nearDriversId, nearDrivers);
            log(nearDriversSorted.toString());
            emit(YandexMapSetDrivers(nearDrivers: nearDrivers, inOrder: false));
            add(YandexMapNearDriversTick());
          }

          emit(YandexMapLoaded(
              status: status,
              nearDrivers: nearDrivers,
              arriveTime: arriveTime,
              aPoint: aPoint,
              bPoint: bPoint,
              isPointAChanged: isPointAChanged));
        }
      }
      if (event is YandexMapSetAPoint) {
        aPoint = event.data;
        isPointAChanged = true;
        if (startedZoomed == false) {
          emit(YandexMapLisSetPointA(aPoint: aPoint[1], withZoom: true));
          startedZoomed = true;
        } else {
          emit(YandexMapLisSetPointA(aPoint: aPoint[1], withZoom: false));
        }

        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            nearDrivers: nearDrivers,
            status: status,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapSetBPoint) {
        isPointAChanged = true;
        bPoint = event.data;
        emit(YandexMapLisSetPointB(bPoint: bPoint[1], withZoom: true));
        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            aPoint: aPoint,
            status: status,
            bPoint: bPoint,
            nearDrivers: nearDrivers,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapSetBPointMinute) {
        if (!bPoint[0].toString().contains('мин') &&
            !bPoint[0].toString().contains('min')) {
          bPoint[0] = bPoint[0].toString() + ', ' + event.minute;
        }

        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            status: status,
            aPoint: aPoint,
            nearDrivers: nearDrivers,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapNearDriversTick) {
        if (mustChangeLoadTimer) {
          try {
            _timer!.cancel();
          } catch (e) {}

          _timer = Timer.periodic(const Duration(milliseconds: 10000),
              (timer) async {
            try {
              nearDrivers.clear();
              nearDriversId.clear();
              var coordinate = await Geolocator.getCurrentPosition();
              final QueryOptions options = QueryOptions(
                fetchPolicy: FetchPolicy.networkOnly,
                document: gql(JetuDriverSubscription.getDrivers()),
                variables: {
                  "lat": coordinate.latitude,
                  "long": coordinate.longitude
                },
              );

              final QueryResult result = await client.query(options);

              if (result.data != null) {
                for (var i = 0; i < result.data!['neardrivers'].length; i++) {
                  nearDriversId
                      .add(result.data!['neardrivers'][i]['lat'].toString());
                  nearDrivers.add(
                    Point(
                        latitude: double.parse(
                            result.data!['neardrivers'][i]['lat'].toString()),
                        longitude: double.parse(
                          result.data!['neardrivers'][i]['long'].toString(),
                        )),
                  );
                }
              }
            } catch (e) {}
            log('MUST ADD NEAR DRIVERS');

            add(YandexMapLoad(isStart: false));
          });
        }
      }

      if (event is YandexMapDriverOnWayDraw) {
        if (mustChangeOnwayTimer) {
          log('MUST DROW ON WAY');
          status = 'onWay';
          var driverData =
              await fetchDriverLocation(client, driverId: event.driverId);

          aPoint[1] = Point(
              latitude: double.parse(event.order!.aPointLat.toString()),
              longitude: double.parse(event.order!.aPointLong.toString()));

          emit(YandexMapLisSetPointA(aPoint: aPoint[1], withZoom: false));
          bPoint[1] =
              Point(latitude: driverData['lat'], longitude: driverData['long']);

          emit(YandexMapLisSetPointB(
            bPoint: bPoint[1],
            isCar: true,
            withZoom: false,
          ));
          log('ON WAY DROW');
          emit(YandexMapLoaded(
              arriveTime: arriveTime,
              status: status,
              aPoint: aPoint,
              bPoint: bPoint,
              isPointAChanged: isPointAChanged));
        }
      }
      if (event is YandexMapStartDriverTimer) {
        if (mustChangeStartedTimer) {
          if (event.isOnWay) {
            status = 'onWay';
            try {
              _timer?.cancel();
            } catch (e) {}

            _timer = Timer.periodic(const Duration(milliseconds: 3500),
                (timer) async {
              add(YandexMapDriverOnWayDraw(
                  driverId: event.driverId, order: event.order));
            });
          } else {
            log('CLICKEC START START');
            status = 'started';
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(milliseconds: 3500),
                (timer) async {
              add(YandexMapDriverStarted(order: event.order));
            });
          }
        }
      }
      if (event is YandexMapDriveraArriveTimeSet) {
        arriveTime = event.time;
        emit(YandexMapLoaded(
            status: status,
            arriveTime: arriveTime,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapDriverArrived) {
        try {
          _timer!.cancel();
        } catch (e) {}
        var driverData =
            await fetchDriverLocation(client, driverId: event.driverId);

        aPoint[1] =
            Point(latitude: driverData['lat'], longitude: driverData['long']);

        emit(YandexMapLisSetPointA(
            aPoint: aPoint[1], withZoom: true, isCar: true));
        arriveTime = [];

        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            aPoint: aPoint,
            bPoint: bPoint,
            status: status,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapDriverStarted) {
        status = 'started';

        var driverData =
            await fetchDriverLocation(client, driverId: event.order!.driver);
        aPoint[1] =
            Point(latitude: driverData['lat'], longitude: driverData['long']);
        emit(YandexMapLisSetPointA(
            aPoint: aPoint[1], isCar: true, withZoom: true));
        bPoint[1] = Point(
            latitude: double.parse(event.order!.bPointLat.toString()),
            longitude: double.parse(event.order!.bPointLong.toString()));
        emit(YandexMapLisSetPointB(
          bPoint: bPoint[1],
        ));
        startedAddedApoint = true;

        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            status: status,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapRequestedOrder) {
        aPoint[1] = Point(
            latitude: double.parse(event.order!.aPointLat.toString()),
            longitude: double.parse(event.order!.aPointLong.toString()));
        emit(YandexMapLisSetPointA(aPoint: aPoint[1], withZoom: false));
        emit(YandexMapLoaded(
            arriveTime: arriveTime,
            status: status,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapStopLoadTimer) {
        log('STOP LOAD TIMER');
        mustChangeLoadTimer = false;
        _timer!.cancel();
      }
      if (event is YandexMapStopOnWayTimer) {
        log('STOP ONWAY TIMER');
        mustChangeOnwayTimer = false;
        _timer!.cancel();
      }
      if (event is YandexMapStopStartTimer) {
        log('STOP START TIMER');
        mustChangeStartedTimer = false;
        _timer!.cancel();
      }
      if (event is YandexMapResetTimers) {
        log('RELOAD TIMERS TO TRUE');
        mustChangeStartedTimer = true;
        mustChangeOnwayTimer = true;
        mustChangeLoadTimer = true;
        _timer!.cancel();
      }
    });
  }
}

Future<List> test(double latitude, double longitude) async {
  final String url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lon=$longitude&lat=$latitude&zoom=18&addressdetails=1&accept-language=ru';
  try {
    List res = [];
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final component = jsonResponse['address'];

      final road = component['road'] ?? ''; // Handle null value for road
      final houseNumber =
          component['house_number'] ?? ''; // Handle null value for house_number
      final address = '$road $houseNumber';
      final point = {
        'pos': jsonResponse['lat'].toString() +
            ' ' +
            jsonResponse['lon'].toString()
      };

      res.add(address);
      res.add(point);

      return res;
    } else {
      print('Failed to load address data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

Future<List> getAddressFromCoordinates(
    double latitude, double longitude) async {
  const String apiKey = 'fb3fe377-05c0-4d2a-b49d-56694dd931b2';
  final String url =
      'https://geocode-maps.yandex.ru/1.x/?format=json&apikey=$apiKey&geocode=$longitude,$latitude';

  try {
    List res = [];
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final components =
          jsonResponse['response']['GeoObjectCollection']['featureMember'];

      if (components.isNotEmpty) {
        final address = components[0]['GeoObject']['name'];
        final point = components[0]['GeoObject']['Point'];

        res.add(address);
        res.add(point);
        return res;
      }
    } else {
      print('Failed to load address data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

Future<dynamic> fetchDriverLocation(GraphQLClient client,
    {required JetuDriverModel? driverId}) async {
  final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(JetuDriverSubscription.getDriverLocation()),
      variables: {"driverId": driverId!.id});

  final QueryResult result = await client.query(options);

  if (result.hasException) {
    throw Exception('Failed to load drivers');
  }
  final List<dynamic> drivers = result.data!['jetu_drivers'] as List<dynamic>;

  return drivers[0];
}

removeDuplicates(List<String> ids, List<Point> data) {
  assert(ids.length == data.length, 'Списки должны быть одинаковой длины');

  // Словарь для отслеживания первого вхождения каждого уникального ID
  Map<String, int> uniqueIds = {};

  // Обратный проход по списку ids, чтобы сохранить последний индекс дубликатов
  for (int i = ids.length - 1; i >= 0; i--) {
    if (!uniqueIds.containsKey(ids[i])) {
      // Если ID встречается впервые (с конца), сохраняем его индекс
      uniqueIds[ids[i]] = i;
    }
  }

  // Получаем индексы уникальных ID в правильном порядке
  List<int> uniqueIndexes = uniqueIds.values.toList()..sort();

  // Создаем новые списки для уникальных ID и данных
  List<String> newIds = [for (int index in uniqueIndexes) ids[index]];
  List<Point> newData = [for (int index in uniqueIndexes) data[index]];

  // Обновляем исходные списки
  ids
    ..clear()
    ..addAll(newIds);
  data
    ..clear()
    ..addAll(newData);
  return newData;
}
