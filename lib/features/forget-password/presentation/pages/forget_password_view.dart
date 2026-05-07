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

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});

  final TextEditingController emailController = TextEditingController();
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
            Navigator.pushNamed(context, AppRoutesName.verifyEmail);
          }
        },
        builder: (context, state) {
          return _buildUI(context, state);
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, ForgetPasswordState state) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: 20,
          ),
        ),
        title: Text(AppStrings.password, style: TextStyles.appBarTextStyle),
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
                  AppStrings.forgetPassword,
                  style: TextStyles.appBarTextStyle,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.pleaseEnterYourEmailAssociatedToYourAccount,
                  textAlign: TextAlign.center,
                  style: TextStyles.hintTextFieldStyle,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  validator: (v) => AppValidations.validateEmail(v ?? ""),
                  decoration: const InputDecoration(
                    labelText: AppStrings.email,
                    hintText: AppStrings.enterYourEmail,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              context.read<ForgetPasswordCubit>().onEvent(
                                ForgotPasswordEvent(
                                  emailController.text.trim(),
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
  }
}
