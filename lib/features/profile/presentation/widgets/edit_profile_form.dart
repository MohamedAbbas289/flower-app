import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_validations.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final void Function(EditProfileRequestModel request) onUpdate;

  const EditProfileForm({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    required this.onUpdate,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late String _selectedGender;

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _firstNameEnabled = false;
  bool _lastNameEnabled = false;
  bool _emailEnabled = false;
  bool _phoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.lastName ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _selectedGender = widget.gender ?? 'male';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _showConfirmDialog({
    required String fieldName,
    required VoidCallback onConfirm,
  }) {
    AppDialog.show(
      context: context,
      title: AppStrings.editField,
      description: '${AppStrings.doYouWantToEdit} $fieldName?',
      confirmText: AppStrings.confirm,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.pink,
      onConfirm: onConfirm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildField(
                  label: AppStrings.firstName,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  enabled: _firstNameEnabled,
                  validator: AppValidations.validateFirstName,
                  onTap: () => _showConfirmDialog(
                    fieldName: AppStrings.firstName,
                    onConfirm: () {
                      setState(() => _firstNameEnabled = true);
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _firstNameFocus.requestFocus(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  label: AppStrings.lastName,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  enabled: _lastNameEnabled,
                  validator: AppValidations.validateLastName,
                  onTap: () => _showConfirmDialog(
                    fieldName: AppStrings.lastName,
                    onConfirm: () {
                      setState(() => _lastNameEnabled = true);
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _lastNameFocus.requestFocus(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField(
            label: AppStrings.email,
            controller: _emailController,
            focusNode: _emailFocus,
            enabled: _emailEnabled,
            validator: AppValidations.validateEmail,
            keyboardType: TextInputType.emailAddress,
            onTap: () => _showConfirmDialog(
              fieldName: AppStrings.email,
              onConfirm: () {
                setState(() => _emailEnabled = true);
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () => _emailFocus.requestFocus(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildField(
            label: AppStrings.phoneNumber,
            controller: _phoneController,
            focusNode: _phoneFocus,
            enabled: _phoneEnabled,
            validator: AppValidations.validatePhone,
            keyboardType: TextInputType.phone,
            onTap: () => _showConfirmDialog(
              fieldName: AppStrings.phoneNumber,
              onConfirm: () {
                setState(() => _phoneEnabled = true);
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () => _phoneFocus.requestFocus(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildGenderSection(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onUpdate,
              child: Text(AppStrings.update),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool enabled,
    required String? Function(String) validator,
    TextInputType keyboardType = TextInputType.text,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: !enabled,
      keyboardType: keyboardType,
      validator: (v) => validator(v ?? ''),
      decoration: InputDecoration(labelText: label),
      onTap: !enabled ? onTap : null,
    );
  }

  Widget _buildPasswordField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          enabled: false,
          initialValue: '••••••',
          style: TextStyles.bodyRegular14.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            labelText: AppStrings.password,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
            ),
            suffixIcon: const SizedBox(width: 80),
          ),
        ),
        PositionedDirectional(
          end: 8,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutesName.changePassword);
            },
            child: Text(
              AppStrings.change,
              style: TextStyles.bodyRegular14.copyWith(color: AppColors.pink),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return IgnorePointer(
      child: Row(
        children: [
          Text(AppStrings.gender, style: TextStyles.bodyRegular14),
          const SizedBox(width: 16),
          RadioGroup<String>(
            groupValue: _selectedGender,
            onChanged: (v) => setState(() => _selectedGender = v!),
            child: Row(
              children: [
                _buildRadio(label: AppStrings.female, value: 'female'),
                const SizedBox(width: 16),
                _buildRadio(label: AppStrings.male, value: 'male'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio({required String label, required String value}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Row(
        children: [
          Radio<String>(value: value, activeColor: AppColors.pink),
          Text(label, style: TextStyles.bodyRegular14),
        ],
      ),
    );
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;
    widget.onUpdate(
      EditProfileRequestModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }
}
