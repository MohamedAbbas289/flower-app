import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../view_model/cubit/forget_password_cubit.dart';
import '../view_model/states/forget_password_states.dart';
import '../widgets/app_snack_bar.dart';

// BlocProvider.value is provided in app_routes.dart — reuses the same cubit
// instance created on the forgotPassword route.
class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordBaseState>(
      listenWhen: (_, current) =>
          current is VerifyCodeSuccess || current is VerifyCodeFailure,
      listener: (context, state) {
        if (state is VerifyCodeFailure) {
          AppSnackBar.showError(context, state.error);
        }

        if (state is VerifyCodeSuccess) {
          Navigator.pushNamed(
            context,
            AppRoutesName.resetPassword,
            arguments: context.read<ForgetPasswordCubit>(),
          );
        }
      },
      child: const _EmailVerificationScaffold(),
    );
  }
}

// ---------------------------------------------------------------------------
// Scaffold — never rebuilds
// ---------------------------------------------------------------------------
class _EmailVerificationScaffold extends StatelessWidget {
  const _EmailVerificationScaffold();

  @override
  Widget build(BuildContext context) {
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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 40),
              _HeaderTexts(),
              SizedBox(height: 40),
              _OtpInput(),
              SizedBox(height: 16),
              _ResendRow(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private const widgets
// ---------------------------------------------------------------------------
class _HeaderTexts extends StatelessWidget {
  const _HeaderTexts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.emailVerification, style: TextStyles.appBarTextStyle),
        const SizedBox(height: 12),
        Text(
          AppStrings.pleaseEnterYourEmailAssociatedToYourAccount,
          textAlign: TextAlign.center,
          style: TextStyles.hintTextFieldStyle,
        ),
      ],
    );
  }
}

/// Only rebuilds to show/hide loading on the OTP input.
class _OtpInput extends StatelessWidget {
  const _OtpInput();

  @override
  Widget build(BuildContext context) {
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

    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordBaseState>(
      buildWhen: (_, current) =>
          current is VerifyCodeLoading ||
          current is VerifyCodeSuccess ||
          current is VerifyCodeFailure,
      builder: (context, state) {
        return Pinput(
          length: 4,
          defaultPinTheme: defaultPinTheme,
          enabled: state is! VerifyCodeLoading,
          onCompleted: (pin) =>
              context.read<ForgetPasswordCubit>().verifyOtpCode(pin),
        );
      },
    );
  }
}

/// Only rebuilds to disable the resend tap while loading.
class _ResendRow extends StatelessWidget {
  const _ResendRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordBaseState>(
      buildWhen: (_, current) =>
          current is VerifyCodeLoading || current is VerifyCodeSuccess,
      builder: (context, state) {
        final isLoading = state is VerifyCodeLoading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.didntReciveCode, style: TextStyles.bodyRegular16),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () => context.read<ForgetPasswordCubit>().resendOtpCode(),
              child: Text(
                AppStrings.resend,
                style: TextStyles.bodyRegular16.copyWith(
                  color: AppColors.pink,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
