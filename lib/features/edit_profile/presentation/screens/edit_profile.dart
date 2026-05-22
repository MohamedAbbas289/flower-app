import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_snack_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../../data/models/edit_user_dto.dart';
import '../view_models/cubit/edit_profile_view_model.dart';
import '../view_models/states/edit_profile_events.dart';
import '../view_models/states/edit_profile_state.dart';
import '../widgets/change_profile_screen.dart';
import '../widgets/gender_option.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String _phoneForForm(String? phone) {
    final cleanPhone = phone?.replaceAll(RegExp(r'\s+'), '').trim() ?? '';
    if (cleanPhone.startsWith('+20')) return '0${cleanPhone.substring(3)}';
    if (cleanPhone.startsWith('20')) return '0${cleanPhone.substring(2)}';
    return cleanPhone;
  }

  String _phoneForRequest() {
    final cleanPhone = phoneNumberController.text
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
    if (cleanPhone.startsWith('+20')) return cleanPhone;
    if (cleanPhone.startsWith('20')) return '+$cleanPhone';
    return '+20$cleanPhone';
  }

  void _fillControllers(UpdateProfileState state) {
    final user = state.profileDataState.data;
    if (user == null) return;
    if (firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        phoneNumberController.text.isNotEmpty) {
      return;
    }

    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    phoneNumberController.text = _phoneForForm(user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(AppStrings.editProfile, style: TextStyles.appBarTextStyle),
              Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_sharp, size: 30),

                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyles.appBarTextStyle.copyWith(
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocProvider(
          create: (_) =>
              getIt<EditProfileViewModel>()
                ..doEvent(const LoadUpdateProfileDataEvent()),
          child: BlocConsumer<EditProfileViewModel, UpdateProfileState>(
            listenWhen: (previous, current) =>
                previous.profileDataState.data !=
                    current.profileDataState.data ||
                previous.profileDataState.msg != current.profileDataState.msg ||
                previous.updateProfileState.msg !=
                    current.updateProfileState.msg ||
                previous.updateProfileState.data !=
                    current.updateProfileState.data,
            listener: (context, state) {
              _fillControllers(state);

              if (state.profileDataState.msg != null) {
                AppSnackBar.showError(context, state.profileDataState.msg!);
              }
              if (state.updateProfileState.msg != null) {
                AppSnackBar.showError(context, state.updateProfileState.msg!);
              }
              if (state.updateProfileState.data != null) {
                AppSnackBar.showSuccess(
                  context,
                  'Profile updated successfully',
                );
              }
            },
            builder: (context, state) {
              final profileState = state.profileDataState;
              final updateState = state.updateProfileState;

              if (profileState.isLoading && profileState.data == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.pink),
                );
              }

              if (profileState.msg != null && profileState.data == null) {
                return Center(
                  child: Text(
                    profileState.msg!,
                    textAlign: TextAlign.center,
                    style: TextStyles.bodyRegular18,
                  ),
                );
              }

              return Form(
                key: formKey,
                child: Column(
                  spacing: 20,
                  children: [
                    ChangeProfileScreen(photo: profileState.data?.photo),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              return AppValidations.validateFirstName(
                                value ?? '',
                              );
                            },
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: AppStrings.firstNameLabel,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              return AppValidations.validateLastName(
                                value ?? '',
                              );
                            },
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: AppStrings.lastNameLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        return AppValidations.validateEmail(value ?? '');
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: AppStrings.emailLabel,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        return AppValidations.validatePhone(value ?? '');
                      },
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: AppStrings.phoneLabel,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppStrings.passwordLabel,
                        hint: Row(
                          children: [
                            Text('********', style: TextStyles.bodyRegular18),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                AppStrings.change,
                                style: TextStyles.bodyRegular12.copyWith(
                                  color: AppColors.pink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppStrings.genderLabel,
                          style: TextStyles.bodyRegular16,
                        ),

                        Expanded(
                          child: GenderOption(
                            gender: AppStrings.femaleLabel,
                            value: 'female',
                            selectedGender: state.selectedGender,

                            onChanged: (String value) {
                              context.read<EditProfileViewModel>().changeGender(
                                value,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: GenderOption(
                            gender: AppStrings.maleLabel,
                            value: 'male',
                            selectedGender: state.selectedGender,

                            onChanged: (String value) {
                              context.read<EditProfileViewModel>().changeGender(
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: updateState.isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  context.read<EditProfileViewModel>().doEvent(
                                    UpdateProfileDataEvent(
                                      EditUserDto(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        phone: _phoneForRequest(),
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: updateState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppStrings.update),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
