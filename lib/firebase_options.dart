// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5D6k4WYLaxp1CNBbOOECYB_LJOQ0ht7Q',
    appId: '1:780177293173:web:ff516f0ce0672600b8dd3c',
    messagingSenderId: '780177293173',
    projectId: 'ithraa-webview-notifications',
    authDomain: 'ithraa-webview-notifications.firebaseapp.com',
    storageBucket: 'ithraa-webview-notifications.appspot.com',
    measurementId: 'G-VKL86F0R94',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2UrFSL78houyhkLq3bn72RtuyTr9n8Yg',
    appId: '1:780177293173:android:14f53c7b81979780b8dd3c',
    messagingSenderId: '780177293173',
    projectId: 'ithraa-webview-notifications',
    storageBucket: 'ithraa-webview-notifications.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbvn9QUHbXUfB2YYuXvp9lxxLhZqftgMc',
    appId: '1:780177293173:ios:fe48baf251f069bbb8dd3c',
    messagingSenderId: '780177293173',
    projectId: 'ithraa-webview-notifications',
    storageBucket: 'ithraa-webview-notifications.appspot.com',
    iosClientId: '780177293173-fujd52fquckg1e56g9vqi3v2acrb02n4.apps.googleusercontent.com',
    iosBundleId: 'com.ithraa.wbvwshop',
  );
}
