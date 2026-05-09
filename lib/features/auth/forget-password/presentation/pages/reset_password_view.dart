import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../view_model/cubit/forget_password_cubit.dart';
import '../view_model/states/forget_password_states.dart';
import '../../../../../core/reusable_widgets/app_snack_bar.dart';

// BlocProvider.value is provided in app_routes.dart — same cubit instance.
class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordBaseState>(
      listenWhen: (_, current) =>
          current is ResetPasswordSuccess || current is ResetPasswordFailure,
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          AppSnackBar.showError(
            context,
            state.error,
            icon: SvgPicture.asset(
              Assets.assetsIconsError,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          );
        }

        if (state is ResetPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesName.login,
            (route) => false,
          );
        }
      },
      child: const _ResetPasswordScaffold(),
    );
  }
}

// ---------------------------------------------------------------------------
// Scaffold — never rebuilds
// ---------------------------------------------------------------------------
class _ResetPasswordScaffold extends StatelessWidget {
  const _ResetPasswordScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(AppStrings.password, style: TextStyles.appBarTextStyle),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _ResetPasswordBody(),
        ),
      ),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  const _ResetPasswordBody();

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const _HeaderTexts(),
            const SizedBox(height: 40),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (v) => AppValidations.validatePassword(v ?? ''),
              decoration: const InputDecoration(
                labelText: AppStrings.newPassword,
                hintText: AppStrings.enterYourPassword,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              validator: (v) => AppValidations.validateConfirmPassword(
                _passwordController.text,
                v ?? '',
              ),
              decoration: const InputDecoration(
                labelText: AppStrings.confirmPassword,
                hintText: AppStrings.confirmPassword,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 40),
            // Only this widget rebuilds to reflect loading state
            _SubmitButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ForgetPasswordCubit>().resetPassword(
                    _passwordController.text.trim(),
                  );
                }
              },
            ),
          ],
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
      ],
    );
  }
}

/// Only this widget rebuilds to reflect loading state.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordBaseState>(
      buildWhen: (_, current) =>
          current is ResetPasswordLoading ||
          current is ResetPasswordSuccess ||
          current is ResetPasswordFailure,
      builder: (context, state) {
        final isLoading = state is ResetPasswordLoading;

        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text(AppStrings.confirm),
          ),
        );
      },
    );
  }
}
