import 'dart:io';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/data/models/change_password_response.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<AuthResponse>> getProfileData();

  Future<BaseResponse<AuthResponse>> editProfile(
    EditProfileRequestModel request,
  );

  Future<BaseResponse<void>> uploadPhoto(File photo);

  Future<BaseResponse<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}
