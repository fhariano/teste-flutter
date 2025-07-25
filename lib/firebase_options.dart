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
    apiKey: 'AIzaSyC3PSwShpeA-5k6OtSIquWcVYYYbz-N6W0',
    appId: '1:337009680346:web:bdf486cb865870d9806ae3',
    messagingSenderId: '337009680346',
    projectId: 'test-flutter-b41b8',
    authDomain: 'test-flutter-b41b8.firebaseapp.com',
    storageBucket: 'test-flutter-b41b8.firebasestorage.app',
    measurementId: 'G-GNPGNXQ0N4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIkNhADe_I5vc_p9E76t6MAL1iyTZ9cHQ',
    appId: '1:337009680346:android:d3b7941cdda8d49b806ae3',
    messagingSenderId: '337009680346',
    projectId: 'test-flutter-b41b8',
    storageBucket: 'test-flutter-b41b8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsjgKMp049uI3LlRVnyvgbF4-MNLoxpmg',
    appId: '1:337009680346:ios:4ad0c7f3b68b0960806ae3',
    messagingSenderId: '337009680346',
    projectId: 'test-flutter-b41b8',
    storageBucket: 'test-flutter-b41b8.firebasestorage.app',
    iosBundleId: 'com.example.testFlutter',
  );
}
