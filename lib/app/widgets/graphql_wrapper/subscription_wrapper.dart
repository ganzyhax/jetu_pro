import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/widgets/error_widget.dart';
import 'package:jetu/data/model/error.dart';

class SubscriptionWrapper<T> extends StatelessWidget {
  const SubscriptionWrapper({
    Key? key,
    required this.queryString,
    required this.contentBuilder,
    required this.dataParser,
    this.variables,
  }) : super(key: key);
  final Map<String, dynamic>? variables;
  final String queryString;
  final Widget Function(T data) contentBuilder;
  final T Function(Map<String, dynamic> data) dataParser;

  @override
  Widget build(BuildContext context) {
    return Subscription(
      options: SubscriptionOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(queryString),
        variables: variables ?? const {},
        parserFn: dataParser,
      ),
      builder: (
        QueryResult result, {
        VoidCallback? refetch,
        FetchMore? fetchMore,
      }) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          return AppErrorWidget(
            error: ErrorModel.fromString(
              result.exception.toString(),
            ),
          );
        }
        return ResultAccumulator?.appendUniqueEntries(
            latest: result.data,
            builder: (context, {results}) => contentBuilder(result.parserFn(result.data ?? {}) as T)
        );
      },
    );
  }
}
