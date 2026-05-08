import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/login/api/request_models/login_request_model.dart';
import 'package:flower_app/features/login/presentation/view_model/login_events.dart';
import 'package:flower_app/features/login/presentation/view_model/login_state.dart';
import 'package:flower_app/features/login/presentation/view_model/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginViewModel>(),
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyles.bodyRegular13.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(AppStrings.loginTitle, style: TextStyles.appBarTextStyle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocListener<LoginViewModel, LoginStates>(
          listener: (context, state) {
            if (state.loginState.data != null) {
              Navigator.pushReplacementNamed(context, AppRoutesName.home);
            } else if (state.loginState.msg != null) {
              _showErrorSnackBar(context, state.loginState.msg!);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<LoginViewModel, LoginStates>(
                  buildWhen: (prev, curr) =>
                      prev.emailError != curr.emailError ||
                      prev.passwordError != curr.passwordError,
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyles.textFieldTextStyle,
                          decoration: InputDecoration(
                            labelText: AppStrings.emailLabel,
                            hintText: AppStrings.emailHint,
                            labelStyle: TextStyles.labelTextFieldStyle,
                            hintStyle: TextStyles.hintTextFieldStyle,
                            errorText: state.emailError,
                            errorStyle: TextStyles.errorTextFieldStyle,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyles.textFieldTextStyle,
                          decoration: InputDecoration(
                            labelText: AppStrings.passwordLabel,
                            hintText: AppStrings.passwordHint,
                            labelStyle: TextStyles.labelTextFieldStyle,
                            hintStyle: TextStyles.hintTextFieldStyle,
                            errorText: state.passwordError,
                            errorStyle: TextStyles.errorTextFieldStyle,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: SvgPicture.asset(
                                _obscurePassword
                                    ? Assets.assetsIconsVisibilityOff
                                    : Assets.assetsIconsVisibilityOn,
                                width: 22,
                                height: 22,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.gray,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.pink,
                            side: const BorderSide(color: AppColors.gray),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.rememberMe,
                          style: TextStyles.bodyRegular13,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutesName.forgotPassword,
                        );
                      },
                      child: Text(
                        AppStrings.forgetPassword,
                        style: TextStyles.bodyRegularUnderLine12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                BlocBuilder<LoginViewModel, LoginStates>(
                  buildWhen: (prev, curr) =>
                      prev.loginState.isLoading != curr.loginState.isLoading,
                  builder: (context, state) {
                    final isLoading = state.loginState.isLoading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<LoginViewModel>().doEvent(
                                LoginRequestEvent(
                                  requestModel: LoginRequestModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    rememberMe: _rememberMe,
                                  ),
                                ),
                              );
                            },
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              AppStrings.loginButton,
                              style: TextStyles.buttonTextStyle,
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.gray),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppStrings.continueAsGuest,
                    style: TextStyles.bodyRegular16.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: TextStyles.bodyRegular13,
                      children: [
                        TextSpan(
                          text: AppStrings.signUp,
                          style: TextStyles.bodyRegularUnderLine12.copyWith(
                            color: AppColors.pink,
                            decorationColor: AppColors.pink,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                AppRoutesName.signUp,
                              );
                            },
                        ),
                      ],
                    ),
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
