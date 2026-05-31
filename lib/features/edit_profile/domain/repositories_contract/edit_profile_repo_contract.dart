import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';

abstract interface class EditProfileRepoContract {
  Future<BaseResponse<AuthResponseEntity>> editProfile(
    EditProfileRequestModel request,
  );
  Future<BaseResponse<void>> uploadPhoto(File photo);
}
