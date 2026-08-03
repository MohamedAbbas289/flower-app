import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/firebase/fcm_service.dart';
import 'package:flower_app/config/firebase/firebase_service.dart';
import 'package:flower_app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  await getIt<AuthManager>().init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  getIt<FcmService>().initNotification();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}
