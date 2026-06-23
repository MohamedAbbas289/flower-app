import 'dart:io';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'edit_profile_events.dart';
import 'edit_profile_state.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  EditProfileViewModel(this._editProfileUseCase, this._uploadPhotoUseCase)
    : super(const EditProfileState());

  void doEvent(EditProfileEvent event) {
    switch (event) {
      case UpdateProfileEvent():
        _updateProfile(event.request);
      case UploadPhotoEvent():
        _uploadPhoto(event.photo);
      case PickImageEvent():
        _pickImage(event.source);
      case LoadEditProfileDataEvent():
        break;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final status = await permission.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      emit(
        state.copyWith(
          uploadPhotoState: BaseState<void>.error(AppStrings.permissionDenied),
        ),
      );
      return;
    }

    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    emit(state.copyWith(pickedImage: file));
    _uploadPhoto(file);
  }

  Future<void> _uploadPhoto(File photo) async {
    emit(state.copyWith(uploadPhotoState: BaseState<void>.loading()));
    final response = await _uploadPhotoUseCase(photo);
    switch (response) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(uploadPhotoState: BaseState<void>.success(null)));
      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(
            uploadPhotoState: BaseState<void>.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _updateProfile(EditProfileRequestModel request) async {
    emit(
      state.copyWith(
        updateProfileState: BaseState<AuthResponseEntity>.loading(),
      ),
    );
    final response = await _editProfileUseCase(request);
    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(
            updateProfileState: BaseState<AuthResponseEntity>.success(
              response.data,
            ),
          ),
        );
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(
            updateProfileState: BaseState<AuthResponseEntity>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }
}
