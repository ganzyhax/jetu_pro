import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu/gateway/graphql_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotificationsManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
              onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ),
            android: AndroidInitializationSettings('@mipmap/launcher_icon'));
    _notificationsPlugin.initialize(initializationSettings);

    // Firebase Messaging Initialization and Setup
    requestPermission();
    setupFirebaseMessagingListeners();
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    String? userToken = await FirebaseMessaging.instance.getToken();
    print(userToken);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserToken()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": userToken.toString()},
    );
    final client = await GraphQlService.init();
    var data = await client.value.mutate(options);
    print(data);
  }

  static void setupFirebaseMessagingListeners() {
    FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Here, navigate to specific screen based on message
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    }
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    showNotification(
      title: title.toString(),
      body: body.toString(),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'jetu_cleint',
        'jetu_client_channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
