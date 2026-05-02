
import 'package:flutter/material.dart';
import '../../features/home_screen/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    HomeScreen.routeName: (context) => HomeScreen(),

  };
}
