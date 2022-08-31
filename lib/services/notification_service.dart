import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // local notifications handler
  late FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin;

  // setup channel for android
  AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
    'firebase_push_notification_channel',
    "Firebase Push Notification Channel",
    description:
        "This is the channel for Push Notifications for Android devices",
    importance: Importance.high,
  );

  Future<void> setupPushNotifications() async {
    debugPrint('=== setting up push notifications ... ===');

    // initializing local notifications handler
    flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    // overriding default configuration for Local Notifications in android
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void showPushNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationPlugin.show(
        notification.hashCode, // id
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            icon: 'mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.max,
            enableVibration: true,
          ),
        ),
      );
    }
  }
}

// class CustomNotification {
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;

//   CustomNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
// }

// class NotificationService {
//   late FlutterLocalNotificationsPlugin localNotificationsPlugin;
//   late AndroidNotificationDetails androidDetails;

//   NotificationService() {
//     localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _setupNotifications();
//   }

//   _setupNotifications() async {
//     await _setupTimezone();
//     await _initializeNotifications();
//   }

//   Future<void> _setupTimezone() async {
//     tz.initializeTimeZones();
//     final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName!));
//   }

//   _initializeNotifications() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     await localNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: android,
//       ),
//       onSelectNotification: _onSelectNotification,
//     );
//   }

//   _onSelectNotification(String? payload) {}

//   showNotification(CustomNotification notification) {
//     androidDetails = const AndroidNotificationDetails(
//       'notificacao_firebase',
//       'PokeApp',
//       channelDescription: 'Este canal é para notificações pelo Firebase',
//       importance: Importance.max,
//       priority: Priority.max,
//       enableVibration: true,
//     );

//     localNotificationsPlugin.show(
//       notification.id,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: androidDetails,
//       ),
//       payload: notification.payload,
//     );
//   }

//   checkForNotifications() async {
//     final details =
//         await localNotificationsPlugin.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       _onSelectNotification(details.payload);
//     }
//   }
// }
