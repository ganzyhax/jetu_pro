import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/app.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/services/firebase_notification.dart';
import 'package:jetu/gateway/graphql_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await initHiveForFlutter();
  final client = await GraphQlService.init();
  await setGraphClient(client.value);
  FirebaseNotificationsManager.initialize();
  await Geolocator.requestPermission();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setBool(AppSharedKeys.isLogged, true);
  // prefs.setString(AppSharedKeys.userId, '43afe070-d39d-11ee-845c-cb553bc5c40b');
  AndroidYandexMap.useAndroidViewSurface = false;

  runApp(Jetu(client: client));
}
