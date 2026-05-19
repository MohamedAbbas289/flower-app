import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/data/data_source_contract/change_password_remote_data_source_contract.dart';
import 'package:flower_app/features/change_password/data/model/change_password_mapper.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';
import 'package:flower_app/features/change_password/domain/repo_contract/change_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChangePasswordRepoContract)
class ChangePasswordRepoImpl implements ChangePasswordRepoContract {
  final ChangePasswordRemoteDataSourceContract
  _changePasswordRemoteDataSourceContract;

  ChangePasswordRepoImpl(this._changePasswordRemoteDataSourceContract);

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    final response = await _changePasswordRemoteDataSourceContract
        .changePassword(password: password, newPassword: newPassword);

    switch (response) {
      case SuccessBaseResponse<ChangePasswordResponse>():
        final entity = response.data.toEntity();
        return SuccessBaseResponse(data: entity);
      case ErrorBaseResponse<ChangePasswordResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
