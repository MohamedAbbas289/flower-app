import 'dart:io';

import '../../../data/models/edit_user_dto.dart';

sealed class UpdateProfileEvent {
  const UpdateProfileEvent();
}

class LoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const LoadUpdateProfileDataEvent();
}

class RetryLoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const RetryLoadUpdateProfileDataEvent();
}

class UpdateProfileDataEvent extends UpdateProfileEvent {
  final EditUserDto request;

  const UpdateProfileDataEvent(this.request);
}

class UploadImageEvent extends UpdateProfileEvent {
  final File image;
  final int imageIndex;

  UploadImageEvent({
    required this.image,
    required this.imageIndex,
  });
}