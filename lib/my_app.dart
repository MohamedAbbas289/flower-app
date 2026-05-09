import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/core/utils/app_routes.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesName.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}
