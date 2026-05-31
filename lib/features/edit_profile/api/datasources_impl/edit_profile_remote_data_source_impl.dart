import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/edit_profile/api/edit_profile_api_client/edit_profile_api_client.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/edit_profile/data/datasources_contract/edit_profile_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditProfileRemoteDataSourceContract)
class EditProfileRemoteDataSourceImpl
    implements EditProfileRemoteDataSourceContract {
  final EditProfileApiClient _apiClient;

  EditProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<AuthResponse>> editProfile(
    EditProfileRequestModel request,
  ) async {
    try {
      final response = await _apiClient.editProfile(request);
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    try {
      final multipartFile = await MultipartFile.fromFile(photo.path);
      await _apiClient.uploadPhoto(multipartFile);
      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      return ErrorBaseResponse<void>(exception: e);
    }
  }
}
