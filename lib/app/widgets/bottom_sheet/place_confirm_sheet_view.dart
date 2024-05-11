import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/widgets/button/app_button_v1.dart';
import 'package:jetu/app/widgets/map/new_marker.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:latlong2/latlong.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../const/app_const.dart';
import '../../view/home/bloc_old/home_cubit.dart';

enum MapPickSetPoint { fromAPoint, fromBPoint }

MapPickSetPoint currentPoint = MapPickSetPoint.fromAPoint;

class PlaceConfirmSheetView extends StatefulWidget {
  const PlaceConfirmSheetView({Key? key}) : super(key: key);

  @override
  State<PlaceConfirmSheetView> createState() => _PlaceConfirmSheetViewState();
}

class _PlaceConfirmSheetViewState extends State<PlaceConfirmSheetView> {
  final yandexMapController = Completer<YandexMapController>();
  List returnAdress = ['', Point(latitude: 0, longitude: 0)];
  @override
  void initState() {
    getCurrentLocation().ignore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Stack(children: [
          YandexMap(
            onCameraPositionChanged: (cameraPosition, reason, finished) async {
              if (finished) {
                String adress = await test(cameraPosition.target.latitude,
                    cameraPosition.target.longitude);
                returnAdress[1] = cameraPosition.target;
                returnAdress[0] = adress;
                setState(() {});
                print(cameraPosition);
              }
            },
            onMapCreated: (controller) {
              try {
                yandexMapController.complete(controller);
              } catch (e) {}
            },
          ),
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.blue,
                ),
              )),
          ((returnAdress[0].length != 0))
              ? Positioned(
                  left: 0,
                  top: 100,
                  bottom: 0,
                  right: 0,
                  child: Center(
                      child: Container(
                    height: (returnAdress[0].length > 30) ? 50 : 40,
                    width: 210,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: SizedBox(
                            width: 200,
                            child: Center(child: Text(returnAdress[0])))),
                  )))
              : Stack(),
          Positioned(
              left: 20,
              right: 20,
              bottom:
                  20, // Указываем, что кнопка должна быть в 20 пикселях от нижнего края
              child: AppButtonV1(
                  onTap: () {
                    Navigator.of(context).pop(returnAdress);
                  },
                  text: 'Подтвердить местоположение')),
        ]);
      },
    );
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
}

Future<String> test(double latitude, double longitude) async {
  final String url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lon=$longitude&lat=$latitude&zoom=18&addressdetails=1&accept-language=ru';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final component = jsonResponse['address'];
      print(jsonResponse['display_name']);
      final road = component['road'] ??
          jsonResponse['display_name']; // Handle null value for road
      final houseNumber =
          component['house_number'] ?? ''; // Handle null value for house_number
      final address = '$road $houseNumber';
      final point = {
        'pos': jsonResponse['lat'].toString() +
            ' ' +
            jsonResponse['lon'].toString()
      };

      return address;
    } else {
      print('Failed to load address data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return 'Не найдено';
}
