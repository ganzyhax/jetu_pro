import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GetIt injection = GetIt.I;

Future setGraphClient(GraphQLClient client) async {
  injection.registerLazySingleton<GraphQLClient>(
    () => client,
  );
}
