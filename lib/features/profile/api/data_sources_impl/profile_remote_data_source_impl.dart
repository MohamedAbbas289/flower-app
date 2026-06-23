import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/change_password_request_model.dart';
import '../../api/request_models/edit_profile_request_model.dart';
import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';
import '../../data/models/change_password_response.dart';
import '../api_client/profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<BaseResponse<AuthResponse>> getProfileData() async {
    try {
      final response = await profileApiClient.getProfileData();
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<AuthResponse>> editProfile(
    EditProfileRequestModel request,
  ) async {
    try {
      final response = await profileApiClient.editProfile(request);
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    try {
      final multipartFile = await MultipartFile.fromFile(photo.path);
      await profileApiClient.uploadPhoto(multipartFile);
      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      return ErrorBaseResponse<void>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    try {
      final response = await profileApiClient.changePassword(
        changePasswordRequestModel: ChangePasswordRequestModel(
          password: password,
          newPassword: newPassword,
        ),
      );
      return SuccessBaseResponse<ChangePasswordResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ChangePasswordResponse>(exception: e);
    }
  }
}
