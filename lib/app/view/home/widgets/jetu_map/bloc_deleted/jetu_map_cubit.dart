import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu/app/services/network_service.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc_deleted/jetu_map_state.dart';
import 'package:jetu/data/app/full_location.dart';
import 'package:jetu/data/model/jetu_driver_model.dart';
import 'package:latlong2/latlong.dart';

class JetuMapCubit extends Cubit<JetuMapState> {
  final GraphQLClient client;

  JetuMapCubit({
    required this.client,
  }) : super(JetuMapState.initial());

  late Stream<QueryResult> nearDriverStream;

  final LatLng notEq = LatLng(0, 0);

  init() async {
    var coordinate = await Geolocator.getCurrentPosition();
    LatLng startPoint = LatLng(coordinate.latitude, coordinate.longitude);
    emit(state.copyWith(mapCenter: startPoint));
    String startAddress = await getGeocode(startPoint);
    emit(state.copyWith(currentAddress: startAddress));
  }

  Future<void> nearDrivers({LatLng? latLng}) async {
    print('nearDrivers: ${latLng}');
    final subscriptionDocument = gql(JetuDriverSubscription.getDrivers());
    nearDriverStream = client.subscribe(
      SubscriptionOptions(
        document: subscriptionDocument,
        variables: {
          "lat": latLng?.latitude ?? 41.635821,
          "long": latLng?.longitude ?? 41.632891,
        },
      ),
    );
  }

  onAddressChange(LatLng latLng) async {
    emit(state.copyWith(
      mapCenter: latLng,
      currentAddress: await getGeocode(latLng),
    ));
    final QueryOptions options = QueryOptions(
      document: gql(JetuDriverSubscription.getDrivers()),
      variables: {"lat": latLng.latitude, "long": latLng.longitude},
      parserFn: (json) =>
          JetuDriverList.fromUserJson(json, name: 'near_drivers'),
    );

    final QueryResult result = await client.query(options);
    if (result.data != null) {
      JetuDriverList data = result.parsedData as JetuDriverList;
      final dat = data.users.map((e) => {
            "lat": e.lat,
            "long": e.long,
            "angle": Random().nextDouble() * 2 * pi,
          });
      emit(state.copyWith(nearDrivers: dat));
    }
  }

  void updatePoints({required List<FullLocation> points}) async {
    if (points.isNotEmpty &&
        points.length >= 2 &&
        points.first.latlng != notEq &&
        points.last.latlng != notEq) {
      List<LatLng> remoteDirections =
          await NetworkService.requestPathFromMapBox(
        [
          [points.first.latlng.latitude, points.first.latlng.longitude],
          [points.last.latlng.latitude, points.last.latlng.longitude]
        ],
      );

      emit(state.copyWith(points: points, route: remoteDirections));
    }
  }

  Future<String> getGeocode(LatLng latLng) async {
    List<Placemark> place = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: 'RU',
    );

    return place.first.street ?? '';
  }
}
