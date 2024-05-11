import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/widgets/bottom_sheet/place_confirm_sheet_view.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'place_suggestions_event.dart';
part 'place_suggestions_state.dart';

class PlaceSuggestionsBloc
    extends Bloc<PlaceSuggestionsEvent, PlaceSuggestionsState> {
  PlaceSuggestionsBloc() : super(PlaceSuggestionsInitial()) {
    bool isLoading = false;
    String searchText = '';
    List suggestions = [];
    List currentCityCoordinates = [];
    on<PlaceSuggestionsEvent>((event, emit) async {
      String formatMilesAsKmOrM(double miles) {
        double kilometers = miles * 1.60934;

        if (kilometers < 1) {
          // Если меньше 1 км, конвертируем в метры и выводим без десятичных
          int meters = (kilometers * 1000).round();
          return '$meters м';
        } else {
          // Если 1 км или больше, округляем до 1 десятичного и выводим как км
          String roundedKilometers = kilometers.toStringAsFixed(1);
          return '$roundedKilometers км';
        }
      }

      Future<List> searchSuggestAdress(String query) async {
        List res = [];
        String cLat = currentCityCoordinates[0].toString();
        String cLon = currentCityCoordinates[1].toString();
        final String requestUrl =
            'https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=$cLat,$cLon&origin=maps-search-form&outformat=json&part=$query&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825';

        // final String requestUrl =
        //     'https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=$currentCityLat,$currentCityLong&origin=maps-search-form&outformat=json&part=$query&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825';

        try {
          if (query == '') {
            return [];
          } else {
            final response = await http.get(Uri.parse(requestUrl));
            if (response.statusCode == 200) {
              final jsonResponse = json.decode(response.body);

              for (var i = 0; i < jsonResponse['results'].length; i++) {
                var data = {};
                if (jsonResponse['results'][i]['type'] == 'toponym') {
                  String distance = formatMilesAsKmOrM(double.parse(
                      jsonResponse['results'][i]['distance']['text']
                          .toString()
                          .split(' ')[0]));
                  data = {
                    'pos': jsonResponse['results'][i]['pos'].toString(),
                    'fullAdress': jsonResponse['results'][i]['log_id']['where']
                            ['name']
                        .toString(),
                    'adress': jsonResponse['results'][i]['log_id']['where']
                            ['title']
                        .toString(),
                    "distance": distance,
                  };
                } else if (jsonResponse['results'][i]['type'] == 'business') {
                  String distance = formatMilesAsKmOrM(double.parse(
                      jsonResponse['results'][i]['distance']['text']
                          .toString()
                          .split(' ')[0]));
                  data = {
                    'pos': jsonResponse['results'][i]['pos'].toString(),
                    'fullAdress': jsonResponse['results'][i]['subtitle']['text']
                        .toString(),
                    'adress': jsonResponse['results'][i]['text'].toString(),
                    "distance": distance,
                  };
                } else {
                  print(jsonResponse['results'][i]);
                }
                res.add(data);
              }
              return res;
            } else {
              print(
                  'Ошибка при получении данных от Yandex Geocoder API. Код статуса: ${response.statusCode}.');
              return [];
            }
          }
        } catch (e) {
          print('Произошла ошибка при выполнении запроса: $e');
          return [];
        }
      }

      Future<List<double>> findCoordinateOfCurrentCity(String query) async {
        List<double> cordinates = [];
        final String requestUrl =
            'https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=67.528112%2C47.907455&origin=maps-search-form&outformat=json&part=$query&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825';

        // final String requestUrl =
        //     'https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=$currentCityLat,$currentCityLong&origin=maps-search-form&outformat=json&part=$query&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825';

        try {
          if (query == '') {
            return cordinates;
          } else {
            final response = await http.get(Uri.parse(requestUrl));

            if (response.statusCode == 200) {
              final jsonResponse = json.decode(response.body);
              List pointData =
                  jsonResponse['results'][0]['pos'].toString().split(',');
              double lat = double.parse(pointData[0]);
              double lon = double.parse(pointData[1]);
              cordinates = [lat, lon];

              return cordinates;
            } else {
              print(
                  'Ошибка при получении данных от Yandex Geocoder API. Код статуса: ${response.statusCode}.');
              return cordinates;
            }
          }
        } catch (e) {
          print('Произошла ошибка при выполнении запроса: $e');
          return cordinates;
        }
      }

      Future<String> getCityNameByCoordinate(
          double latitude, double longitude) async {
        final String url =
            'https://nominatim.openstreetmap.org/reverse?format=json&lon=$longitude&lat=$latitude&zoom=18&addressdetails=1&accept-language=ru';
        try {
          List res = [];
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final jsonResponse = json.decode(response.body);
            final component = jsonResponse['address'];
            print(jsonResponse);

            final cityName = component['city'];

            if (cityName == 'Карагандинская Г.А.') {
              cityName == 'Караганда';
            }
            return cityName;
          } else {
            print(response.body);
            print('Failed to load address data');
          }
        } catch (e) {
          print('Error: $e');
        }
        return '';
      }
      // Future<String> getCityNameByCoordinate(
      //     double latitude, double longitude) async {
      //   const String apiKey = 'fb3fe377-05c0-4d2a-b49d-56694dd931b2';
      //   final String url =
      //       'https://geocode-maps.yandex.ru/1.x/?format=json&apikey=$apiKey&geocode=$longitude,$latitude';

      //   try {
      //     List res = [];
      //     final response = await http.get(Uri.parse(url));
      //     if (response.statusCode == 200) {
      //       final jsonResponse = json.decode(response.body);

      //       final components = jsonResponse['response']['GeoObjectCollection']
      //           ['featureMember'];

      //       if (components.isNotEmpty) {
      //         final currentCityName = components[0]['GeoObject']
      //                     ['metaDataProperty']['GeocoderMetaData']
      //                 ['AddressDetails']['Country']['AdministrativeArea']
      //             ['SubAdministrativeArea']['Locality']['LocalityName'];

      //         return currentCityName.toString();
      //       }
      //     } else {
      //       print(response.body);
      //       print('Failed to load address data');
      //     }
      //   } catch (e) {
      //     print('Error: $e');
      //   }
      //   return '';
      // }

      if (event is PlaceSuggestionsLoad) {
        var coordinate = await Geolocator.getCurrentPosition();
        String currentCity = await getCityNameByCoordinate(
            coordinate.latitude, coordinate.longitude);

        currentCityCoordinates = await findCoordinateOfCurrentCity(currentCity);

        emit(PlaceSuggestionsLoaded(
            isLoading: isLoading,
            searchText: searchText,
            suggestions: suggestions));
      }
      if (event is PlaceSuggestionsSearch) {
        suggestions = await searchSuggestAdress(event.text);
        emit(PlaceSuggestionsLoaded(
            isLoading: isLoading,
            searchText: searchText,
            suggestions: suggestions));
      }
    });
  }
}
