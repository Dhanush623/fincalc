// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQt1IUYxHelufs0kX8v-sDefqQXBRnG2w',
    appId: '1:4424271195:ios:f7dc777bc93bbd436d467e',
    messagingSenderId: '4424271195',
    projectId: 'softly-8f8b0',
    databaseURL:
        'https://softly-8f8b0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'softly-8f8b0.appspot.com',
    androidClientId:
        '4424271195-19ep3q0b1one3npme5ttqclii5c0aoo0.apps.googleusercontent.com',
    iosClientId:
        '4424271195-o197v6mcg1d97d8mi7e29hvqeelo2hav.apps.googleusercontent.com',
    iosBundleId: 'com.finance',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBIOforuTT_BD6fWv8LhacGNv6rM_wbVU',
    appId: '1:4424271195:android:545de76ee1517e456d467e',
    messagingSenderId: '4424271195',
    projectId: 'softly-8f8b0',
    databaseURL:
        'https://softly-8f8b0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'softly-8f8b0.appspot.com',
  );
}
