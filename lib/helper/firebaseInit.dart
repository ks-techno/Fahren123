import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseInit {
  static init() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      firebaseMessaging.getAPNSToken().then((value) {
        debugPrint("device APNs FCM TOKEN:-> $value");
      });
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
      debugPrint("notification settings:-> ${settings}");
    }
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint("device FCM TOKEN:-> $value");
    });

    final RemoteMessage? remoteMessage =
        await firebaseMessaging.getInitialMessage();
    firebaseMessaging.subscribeToTopic("Fahren123").then((value) {
      debugPrint("subscribeToTopic:-> Fahren123");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event);
    });
    FirebaseMessaging.onMessage.listen((event) {
      print(event);
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      RemoteMessage message) async {
    print(
        "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
  }
}
