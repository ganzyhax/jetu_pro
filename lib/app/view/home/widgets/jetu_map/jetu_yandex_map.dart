import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class JetuYandexMap extends StatefulWidget {
  const JetuYandexMap({Key? key}) : super(key: key);

  @override
  State<JetuYandexMap> createState() => _JetuYandexMapState();
}

class _JetuYandexMapState extends State<JetuYandexMap> {
  @override
  void initState() {
    super.initState();

    // getCurrentLocation().ignore();
  }

  List<MapObject<dynamic>> mapObjects = [];
  List<MapObject<dynamic>> mapDrivers = [];
  final yandexMapController = Completer<YandexMapController>();
  List<Point> points = [];
  DrivingResultWithSession? _drivingResultWithSession;
  List<PolylineMapObject> _drivingMapLines = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<YandexMapBloc, YandexMapState>(
      listener: (context, state) {
        if (state is YandexMapClearNearDrivers) {}
        if (state is YandexMapLisClear) {
          mapObjects.clear();
          _drivingResultWithSession = null;
          _drivingMapLines.clear();
          points.clear();
          setState(() {});
          log(' CLEAR LINES');

          if (state.withLoad) {
            BlocProvider.of<YandexMapBloc>(context)
              ..add(YandexMapLoad(isStart: true));
          }
        }
        if (state is YandexMapClearNearDrivers) {
          log(mapObjects.toString());
        }
        if (state is YandexMapSetDrivers) {
          // Peradal List Points
          // Mozhno i single Point davat'

          addMapObject(state.nearDrivers, 'drivers', isCar: true);
          setState(() {});
        }
        if (state is YandexMapLisSetPointA) {
          _drivingResultWithSession = null;
          if (points.length == 0) {
            print('FIRST ADD A');
            points.add(state.aPoint);
            if (state.isCar == true) {
              addMapObject(state.aPoint, 'pointA', isCar: true);
            } else {
              addMapObject(state.aPoint, 'pointA');
            }

            _moveToCurrentLocation(state.aPoint, true);

            setState(() {});
          } else {
            print('Second ADD A');

            points[0] = state.aPoint;

            if (state.isCar == true) {
              addMapObject(state.aPoint, 'pointA', isCar: true);
            } else {
              addMapObject(state.aPoint, 'pointA');
            }
            if (state.withZoom == true && state.isCar == true) {
              _moveToCurrentLocation(
                state.aPoint,
                true,
              );
            } else if (state.withZoom == true) {
              _moveToCurrentLocation(
                state.aPoint,
                true,
              );
            }
            setState(() {});

            if (points.length == 2) {
              _drivingResultWithSession = _getDrivingResultWithSession(
                startPoint: points.first,
                endPoint: points.last,
              );
              setState(() {});
              if (state.isCar == true) {
                _buildRoutes(isAddArriveTime: true);
              } else {
                _buildRoutes();
              }
            }
          }
        }
        if (state is YandexMapLisSetPointB) {
          _drivingResultWithSession = null;
          if (points.length == 1) {
            print('FIRST ADD B');
            points.add(state.bPoint);

            if (state.isCar == true) {
              addMapObject(state.bPoint, 'pointB', isCar: true);
            } else {
              addMapObject(state.bPoint, 'pointB');
            }
            double middleLatitude =
                (points[0].latitude + state.bPoint.latitude) / 2;
            double middleLongitude =
                (points[0].longitude + state.bPoint.longitude) / 2;
            final middlePointCamera =
                Point(latitude: middleLatitude, longitude: middleLongitude);
            if (state.isCar == true) {
              _moveToCurrentLocation(state.bPoint, true, fullShow: true);
            } else {
              _moveToCurrentLocation(middlePointCamera, true, fullShow: true);
            }

            setState(() {});
          } else {
            print('SECOND ADD B');
            points[1] = state.bPoint;

            if (state.isCar == true) {
              addMapObject(state.bPoint, 'pointB', isCar: true);
            } else {
              addMapObject(
                state.bPoint,
                'pointB',
              );
            }

            double middleLatitude =
                (points[0].latitude + state.bPoint.latitude) / 2;
            double middleLongitude =
                (points[0].longitude + state.bPoint.longitude) / 2;
            final middlePointCamera =
                Point(latitude: middleLatitude, longitude: middleLongitude);
            if (state.withZoom == true) {
              if (state.isCar == true) {
                _moveToCurrentLocation(state.bPoint, true, fullShow: true);
              } else {
                _moveToCurrentLocation(middlePointCamera, true, fullShow: true);
              }
            }

            setState(() {});
          }
          _drivingResultWithSession = _getDrivingResultWithSession(
            startPoint: points[0],
            endPoint: points[1],
          );
          setState(() {});
          if (state.isCar == true) {
            _buildRoutes(isAddArriveTime: true, isB: true);
          } else {
            _buildRoutes(isB: true);
          }
        }
      },
      child: BlocBuilder<YandexMapBloc, YandexMapState>(
        builder: (context, state) {
          if (state is YandexMapLoaded) {
            return Stack(
              children: [
                YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated: (controller) {
                    try {
                      yandexMapController.complete(controller);
                    } catch (e) {}
                  },
                ),
                (state.arriveTime.length == 2)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 35, left: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.blue,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (state.status == 'onWay')
                                      ? 'Водитель прибудет через: ' +
                                          state.arriveTime[1]
                                      : 'Примерное время прибытия: ' +
                                          state.arriveTime[1],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RawMaterialButton(
                      onPressed: () async {
                        await getCurrentLocation();
                      },
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      shape: const CircleBorder(),
                      child: const Icon(
                        CupertinoIcons.location_fill,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(
            child: Text('NOT LOAD'),
          );
        },
      ),
    );
  }

  Future<void> _buildRoutes(
      {bool isAddArriveTime = false, bool isB = false}) async {
    if (points.length == 2) {
      final drivingResult = await _drivingResultWithSession?.result;
      _drivingMapLines.clear();
      setState(() {
        for (var element in drivingResult?.routes ?? []) {
          _drivingMapLines.add(
            PolylineMapObject(
              mapId: MapObjectId('route $element'),
              polyline: Polyline(points: element.geometry),
              strokeColor: Colors.blue,
              strokeWidth: 3,
            ),
          );
          DrivingSectionMetadata drivingSectionMetadata = element.metadata;

          String km = drivingSectionMetadata.weight.distance.text.toString();
          String minutes =
              drivingSectionMetadata.weight.timeWithTraffic.text.toString();
          if (isAddArriveTime == true) {
            List arriveData = [];
            arriveData.add(km);
            arriveData.add(minutes);
            BlocProvider.of<YandexMapBloc>(context)
              ..add(YandexMapDriveraArriveTimeSet(time: arriveData));
          }

          if (points.length == 2 && isB) {
            BlocProvider.of<YandexMapBloc>(context)
              ..add(YandexMapSetBPointMinute(minute: minutes));
          }
        }
        mapObjects = mapObjects.take(2).toList();
        mapObjects.addAll(_drivingMapLines);
      });
      setState(() {});
    }
  }

  DrivingResultWithSession _getDrivingResultWithSession({
    required Point startPoint,
    required Point endPoint,
  }) {
    var drivingResultWithSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: startPoint,
          requestPointType: RequestPointType.wayPoint, // точка начала маршрута
        ),
        RequestPoint(
          point: endPoint,
          requestPointType: RequestPointType.wayPoint, // точка конца маршрута
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
        avoidPoorConditions: true,
      ),
    );

    return drivingResultWithSession;
  }

  Future<void> getCurrentLocation() async {
    var coordinate = await Geolocator.getCurrentPosition();
    // addMapObject(coordinate, false);

    _moveToCurrentLocation(coordinate, false);
  }

  Future<void> _moveToCurrentLocation(location, isYandex,
      {bool? fullShow}) async {
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: (isYandex == false)
              ? Point(
                  latitude: location.latitude, longitude: location.longitude)
              : location,
          zoom: (fullShow == true) ? 13 : 16,
        ),
      ),
    );
  }

  void addMapObject(location, pointType, {bool isCar = false}) {
    if (pointType == 'pointA') {
      final myLocationMarker = PlacemarkMapObject(
        mapId: const MapObjectId('pointA'),
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: (!isCar) ? 0.8 : 0.35,
            rotationType: RotationType.noRotation,
            image: BitmapDescriptor.fromAssetImage(
              (!isCar)
                  ? 'assets/icons/location_logo.png'
                  : 'assets/icons/car_top.png',
            ),
          ),
        ),
        point:
            Point(latitude: location.latitude, longitude: location.longitude),
      );
      if (mapObjects.length == 0) {
        mapObjects.add(myLocationMarker);
      } else {
        mapObjects[0] = myLocationMarker;
      }
    } else if (pointType == 'pointB') {
      final myLocationMarker = PlacemarkMapObject(
        mapId: const MapObjectId('pointB'),
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: (!isCar) ? 0.8 : 0.35,
            rotationType: RotationType.rotate,
            image: BitmapDescriptor.fromAssetImage(
              (!isCar)
                  ? 'assets/icons/location_logo.png'
                  : 'assets/icons/car_top.png',
            ),
          ),
        ),
        point:
            Point(latitude: location.latitude, longitude: location.longitude),
      );
      if (mapObjects.length == 1) {
        mapObjects.add(myLocationMarker);
      } else if (mapObjects.length > 1) {
        mapObjects[1] = myLocationMarker;
      }
      setState(() {});
    } else {
      print(mapObjects.length);
      mapObjects.removeWhere((item) => mapDrivers.contains(item));
      mapDrivers.clear();
      setState(() {});
      print(mapObjects.length);
      for (var i = 0; i < location.length; i++) {
        final driver = PlacemarkMapObject(
          mapId: MapObjectId('driver' + i.toString()),
          opacity: 1,
          direction: (i == 0)
              ? 50
              : (i == 1)
                  ? 120
                  : (i == 2)
                      ? 19
                      : (i == 3)
                          ? 90
                          : 320,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              scale: (!isCar) ? 0.8 : 0.35,
              rotationType: RotationType.rotate,
              image: BitmapDescriptor.fromAssetImage(
                (!isCar)
                    ? 'assets/icons/location_logo.png'
                    : 'assets/icons/car_top.png',
              ),
            ),
          ),
          point: Point(
              latitude: location[i].latitude, longitude: location[i].longitude),
        );

        mapDrivers.add(driver);
      }
      mapObjects.addAll(mapDrivers);
      setState(() {});
    }
  }
}
