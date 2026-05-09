import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/cubit/forget_password_cubit.dart';
import 'package:flower_app/core/utils/app_routes.dart';

class ForgetPasswordFlow extends StatelessWidget {
  const ForgetPasswordFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordCubit>(),
      child: Navigator(
        initialRoute: AppRoutesName.forgotPassword,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
