import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';

import 'package:injectable/injectable.dart';

import '../../data/datasources_contract/signup_remote_datasource_contract.dart';
import '../api_client/signup_api_client.dart';
import '../request_models/signup_request_model.dart';

@Injectable(as: SignupRemoteDatasourceContract)
class SignupRemoteDatasourceImpl implements SignupRemoteDatasourceContract {
  SignupRemoteDatasourceImpl(this._signupApiClient);
  final SignupApiClient _signupApiClient;
  @override
  Future<BaseResponse<AuthResponse>> signup({
    required SignupRequestModel requestModel,
  }) async {
    try {
      final response = await _signupApiClient.signup(
        requestModel: requestModel,
      );
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }
}
