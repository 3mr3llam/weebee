import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ithraashop/pages/home_page.dart';

class NotifyHelper {
  final BuildContext? context;
  NotifyHelper(this.context);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    //tz.initializeTimeZones();
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  // this func is for ios older than ios10
  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('ok'.tr),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Get.to(() => HomePage());
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Navigator.of(context!, rootNavigator: true).pop();
    Get.to(() => const HomePage());
  }

  // REQUEST PERMISSION FOR NOTIFICATION ON IOS
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  displayNotification({required String title, required String body}) async {
    String channelId = '1';
    String channelName = 'iacoder_weebee';
    String channelDescription = "This nofication channel is from $channelName";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      101,
      title,
      body,
      platformChannelSpecifics,
      payload: '', //'It could be anything you pass
    );
  }

  // THIS FUNCTION NEED flutter_native_timezone PAKCAGE TO BE ADDED
  scheduledNotification() async {
    //    await flutterLocalNotificationsPlugin.zonedSchedule(
    //        0,
    //        'scheduled title',
    //        'theme changes 5 seconds ago',
    //        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //        const NotificationDetails(
    //            android: AndroidNotificationDetails('your channel id',
    //                'your channel name', 'your channel description')),
    //        androidAllowWhileIdle: true,
    //        uiLocalNotificationDateInterpretation:
    //            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
