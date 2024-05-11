import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/const/app_const.dart';

class GraphQlService {
  static Future<ValueNotifier<GraphQLClient>> init() async {
    final Link httpLink = HttpLink(
      AppConst.hasuraHttpPoint,
      defaultHeaders: AppConst.hasuraKey,
    );

    final WebSocketLink webSocketLink = WebSocketLink(
      AppConst.hasuraWebSocketPoint,
      config: const SocketClientConfig(
        parser: ResponseParser(),
        autoReconnect: true,
        inactivityTimeout: Duration(hours: 1),
        headers: AppConst.hasuraKey,
      ),
    );

    final Link link = Link.split(
      (request) => request.isSubscription,
      webSocketLink,
      httpLink,
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(
          store: HiveStore(),
        ),
      ),
    );
    return client;
  }

  static GraphQLClient getGraphQLClient() {
    final Link httpLink = HttpLink(
      AppConst.hasuraHttpPoint,
      defaultHeaders: AppConst.hasuraKey,
    );

    final WebSocketLink webSocketLink = WebSocketLink(
      AppConst.hasuraWebSocketPoint,
      config: const SocketClientConfig(
        parser: ResponseParser(),
        autoReconnect: true,
        inactivityTimeout: Duration(hours: 1),
        headers: AppConst.hasuraKey,
      ),
    );

    final Link link = Link.split(
        (request) => request.isSubscription, webSocketLink, httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }
}
