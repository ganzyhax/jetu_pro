import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu/app/services/jetu_service/grapql_query.dart';
import 'package:jetu/app/view/intercity/bloc/intercity_cubit.dart';

part 'app_city_state.dart';

class AppCityCubit extends Cubit<AppCityState> {
  final GraphQLClient client;

  AppCityCubit({
    required this.client,
  }) : super(AppCityState.initial());
  String capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }

  void search(String text) async {
    if (text.isEmpty) {
      emit(state.copyWith(cityList: []));
    }
    if (text.isNotEmpty) {
      String searchText = capitalize(text);
      final QueryOptions options = QueryOptions(
        document: gql(JetuServicesQuery.getCity()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"query": "%$searchText%"},
        parserFn: (json) => PointList.fromUserJson(json),
      );

      QueryResult result = await client.query(options);
      PointList res = result.parsedData as PointList;

      emit(state.copyWith(cityList: res.points));
    }
  }
}
