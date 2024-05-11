import 'package:jetu/data/app/full_location.dart';
import 'package:jetu/data/model/jetu_driver_model.dart';
import 'package:latlong2/latlong.dart';

class JetuMapState {
  final LatLng mapCenter;
  final String currentAddress;
  final dynamic nearDrivers;
  final List<FullLocation> points;
  final List<LatLng> route;

  const JetuMapState({
    required this.mapCenter,
    required this.currentAddress,
    required this.nearDrivers,
    required this.points,
    required this.route,
  });

  factory JetuMapState.initial() => JetuMapState(
        mapCenter: LatLng(0.0, 0.0),
        currentAddress: '',
        nearDrivers: [],
        points: [],
        route: [],
      );

  JetuMapState copyWith({
    LatLng? mapCenter,
    String? currentAddress,
    dynamic nearDrivers,
    List<FullLocation>? points,
    List<LatLng>? route,
  }) =>
      JetuMapState(
        mapCenter: mapCenter ?? this.mapCenter,
        currentAddress: currentAddress ?? this.currentAddress,
        nearDrivers: nearDrivers ?? this.nearDrivers,
        points: points ?? this.points,
        route: route ?? this.route,
      );
}
