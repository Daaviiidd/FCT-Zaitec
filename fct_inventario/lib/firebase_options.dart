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
    apiKey: 'AIzaSyD56d5OYMkaMnvj_8VGQe6mQC0zjKYPhKg',
    appId: '1:235265469094:web:b0514a034ada0eff502267',
    messagingSenderId: '235265469094',
    projectId: 'fct-zaitec',
    authDomain: 'fct-zaitec.firebaseapp.com',
    storageBucket: 'fct-zaitec.firebasestorage.app',
    measurementId: 'G-W495SH15J7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAInwTUHYHryt1VtOsQlOazuCLmCfDmCro',
    appId: '1:235265469094:android:a20c39ac43f040d2502267',
    messagingSenderId: '235265469094',
    projectId: 'fct-zaitec',
    storageBucket: 'fct-zaitec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIQma2phRyHqFuhfjFHtLpIEECxoygOXs',
    appId: '1:235265469094:ios:12b480cc20fe05b5502267',
    messagingSenderId: '235265469094',
    projectId: 'fct-zaitec',
    storageBucket: 'fct-zaitec.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIQma2phRyHqFuhfjFHtLpIEECxoygOXs',
    appId: '1:235265469094:ios:12b480cc20fe05b5502267',
    messagingSenderId: '235265469094',
    projectId: 'fct-zaitec',
    storageBucket: 'fct-zaitec.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD56d5OYMkaMnvj_8VGQe6mQC0zjKYPhKg',
    appId: '1:235265469094:web:26265dedda2bad61502267',
    messagingSenderId: '235265469094',
    projectId: 'fct-zaitec',
    authDomain: 'fct-zaitec.firebaseapp.com',
    storageBucket: 'fct-zaitec.firebasestorage.app',
    measurementId: 'G-VBW7E7MC7V',
  );
}
