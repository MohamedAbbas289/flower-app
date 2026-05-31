import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/request_models/signup_request_model.dart';
import '../signup_view_model/signup_event.dart';
import '../signup_view_model/signup_state.dart';
import '../signup_view_model/signup_view_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedGender = 'female';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignup(BuildContext context) {
    context.read<SignupViewModel>().doEvent(EnableAutoValidateEvent());

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final requestModel = SignupRequestModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rePassword: _confirmPasswordController.text,
      phone: '+20${_phoneController.text.trim()}',
      gender: _selectedGender,
    );

    context.read<SignupViewModel>().doEvent(
      SignupRequestEvent(requestModel: requestModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _SignupAppBar(),
      body: BlocProvider(
        create: (_) => getIt<SignupViewModel>(),
        child: BlocConsumer<SignupViewModel, SignupState>(
          listener: _SignupListener.onStateChange,
          builder: (context, state) {
            return _SignupForm(
              formKey: _formKey,
              state: state,
              autoValidate: state.autoValidate,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              phoneController: _phoneController,
              obscurePassword: _obscurePassword,
              obscureConfirmPassword: _obscureConfirmPassword,
              selectedGender: _selectedGender,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onToggleConfirmPassword: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              onGenderChanged: (v) {
                if (v != null) {
                  setState(() => _selectedGender = v);
                }
              },
              onSubmit: () => _onSignup(context),
            );
          },
        ),
      ),
    );
  }
}

class _SignupAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SignupAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Transform.flip(
          flipX: Directionality.of(context) == TextDirection.rtl,
          child: SvgPicture.asset(Assets.assetsIconsArrowBack),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(AppStrings.signupTitle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SignupListener {
  static void onStateChange(BuildContext context, SignupState state) {
    if (!state.signupState.isLoading && state.signupState.data != null) {
      AppSnackBar.showSuccess(
        context,
        AppStrings.accountCreatedSuccessfully,
        icon: SvgPicture.asset(
          Assets.assetsIconsCheckCircle,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ).closed.then((_) {
        if (!context.mounted) return;

        Navigator.pop(context);
      });
    } else if (!state.signupState.isLoading && state.signupState.msg != null) {
      AppSnackBar.showError(
        context,
        state.signupState.msg!,
        icon: SvgPicture.asset(
          Assets.assetsIconsError,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    required this.formKey,
    required this.state,
    required this.autoValidate,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.selectedGender,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onGenderChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final SignupState state;
  final bool autoValidate;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String selectedGender;

  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NameRow(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
            ),
            const SizedBox(height: 16),

            _EmailField(controller: emailController),
            const SizedBox(height: 16),

            _PasswordRow(
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              obscurePassword: obscurePassword,
              obscureConfirmPassword: obscureConfirmPassword,
              onTogglePassword: onTogglePassword,
              onToggleConfirmPassword: onToggleConfirmPassword,
            ),
            const SizedBox(height: 16),

            _PhoneField(controller: phoneController),
            const SizedBox(height: 20),

            _GenderSection(
              selectedGender: selectedGender,
              onChanged: onGenderChanged,
            ),
            const SizedBox(height: 20),

            const _TermsText(),
            const SizedBox(height: 28),

            _SignupButton(
              isLoading: state.signupState.isLoading,
              onSubmit: onSubmit,
            ),

            const SizedBox(height: 20),
            const _LoginLink(),
          ],
        ),
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.firstNameController,
    required this.lastNameController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: AppStrings.firstNameLabel,
              hintText: AppStrings.firstNameHint,
            ),
            validator: (value) => AppValidations.validateFirstName(value ?? ''),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: AppStrings.lastNameLabel,
              hintText: AppStrings.lastNameHint,
            ),
            validator: (value) => AppValidations.validateLastName(value ?? ''),
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: AppStrings.emailLabel,
        hintText: AppStrings.emailHint,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => AppValidations.validateEmail(value ?? ''),
    );
  }
}

class _PasswordRow extends StatelessWidget {
  const _PasswordRow({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: AppStrings.passwordLabel,
              hintText: AppStrings.passwordHint,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  obscurePassword
                      ? Assets.assetsIconsVisibilityOff
                      : Assets.assetsIconsVisibilityOn,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: onTogglePassword,
              ),
            ),
            validator: (value) => AppValidations.validatePassword(value ?? ''),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: AppStrings.confirmPasswordLabel,
              hintText: AppStrings.confirmPasswordHint,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  obscureConfirmPassword
                      ? Assets.assetsIconsVisibilityOff
                      : Assets.assetsIconsVisibilityOn,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: onToggleConfirmPassword,
              ),
            ),
            validator: (value) => AppValidations.validateConfirmPassword(
              passwordController.text,
              value ?? '',
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: AppStrings.phoneLabel,
          hintText: AppStrings.phoneHint,
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Assets.assetsIconsEgypt),
                const SizedBox(width: 6),
                Text("+20", style: TextStyles.bodyRegular16),
              ],
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
          LengthLimitingTextInputFormatter(11),
        ],
        keyboardType: TextInputType.phone,
        validator: (value) => AppValidations.validatePhone(value ?? ''),
      ),
    );
  }
}

class _GenderSection extends StatelessWidget {
  const _GenderSection({required this.selectedGender, required this.onChanged});

  final String selectedGender;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppStrings.genderLabel, style: TextStyles.bodyRegular16),
        const SizedBox(width: 20),

        Expanded(
          child: RadioGroup<String>(
            groupValue: selectedGender,
            onChanged: onChanged,
            child: Row(
              children: [
                _GenderOption(label: AppStrings.female, value: 'female'),
                SizedBox(width: 16),
                _GenderOption(label: AppStrings.male, value: 'male'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(value: value),
        Text(label),
      ],
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyles.bodyRegular13,
        children: [
          TextSpan(text: AppStrings.creatingAccount),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _showTermsDialog(context),
              child: Text(
                AppStrings.termsAndConditions,
                style: TextStyles.bodyRegularUnderLine13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showTermsDialog(BuildContext context) {
  AppDialog.show(
    context: context,
    title: AppStrings.termsAndConditions,
    description: AppStrings.terms,
    confirmText: AppStrings.close,
  );
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({required this.isLoading, required this.onSubmit});

  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(AppStrings.signupTitle),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.alreadyHaveAccount,
              style: TextStyles.bodyRegular16,
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  AppStrings.loginTitle,
                  style: TextStyles.bodyRegular16.copyWith(
                    color: AppColors.pink,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.pink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
