import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showDefaultNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Communication channel',
      channelDescription:
          'This channel will be used to send all kinds of notifications.',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'ic_stat_notification',
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond, title, body, notificationDetails);
  }
}
