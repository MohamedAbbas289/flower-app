import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/edit_profile/data/datasources_contract/edit_profile_remote_data_source_contract.dart';
import 'package:flower_app/features/edit_profile/domain/repositories_contract/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditProfileRepoContract)
class EditProfileRepoImpl implements EditProfileRepoContract {
  final EditProfileRemoteDataSourceContract _dataSource;

  EditProfileRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<AuthResponseEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    final response = await _dataSource.editProfile(request);
    switch (response) {
      case SuccessBaseResponse<AuthResponse>():
        return SuccessBaseResponse<AuthResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorBaseResponse<AuthResponse>():
        return ErrorBaseResponse<AuthResponseEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    return await _dataSource.uploadPhoto(photo);
  }
}
