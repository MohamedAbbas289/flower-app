import 'dart:io';

import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';

import '../../../../config/base_response/base_response.dart';

abstract interface class ProfileRepoContract {
  Future<BaseResponse<AuthResponseEntity>> getProfileData();

  Future<BaseResponse<AuthResponseEntity>> editProfile(
    EditProfileRequestModel request,
  );

  Future<BaseResponse<void>> uploadPhoto(File photo);

  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  });
}
