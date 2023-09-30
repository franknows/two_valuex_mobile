import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'local_notification_service.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    // Request permission to receive FCM notifications
    NotificationSettings settings = await _fcm.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Subscribe to FCM topic
      // _fcm.subscribeToTopic('my-topic');

      FirebaseMessaging.instance.getInitialMessage().then((value) {
        //handle from teminated
      });

      // Handle incoming FCM messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received FCM message: ${message.notification!.title}');
        LocalNotificationService().showDefaultNotification(
            '${message.notification!.title}', '${message.notification!.body}');
        _handleNotification(message.data);
      });

      // Handle FCM notifications that are opened by the user
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Navigator.pushNamed(context, '/notifications');
      });
    }
  }

  void _handleNotification(Map<String, dynamic> message) {
    // Handle FCM notification here
  }
}
