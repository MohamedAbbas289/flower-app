import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/get_profile_screen/domain/entities/user_entitiy.dart';
import '../../../domain/entities/edit_user_entity.dart';

class UpdateProfileState extends Equatable {
  final BaseState<GetUserEntity> profileDataState;
  final BaseState<EditUserEntity> updateProfileState;
  final String selectedGender;
  final String? profilePhoto;
  final File? selectedProfileImage;

  const UpdateProfileState({
    this.profileDataState = const BaseState(),
    this.updateProfileState = const BaseState(),
    this.selectedGender = 'female',
    this.profilePhoto,
    this.selectedProfileImage,
  });

  UpdateProfileState copyWith({
    BaseState<GetUserEntity>? profileDataState,
    BaseState<EditUserEntity>? updateProfileState,
    String? selectedGender,
    String? profilePhoto,
    File? selectedProfileImage,
  }) {
    return UpdateProfileState(
      profileDataState: profileDataState ?? this.profileDataState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      selectedGender: selectedGender ?? this.selectedGender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      selectedProfileImage: selectedProfileImage ?? this.selectedProfileImage,
    );
  }

  @override
  List<Object?> get props => [
    profileDataState,
    updateProfileState,
    selectedGender,
    profilePhoto,
    selectedProfileImage,
  ];
}
