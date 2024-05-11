part of 'home_cubit.dart';

class HomeState {
  final bool isLoading;
  final AppConfig appConfig;
  final bool storeUpdate;
  final String serviceId;
  final FullLocation aPoint;
  final FullLocation bPoint;
  final FullLocation? mapPickPoint;
  final double? mapCenter;

  const HomeState({
    required this.isLoading,
    required this.appConfig,
    required this.storeUpdate,
    required this.serviceId,
    required this.aPoint,
    required this.bPoint,
    this.mapPickPoint,
    this.mapCenter,
  });

  factory HomeState.initial() => HomeState(
        isLoading: false,
        appConfig: AppConfig(),
        storeUpdate: false,
        serviceId: '',
        aPoint: FullLocation(
          title: '',
          address: '',
          latlng: LatLng(
            0.0,
            0.0,
          ),
        ),
        bPoint: FullLocation(
          title: '',
          address: '',
          latlng: LatLng(
            0.0,
            0.0,
          ),
        ),
        mapPickPoint: null,
        mapCenter: 14,
      );

  HomeState copyWith({
    bool? isLoading,
    AppConfig? appConfig,
    bool? storeUpdate,
    String? serviceId,
    FullLocation? aPoint,
    FullLocation? bPoint,
    FullLocation? mapPickPoint,
    double? mapCenter,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        appConfig: appConfig ?? this.appConfig,
        storeUpdate: storeUpdate ?? this.storeUpdate,
        serviceId: serviceId ?? this.serviceId,
        aPoint: aPoint ?? this.aPoint,
        bPoint: bPoint ?? this.bPoint,
        mapPickPoint: mapPickPoint ?? this.mapPickPoint,
        mapCenter: mapCenter ?? 14,
      );
}
