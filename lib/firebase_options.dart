import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  /// Returns the FirebaseOptions for the current platform.
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are only configured for Android. '
        'You need to add options for iOS/web if required.',
      );
    }
  }

  /// Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvZSsmax34jV6cQ80YX-vln-qXpeEATYE',
    appId: '1:471695951345:android:ee5e0f0a1ae1e547673050',
    messagingSenderId: '471695951345',
    projectId: 'todoit-85a12',
    storageBucket: 'todoit-85a12.firebasestorage.app',
  );
}
