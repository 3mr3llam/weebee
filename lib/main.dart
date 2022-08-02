// @//dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ithraashop/languages.dart';
import 'package:ithraashop/notification_service.dart';
import 'package:ithraashop/pages/splash_page.dart';
import 'package:ithraashop/firebase_options.dart';
import 'package:ithraashop/utils/app_theme.dart';
import 'package:ithraashop/widgets/rate_app_init.dart';

/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    var notifyHelper = NotifyHelper(null);
    // String? title = message.notification!.title;
    // String? body = message.notification!.body;
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    // notifyHelper.displayNotification(title: title!, body: body!);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//build\app\outputs\bundle\release\app-release.aab
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).colorScheme.primary));
    return RateAppInit(builder: (rateMyApp) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weebee',
        theme: appTheme,
        home: SplashPage(rateMyApp: rateMyApp),
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en'),
      );
    });
  }
}
