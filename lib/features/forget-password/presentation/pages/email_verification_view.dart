import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:pinput/pinput.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/events/forget_password_events.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:flower_app/features/forget-password/presentation/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerificationView extends StatelessWidget {
  EmailVerificationView({super.key});

  final TextEditingController codeController = TextEditingController();
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
            Navigator.pushNamed(context, AppRoutesName.resetPassword);
          }
        },
        builder: (context, state) {
          return _buildUI(context, state);
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, ForgetPasswordState state) {
    final defaultPinTheme = PinTheme(
      width: 65,
      height: 65,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
        title: Text(AppStrings.password, style: TextStyles.appBarTextStyle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                AppStrings.emailVerification,
                style: TextStyles.appBarTextStyle,
              ),

              const SizedBox(height: 12),

              Text(
                AppStrings.pleaseEnterYourEmailAssociatedToYourAccount,
                textAlign: TextAlign.center,
                style: TextStyles.hintTextFieldStyle,
              ),

              const SizedBox(height: 40),

              Pinput(
                controller: codeController,
                length: 4,
                autofocus: true,
                closeKeyboardWhenCompleted: true,

                defaultPinTheme: defaultPinTheme,

                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: AppColors.pink, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),

                submittedPinTheme: defaultPinTheme,

                errorPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: AppColors.red, width: 2),
                ),

                validator: (value) {
                  if (value == null || value.length < 4) {
                    return AppStrings.invalidCode;
                  }
                  return null;
                },

                errorBuilder: (errorText, pin) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  );
                },

                onCompleted: (pin) {
                  if (state.isLoading) return;

                  context.read<ForgetPasswordCubit>().onEvent(
                    VerifyCodeEvent(pin),
                  );
                },
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.didntReciveCode,
                    style: TextStyles.bodyRegular16,
                  ),

                  GestureDetector(
                    onTap: state.isLoading
                        ? null
                        : () {
                            context.read<ForgetPasswordCubit>().onEvent(
                              ResendCodeEvent(),
                            );
                          },
                    child: Text(
                      AppStrings.resend,
                      style: TextStyles.bodyRegular16.copyWith(
                        color: AppColors.pink,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.pink,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
