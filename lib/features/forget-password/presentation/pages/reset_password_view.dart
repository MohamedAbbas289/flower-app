import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/events/forget_password_events.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:flower_app/features/forget-password/presentation/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordCubit>(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.error != null) {
            AppSnackBar.showError(context, state.error!);
          }

          if (state.data != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutesName.login,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                AppStrings.password,
                style: TextStyles.appBarTextStyle,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      Text(
                        AppStrings.resetPassword,
                        style: TextStyles.bodyRegular16.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: 250,
                        child: Text(
                          AppStrings.hitTextForResetPassword,
                          textAlign: TextAlign.center,
                          style: TextStyles.hintTextFieldStyle,
                        ),
                      ),

                      const SizedBox(height: 40),

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (v) =>
                            AppValidations.validatePassword(v ?? ""),
                        decoration: const InputDecoration(
                          labelText: AppStrings.newPassword,
                          hintText: AppStrings.enterYourPassword,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: confirmController,
                        obscureText: true,
                        validator: (v) =>
                            AppValidations.validateConfirmPassword(
                              passwordController.text,
                              v ?? "",
                            ),
                        decoration: const InputDecoration(
                          labelText: AppStrings.confirmPassword,
                          hintText: AppStrings.confirmPassword,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<ForgetPasswordCubit>().onEvent(
                                      ResetPasswordEvent(
                                        AppStrings.exampleEmail,
                                        passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                          child: state.isLoading
                              ? const CircularProgressIndicator()
                              : const Text(AppStrings.confirm),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
