import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/edit_profile/presentation/edit_profile_view_model/cubit/edit_profile_view_model.dart';
import 'package:flower_app/features/edit_profile/presentation/edit_profile_view_model/states/edit_profile_events.dart';
import 'package:flower_app/features/edit_profile/presentation/edit_profile_view_model/states/edit_profile_state.dart';
import 'package:flower_app/features/edit_profile/presentation/widgets/edit_profile_form.dart';
import 'package:flower_app/features/edit_profile/presentation/widgets/edit_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';

class EditProfileView extends StatelessWidget {
  final AuthResponseEntity initialData;

  const EditProfileView({super.key, required this.initialData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileViewModel>(),
      child: _EditProfileContent(initialData: initialData),
    );
  }
}

class _EditProfileContent extends StatelessWidget {
  final AuthResponseEntity initialData;

  const _EditProfileContent({required this.initialData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editProfile),
        leading: IconButton(
          icon: SvgPicture.asset(Assets.assetsIconsArrowBack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<EditProfileViewModel, EditProfileState>(
        listenWhen: (previous, current) =>
            previous.updateProfileState.msg != current.updateProfileState.msg &&
                current.updateProfileState.msg != null ||
            previous.updateProfileState.data !=
                    current.updateProfileState.data &&
                current.updateProfileState.data != null ||
            previous.uploadPhotoState.msg != current.uploadPhotoState.msg &&
                current.uploadPhotoState.msg != null,
        listener: (context, state) {
          if (state.updateProfileState.msg != null) {
            AppSnackBar.showError(context, state.updateProfileState.msg!);
          }
          if (state.updateProfileState.data != null) {
            AppSnackBar.showSuccess(context, AppStrings.profileUpdated);
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pop(context, state.updateProfileState.data);
              }
            });
          }
          if (state.uploadPhotoState.msg != null) {
            AppSnackBar.showError(context, state.uploadPhotoState.msg!);
          }
        },
        builder: (context, state) {
          final isLoading =
              state.updateProfileState.isLoading ||
              state.uploadPhotoState.isLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    EditProfilePhoto(
                      networkPhoto: initialData.user?.photo,
                      pickedImage: state.pickedImage,
                      onTap: () => _showImageSourceDialog(context),
                    ),
                    const SizedBox(height: 32),
                    EditProfileForm(
                      firstName: initialData.user?.firstName,
                      lastName: initialData.user?.lastName,
                      email: initialData.user?.email,
                      phone: initialData.user?.phone,
                      gender: initialData.user?.gender,
                      onUpdate: (request) => context
                          .read<EditProfileViewModel>()
                          .doEvent(UpdateProfileEvent(request)),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.pink),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      title: AppStrings.changePhoto,
      description: AppStrings.chooseImageSource,
      confirmText: AppStrings.camera,
      cancelText: AppStrings.gallery,
      confirmButtonColor: AppColors.pink,
      cancelButtonColor: AppColors.pink,
      buttonsVertical: true,
      onConfirm: () => context.read<EditProfileViewModel>().doEvent(
        PickImageEvent(ImageSource.camera),
      ),
      onCancel: () => context.read<EditProfileViewModel>().doEvent(
        PickImageEvent(ImageSource.gallery),
      ),
    );
  }
}
