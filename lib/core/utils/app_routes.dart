import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/forget-password/presentation/pages/email_verification_view.dart';
import 'package:flower_app/features/forget-password/presentation/pages/forget_password_view.dart';
import 'package:flower_app/features/forget-password/presentation/pages/reset_password_view.dart';
import 'package:flower_app/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutesName.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordView());

      case AppRoutesName.verifyEmail:
        return MaterialPageRoute(builder: (_) => EmailVerificationView());

      case AppRoutesName.resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordView());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppStrings.routeNotFound)),
          ),
        );
    }
  }
}
