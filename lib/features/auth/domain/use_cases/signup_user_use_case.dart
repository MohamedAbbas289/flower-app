import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/signup_request_model.dart';
import '../repository_contract/auth_repository_contract.dart';

@injectable
class SignupUserUseCase {
  SignupUserUseCase(this._authRepositoryContract);
  final AuthRepositoryContract _authRepositoryContract;

  Future<BaseResponse<AuthResponseEntity>> execute({
    required SignupRequestModel requestModel,
  }) async {
    return await _authRepositoryContract.signup(requestModel: requestModel);
  }
}
