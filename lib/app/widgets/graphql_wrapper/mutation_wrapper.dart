import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/widgets/error_widget.dart';
import 'package:jetu/data/model/error.dart';

class MutationWrapper extends StatelessWidget {
  const MutationWrapper({
    Key? key,
    required this.queryString,
    required this.child,
    required this.onTapValue,
  }) : super(key: key);
  final Map<String, dynamic> onTapValue;
  final String queryString;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(queryString),
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        if (result?.isLoading ?? false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result?.hasException ?? false) {
          return AppErrorWidget(
            error: ErrorModel.fromString(
              result?.exception.toString() ?? '',
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            print('Tap');
            runMutation(onTapValue);
          },
          child: child,
        );
      },
    );
  }
}
