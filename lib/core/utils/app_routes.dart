import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/app_section/presentation/view/app_section_view.dart';
import 'package:flower_app/features/forget-password/presentation/flow/forget_password_routes.dart';
import 'package:flower_app/features/login/presentation/screens/login_screen.dart';
import 'package:flower_app/features/signup/presentation/pages/signup_view.dart';
import 'package:flower_app/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final forgetPasswordRoute = ForgetPasswordRoutes.onGenerateRoute(settings);
    if (forgetPasswordRoute != null) return forgetPasswordRoute;

    switch (settings.name) {
      case AppRoutesName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutesName.home:
        return MaterialPageRoute(builder: (_) => const AppSectionView());
      case AppRoutesName.signUp:
        return MaterialPageRoute(builder: (_) => const SignupView());
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppStrings.routeNotFound)),
          ),
        );
    }
  }
}
