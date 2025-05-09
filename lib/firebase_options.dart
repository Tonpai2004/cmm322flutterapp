// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAFm8Wpa74qc0_VsSPTWSI8dsWCMRzCQlQ',
    appId: '1:771244686030:web:bc696b6b3e4a6a6f732e9f',
    messagingSenderId: '771244686030',
    projectId: 'cmm322-pj',
    authDomain: 'cmm322-pj.firebaseapp.com',
    storageBucket: 'cmm322-pj.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3yZ4b8CCvnytfgmtjKz3AYkmyOerhyjA',
    appId: '1:771244686030:android:928f5c3a3a33d29b732e9f',
    messagingSenderId: '771244686030',
    projectId: 'cmm322-pj',
    storageBucket: 'cmm322-pj.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuhzZGLgrOQYo0jkgnNkS1zD8dXDvUvJc',
    appId: '1:771244686030:ios:3fed3f98429c293c732e9f',
    messagingSenderId: '771244686030',
    projectId: 'cmm322-pj',
    storageBucket: 'cmm322-pj.firebasestorage.app',
    iosBundleId: 'com.example.cmmcontent.contentpagecmmapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCuhzZGLgrOQYo0jkgnNkS1zD8dXDvUvJc',
    appId: '1:771244686030:ios:3fed3f98429c293c732e9f',
    messagingSenderId: '771244686030',
    projectId: 'cmm322-pj',
    storageBucket: 'cmm322-pj.firebasestorage.app',
    iosBundleId: 'com.example.cmmcontent.contentpagecmmapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAFm8Wpa74qc0_VsSPTWSI8dsWCMRzCQlQ',
    appId: '1:771244686030:web:11e80f413061c834732e9f',
    messagingSenderId: '771244686030',
    projectId: 'cmm322-pj',
    authDomain: 'cmm322-pj.firebaseapp.com',
    storageBucket: 'cmm322-pj.firebasestorage.app',
  );

}