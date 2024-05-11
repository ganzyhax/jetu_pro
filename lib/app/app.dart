import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/app_router/app_router.gr.dart';
import 'package:jetu/app/resourses/app_themes.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/home/bloc_old/current_location_cubit.dart';
import 'package:jetu/app/view/home/bloc_old/home_cubit.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc_deleted/jetu_map_cubit.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';

class Jetu extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  Jetu({
    Key? key,
    required this.client,
  }) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(client: client.value)..init(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => HomeCubit(client: client.value)..init(),
            ),
            BlocProvider(
              create: (context) => JetuMapCubit(client: client.value)..init(),
            ),
            BlocProvider(
              create: (context) => YandexMapBloc(client: client.value)
                ..add(YandexMapLoad(isStart: true)),
            ),
            BlocProvider(
              create: (context) => CurrentLocationCubit(),
            ),
            BlocProvider(
              create: (context) => OrderCubit(client: client.value),
            ),
          ],
          child: GraphQLProvider(
            client: client,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Jetu Taxi',
              theme: AppThemes.appTheme,
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
            ),
          ),
        );
      },
    );
  }
}
