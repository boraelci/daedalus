import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {

  Future<void> getNotificationPermissions() async {
    await Permission.notification.request();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future scheduleNotification(facility) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? frequencyInMinutes = prefs.getInt('notificationFrequency');
    if (frequencyInMinutes == null) {
      frequencyInMinutes = 1440;
      prefs.setInt('notificationFrequency', frequencyInMinutes);
    }

    String? timestampString = prefs.getString('notificationTimestamp');
    if (timestampString == null || DateTime.now().difference(DateTime.parse(timestampString)) >
        Duration(minutes: frequencyInMinutes)) {
      prefs.setString('notificationTimestamp', DateTime.now().toString());
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('DAE', 'Daedalus',
          channelDescription: 'Notifications on facility health & safety information',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const iOSPlatformChannelSpecifics = IOSNotificationDetails();
      const platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      int? counter = prefs.getInt('counter');
      counter ??= 0;
      await flutterLocalNotificationsPlugin.show(
        counter,
        'View facility health & safety information',
        "Nearby: ${facility.siteName}",
        platformChannelSpecifics,
        payload: '',
      );
      counter += 1;
      prefs.setInt('counter', counter);
    }
  }

  //final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');


  NotificationService() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}