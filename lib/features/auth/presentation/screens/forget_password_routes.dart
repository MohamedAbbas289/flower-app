import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'email_verification_view.dart';
import 'forget_password_view.dart';
import 'reset_password_view.dart';
import '../view_models/forget_password_view_model/forget_password_cubit.dart';

class ForgetPasswordRoutes {
  /// Returns the matched route for the forget-password flow,
  /// or null if the route name doesn't belong to this feature.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.forgotPassword:
        final cubit = getIt<ForgetPasswordCubit>();
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const ForgetPasswordView(),
          ),
        );

      case AppRoutesName.verifyEmail:
        final cubit = settings.arguments as ForgetPasswordCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const EmailVerificationView(),
          ),
        );

      case AppRoutesName.resetPassword:
        final cubit = settings.arguments as ForgetPasswordCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const ResetPasswordView(),
          ),
        );

      default:
        return null;
    }
  }
}
