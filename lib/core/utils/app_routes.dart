import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/app_section/presentation/view/app_section_view.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_view_model.dart';
import 'package:flower_app/features/occasions/presentation/pages/occasions_view.dart';
import 'package:flower_app/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/forget-password/presentation/flow/forget_password_routes.dart';
import '../../features/auth/login/presentation/screens/login_screen.dart';
import '../../features/auth/signup/presentation/pages/signup_view.dart';

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
      case AppRoutesName.occasions:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OccasionsViewModel>(),
            child: const OccasionsView(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppStrings.routeNotFound)),
          ),
        );
    }
  }
}
