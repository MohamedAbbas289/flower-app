import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<AuthResponseEntity> updateProfileState;
  final BaseState<void> uploadPhotoState;
  final File? pickedImage;

  const EditProfileState({
    this.updateProfileState = const BaseState(),
    this.uploadPhotoState = const BaseState(),
    this.pickedImage,
  });

  EditProfileState copyWith({
    BaseState<AuthResponseEntity>? updateProfileState,
    BaseState<void>? uploadPhotoState,
    File? pickedImage,
  }) {
    return EditProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
    uploadPhotoState,
    pickedImage,
  ];
}
