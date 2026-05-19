import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/api/api_client/change_password_api_client.dart';
import 'package:flower_app/features/change_password/api/request_models/change_password_request_model.dart';
import 'package:flower_app/features/change_password/data/data_source_contract/change_password_remote_data_source_contract.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChangePasswordRemoteDataSourceContract)
class ChangePasswordRemoteDataSourceImpl
    implements ChangePasswordRemoteDataSourceContract {
  final ChangePasswordApiClient _changePasswordApiClient;

  ChangePasswordRemoteDataSourceImpl(this._changePasswordApiClient);

  @override
  Future<BaseResponse<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    try {
      final response = await _changePasswordApiClient.changePassword(
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
