import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/cubit/change_password_view_model.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/events/change_password_events.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/states/change_password_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context) {
    context.read<ChangePasswordViewModel>().doEvent(EnableAutoValidateEvent());
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordViewModel>().doEvent(
        ChangePasswordRequestEvent(
          password: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const _ChangePasswordAppBar(),
      body: BlocListener<ChangePasswordViewModel, ChangePasswordState>(
        listener: (context, state) {
          if (!state.changePasswordState.isLoading &&
              state.changePasswordState.data != null) {
            AppSnackBar.showSuccess(context, AppStrings.passwordUpdated);
            Navigator.pop(context);
          } else if (!state.changePasswordState.isLoading &&
              state.changePasswordState.msg != null) {
            AppSnackBar.showError(context, state.changePasswordState.msg!);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocBuilder<ChangePasswordViewModel, ChangePasswordState>(
              buildWhen: (prev, curr) =>
                  prev.autoValidate != curr.autoValidate ||
                  prev.changePasswordState.isLoading !=
                      curr.changePasswordState.isLoading,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  autovalidateMode: state.autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _PasswordField(
                          controller: _currentPasswordController,
                          label: AppStrings.currentPassword,
                          hint: AppStrings.currentPassword,
                          obscureText: _obscureCurrent,
                          onToggle: () => setState(
                            () => _obscureCurrent = !_obscureCurrent,
                          ),
                          validator: (v) =>
                              AppValidations.validatePassword(v ?? ''),
                        ),
                        const SizedBox(height: 16),
                        _PasswordField(
                          controller: _newPasswordController,
                          label: AppStrings.newPassword,
                          hint: AppStrings.newPassword,
                          obscureText: _obscureNew,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          validator: (v) =>
                              AppValidations.validatePassword(v ?? ''),
                        ),
                        const SizedBox(height: 16),
                        _PasswordField(
                          controller: _confirmPasswordController,
                          label: AppStrings.confirmPassword,
                          hint: AppStrings.confirmPassword,
                          obscureText: _obscureConfirm,
                          onToggle: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          validator: (v) =>
                              AppValidations.validateConfirmPassword(
                                _newPasswordController.text,
                                v ?? '',
                              ),
                        ),
                        const SizedBox(height: 32),
                        _UpdateButton(
                          isLoading: state.changePasswordState.isLoading,
                          onPressed: () => _onUpdate(context),
                          currentController: _currentPasswordController,
                          newController: _newPasswordController,
                          confirmController: _confirmPasswordController,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ChangePasswordAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
      ),
      title: Text(AppStrings.changePassword, style: TextStyles.appBarTextStyle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.onToggle,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
    );
  }
}

class _UpdateButton extends StatefulWidget {
  const _UpdateButton({
    required this.isLoading,
    required this.onPressed,
    required this.currentController,
    required this.newController,
    required this.confirmController,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final TextEditingController currentController;
  final TextEditingController newController;
  final TextEditingController confirmController;

  @override
  State<_UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<_UpdateButton> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.currentController.addListener(_checkFields);
    widget.newController.addListener(_checkFields);
    widget.confirmController.addListener(_checkFields);
  }

  void _checkFields() {
    final enabled =
        widget.currentController.text.isNotEmpty &&
        widget.newController.text.isNotEmpty &&
        widget.confirmController.text.isNotEmpty;

    if (enabled != _isEnabled) {
      setState(() => _isEnabled = enabled);
    }
  }

  @override
  void dispose() {
    widget.currentController.removeListener(_checkFields);
    widget.newController.removeListener(_checkFields);
    widget.confirmController.removeListener(_checkFields);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.gray,
        ),
        onPressed: widget.isLoading || !_isEnabled ? null : widget.onPressed,
        child: widget.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(AppStrings.update),
      ),
    );
  }
}
