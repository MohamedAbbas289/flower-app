import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  final authManager = getIt<AuthManager>();
  await authManager.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}
