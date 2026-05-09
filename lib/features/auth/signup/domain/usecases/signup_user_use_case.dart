import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/signup_request_model.dart';
import '../repositories_contract/signup_repository_contract.dart';

@injectable
class SignupUserUseCase {
  SignupUserUseCase(this._signupRepository);
  final SignupRepositoryContract _signupRepository;

  Future<BaseResponse<AuthResponseEntity>> execute({
    required SignupRequestModel requestModel,
  }) async {
    return await _signupRepository.signup(requestModel: requestModel);
  }
}
