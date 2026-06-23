import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

class LoadEditProfileDataEvent extends EditProfileEvent {
  final AuthResponseEntity initialData;
  const LoadEditProfileDataEvent(this.initialData);
}

class UpdateProfileEvent extends EditProfileEvent {
  final EditProfileRequestModel request;
  const UpdateProfileEvent(this.request);
}

class UploadPhotoEvent extends EditProfileEvent {
  final File photo;
  const UploadPhotoEvent(this.photo);
}

class PickImageEvent extends EditProfileEvent {
  final ImageSource source;
  const PickImageEvent(this.source);
}
