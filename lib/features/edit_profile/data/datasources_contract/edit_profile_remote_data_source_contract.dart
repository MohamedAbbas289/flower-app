import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';

abstract interface class EditProfileRemoteDataSourceContract {
  Future<BaseResponse<AuthResponse>> editProfile(
    EditProfileRequestModel request,
  );
  Future<BaseResponse<void>> uploadPhoto(File photo);
}
