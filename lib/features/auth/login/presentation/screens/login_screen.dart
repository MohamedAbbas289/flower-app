import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/request_models/login_request_model.dart';
import '../view_model/login_events.dart';
import '../view_model/login_state.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<LoginViewModel>().doEvent(
      LoginRequestEvent(
        requestModel: LoginRequestModel(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _LoginAppBar(),
      body: BlocListener<LoginViewModel, LoginState>(
        listener: _LoginListener.onStateChange,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),

                _EmailField(controller: _emailController),
                const SizedBox(height: 16),

                _PasswordField(
                  controller: _passwordController,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: 16),

                _RememberMeRow(
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),

                const SizedBox(height: 40),

                _LoginButton(onPressed: () => _onLogin(context)),

                const SizedBox(height: 16),
                const _GuestButton(),

                const SizedBox(height: 24),
                const _SignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LoginAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsetsDirectional.only(start: 20),
        child: Text(AppStrings.loginTitle),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _LoginListener {
  static void onStateChange(BuildContext context, LoginState state) {
    if (state.loginState.data != null) {
      Navigator.pushReplacementNamed(context, AppRoutesName.home);
    } else if (state.loginState.msg != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.loginState.msg!)));
    }
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => AppValidations.validateEmail(value ?? ''),
      decoration: const InputDecoration(
        labelText: AppStrings.emailLabel,
        hintText: AppStrings.emailHint,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) => AppValidations.validatePassword(value ?? ''),
      decoration: InputDecoration(
        labelText: AppStrings.passwordLabel,
        hintText: AppStrings.passwordHint,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: SvgPicture.asset(
            obscure
                ? Assets.assetsIconsVisibilityOff
                : Assets.assetsIconsVisibilityOn,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.gray,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _RememberMeRow extends StatelessWidget {
  const _RememberMeRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const Text(AppStrings.rememberMe),
        const Spacer(),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutesName.forgotPassword),
          child: Text(
            AppStrings.doYouForgetPassword,
            style: TextStyles.bodyRegularUnderLine13,
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text(AppStrings.loginButton),
      ),
    );
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: const Text(AppStrings.continueAsGuest),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.dontHaveAccount,
          style: TextStyles.bodyRegular16,
          children: [
            TextSpan(
              text: AppStrings.signUp,
              style: TextStyles.bodyRegular16.copyWith(
                color: AppColors.pink,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.pink,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.pushNamed(context, AppRoutesName.signUp),
            ),
          ],
        ),
      ),
    );
  }
}
