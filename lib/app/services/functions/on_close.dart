import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu/gateway/graphql_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _handleAppPaused();
    }
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
    if (state == AppLifecycleState.detached) {
      _handleAppClosed();
    }
  }

  Future<void> _handleAppPaused() async {}

  Future<void> _handleAppResumed() async {}

  Future<void> _handleAppClosed() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
  }
}
