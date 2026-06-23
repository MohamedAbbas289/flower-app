import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../view_models/forget_password_view_model/forget_password_cubit.dart';
import '../view_models/forget_password_view_model/forget_password_states.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';

// BlocProvider is created in app_routes.dart — this widget just uses the
// existing instance via context.read / BlocConsumer.
class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordBaseState>(
      listenWhen: (_, current) =>
          current is ForgotPasswordSuccess || current is ForgotPasswordFailure,
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
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

        if (state is ForgotPasswordSuccess) {
          Navigator.pushNamed(
            context,
            AppRoutesName.verifyEmail,
            arguments: context.read<ForgetPasswordCubit>(),
          );
        }
      },
      child: const _ForgetPasswordScaffold(),
    );
  }
}

// ---------------------------------------------------------------------------
// Scaffold — never rebuilds (no BlocBuilder here)
// ---------------------------------------------------------------------------
class _ForgetPasswordScaffold extends StatelessWidget {
  const _ForgetPasswordScaffold();

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
          child: _ForgetPasswordBody(),
        ),
      ),
    );
  }
}

class _ForgetPasswordBody extends StatefulWidget {
  const _ForgetPasswordBody();

  @override
  State<_ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<_ForgetPasswordBody> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const _HeaderTexts(),
          const SizedBox(height: 40),
          TextFormField(
            controller: _emailController,
            validator: (v) => AppValidations.validateEmail(v ?? ''),
            decoration: InputDecoration(
              labelText: AppStrings.email,
              hintText: AppStrings.enterYourEmail,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 32),
          // Only the button rebuilds to reflect loading state
          _SubmitButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ForgetPasswordCubit>().sendResetEmail(
                  _emailController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private const widgets — never rebuild when parent rebuilds
// ---------------------------------------------------------------------------
class _HeaderTexts extends StatelessWidget {
  const _HeaderTexts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.forgetPassword, style: TextStyles.appBarTextStyle),
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

/// Only this widget listens to loading state — nothing else rebuilds.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordBaseState>(
      buildWhen: (_, current) =>
          current is ForgotPasswordLoading ||
          current is ForgotPasswordSuccess ||
          current is ForgotPasswordFailure,
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(AppStrings.confirm),
          ),
        );
      },
    );
  }
}
