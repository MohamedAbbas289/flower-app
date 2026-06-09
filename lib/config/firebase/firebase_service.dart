import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';

class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _setupCrashlytics();
  }

  static void _setupCrashlytics() {
    FlutterError.onError = (flutterErrorDetails) {
      FlutterError.presentError(flutterErrorDetails);
      FirebaseCrashlytics.instance.recordFlutterFatalError(flutterErrorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
