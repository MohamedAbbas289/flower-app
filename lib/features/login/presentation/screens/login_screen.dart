import 'dart:io';

import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/login/presentation/view_model/login_cubit.dart';
import 'package:flower_app/features/login/presentation/view_model/login_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => {
            if (Platform.isAndroid)
              {SystemNavigator.pop()}
            else if (Platform.isIOS)
              {exit(0)},
          },
        ),
        title: Text(AppStrings.loginTitle, style: TextStyles.appBarTextStyle),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, AppRoutesName.home);
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            String? emailError;
            String? passwordError;

            if (state is LoginValidationError) {
              emailError = state.emailError;
              passwordError = state.passwordError;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      errorText: emailError,
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
                      errorText: passwordError,
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
                  ElevatedButton(
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            context.read<LoginCubit>().login(
                              email: _emailController.text,
                              password: _passwordController.text,
                              rememberMe: _rememberMe,
                            );
                          },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: state is LoginLoading
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
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Continue as guest
                    },
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
            );
          },
        ),
      ),
    );
  }
}
