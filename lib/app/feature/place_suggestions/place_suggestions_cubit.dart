// import 'dart:developer';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jetu/app/services/network_service.dart';
// import 'package:jetu/data/model/place_item.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:yandex_geocoder/yandex_geocoder.dart';
// part 'place_suggestions_state.dart';

// class PlaceSuggestionsCubit extends Cubit<PlaceSuggestionsState> {
//   PlaceSuggestionsCubit() : super(PlaceSuggestionsState.initial());

//   void search({String? text}) async {
//     emit(state.copyWith(isLoading: true));
//     // await fetchBuildingsFromOSM('Абая');
//     await searchSuggestAdress(text.toString());
//     SearchLocation location = await NetworkService.placeGoogleAutocomplete(
//       text: text ?? '',
//     );
//     // log("location: ${location.candidates?.length}");

//     emit(
//       state.copyWith(
//         suggestions: location,
//         isLoading: false,
//         searchText: text,
//       ),
//     );
//   }
// }
// // https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=67.528112%2C47.907455&origin=maps-search-form&outformat=json&part=%D0%90%D0%B1%D0%B0%D1%8F&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825

// // 47.907461, 67.528105 Satbayev
// // 47.799830, 67.713811 жезказган
// // https://geocode-maps.yandex.ru/1.x?apikey=07beaa3f-8787-46f0-a5d1-2c8264b08d9e&lang=ru&geocode=Аба%20?uri=Сатпаев
// // https://geocode-maps.yandex.ru//1.x?apikey=07beaa3f-8787-46f0-a5d1-2c8264b08d9e&lang=ru&geocode=Абая?uri=Сатпаев
// const String apiKey =
//     '07beaa3f-8787-46f0-a5d1-2c8264b08d9e'; // Замените на ваш действительный API ключ
// Future<List> searchSuggestAdress(String query) async {
//   List res =
//       []; // Ограничиваем поиск городом Астана и уточняем запрос до уровня улиц
//   final String requestUrl =
//       'https://suggest-maps.yandex.com/suggest-geo?add_chains_loc=1&add_coords=1&add_rubrics_loc=1&bases=geo%2Cbiz%2Ctransit&client_reqid=1707670677865_271544&custom_ranking=gdu_target_3&fullpath=1&lang=ru_US&ll=67.528112%2C47.907455&origin=maps-search-form&outformat=json&part=$query&pos=4&spn=0.008184898926543838%2C0.008902582057892516&v=9&yu=8152724851673436825';

//   try {
//     final response = await http.get(Uri.parse(requestUrl));
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       for (var i = 0; i < jsonResponse['results'].length; i++) {
//         log(jsonResponse['results'][i].toString());
//         print('Position:' + jsonResponse['results'][i]['pos'].toString());
//         print('Adress:' +
//             jsonResponse['results'][i]['log_id']['where']['name'].toString());
//         print('Title :' +
//             jsonResponse['results'][i]['log_id']['where']['title'].toString());
//         var data = {
//           'pos': jsonResponse['results'][i]['pos'].toString(),
//           'fullAdress':
//               jsonResponse['results'][i]['log_id']['where']['name'].toString(),
//           'adress':
//               jsonResponse['results'][i]['log_id']['where']['title'].toString()
//         };
//         res.add(data);
//       }
//       return res;
//     } else {
//       print(
//           'Ошибка при получении данных от Yandex Geocoder API. Код статуса: ${response.statusCode}.');
//       return [];
//     }
//   } catch (e) {
//     print('Произошла ошибка при выполнении запроса: $e');
//     return [];
//   }
// }
