import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseOptions> getFirebaseOptionsFromEnv() async {
  await dotenv.load(); // Loads the .env file

  if (kIsWeb) {
    return FirebaseOptions(
      apiKey: dotenv.env['WEB_FIREBASE_API_KEY']!,
      appId: dotenv.env['WEB_FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['WEB_FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      authDomain: dotenv.env['WEB_FIREBASE_AUTH_DOMAIN'],
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      measurementId: dotenv.env['WEB_FIREBASE_MEASUREMENT_ID'],
    );
  }

  if (Platform.isAndroid) {
    return FirebaseOptions(
      apiKey: dotenv.env['ANDROID_FIREBASE_API_KEY']!,
      appId: dotenv.env['ANDROID_FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['ANDROID_FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      authDomain: dotenv.env['ANDROID_FIREBASE_AUTH_DOMAIN'],
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      measurementId: dotenv.env['ANDROID_FIREBASE_MEASUREMENT_ID'],
    );
  }

  if (Platform.isIOS || Platform.isMacOS) {
    return FirebaseOptions(
      apiKey: dotenv.env['IOS_FIREBASE_API_KEY']!,
      appId: dotenv.env['IOS_FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['IOS_FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      authDomain: dotenv.env['IOS_FIREBASE_AUTH_DOMAIN'],
      storageBucket: dotenv.env['IOS_FIREBASE_STORAGE_BUCKET']!,
      measurementId: dotenv.env['IOS_FIREBASE_MEASUREMENT_ID'],
      iosClientId: dotenv.env['IOS_FIREBASE_IOS_CLIENT_ID'],
      iosBundleId: dotenv.env['IOS_FIREBASE_IOS_BUNDLE_ID'],
    );
  }

  if (Platform.isWindows) {
    return FirebaseOptions(
      apiKey: dotenv.env['WINDOWS_FIREBASE_API_KEY']!,
      appId: dotenv.env['WINDOWS_FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['WINDOWS_FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      authDomain: dotenv.env['WINDOWS_FIREBASE_AUTH_DOMAIN'],
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      measurementId: dotenv.env['WINDOWS_FIREBASE_MEASUREMENT_ID'],
    );
  }

  throw UnsupportedError('Unsupported platform for Firebase configuration');
}
