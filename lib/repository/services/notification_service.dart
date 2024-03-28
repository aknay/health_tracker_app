import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthtracker/repository/services/date_time_helper.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings androidInitializationSettings;
  late InitializationSettings initializationSettings;

  Future<void> init() async {
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    var initializationsSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future<void> showTextNotification(
      String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
    //https://github.com/mohanedaldohmi/-resturant_delivery_boy/blob/main/lib/helper/notification_helper.dart

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '6valley_delivery', '6valley_delivery name',
        importance: Importance.max, priority: Priority.max, playSound: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    DateTimeHelper.initTimezone();

    fln.zonedSchedule(0, "title", "body", DateTimeHelper.scheduleDaily(DateTime(09, 05)), platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
