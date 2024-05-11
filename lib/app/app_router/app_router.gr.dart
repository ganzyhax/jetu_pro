// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../../data/model/jetu_user_model.dart' as _i9;
import '../view/auth/update_info_screen.dart' as _i3;
import '../view/home/home_screen.dart' as _i1;
import '../view/intercity/create/intercity_create_screen.dart' as _i6;
import '../view/intercity/intercity_find_screen.dart' as _i5;
import '../view/intercity/intercity_screen.dart' as _i4;
import '../view/order_history/order_history_screen.dart' as _i2;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    OrderHistoryScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.OrderHistoryScreen(),
      );
    },
    UpdateInfoScreen.name: (routeData) {
      final args = routeData.argsAs<UpdateInfoScreenArgs>(
          orElse: () => const UpdateInfoScreenArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.UpdateInfoScreen(
          key: args.key,
          user: args.user,
          isEdit: args.isEdit,
        ),
      );
    },
    IntercityScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.IntercityScreen(),
      );
    },
    IntercityFindScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.IntercityFindScreen(),
      );
    },
    IntercityCreateScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.IntercityCreateScreen(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          HomeScreen.name,
          path: '/',
        ),
        _i7.RouteConfig(
          OrderHistoryScreen.name,
          path: '/order-history-screen',
        ),
        _i7.RouteConfig(
          UpdateInfoScreen.name,
          path: '/update-info-screen',
        ),
        _i7.RouteConfig(
          IntercityScreen.name,
          path: '/intercity-screen',
          children: [
            _i7.RouteConfig(
              IntercityFindScreen.name,
              path: 'intercity-find-screen',
              parent: IntercityScreen.name,
            ),
            _i7.RouteConfig(
              IntercityCreateScreen.name,
              path: 'intercity-create-screen',
              parent: IntercityScreen.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreen extends _i7.PageRouteInfo<void> {
  const HomeScreen()
      : super(
          HomeScreen.name,
          path: '/',
        );

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.OrderHistoryScreen]
class OrderHistoryScreen extends _i7.PageRouteInfo<void> {
  const OrderHistoryScreen()
      : super(
          OrderHistoryScreen.name,
          path: '/order-history-screen',
        );

  static const String name = 'OrderHistoryScreen';
}

/// generated route for
/// [_i3.UpdateInfoScreen]
class UpdateInfoScreen extends _i7.PageRouteInfo<UpdateInfoScreenArgs> {
  UpdateInfoScreen({
    _i8.Key? key,
    _i9.JetuUserModel? user,
    bool isEdit = false,
  }) : super(
          UpdateInfoScreen.name,
          path: '/update-info-screen',
          args: UpdateInfoScreenArgs(
            key: key,
            user: user,
            isEdit: isEdit,
          ),
        );

  static const String name = 'UpdateInfoScreen';
}

class UpdateInfoScreenArgs {
  const UpdateInfoScreenArgs({
    this.key,
    this.user,
    this.isEdit = false,
  });

  final _i8.Key? key;

  final _i9.JetuUserModel? user;

  final bool isEdit;

  @override
  String toString() {
    return 'UpdateInfoScreenArgs{key: $key, user: $user, isEdit: $isEdit}';
  }
}

/// generated route for
/// [_i4.IntercityScreen]
class IntercityScreen extends _i7.PageRouteInfo<void> {
  const IntercityScreen({List<_i7.PageRouteInfo>? children})
      : super(
          IntercityScreen.name,
          path: '/intercity-screen',
          initialChildren: children,
        );

  static const String name = 'IntercityScreen';
}

/// generated route for
/// [_i5.IntercityFindScreen]
class IntercityFindScreen extends _i7.PageRouteInfo<void> {
  const IntercityFindScreen()
      : super(
          IntercityFindScreen.name,
          path: 'intercity-find-screen',
        );

  static const String name = 'IntercityFindScreen';
}

/// generated route for
/// [_i6.IntercityCreateScreen]
class IntercityCreateScreen extends _i7.PageRouteInfo<void> {
  const IntercityCreateScreen()
      : super(
          IntercityCreateScreen.name,
          path: 'intercity-create-screen',
        );

  static const String name = 'IntercityCreateScreen';
}
