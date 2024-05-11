part of 'app_city_cubit.dart';


class AppCityState {
  final bool isLoading;
  final List<Point> cityList;

  AppCityState({
    required this.isLoading,
    required this.cityList,
  });

  factory AppCityState.initial() => AppCityState(
        isLoading: true,
        cityList: [],
      );

  AppCityState copyWith({
    bool? isLoading,
    List<Point>? cityList,
  }) =>
      AppCityState(
        isLoading: isLoading ?? this.isLoading,
        cityList: cityList ?? this.cityList,
      );
}