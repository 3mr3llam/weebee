// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:ithraashop/firebase_options.dart';

// class PushNotificationsManager {
//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance = PushNotificationsManager._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   bool _initialized = false;

//   /// To verify things are working, check out the native platform logs.
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     // If you're going to use other Firebase services in the background, such as Firestore,
//     // make sure you call `initializeApp` before using other Firebase services.
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     print('Handling a background message ${message.messageId}');
//   }

//   Future<void> init() async {
//     if (!_initialized) {

//       // For iOS request permission first.
//       _firebaseMessaging.requestPermission();
//       _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print("onMessage: $message");
//         },
//         onBackgroundMessage: myBackgroundMessageHandler,
//         onLaunch: (Map<String, dynamic> message) async {
//           print("onLaunch: $message");
//         },
//         onResume: (Map<String, dynamic> message) async {
//           print("onResume: $message");
//         },
//       );

//       // For testing purposes print the Firebase Messaging token
//       String? token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");

//       _initialized = true;
//     }
//   }
// }
