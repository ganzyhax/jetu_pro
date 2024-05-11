import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu/app/services/network_service.dart';
import 'package:jetu/app/widgets/bottom_sheet/place_confirm_sheet_view.dart';
import 'package:jetu/data/app/app_config.dart';
import 'package:jetu/data/app/full_location.dart';
import 'package:jetu/data/model/jetu_order_model.dart';
import 'package:jetu/data/model/place_item.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GraphQLClient client;

  HomeCubit({
    required this.client,
  }) : super(HomeState.initial());

  final LatLng emptyLocation = LatLng(0.0, 0.0);

  Future<void> init() async {
    // emit(state.copyWith(isLoading: true, storeUpdate: true));
    // FirebaseRemoteConfig remoteConfig =
    //     await ApiFirebaseRemoteConfigGateway.getConfig();
    //
    // final res = await AppVersionUpdate.checkForUpdates(
    //     appleId: AppConst.appStoreId,
    //     playStoreId: AppConst.playMarketId,
    //     country: 'kz');

    emit(
      state.copyWith(
        isLoading: false,
        appConfig: AppConfig(),
        storeUpdate: false,
      ),
    );
  }

  Future<void> setServiceId(String serviceId) async {
    emit(state.copyWith(serviceId: serviceId));
  }

  Future<void> setMapPoint(LatLng latLng) async {
    final res = await NetworkService.placeGoogleGeoCoding(
      latLng: latLng,
    );
    print(res.results);

    emit(
      state.copyWith(
        isLoading: false,
        aPoint: FullLocation(
          latlng: LatLng(
            res.results.first.geometry.location?.lat ?? 0.0,
            res.results.first.geometry.location?.lng ?? 0.0,
          ),
          address: res.results.first.placeId,
          title: res.results.first.formattedAddress,
        ),
      ),
    );
  }

  Future<dynamic> setMapPickPointInit(MapPickSetPoint pickSetPoint) async {
    if (pickSetPoint == MapPickSetPoint.fromBPoint &&
        state.bPoint.title.isNotEmpty) {
      emit(
        state.copyWith(
          mapPickPoint: state.bPoint,
        ),
      );
      return;
    }

    if (state.aPoint.latlng.longitude == 0.0 &&
        state.aPoint.latlng.longitude == 0.0) {
      final add = FullLocation(
        latlng: LatLng(48.43113331651381, 68.22826132545366),
        address: "",
        title: "",
      );
      emit(
        state.copyWith(
          mapPickPoint: add,
          mapCenter: 4,
        ),
      );
    } else {
      emit(
        state.copyWith(
          mapPickPoint: state.aPoint,
        ),
      );
    }

    log("setMapPickPointInit1");

    return;
  }

  Future<void> setMapPickPoint(LatLng latLng) async {
    emit(state.copyWith(isLoading: false));
    final res = await NetworkService.placeGoogleGeoCoding(
      latLng: latLng,
    );

    emit(
      state.copyWith(
        isLoading: false,
        mapPickPoint: FullLocation(
          latlng: LatLng(
            res.results.first.geometry.location?.lat ?? 0.0,
            res.results.first.geometry.location?.lng ?? 0.0,
          ),
          address: res.results.first.placeId,
          title: res.results.first.formattedAddress,
        ),
      ),
    );
  }

  Future<void> setAPoint(Candidate candidate) async {
    emit(
      state.copyWith(
        aPoint: FullLocation(
          latlng: LatLng(
            candidate.geometry?.location?.lat ?? 0.0,
            candidate.geometry?.location?.lng ?? 0.0,
          ),
          address: candidate.name ?? '',
          title: candidate.formattedAddress ?? '',
        ),
      ),
    );
  }

  Future<void> setBPoint(Candidate candidate) async {
    emit(
      state.copyWith(
        bPoint: FullLocation(
          latlng: LatLng(
            candidate.geometry?.location?.lat ?? 0.0,
            candidate.geometry?.location?.lng ?? 0.0,
          ),
          address: candidate.name ?? '',
          title: candidate.formattedAddress ?? '',
        ),
      ),
    );
  }

  void sendOrder(
      {required String cost,
      required String comment,
      required Point aPoint,
      required Point bPoint,
      required String aPointAddress,
      required String bPointAddress,
      required String serviceId,
      required String currency}) async {
    emit(state.copyWith(isLoading: true));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(AppSharedKeys.userId) ??
        '9e1edb50-cb3d-11ee-95d0-7166cffffb33';

    if (aPoint == emptyLocation) {
      var coordinate = await Geolocator.getLastKnownPosition();
      aPoint = Point(
        latitude: coordinate?.latitude ?? 0.0,
        longitude: coordinate?.longitude ?? 0.0,
      );
    }

    //point_a_lat: 12.6838492
    //point_a_long: 108.0445774
    //point_b_lat: 12.6838492
    //point_b_long: 108.0445774
    // A point - 12.6838492, 108.0445774
    // B point - 12.6838492, 108.0445774

    final variables = {
      "object": {
        "user_id": userId,
        "cost": cost,
        "comment": comment,
        "status": "requested",
        "point_a_lat": aPoint.latitude,
        "point_a_long": aPoint.longitude,
        "point_b_lat": bPoint.latitude,
        "point_b_long": bPoint.longitude,
        "point_a_address": aPointAddress,
        "point_b_address": bPointAddress,
        "service_id": serviceId,
        'currency': currency,
      }
    };

    log('variables: $variables');

    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.orderTaxi()),
      variables: variables,
    );

    QueryResult res = await client.mutate(options);
    emit(state.copyWith(isLoading: false));
    log(res.toString());
  }

  Future<void> cancelOrder({
    required JetuOrderModel order,
  }) async {
    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.cancelOrder()),
      variables: {"orderId": order.id},
    );

    await client.mutate(options);
  }
}
