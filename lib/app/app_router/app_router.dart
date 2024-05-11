import 'package:auto_route/auto_route.dart';
import 'package:jetu/app/view/auth/update_info_screen.dart';
import 'package:jetu/app/view/home/home_screen.dart';
import 'package:jetu/app/view/intercity/create/intercity_create_screen.dart';
import 'package:jetu/app/view/intercity/intercity_find_screen.dart';
import 'package:jetu/app/view/intercity/intercity_screen.dart';
import 'package:jetu/app/view/order_history/order_history_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      initial: true,
    ),
    AutoRoute(
      page: OrderHistoryScreen,
    ),
    AutoRoute(
      page: UpdateInfoScreen,
    ),
    AutoRoute(
      page: IntercityScreen,
      children: [
        AutoRoute(
          page: IntercityFindScreen,
        ),
        AutoRoute(
          page: IntercityCreateScreen,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
