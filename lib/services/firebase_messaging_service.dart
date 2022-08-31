import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pokeapp/main.dart';
import 'package:pokeapp/services/notification_service.dart';

class Message {
  String? title, body;
}

class FirebaseMessagingService {
  NotificationService notificationService = NotificationService();

  FirebaseMessagingService() {
    notificationService.setupPushNotifications();
  }

  Future<void> setFirebaseForegroundNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //retorna token do dispositivo
  getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    debugPrint("=========================");
    debugPrint("Token = $token");
    debugPrint("=========================");
  }

  //lida com mensagens recebidas quando app está aberto
  onMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint('=== on message: ===');
        debugPrint('!!!!! MESSAGE RECIEVED !!!!!!!!!');
        if (message.notification != null) {
          notificationService.showPushNotification(message);
        }
      },
    );
  }

  onMessageOpenedApp() {
    debugPrint('=== on message (opened app): ===');
    FirebaseMessaging.onMessageOpenedApp
        .listen(notificationService.showPushNotification);
  }
}

//lida com mensagens recebidas quando app está em segundo plano
onBackgroundMessage() {
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
}

Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('!!!!! BACKGROUND MESSAGE RECIEVED !!!!!!!!!');
  if (message.notification != null) {
    pushNotification.notificationService.showPushNotification(message);
  }
}

// class FirebaseMessagingService {
//   final NotificationService _notificationService;

//   FirebaseMessagingService(this._notificationService);

//   Future<void> initialize() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             badge: true, sound: true, alert: true);

//     getDeviceFirebaseToken();
//     _onMessage();
//   }

//   getDeviceFirebaseToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//     debugPrint("========================");
//     debugPrint("Token: $token");
//     debugPrint("========================");
//   }

//   _onMessage() {
//     FirebaseMessaging.onMessage.listen(
//       (message) {
//         RemoteNotification? notification = message.notification;
//         AndroidNotification? android = message.notification?.android;

//         if (notification != null && android != null) {
//           _notificationService.showNotification(
//             CustomNotification(
//               id: android.hashCode,
//               title: notification.title,
//               body: notification.body,
//               payload: message.data['route'] ?? '',
//             ),
//           );
//         }
//       },
//     );
//   }

//   _onMessageOpenedApp() {
//     FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
//   }

//   _goToPageAfterMessage(message) {}
// }